FROM maven:3-amazoncorretto-20 as base
WORKDIR /application
ARG PATH
COPY ${PATH}/src ./src
COPY ${PATH}/pom.xml ./pom.xml
COPY services/pom.xml .

FROM base as development
CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base as build
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy as production
ARG PORT
EXPOSE ${PORT}
COPY --from=build /application/target/*.jar /application/app.jar
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/application/app.jar"]














# FROM maven:3-amazoncorretto-20 as base
# WORKDIR /application
# COPY ${APP_PATH}/pom.xml application/pom.xml
# COPY ${APP_PATH}/src application/src

# FROM base as development
# CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

# FROM base as build
# RUN mvn package

# FROM eclipse-temurin:17-jre-jammy as production
# ARG EXPOSE, ARTIFACT_NAME
# EXPOSE ${EXPOSE}
# COPY --from=build ${APP_PATH}/target/${ARTIFACT_NAME}.jar /${ARTIFACT_NAME}.jar
# CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/${ARTIFACT_NAME}.jar"]
