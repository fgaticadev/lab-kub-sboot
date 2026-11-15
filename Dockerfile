FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
RUN useradd --create-home --uid 1001 app
COPY --from=build /app/target/*.jar app.jar
ENV SERVER_PORT=8081
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75.0"
EXPOSE 8081
USER app
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
