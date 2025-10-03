ARG CORRETTO_JAVA_TAG=21
ARG ALPINE_VERSION=3.21

FROM amazoncorretto:$CORRETTO_JAVA_TAG-alpine${ALPINE_VERSION} AS base

FROM base AS builder
ENV MAVEN_VERSION=3.9.9
ENV MAVEN_BUILD_ARGS="-Dmaven.test.skip=true"

ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

WORKDIR /tmp

ADD "https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" ./maven.tar.gz

RUN tar -zxf maven.tar.gz \
  && mv apache-maven-$MAVEN_VERSION $MAVEN_HOME \
  && rm maven.tar.gz

WORKDIR /build

COPY pom.xml /build/
RUN mvn verify --fail-never

COPY . /build

RUN apk update \
  && apk add --no-cache openssl \
  && mvn clean package --batch-mode "$MAVEN_BUILD_ARGS"

FROM base AS deploy
ENV DEFAULT_USER=spring

RUN addgroup -S ${DEFAULT_USER} \
    && adduser -S ${DEFAULT_USER} -G ${DEFAULT_USER}

USER spring:spring

COPY --from=builder /build/target/*.jar /app/app.jar

EXPOSE 5000

ENTRYPOINT ["java","-jar","/app/app.jar"]

