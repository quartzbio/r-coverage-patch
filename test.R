library(methods)
library(devtools)
pkg  <- download.packages('testthat', '.', repos = "http://stat.ethz.ch/CRAN")
untar(pkg[1, 2])

Rcov_start()
test('testthat')
env <- Rcov_stop()

res <- lapply(ls(env), get, envir = env)
names(res) <- ls(env)
print(res)
