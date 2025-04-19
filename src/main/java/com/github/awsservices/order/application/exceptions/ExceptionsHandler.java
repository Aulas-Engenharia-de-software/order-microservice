package com.github.awsservices.order.application.exceptions;

import com.github.awsservices.order.application.exceptions.model.ErrorResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.List;

@ControllerAdvice
public class ExceptionsHandler {

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleValidationException(HttpMessageNotReadableException ex) {
        ErrorResponse error = new ErrorResponse(
                "BAD_REQUEST",
                "Invalid request payload",
                List.of("Check your request body format")
        );
        return ResponseEntity.badRequest().body(error);
    }
}


