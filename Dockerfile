FROM eclipse-temurin:21-jre-jammy

WORKDIR /app
COPY target/order-microservice-0.0.1-SNAPSHOT.jar /app/order-service.jar
COPY src/main/resources/application.properties /app/config/application.properties

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "order-service.jar", "--spring.config.location=file:/app/config/application.properties"]