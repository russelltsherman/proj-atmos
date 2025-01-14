# Debian/Atmos Infrastructure Management DevContainer

Atmos is both a library and a command-line tool
for provisioning, managing and orchestrating workflows
across various toolchains.

- [atmos](https://atmos.tools/).

## usage

for basic atmos orientation see the [tutorial](https://docs.cloudposse.com/tutorials/)

### build and run the atmos container

```sh
make build; make infra
```

### available atmos commands

```sh
Usage:
  atmos [command]

Available Commands:
  atlantis    Execute 'atlantis' commands
  aws         Execute 'aws' commands
  completion  Generate the autocompletion script for the specified shell
  describe    Execute 'describe' commands
  helmfile    Execute 'helmfile' commands
  help        Help about any command
  infracost   Runs infracost on existing plans

  play        This command plays games
  show        Execute 'show' commands
  terraform   Execute 'terraform' commands
  tf          Execute 'terraform' commands
  validate    Execute 'validate' commands
  vendor      Execute 'vendor' commands
  version     Print the CLI version
  workflow    Execute a workflow

Flags:
  -h, --help   help for atmos
```

### AWS Authentication

When applying terraform you should use aws sso and authenticate to the root Exhale account.
When applying helmfile you should use aws sso and authenticate to the aws account which holds the specific eks cluster which you want to manage.

### atmos command examples

Noticeable `atmos` commands:

```bash
atmos version
atmos validate stacks
atmos describe stacks
atmos describe component infra/vpc -s tenant1-ue2-dev
atmos terraform plan infra/vpc -s tenant1-ue2-dev
atmos terraform plan test/test-component-override -s tenant1-ue2-dev
atmos terraform plan test/test-component-override-3 -s tenant1-ue2-dev
atmos terraform validate test/test-component-override -s tenant1-ue2-dev
atmos terraform output test/test-component-override -s tenant1-ue2-dev
atmos terraform graph test/test-component-override -s tenant1-ue2-dev
atmos terraform show test/test-component-override -s tenant1-ue2-dev
atmos terraform shell test/test-component-override -s tenant1-ue2-dev
```

### clean terraform artifacts

make clean
