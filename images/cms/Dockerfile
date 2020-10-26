FROM adoptopenjdk:11-jre-openj9

ARG LAUNCHER_VERSION=1.1.8
ARG APP_VERSION=1.0.0-SNAPSHOT
ENV APP_VERSION=${APP_VERSION}
ARG SHARED_PASSWORD=
ENV SHARED_PASSWORD=${SHARED_PASSWORD}

# Configure directories
WORKDIR /opt/slingcms

# Install Apache Maven
RUN apt-get update && apt-get install maven jq -y
COPY settings.xml /root/.m2/

# Setup Sling CMS
COPY download-dependencies.sh /opt/slingcms/setup/
RUN /bin/bash /opt/slingcms/setup/download-dependencies.sh
COPY setup-composite.sh /opt/slingcms/setup/
RUN /bin/bash /opt/slingcms/setup/setup-composite.sh
RUN /bin/bash echo "${SHARED_PASSWORD}" > /opt/slingcms/passwd

# Expose endpoints
EXPOSE 8080

# Start Sling CMS
CMD exec java \
    -jar org.apache.sling.feature.launcher.jar \
    -f *.slingosgifeature
