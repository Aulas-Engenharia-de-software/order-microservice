mvn clean package && \
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 624676054102.dkr.ecr.us-east-1.amazonaws.com && \
docker build -t order-app . && \
docker tag order-app:latest 624676054102.dkr.ecr.us-east-1.amazonaws.com/order-app:latest && \
docker push 624676054102.dkr.ecr.us-east-1.amazonaws.com/order-app:latest