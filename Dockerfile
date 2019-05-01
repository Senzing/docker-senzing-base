ARG BASE_IMAGE=debian:9
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-03-22

LABEL Name="senzing/senzing-base" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      curl \
      gnupg \
      jq \
      lsb-core \
      lsb-release \
      odbc-postgresql \
      postgresql-client \
      python-dev \
      python-pip \
      python-pyodbc \
      sqlite \
      unixodbc \
      unixodbc-dev \
      wget \
 && rm -rf /var/lib/apt/lists/*

# Install packages via pip.

RUN pip install \
    psutil \
    pyodbc

# Set environment variables.

ENV SENZING_ROOT=/opt/senzing
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib:${SENZING_ROOT}/g2/lib/debian:${SENZING_ROOT}/db2/clidriver/lib
ENV DB2_CLI_DRIVER_INSTALL_PATH=${SENZING_ROOT}/db2/clidriver
ENV PATH=$PATH:${SENZING_ROOT}/db2/clidriver/adm:${SENZING_ROOT}/db2/clidriver/bin

# Copy files from repository.

COPY ./rootfs /

# Runtime execution.

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["/bin/bash"]
