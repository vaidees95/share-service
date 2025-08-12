# Stage 1: Build with Maven and Java 17
FROM maven:3.9.0-eclipse-temurin-17 AS build

WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the application and skip tests for faster builds
RUN mvn clean package -DskipTests

# Stage 2: Run with Java 24 JRE
FROM eclipse-temurin:24-jre-alpine

WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/share-service-0.0.1-SNAPSHOT.jar app.jar

# Expose the default Spring Boot WebFlux port (8080)
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
