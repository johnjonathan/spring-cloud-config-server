ARG VERSION=8u222
FROM openjdk:${VERSION}-jdk-slim as BUILD

COPY *.gradle gradle.* gradlew /src/
COPY gradle /src/gradle
WORKDIR /src
RUN ./gradlew --version

COPY . .
ENV MAIN_CLASS_NAME=com.example.App
RUN ./gradlew --no-daemon build

FROM openjdk:${VERSION}-jre-slim
COPY --from=BUILD /src/build/libs/spring-cloud-config-server.jar /bin/run.jar
CMD ["java", "-d64", "-jar", "/bin/run.jar"]