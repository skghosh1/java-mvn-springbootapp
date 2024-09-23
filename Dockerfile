FROM tomcat:9.0
COPY ./target/*.war /usr/local/tomcat/webapps/webapps/
EXPOSE 80
