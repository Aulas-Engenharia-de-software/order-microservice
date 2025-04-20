package com.github.awsservices.order.application.core.ports.inbound;

import com.github.awsservices.order.application.core.domain.Order;
import com.github.awsservices.order.application.exceptions.PublishSnsMessageException;

public interface OrderServicePort {

    void confirmOrder(Order order) throws PublishSnsMessageException;
}
