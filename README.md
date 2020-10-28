# DanKlco.com

My personal website, built with [Sling CMS](https://github.com/apache/sling-org-apache-sling-app-cms).

## Build

Build the project run:

    mvn clean install -P github -DMAXMIND_LICENSE_KEY=[MAXMIND_LICENSE_KEY] -DSHARED_PASSWORD=[SHARED_PASSWORD] \
        -DSMTP_HOST=[SMTP_HOST] -DGITHUB_TOKEN=[GITHUB_TOKEN] -DSMTP_USERNAME=[SMTP_USERNAME] -DSMTP_ENC_PASSWORD=[SMTP_ENC_PASSWORD] \
        -DORIGIN_CERT=[ORIGIN_CERT] -DORIGIN_CERT_KEY=[ORIGIN_CERT_KEY] -DORIGIN_ROOT_CERT=[ORIGIN_ROOT_CERT] \
        && docker-compose -f images/target/classes/docker-compose.yaml -p danklcocom up
    
This will build and run a local Sling CMS instance at `https://cms.danklco.local` and `https://www.danklco.local`
