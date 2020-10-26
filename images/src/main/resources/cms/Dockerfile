FROM adoptopenjdk:11-jre-openj9

# Configure directories
WORKDIR /opt/slingcms

# Install Apache Maven
RUN apt-get update && apt-get install maven -y
COPY settings.xml /root/.m2/
COPY slingcms/ /opt/slingcms/

# Setup Sling CMS
RUN /bin/bash /opt/slingcms/setup/setup-composite.sh

# Expose endpoints
EXPOSE 8080

# Start Sling CMS
CMD exec java -jar org.apache.sling.feature.launcher.jar -f *.far
