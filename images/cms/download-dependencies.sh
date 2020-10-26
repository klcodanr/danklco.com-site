#!/bin/bash

mkdir -p /opt/slingcms/features
cd /opt/slingcms

echo "Downloading Feature Launcher..."
mvn -q org.apache.maven.plugins:maven-dependency-plugin:copy \
    -Dartifact=org.apache.sling:org.apache.sling.feature.launcher:${LAUNCHER_VERSION}:jar \
    -DoutputDirectory=/opt/slingcms \
    -Dmdep.stripVersion=true \
    || { echo 'Failed to download Feature Launcher' ; exit 1; } 
 
echo "Downloading Feature Models..."
mvn -q org.apache.maven.plugins:maven-dependency-plugin:copy \
    -Dartifact=com.danklco:com.danklco.site.feature:${APP_VERSION}:slingosgifeature:danklco-com-seed \
    -DoutputDirectory=/opt/slingcms/setup \
    -Dmdep.stripVersion=true \
    || { echo 'Failed to download composite seed' ; exit 1; }
mvn -q org.apache.maven.plugins:maven-dependency-plugin:copy \
    -Dartifact=com.danklco:com.danklco.site.feature:${APP_VERSION}:slingosgifeature:danklco-com-runtime \
    -DoutputDirectory=/opt/slingcms \
    -Dmdep.stripVersion=true \
    || { echo 'Failed to download composite runtime' ; exit 1; }