package com.jws.consig.dto;

import java.util.List;

public record AssignLeadsRequest(List<Long> leadIds, Long consultorId) {}
