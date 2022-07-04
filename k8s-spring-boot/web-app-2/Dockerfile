FROM openjdk:17-alpine
RUN mkdir /opt/app
RUN chmod -R 777 /opt/app
COPY target/*.jar /opt/app/app.jar
USER 1001
CMD ["java", "-jar", "/opt/app/app.jar"]
