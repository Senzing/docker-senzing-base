ARG BASE_IMAGE=debian:10.2
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2020-07-22

LABEL Name="senzing/senzing-base" \
      Maintainer="support@senzing.com" \
      Version="1.5.2"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.
# Required for msodbcsql17:  libodbc1:amd64 odbcinst odbcinst1debian2:amd64 unixodbc

RUN apt update \
 && apt -y install \
      build-essential \
      curl \
      jq \
      libbz2-dev \
      libffi-dev \
      libgdbm-dev \
      libncursesw5-dev \
      libodbc1:amd64 \
      libreadline-gplv2-dev \
      libssl-dev \
      libsqlite3-dev \
      lsb-release \
      odbcinst \
      odbc-postgresql \
      postgresql-client \
      python3-dev \
      python3-pip \
      sqlite \
      tk-dev \
      unixodbc \
      wget \
      vim \
 && rm -rf /var/lib/apt/lists/*

# Install packages via pip.

RUN pip3 install --upgrade pip \
 && pip3 install \
      psutil

# Copy files from repository.

COPY ./rootfs /

# Downgrade to TLSv1.1

RUN sed -i 's/TLSv1.2/TLSv1.1/g' /etc/ssl/openssl.cnf

# Make non-root container.

USER 1001

# Set environment variables.

ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:/opt/IBM/db2/clidriver/lib
ENV ODBCSYSINI=/etc/opt/senzing
ENV PATH=${PATH}:/opt/senzing/g2/python:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin
ENV PYTHONPATH=/opt/senzing/g2/python
ENV SENZING_ETC_PATH=/etc/opt/senzing

# Runtime execution.

WORKDIR /
CMD ["/bin/bash"]
