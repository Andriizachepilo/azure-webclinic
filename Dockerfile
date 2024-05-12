FROM eclipse-temurin:17 as builder
WORKDIR /application

ARG JARPATH
COPY ${JARPATH} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM eclipse-temurin:17
WORKDIR /application

ARG PORT
EXPOSE ${PORT}

COPY --from=builder application/dependencies/ ./

RUN true
COPY --from=builder application/spring-boot-loader/ ./
RUN true
COPY --from=builder application/snapshot-dependencies/ ./
RUN true
COPY --from=builder application/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
