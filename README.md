# Docker OpenSSH Host Keys

Generates SSH host keys in a Docker container and copies them to a mounted
directory.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Usage](#usage)
- [Configuration](#configuration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## Usage

This command will generate and copy a set of SSH host keys to the
`/path/to/target` directory:

```bash
docker run \
  --rm \
  -e SSH_HOST_KEYS_OWNER=root \
  -e SSH_HOST_KEYS_GROUP=root \
  -e SSH_HOST_KEYS_MODE=644 \
  -e SSH_HOST_KEYS_DIRECTORY_MODE=700 \
  -v /path/to/target:/target \
  mediacomem/openssh-host-keys
```



## Configuration

The generated SSH host keys can be customized through these environment
variables. All variables are optional.

Variable                       | Default value | Description
:----------------------------- | :------------ | :-------------------------------------------------------------------------
`SSH_HOST_KEYS_OWNER`          | `root`        | User or UID who will own the generated SSH host keys.
`SSH_HOST_KEYS_GROUP`          | `root`        | Group or GID that will own the generated SSH host keys.
`SSH_HOST_KEYS_MODE`           | `644`         | File system permissions of the generated SSH host keys.
`SSH_HOST_KEYS_DIRECTORY_MODE` | -             | Optional file system permissions that will be set on the target directory.
