args <- commandArgs(TRUE)
if (length(args) > 0) x <- as.integer(args[1]) else x  <- 0
options(keep.source = TRUE)

library(devtools)
library(methods)
qbr <- '/home/karl/workspace/qbr'
#load_all(file.path(qbr, 'pkg')
#source(file.path(qbr, 'scripts/bootstrap_qbdev.R'))
##

load_all(file.path(qbr, 'pkg/qbdev_proj/qbdev'))
load_pkg('qbdb', src_pkgs = smart_find_src_pkgs(src_dir_path = qbr))

code <- "
tested_function <- function(x) {
  if (x == 0) return(0)
	
  y <- 1
  a <- 3 + y
  for (i in 1:10) {
	  a <- a + y + x
  }
  if (x == 1) return(1)
  
  a <- y + 3
  
  x + a
}
tested_function(1)
"

expr <- parse(text = code, keep.source = TRUE)
eval(expr)

#print(tested_function(x))
#Rcov(expr)
Rcov_start()
tab <- qbdf(iris)
env <- Rcov_stop()

res <- lapply(ls(env), get, envir = env)
names(res) <- ls(env)
print(res)
#print(tab)

#lm(Sepal.Length ~ Sepal.Width, data = iris)

#lines <- sort(unique(readLines('toto.txt')))
#df <- read.table(text = lines, header = FALSE, stringsAsFactors = FALSE)
#for (i in 1:nrow(df)) {
#	sf <- srcfile(df[i, 1])
#	cat(paste0(basename(df[i, 1]), '#', df[i, 2]), ':',  getSrcLines(sf, df[i, 2], df[i, 2]), '\n')
#}