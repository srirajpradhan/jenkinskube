FROM maven:3.5-jdk-8-alpine

ENV HOME /Javaapp
EXPOSE 9669

WORKDIR $HOME

COPY . $HOME/

RUN mvn clean install \
    && apk add --update bash \
    && rm -rf /var/cache/apk/*

CMD ["java","-jar","/Javaapp/target/spring-boot-web-0.0.2-SNAPSHOT.jar","&"]
