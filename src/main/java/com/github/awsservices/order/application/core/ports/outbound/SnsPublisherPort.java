package com.github.awsservices.order.application.core.ports.outbound;

import com.github.awsservices.order.application.core.domain.Order;

public interface SnsPublisherPort {

    void publish(Order order);
}
