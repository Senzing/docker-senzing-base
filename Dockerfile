ARG BASE_IMAGE=debian:10.9
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2020-10-23

LABEL Name="senzing/senzing-base" \
      Maintainer="support@senzing.com" \
      Version="1.5.5"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.
# Required for msodbcsql17:  libodbc1:amd64 odbcinst odbcinst1debian2:amd64 unixodbc

RUN apt update \
 && apt -y install \
      build-essential \
      curl \
      gdb \
      jq \
      libbz2-dev \
      libffi-dev \
      libgdbm-dev \
      libncursesw5-dev \
      libodbc1:amd64 \
      libreadline-gplv2-dev \
      libsqlite3-dev \
      libssl-dev \
      lsb-release \
      odbc-postgresql \
      odbcinst \
      postgresql-client \
      python3-dev \
      python3-pip \
      sqlite \
      tk-dev \
      unixodbc \
      vim \
      wget \
 && rm -rf /var/lib/apt/lists/*

# upgrade apt

RUN wget http://ftp.us.debian.org/debian/pool/main/a/apt/apt_1.8.2.2_amd64.deb
RUN apt install ./apt_1.8.2.2_amd64.deb
RUN rm apt_1.8.2.2_amd64.deb

# upgrade libssh2

RUN wget https://www.libssh2.org/download/libssh2-1.9.0.tar.gz
RUN tar xvzf libssh2-1.9.0.tar.gz
RUN wget https://www.linuxfromscratch.org/patches/blfs/svn/libssh2-1.9.0-security_fixes-1.patch
RUN cd libssh2-1.9.0 && patch -Np1 -i ../libssh2-1.9.0-security_fixes-1.patch && ./configure --prefix=/usr --disable-static && make && make install

# Install packages via pip.

RUN pip3 install --upgrade pip \
 && pip3 install \
      psutil

# Copy files from repository.

COPY ./rootfs /

# Downgrade to TLSv1.1

RUN sed -i 's/TLSv1.2/TLSv1.1/g' /etc/ssl/openssl.cnf

# Set environment variables for root.

ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:/opt/IBM/db2/clidriver/lib
ENV ODBCSYSINI=/etc/opt/senzing
ENV PATH=${PATH}:/opt/senzing/g2/python:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin
ENV PYTHONPATH=/opt/senzing/g2/python
ENV SENZING_ETC_PATH=/etc/opt/senzing

# Make non-root container.

USER 1001

# Set environment variables for USER 1001.

ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:/opt/IBM/db2/clidriver/lib
ENV ODBCSYSINI=/etc/opt/senzing
ENV PATH=${PATH}:/opt/senzing/g2/python:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin
ENV PYTHONPATH=/opt/senzing/g2/python
ENV SENZING_ETC_PATH=/etc/opt/senzing

# Runtime execution.

WORKDIR /
CMD ["/bin/bash"]
