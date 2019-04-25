# kpin
ECR image pinning tool

## Setup

### Download

Linux:
```
git clone git@github.com:kronostechnologies/kpin
sudo apt-get install python3-pip python3
pip3 install -r requirements.txt
```

Mac:
```
git clone git@github.com:kronostechnologies/kpin
brew install python
pip3 install -r requirements.txt
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
role_arn = arn:aws:iam::123456789012:role/ecr
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
usage: kpin [-h] {set,show,versions,list-versions} ...

optional arguments:
  -h, --help            show this help message and exit

Commands:
  {set,show,versions,list-versions}
    set                 set pins
    show                show pins
    versions (list-versions)
                        list available versions
```


### Set pins for one or many projects in an environment
```
$ kpin set -h
usage: kpin set [-h] ENVIRONMENT PROJECT [PROJECT ...]

positional arguments:
  ENVIRONMENT  environment pin to add
  PROJECT      project to pin: project@x.x.x-x
               You can use * as patch to get the latest patch. Can't be used with a pre release

optional arguments:
  -h, --help   show this help message and exit
```

Example:
```
$ kpin set my-prod a-project@1.0.0 another-project@2.0.3 another-other-project@2.1.*
```

### Show pins for one or many environments
```
$ kpin show -h
usage: kpin show [-h] [ENVIRONMENT [ENVIRONMENT ...]]

positional arguments:
  ENVIRONMENT  environment to list pins from

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
$ kpin versions -h
usage: kpin versions [-h] [-l] [PROJECT [PROJECT ...]]

positional arguments:
  PROJECT

optional arguments:
  -h, --help    show this help message and exit
  -l, --latest  show only the latest open and closed versions
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
