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

# Install packages via pip.

RUN pip3 install --upgrade pip \
 && pip3 install \
      psutil

# upgrade apt to 1.8.2.2
RUN wget http://ftp.us.debian.org/debian/pool/main/a/apt/apt_1.8.2.2_amd64.deb \
      && apt install ./apt_1.8.2.2_amd64.deb \
      && rm apt_1.8.2.2_amd64.deb

# upgrade p11-kit to 0.23.15-2+deb10u1
RUN wget http://ftp.us.debian.org/debian/pool/main/p/p11-kit/libp11-kit0_0.23.15-2+deb10u1_amd64.deb \
      && apt install ./libp11-kit0_0.23.15-2+deb10u1_amd64.deb \
      && rm libp11-kit0_0.23.15-2+deb10u1_amd64.deb

RUN wget http://ftp.us.debian.org/debian/pool/main/p/p11-kit/p11-kit-modules_0.23.15-2+deb10u1_amd64.deb \
      && apt install ./p11-kit-modules_0.23.15-2+deb10u1_amd64.deb \
      && rm p11-kit-modules_0.23.15-2+deb10u1_amd64.deb

RUN wget http://ftp.us.debian.org/debian/pool/main/p/p11-kit/p11-kit_0.23.15-2+deb10u1_amd64.deb \
      && apt install ./p11-kit_0.23.15-2+deb10u1_amd64.deb \
      && rm p11-kit_0.23.15-2+deb10u1_amd64.deb

# upgrade libzstd to 1.3.8+dfsg-3+deb10u2
RUN wget http://ftp.us.debian.org/debian/pool/main/libz/libzstd/libzstd1_1.3.8+dfsg-3+deb10u2_amd64.deb \
      && apt install ./libzstd1_1.3.8+dfsg-3+deb10u2_amd64.deb \
      && rm libzstd1_1.3.8+dfsg-3+deb10u2_amd64.deb

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
