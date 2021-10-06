# syntax=docker/dockerfile:1

FROM ubuntu:20.04

LABEL maintainer="i.safin@innopolis.university"

ENV EXIM_VERSION=exim-4.95

RUN apt-get update; \
  apt-get install -y --no-install-recommends \
  perl \
  libpcre3-dev \
  libssl-dev \
  libdb-dev \
  gcc \
  wget \
  make;

RUN mkdir /exim

RUN wget -P /exim/ http://exim.mirror.globo.tech/exim/exim4/${EXIM_VERSION}.tar.gz 

RUN echo "6fdd83edd7bf53bdc0a208187643aa0c41861aba9a09a026f78351ac8e768b9c /exim/${EXIM_VERSION}.tar.gz" | sha256sum --check

RUN tar -xf /exim/${EXIM_VERSION}.tar.gz -C /exim/

WORKDIR /exim/${EXIM_VERSION}

RUN cp src/EDITME Local/Makefile 

RUN sed "/EXIM_USER=/d" Local/Makefile >> Local/Makefile_tmp && mv Local/Makefile_tmp Local/Makefile 

RUN echo "EXIM_USER=exim\n" >> Local/Makefile 
RUN echo "USE_OPENSSL=yes\n" >> Local/Makefile 
RUN echo "TLS_LIBS=-L/usr/local/openssl/lib -lssl -lcrypto\n" >> Local/Makefile 
RUN echo "PCRE_LIBS=-lpcre\n" >> Local/Makefile

RUN adduser --disabled-password --gecos "" exim && \
   chown -R exim /exim

RUN make
RUN make install 

RUN cp build-Linux-x86_64/exim /artifact



FROM ubuntu:20.04

COPY --from=0 /artifact /exim

RUN apt-get update; \
	apt-get install -y --no-install-recommends \
	libssl-dev

RUN adduser --disabled-password --gecos "" exim && \
   chown -R exim /exim 


COPY --from=0 /var/spool/exim/ /var/spool/exim/
COPY --from=0 /usr/exim/configure /usr/exim/configure

RUN chown -R exim /var/spool/exim 

USER exim

CMD ["/exim"]