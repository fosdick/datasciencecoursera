myfunc <- function(x) {
	y <- rnorm(100)
	mean(y)
}

myfunc2 <- function(x) {
	x + rnorm(length(x))
}