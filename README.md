r-coverage-patch
================

Patches to add code coverage support in the R interpreter.

## Overview
This repository contains patches of the [R](http://www.r-project.org/) interpreter source code to add [code coverage](http://en.wikipedia.org/wiki/Code_coverage) support. 
It allows to know which exact lines of source code were exercized/hit/covered while running some piece of code (usually a test suite).
The easiest way to test it is using our docker container: https://github.com/quartzbio/r-coverage-docker

## Implementation
I added a condition in the internal C function **getSrcref()**, that records the line numbers if the code
coverage is started (via Rcov_start()).
The overhead should be minimal since for a given file, subsequent covered lines will be stored
in constant time. 
I use a hased env to store the occurrences by file.

I added two entry points in the utils package (Rcov_start() and Rcov_stop())

## Usage (see also https://github.com/quartzbio/r-coverage-docker#usage)
Start the patched R interpreter, then:
```r
library(devtools)
pkg  <- download.packages('testthat', '.', repos = "http://stat.ethz.ch/CRAN")
untar(pkg[1, 2])

Rcov_start()
test('testthat')
res <- as.list(Rcov_stop())
print(res)
```
