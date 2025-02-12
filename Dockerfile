FROM eclipse-temurin:21-jdk-jammy AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apt-get update && apt-get install -y maven && \
    mvn clean package -DskipTests
#RUN --mount=type=cache,target=/root/.m2 \  # maven mount 
#    ./mvnw package -DskipTests
FROM eclipse-temurin:21-jre-jammy AS runtime
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
# docker build -t aws-container-spring:1.0 .
# docker build --no-cache --rm -t aws-container-spring:1.0 .
# docker run -p 8080:8080 aws-container-spring:1.0