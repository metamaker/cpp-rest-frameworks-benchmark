This is performance benchmark of popular C++ REST frameworks.

# What this repository contains

This repository contains:

- Code of each sample implementation.
- Vagrant configuration of virtual machine where to build all samples and run benchmark.
- Benchmark results.

# Samples

Code of samples is located in [samples folder](https://github.com/metamaker/cpp-rest-frameworks-benchmark/tree/master/samples).

Scenario of each sample is the same:

1. Client performs GET request to HTTP server.
2. HTTP server must return JSON array of 10,000 items.

There are several implementations of HTTP server:

- C++ : [cpprestsdk](https://github.com/Microsoft/cpprestsdk)
- C++ : [restbed](https://github.com/corvusoft/restbed)
- C++ : [pistache](https://github.com/oktal/pistache)
- C++ : [poco](https://github.com/pocoproject/poco)
- PHP : Native implementation

# Benchmark

Results of benchmark are located in [results folder](https://github.com/metamaker/cpp-rest-frameworks-benchmark/tree/master/results).

Benchmark was done by running `ab -n 1000 -c 1 -k <url>` (see [Apache Benchmark](https://httpd.apache.org/docs/2.4/programs/ab.html)) against each implementation.

# Summary

## cpprestsdk

#### Benchmark results for default JSON implementation on Linux

![cpprestsdk benchmark results](https://raw.githubusercontent.com/metamaker/cpp-rest-frameworks-benchmark/master/results/benchmark-cpprestsdk-default_json_impl.png)

#### Benchmark results with RapidJSON on Linux

![cpprestsdk benchmark results](https://raw.githubusercontent.com/metamaker/cpp-rest-frameworks-benchmark/master/results/benchmark-cpprestsdk-rapidjson.png)

(+) Code documentation of cpprestsdk is one of the best amongst all projects that I have ever seen during my 8 years carreer as software developer. Examples are well structured and easy to reproduce.

(+) cpprestsdk has its own implementation of JSON serializer/deserializer, so you don't need to additionally include RapidJSON or other library.

(+) cpprestsdk is included in Ubuntu 16 Xenial official repository, so you can install it easily by running single `apt` command.

(+) Licensed under MIT.

(-) Worst performance (even worse than PHP) on Linux server. There is opened issue for this problem on project's github (https://github.com/Microsoft/cpprestsdk/issues/468), but it is not solved yet.

## restbed

![restbed benchmark results](https://raw.githubusercontent.com/metamaker/cpp-rest-frameworks-benchmark/master/results/benchmark-restbed.png)

(+) Good documentation on design of framework.

(+) Small and easy to use.

(-) No inline code documentation.

(-) Licensed under either AGPL or proprietary license.

(-) Some important features are still missing, e.g. server-side caching and HTTP2 compliance.

## pistache

![pistache benchmark results](https://raw.githubusercontent.com/metamaker/cpp-rest-frameworks-benchmark/master/results/benchmark-pistache.png)

(+) Fastest performance.

(+) Small and easy to use.

(+) Licensed under Apache License 2.0.

(-) No inline code documentation.

(-) No comprehensive list of implemented features.

(-) Installation instructions are not present in repository and not obvious to find (you should look on "Getting started" page, not on "User's Guide" FYI).

(-) Unit tests are ill-formed.

## PHP native implementation 

![PHP native implementation benchmark results](https://raw.githubusercontent.com/metamaker/cpp-rest-frameworks-benchmark/master/results/benchmark-php.png)
