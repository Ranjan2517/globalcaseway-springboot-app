# Step 1: Use Maven and Java 17 for building the project
FROM maven:3.9-openjdk-17 AS builder

# Set working directory
WORKDIR /app

# Copy only the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the Spring Boot app
RUN mvn clean install -DskipTests

# Step 2: Create a small final image using OpenJDK
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR from the builder image
COPY --from=builder /app/target/spring_boot_backend_template-0.0.1.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the app
CMD ["java", "-jar", "app.jar"]
