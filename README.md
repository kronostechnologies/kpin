**This tool is not used anymore.**

# kpin
ECR image pinning tool

## Setup

### Download

Debian:
```shell
git clone git@github.com:kronostechnologies/kpin
pipenv run ./kpin
```

Mac:
```shell
git clone git@github.com:kronostechnologies/kpin
pipenv run ./kpin
```

Docker:
```shell
wget https://raw.githubusercontent.com/kronostechnologies/kpin/master/docker-kpin -O ~/bin/kpin
chmod +x ~/bin/kpin
```


## Configure

### AWS credentials
An AWS profile configuration is required. Please refer to http://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html.

Config file example (~/.aws/config):
```
[profile ecr]
region = us-east-1
role_arn = arn:aws:iam::123456789012:role/ecr
source_profile = default
# credential_source = Environment
``` 

Credentials file example (~/.aws/credentials):
```
[default]
aws_access_key_id=YOUR_ID
aws_secret_access_key=YOU_SECRET_KEY
```

### kpin configuration file

Configuration file example (~/.config/kpin.yaml):
```
# Optional profile name, this overrides AWS_PROFILE environment variable.
aws_profile: ecr

# Optional role name to assume
aws_role_arn: arn:aws:iam:12346789012:role/ecr

# Optional region name, this overrides AWS_DEFAULT_REGION
aws_region: us-east-1

# Optional project matching rule. Useful when you have multiple images for the same project.
#
# Requirements: 
#  - The regular expression must contain a named group called 'project'
#  - An image must be named after the project name. It will be used to show pins and list image versions.
#
# Example: Images called 'my-project' and 'my-project-backend' are to be pinned simultaneously
project_matching_rule: '(?P<project>[a-z_\-]+?)(-backend)?'
```


## Usage

```
$ kpin -h
usage: kpin [-h] {set,s,env,e,show,versions,v} ...

optional arguments:
  -h, --help            show this help message and exit

Commands:
  {set,s,env,e,show,versions,v}
    set (s)             set pins
    env (e, show)       show environment pins
    versions (v)        list available versions
```


### Set pins for one or many projects in an environment
```
$ kpin s -h
usage: kpin set [-h] [--create-environment] ENVIRONMENT PROJECT [PROJECT ...]

positional arguments:
  ENVIRONMENT           environment pin to add
  PROJECT               project to pin: project@x.x.x-x (You can use * as
                        patch to get the latest patch. Can't be used with a
                        pre release)

optional arguments:
  -h, --help            show this help message and exit
  --create-environment  allows creation of an environment
```

Example:
```
$ kpin set my-prod a-project@1.0.0 another-project@2.0.3 another-other-project@2.1.*
```

### Show pins for one or many environments
```
$ kpin e -h
usage: kpin env [-h] [--old] [ENVIRONMENT [ENVIRONMENT ...]]

positional arguments:
  ENVIRONMENT  environment to list pins from (default all)

optional arguments:
  -h, --help   show this help message and exit
  --old        show old environments
```

Example:
```
$ kpin env my-prod
my-prod:
  a-project (1.0.0)
  another-project (2.0.3)
```

### Show versions for one or many projects
```
$ kpin v -h
usage: kpin versions [-h] [-l] [--old] [PROJECT [PROJECT ...]]

positional arguments:
  PROJECT       projects to list (default all)

optional arguments:
  -h, --help    show this help message and exit
  -l, --latest  show only the latest open and closed versions
  --old         show old pins
```

Example:
```
$ kpin versions a-project
a-project:
  1.0.0 (my-prod)
  1.0.1-0
  1.0.1
  1.0.2
  
$ kpin versions -l a-project
a-project:
  1.0.1-0
  1.0.2
```
