# kpin
ECR image pinning tool

## Setup

### Download

Linux:
```
git clone git@github.com:kronostechnologies/kpin
sudo apt-get install python3-pip python3
pip3 install -r requirements
```

Mac:
```
git clone git@github.com:kronostechnologies/kpin
brew install python3
pip3 install -r requirements
```

Docker:
```
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
role_arn = arn:aws:iam::123456789012:role/ecr-admin
source_profile = default
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
usage: kpin [-h] {set,show,list-versions} ...

optional arguments:
  -h, --help            show this help message and exit

Commands:
  {set,show,list-versions}
    set                 Set pins
    show                Show pins
    list-versions       List available versions
```


### Set pins for one or many projects in an environment
```
$ kpin set -h
usage: kpin set [-h] ENVIRONMENT PROJECT [PROJECT ...]

positional arguments:
  ENVIRONMENT  Environment pin to add
  PROJECT      Project to pin: project@semver

optional arguments:
  -h, --help   show this help message and exit
```

Example:
```
$ kpin set my-prod a-project@1.0.0 another-project@2.0.3
```

### Show pins for one or many environments
```
$ kpin show -h
usage: kpin show [-h] [ENVIRONMENT [ENVIRONMENT ...]]

positional arguments:
  ENVIRONMENT  Environment to list pins from

optional arguments:
  -h, --help   show this help message and exit

```

Example:
```
$ kpin show my-prod
my-prod:
  a-project (1.0.0)
  another-project (2.0.3)
```

### Show versions for one or many projects
```
$ kpin list-versions -h
usage: kpin list-versions [-h] [PROJECT [PROJECT ...]]

positional arguments:
  PROJECT

optional arguments:
  -h, --help  show this help message and exit
```

Example:
```
$ kpin list-versions a-project
a-project:
  1.0.0 (my-prod)
  1.0.1
  1.0.2
```

