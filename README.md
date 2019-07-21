# CIexamplePkg

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/o1iv3r/CIexamplePkg.svg?branch=master)](https://travis-ci.org/o1iv3r/CIexamplePkg)
[![Codecov test coverage](https://codecov.io/gh/o1iv3r/CIexamplePkg/branch/master/graph/badge.svg)](https://codecov.io/gh/o1iv3r/CIexamplePkg?branch=master)
<!-- badges: end -->

This package provdes a quick guide on how to develop an R package from scratch and use Travis CI. A very nice general introduction can be found here:

[rOpenSci Packages: Development, Maintenance, and Peer Review](https://devguide.ropensci.org/)

# R package basics

First, create a new package, e.g. using the RStudio GUI. The *usethis* package provides all upcoming steps immensely:

```{r eval=FALSE}
library(usethis)
```

Feel free to delete the hello world example (R and Rd file). We'll add the functionality via

```{r eval=FALSE}
use_r("add.R")
```

The code we add is as follows:

```{r eval=FALSE}
add <- function(a,b) {
  return(a+b)
}
```


To see the new function in action run "Install and Restart" from the Build tab:

```{r eval=FALSE}
add(7,2)
```

We'll now add more functionality:

```{r eval=FALSE}
add <- function(a,b,plot=FALSE) {
  val <- a+b
  if (plot==TRUE) {
    df <- data.frame(x=c(a,b,val))
    p <- ggplot2::ggplot(df) + ggplot2::geom_col(ggplot2::aes(x=x,y=x))
    print(p)
  }
  return(val)
}
```


Use "Source on save" to play around with the function. When done, install and restart again.

```{r eval=FALSE}
add(4,16,plot=TRUE)
```


The package now depends on ggplot2. We have to add this to the description file

```{r eval=FALSE}
use_package("ggplot2", "Imports")
```

As usethis tells you to do, always refer to functions with `ggplot2::fun()`.

Finally, we'll ad a license to our package

```{r eval=FALSE}
use_gpl3_license(name = "Oliver Pfaffel") # required to share improvements
```

If you are a pipe fan, you can easily make it available via

```{r eval=FALSE}
use_pipe() # Use %>%
```



## Documentation

We'll add a news and readme file. 

```{r eval=FALSE}
use_news_md()
use_readme_md() # use_readme_rmd() IF you want to run R code in your readme
```
