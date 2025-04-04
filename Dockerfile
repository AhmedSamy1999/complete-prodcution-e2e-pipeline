FROM maven:3.9.0-eclipse-temurin as build
WORKDIR /app
COPY . .
RUN mvn clean install


FROM eclipse-temurin:17.0.6_10-jdk
LABEL maintainer="Ahmed Samy <ahmed.s.elsherbiny0@gmail.com>"
WORKDIR /app
COPY --from=build /app/target/demoapp.jar /app/
EXPOSE 8080
CMD ["java","-jar","demoapp.jar"]