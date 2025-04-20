package com.github.awsservices.order.adapters.outbound.sns;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.awsservices.order.adapters.outbound.sns.config.properties.SnsProperties;
import com.github.awsservices.order.application.core.domain.Order;
import com.github.awsservices.order.application.core.ports.outbound.SnsPublisherPort;
import com.github.awsservices.order.application.exceptions.PublishSnsMessageException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sns.model.PublishRequest;

public class SnsPublisher implements SnsPublisherPort {

    private final Logger logger = LoggerFactory.getLogger(SnsPublisher.class);

    private final SnsClient snsClient;

    private final SnsProperties snsProperties;

    private final ObjectMapper mapper = new ObjectMapper();

    public SnsPublisher(SnsClient snsClient, SnsProperties snsProperties) {
        this.snsClient = snsClient;
        this.snsProperties = snsProperties;
    }

    @Override
    public void publish(Order order) {
        try {
            logger.info("Iniciando envio da mensagem para o tópico sns: {}", snsProperties.getTopicArn());
            final String orderEventMessage = mapper.writeValueAsString(order);
            final PublishRequest request = PublishRequest.builder()
                    .topicArn(snsProperties.getTopicArn())
                    .message(orderEventMessage)
                    .build();

            snsClient.publish(request);
            logger.info("Mensagem enviada com sucesso: {}", snsProperties.getTopicArn());
        } catch (Exception e) {
            throw new PublishSnsMessageException(e);
        }
    }

}