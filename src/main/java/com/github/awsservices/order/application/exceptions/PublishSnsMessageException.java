package com.github.awsservices.order.application.exceptions;

public class PublishSnsMessageException extends RuntimeException {

    public PublishSnsMessageException(Throwable ex) {
        super("Ocorreu um erro ao enviar a mensagem para o SNS.", ex);
    }
}
