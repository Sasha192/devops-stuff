FROM adoptopenjdk/openjdk15
RUN mkdir /opt/app
RUN chmod -R 777 /opt/app
USER 1001
COPY target/*.jar /opt/app/app.jar
CMD ["java", "-jar", "/opt/app/app.jar"]

