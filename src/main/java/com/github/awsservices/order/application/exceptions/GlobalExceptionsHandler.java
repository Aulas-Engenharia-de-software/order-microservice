package com.github.awsservices.order.application.exceptions;

import com.github.awsservices.order.application.exceptions.model.ErrorResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.List;

@ControllerAdvice
public class GlobalExceptionsHandler {

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleValidationException(HttpMessageNotReadableException ex) {
        final ErrorResponse error = new ErrorResponse(
                HttpStatus.BAD_REQUEST.toString(),
                "Payload da requisição inválido.",
                List.of("Verifique o formato do corpo da requisição.")
        );
        return ResponseEntity.badRequest().body(error);
    }

    @ExceptionHandler(PublishSnsMessageException.class)
    public ResponseEntity<ErrorResponse> handlePublishMessageException(PublishSnsMessageException ex) {
        final ErrorResponse error = new ErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR.toString(),
                ex.getMessage(),
                List.of(ex.getCause().getMessage())
        );
        return ResponseEntity.badRequest().body(error);
    }
}


