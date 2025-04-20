package com.github.awsservices.order.application.core.services;

import com.github.awsservices.order.application.core.domain.Order;
import com.github.awsservices.order.application.core.ports.inbound.OrderServicePort;
import com.github.awsservices.order.application.core.ports.outbound.SnsPublisherPort;
import com.github.awsservices.order.application.exceptions.PublishSnsMessageException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OrderService implements OrderServicePort {

    private final Logger logger = LoggerFactory.getLogger(OrderService.class);

    private final SnsPublisherPort snsPublisherPort;

    public OrderService(SnsPublisherPort snsPublisherPort) {
        this.snsPublisherPort = snsPublisherPort;
    }

    @Override
    public void confirmOrder(Order order) throws PublishSnsMessageException {
        logger.info("Iniciando confirmacao do pedido...");
        snsPublisherPort.publish(order);
    }
}
