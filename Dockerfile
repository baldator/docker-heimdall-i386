FROM baldator/alpine-s6

# set version label
ARG BUILD_DATE
ARG VERSION
ENV HEIMDALL_RELEASE 2.2.2
ENV PUID 1000
ENV PGUI 1000
LABEL maintainer="baldator"

# environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
	curl \
    php7 \
    php7-json \
    php7-session \
	php7-ctype \
	php7-pdo_pgsql \
	php7-pdo_sqlite \
	php7-tokenizer \
	php7-zip \
	tar && \
 echo "**** install heimdall ****" && \
 mkdir -p \
	/heimdall && \
 if [ -z ${HEIMDALL_RELEASE+x} ]; then \
	HEIMDALL_RELEASE=$(curl -sX GET "https://api.github.com/repos/linuxserver/Heimdall/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /heimdall/heimdall.tar.gz -L \
	"https://github.com/linuxserver/Heimdall/archive/${HEIMDALL_RELEASE}.tar.gz" && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
chown -R 1000:1000 /var/www/localhost/heimdall/

# add local files
COPY root/ /