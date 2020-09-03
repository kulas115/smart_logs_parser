# LogsParser [![CircleCI](https://circleci.com/gh/kulas115/smart_logs_parser.svg?style=svg)](https://circleci.com/gh/kulas115/smart_logs_parser) [![Maintainability](https://api.codeclimate.com/v1/badges/ec62b03b89623f0468a3/maintainability)](https://codeclimate.com/github/kulas115/smart_logs_parser/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/ec62b03b89623f0468a3/test_coverage)](https://codeclimate.com/github/kulas115/smart_logs_parser/test_coverage)

Simple ruby script to parse log file in format `<url_address> <ip_address>` and return count of total or unique visits.

## Prerequisites

* Docker (optional)

## Usage

This project is using `Docker` and `Makefile` to enable swift and reliable usage however `parse` can also be run directly.

In the root of the repository is an example file with logs - `webserver.log` that should be provided as an argument to `parser` script.

To parse the file you got two options:
* run directly in the root of the repository:
```bash
./bin/parse webserver.log
```
* run script in `Docker` container:
```bash
make run_parser args='./webserver.log'
```

Example output:
```
/about/2 90 visits
/contact 89 visits
/index 82 visits
/about 81 visits
/help_page/1 80 visits
/home 78 visits
```

The parser returns the total count of visits by default but that can be changed by passing `-o unique` while running it. This yields:
* while running directly:
```bash
./bin/parse webserver.log -o unique
```
* while running via `make` with `Docker`:
```bash
make run_parser args='./webserver.log -o unique'
```

Example output:
```
/help_page/1 23 unique views
/contact 23 unique views
/home 23 unique views
/index 23 unique views
/about/2 22 unique views
/about 21 unique views
```

## Development

The project is using some fundamental gems that provide ease of development:

    bundler-audit
    pry
    rspec
    rubocop
    rubocop-rspec
    rubocop-performance
    simplecov

To enter container with shell run:
```bash
make run_shell
```

It will build the project's Docker image and run the container with `sh` shell inside.

## Tests

To run the test simply use the command:
```bash
rspec
```
or
```bash
make run_test
```

`make` command will build a Docker image, start the container, and run `rspec` inside.
It will print results and test coverage.
The project uses unit and integration tests that offer 100% test coverage (measured by SimpleCov).
