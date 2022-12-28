FROM alpine:latest
ENV UUID uuid
ENV V_PATH v_path
ENV TZ 'Asia/Shanghai'

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk upgrade --no-cache \
&& apk --update --no-cache add tzdata supervisor ca-certificates nginx curl wget unzip openssl \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& rm -rf /var/cache/apk/*

RUN cd /tmp \
# Install tmal
&& wget https://raw.githubusercontent.com/ttuhg/tmal-app/main/tmal-linux-64.zip \
&& unzip /tmp/tmal-linux-64.zip -d /tmp/tmal \
&& install -m 755 /tmp/tmal/tmal /usr/bin/tmal \
&& mv /tmp/tmal/*.dat /usr/bin \
&& rm -rf /tmp/* \
# Config env for heroku
&& adduser -D myuser \
&& if [ ! -d /run/nginx ]; then mkdir /run/nginx;fi \
&& mkdir -p /var/tmp/nginx/client_body

ADD etc /etc
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
USER myuser
CMD /usr/bin/entrypoint.sh
