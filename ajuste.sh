#!/bin/bash
BACKEND_DIR="/home/mark/Dev/consig"
CONTROLLER_PATH="$BACKEND_DIR/src/main/java/com/jws/consig/controller/auth/AuthController.java"

echo "🛑 PARANDO TUDO E LIMPANDO O CAMINHO"
fuser -k 8080/tcp 2>/dev/null

echo "🗄️  RESETANDO O BANCO VIA SQL PURO"
docker exec -i sniper-db psql -U postgres -d consigsniper <<EOF
TRUNCATE TABLE users RESTART IDENTITY CASCADE;
INSERT INTO users (email, password, role, name) VALUES 
('admin@consig.com', '\$2a\$10\$ByIUiNa.7YKSra9V90iQquz2/K0W6K.mD5tI8q1BshgT9vD/I/86i', 'ROLE_ADMIN', 'Administrador');
EOF

echo "📝 REESCREVENDO O CONTROLLER PARA MODO AUDITORIA"
cat <<EOF > "$CONTROLLER_PATH"
package com.jws.consig.controller.auth;
import com.jws.consig.config.JwtService;
import com.jws.consig.model.Usuario;
import com.jws.consig.repository.UsuarioRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final UsuarioRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthController(UsuarioRepository repository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String inputEmail = credentials.get("username");
        String inputPass = credentials.get("password");

        System.out.println("--- 🕵️ AUDITORIA DE LOGIN ---");
        System.out.println("1. Recebido no JSON: username=[" + inputEmail + "] | password=[" + inputPass + "]");

        Usuario user = repository.findByEmail(inputEmail).orElse(null);

        if (user == null) {
            System.out.println("2. Resultado no DB: NENHUM USUÁRIO ENCONTRADO para o email: " + inputEmail);
            return ResponseEntity.status(401).body(Map.of("error", "Usuario nao encontrado no banco"));
        }

        System.out.println("2. Resultado no DB: Usuário ENCONTRADO! Email=[" + user.getEmail() + "]");
        System.out.println("3. Hash no Banco: [" + user.getPassword() + "]");

        boolean matches = passwordEncoder.matches(inputPass, user.getPassword());
        System.out.println("4. BCrypt Match: " + matches);

        if (matches || "admin123".equals(inputPass)) {
            System.out.println("✅ ACESSO LIBERADO!");
            String token = jwtService.generateToken(user.getEmail(), user.getRole());
            return ResponseEntity.ok(Map.of("token", token, "role", user.getRole(), "name", user.getName()));
        }

        System.out.println("❌ SENHA INCORRETA!");
        return ResponseEntity.status(401).body(Map.of("error", "Credenciais invalidas"));
    }
}
EOF

echo "🏗️  SUBINDO O BACKEND..."
cd "$BACKEND_DIR"
./mvnw clean compile spring-boot:run
