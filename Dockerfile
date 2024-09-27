FROM python:3.8

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y nginx=1.22.1-9 supervisor=4.2.5-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /opt/gugik2osm /opt/gugik2osm/app /opt/gugik2osm/web /opt/gugik2osm/log
WORKDIR /opt/gugik2osm

COPY ./requirements.txt ./
RUN python -m venv /opt/gugik2osm/venv
ENV VIRTUAL_ENV /opt/gugik2osm/venv
ENV PATH /opt/gugik2osm/venv/bin:$PATH
RUN pip install --no-cache-dir -r requirements.txt

COPY ./conf/ ./conf/

RUN cp ./conf/.env.docker ./conf/.env && \
    ln -sf /opt/gugik2osm/conf/nginx.conf /etc/nginx/sites-available/gugik2osm.conf && \
    ln -sf /opt/gugik2osm/conf/nginx.conf /etc/nginx/sites-enabled/gugik2osm.conf && \
    rm -rf /var/www/html && \
    ln -sf /opt/gugik2osm/web /var/www/html && \
    ln -sf /opt/gugik2osm/conf/supervisord.conf /etc/supervisor/conf.d/gugik2osm.conf && \
    rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default && \
    mkdir /run/gugik2osm/ /var/www/overpass-layers/ /tmp/nginx/ && \
    echo "supervisord && service nginx restart && bash" > ./start.sh && chmod +x ./start.sh

CMD ["bash", "./start.sh"]
