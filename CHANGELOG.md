# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6.0] - 2021-07-13

### Added in 1.6.0

- Updated to Debian 10.9
- Moved python requirements to external file

## [1.5.5] - 2020-09-24

### Added in 1.5.5

- Add environment variable for root

## [1.5.4] - 2020-09-24

### Added in 1.5.4

- Added `gdb` package

### Removed in 1.5.4

- Removed `pstack` package

## [1.5.3] - 2020-09-23

### Added in 1.5.3

- Added `pstack` package

## [1.5.2] - 2020-07-22

### Changed in 1.5.2

- Removed environment variable: `SENZING_CONFIG_FILE`

## [1.5.1] - 2020-07-07

### Changed in 1.5.1

- Added environment variables: `SENZING_ETC_PATH`, `SENZING_CONFIG_FILE`, `ODBCSYSINI`
- Removed environment variable: `SENZING_ROOT`
- Modified `PATH`

## [1.5.0] - 2020-06-16

### Changed in 1.5.0

- Downgraded TLS to TLSv1.1

## [1.4.0] - 2020-01-29

### Changed in 1.4.0

- Upgrade Dockerfile to `FROM debian:10.2`

## [1.3.0] - 2019-11-13

### Added in 1.3.0

- Added support for Microsoft MSSQL database

## [1.2.1] - 2019-08-15

### Changed in 1.2.1

- Added support for IBM Db2 database

## [1.2.0] - 2019-08-05

### Changed in 1.2.0

- RPM based installation

## [1.1.0] - 2019-07-23

### Added in 1.1.0

- Is now a `non-root`, immutable container
- Moved root, mutable functions to [docker-init-container](https://github.com/Senzing/docker-init-container)

## [1.0.3] - 2019-07-10

### Added in 1.0.3

- Support for Python3.

## [1.0.2] - 2019-07-10

### Removed in 1.0.2

- ODBC support.

## [1.0.1] - 2019-07-08

### Changed in 1.0.1

- Db2 configuration only done when Db2 is specified.

## [1.0.0] - 2019-06-18

### Added in 1.0.0

- Debian base as recommended by DockerHub.
  - "Choose a Secure Base Image" section of [Docker Store Program and Policies](https://success.docker.com/article/store)
- Python 2.7 support
- Database support
  - PostgreSQL
  - MySQL
  - Db2
  - SQLite
