package com.github.awsservices.order.adapters.inbound.rest;

import com.github.awsservices.order.application.core.domain.Order;
import com.github.awsservices.order.application.core.ports.inbound.OrderServicePort;
import com.github.awsservices.order.application.exceptions.PublishSnsMessageException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.Map;
import java.util.UUID;

@RestController
public class OrderController {

    private final Logger logger = LoggerFactory.getLogger(OrderController.class);

    private final OrderServicePort orderServicePort;

    public OrderController(OrderServicePort orderService) {
        this.orderServicePort = orderService;
    }

    @PostMapping("/orders")
    public ResponseEntity<Map<String, String>> createOrder(@RequestBody Order order) {
        try {
            MDC.put("uuid", UUID.randomUUID().toString());
            logger.info("Iniciando processamento da confirmação do pedido: {}", order);

            orderServicePort.confirmOrder(order);

            return ResponseEntity.ok(Collections.singletonMap("message", "Pedido confirmado"));

        } catch (PublishSnsMessageException exception) {
            return ResponseEntity
                    .internalServerError()
                    .body(Collections
                            .singletonMap("message", "ocorreu um erro com esse pedido: " + exception.getMessage())
                    );
        } finally {
            MDC.clear();
        }
    }

}
