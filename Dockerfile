FROM centos

#ADD jdk-7u79-linux-x64.rpm .
RUN cd /tmp \
&& curl --digest -x ${http_proxy} --user ${REPO_USER}:${REPO_PASS} -LO http://filerepo.osappext.pink.eu-central-1.aws.openpaas.axa-cloud.com/liferay-docker/jdk-7u79-linux-x64.rpm \
&& rpm -i /tmp/jdk-7u79-linux-x64.rpm \
&& rm -f /tmp/jdk-7u79-linux-x64.rpm

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN cd /opt \
	&& curl -LO -x ${https_proxy} https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.4.0.tar.gz \
	&& tar xvfz elasticsearch-1.4.0.tar.gz \
	&& rm elasticsearch-1.4.0.tar.gz 

WORKDIR /opt/elasticsearch-1.4.0

RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done

COPY logging.yml /opt/elasticsearch-1.4.0/config/
COPY elasticsearch.yml /opt/elasticsearch-1.4.0/config/

USER elasticsearch

ENV PATH=$PATH:/opt/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200 9300
