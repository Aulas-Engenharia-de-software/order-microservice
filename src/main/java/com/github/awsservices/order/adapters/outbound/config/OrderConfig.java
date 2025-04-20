package com.github.awsservices.order.adapters.outbound.config;

import com.github.awsservices.order.adapters.outbound.sns.SnsPublisher;
import com.github.awsservices.order.adapters.outbound.sns.config.properties.SnsProperties;
import com.github.awsservices.order.application.core.ports.outbound.SnsPublisherPort;
import com.github.awsservices.order.application.core.services.OrderService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.services.sns.SnsClient;

@Configuration
public class OrderConfig {

    private final SnsProperties snsProperties;

    public OrderConfig(SnsProperties snsProperties) {
        this.snsProperties = snsProperties;
    }

    @Bean
    public SnsPublisherPort eventPublisher(SnsClient snsClient) {
        return new SnsPublisher(snsClient, snsProperties);
    }

    @Bean
    public OrderService orderUseCase(SnsPublisherPort eventPublisher) {
        return new OrderService(eventPublisher);
    }
}
