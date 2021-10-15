# CentOS Linux for Docker

A small CentOS Linux base image designed for use in containers.

All non-required packages were removed to create this small image. When using
this image you may have to install some of the packages that usually are
installed on a regular CentOS Linux image.

## Supported tags

- [`7`](https://github.com/fscm/docker-centos/blob/master/centos7/Dockerfile)
- [`8`](https://github.com/fscm/docker-centos/blob/master/centos8/Dockerfile)
- [`stream-8`][latest], [`stream`][latest], [`latest`][latest]

[latest]: https://github.com/fscm/docker-centos/blob/master/centos8-stream/Dockerfile

## What is CentOS?

> The CentOS Project is a community-driven free software effort focused on delivering a robust open source ecosystem. For users, we offer a consistent manageable platform that suits a wide variety of deployments. For open source communities, we offer a solid, predictable base to build upon, along with extensive resources to build, test, release, and maintain their code.

*from* [centos.org](https://www.centos.org)

## Getting Started

There are a couple of things needed for the script to work.

### Prerequisites

Docker, either the Community Edition (CE) or Enterprise Edition (EE), needs to
be installed on your local computer.

#### Docker

Docker installation instructions can be found
[here](https://docs.docker.com/install/).

### Usage

To start a container with this image and run a shell use the following
command (the container will be deleted after exiting the shell):

```shell
docker container run --rm --interactive --tty fscm/centos bash
```

## Build

Build instructions can be found
[here](https://github.com/fscm/docker-centos/blob/master/README.build.md).

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/docker-centos/tags).

## Authors

- **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/docker-centos/contributors)
who participated in this project.
