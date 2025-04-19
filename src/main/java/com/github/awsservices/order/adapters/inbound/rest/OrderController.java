package com.github.awsservices.order.adapters.inbound.rest;

import com.github.awsservices.order.application.core.domain.OrderEvent;
import com.github.awsservices.order.application.core.services.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Map;

@RestController
public class OrderController {

    private final Logger logger = LoggerFactory.getLogger(OrderController.class);

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping("/orders")
    public ResponseEntity<Map<String, String>> createOrder(@RequestBody OrderEvent evento) {
        logger.info("Iniciando processamento: {}", evento);
        return ResponseEntity.ok(Collections.singletonMap("message", "Pedido confirmado"));
    }

}
