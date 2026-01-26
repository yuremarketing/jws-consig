package com.jws.consig_sniper.controller;

import com.jws.consig_sniper.model.User;
import com.jws.consig_sniper.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public List<User> listUsers() {
        return userService.listAll();
    }

    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody User data) {
        try {
            userService.createUser(data);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<?> toggleStatus(@PathVariable UUID id) {
        userService.toggleStatus(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable UUID id) {
        userService.softDelete(id);
        return ResponseEntity.ok().build();
    }
}
