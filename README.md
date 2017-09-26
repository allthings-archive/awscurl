# awscurl
[Signed AWS API requests](http://docs.aws.amazon.com/general/latest/gr/signing_aws_api_requests.html)
with a [curl](https://curl.haxx.se/docs/manpage.html) like API.

## Setup
Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.
Also set the `AWS_SECURITY_TOKEN` environment variable when using the
[AWS Security Token Service](http://docs.aws.amazon.com/STS/latest/APIReference/Welcome.html).

Define an alias for the docker based `awscurl` command:

```sh
alias awscurl='docker run --rm '\
'-e AWS_ACCESS_KEY_ID '\
'-e AWS_SECRET_ACCESS_KEY '\
'-e AWS_SECURITY_TOKEN '\
allthings/awscurl
```

## Usage

```sh
awscurl [-X request_method] [-H header:value] [-d post_data] URL
```

## Example

```sh
awscurl -X POST -H x-api-key:example -d '{"data":"example"}' \
  https://example.execute-api.eu-west-1.amazonaws.com/
```

## Build

```sh
docker-compose build
```

## License
Released under the [MIT license](https://opensource.org/licenses/MIT).
