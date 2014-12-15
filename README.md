r-coverage-patch
================

Patches to add code coverage support in the R interpreter.

## Overview
This repository contains patches of the [R](http://www.r-project.org/) interpreter source code to add [code coverage](http://en.wikipedia.org/wiki/Code_coverage) support. 
It allows to know which exact lines of source code were exercized/hit/covered while running some piece of code (usually a test suite).
The easiest way to test it is using our docker container: https://github.com/quartzbio/r-coverage-docker

## Installation
As stated above, you can just use the docker container.
To patch it manually:
 1. choose the appropriate patch corresponding to the version of the R interpreter you are going to use.
 1. get the source code of the R version (download and untar)
 2. patch the source code (patch)
 3. configure the source directory (./configure)
 4. compile and install (make; make install)

The project is organized in sudirectories per supported R version, e.g. r302 for R version 3.0.2.
The above steps are somewhat automated using a Makefile (you need probably GNU make).
For example, to download, untar, patch, configure, make and install R-3.0.2:
```bash
git clone https://github.com/quartzbio/r-coverage-patch.git
cd r-coverage-patch/r302/
# download, untar and patch
make apply_production_patch 
# install in ./local/
make install 
# Or install in a custom place
make install PREFIX=/whatever/

# run it
./local/bin/R

```



## Implementation
I added a condition in the internal C function **getSrcref()**, that records the line numbers if the code
coverage is started (via Rcov_start()).
The overhead should be minimal since for a given file, subsequent covered lines will be stored
in constant time. 
I use a hashed env to store the occurrences by file.

I added two entry points in the utils package (**Rcov_start()** and **Rcov_stop()**)

### viewing the main patched file: eval.c
For convenience (Caution: it can be outdated), I included the main patched file in the repo, 
you can view it here: https://github.com/quartzbio/r-coverage-patch/blob/master/r302/patched_files/eval.c

## Usage 
(see also https://github.com/quartzbio/r-coverage-docker#usage).

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
