# awscurl
[Signed AWS API requests](http://docs.aws.amazon.com/general/latest/gr/signing_aws_api_requests.html)
with a [curl](https://curl.haxx.se/docs/manpage.html) like API.

## Setup

### Docker alias
Define an alias for the docker based `awscurl` command:

```sh
alias awscurl='docker run --rm '\
'-e AWS_ACCESS_KEY_ID '\
'-e AWS_SECRET_ACCESS_KEY '\
'-e AWS_SECURITY_TOKEN '\
allthings/awscurl
```

### OS dependent binary
Download one of the OS dependent
[release files](https://github.com/allthings/awscurl/releases), save it as
`/usr/local/bin/awscurl` and make it executable with
`chmod +x /usr/local/bin/awscurl`.

## Usage

### Environment variables
Set the following
[AWS CLI environment variables](http://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html):
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_SECURITY_TOKEN` (optional)

`AWS_SECURITY_TOKEN` (= `AWS_SESSION_TOKEN`) is only required when using the
[AWS Security Token Service](http://docs.aws.amazon.com/STS/latest/APIReference/Welcome.html).

The recommended way to store and provide AWS CLI credentials is by using
[aws-vault](https://github.com/99designs/aws-vault).

### Options

```sh
awscurl [-X request_method] [-H header:value] [-d post_data] URL
```

### Example

```sh
awscurl -X POST -H x-api-key:example -d '{"data":"example"}' \
  https://example.execute-api.eu-west-1.amazonaws.com/
```

## Build

### Docker image

```sh
docker-compose build
```

### OS dependent binaries

```sh
make
```

## Release
Create a
[GitHub personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
with `repo` scope and set it as `GITHUB_TOKEN` environment variable.

Commit your changes, create a git tag and execute `make` to cross-compile the
binaries.

Then execute the following to release the binaries on GitHub:

```sh
./github-release.sh awscurl-*
```

## License
Released under the [MIT license](https://opensource.org/licenses/MIT).
