# CIexamplePkg

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/o1iv3r/CIexamplePkg.svg?branch=master)](https://travis-ci.org/o1iv3r/CIexamplePkg)
[![Codecov test coverage](https://codecov.io/gh/o1iv3r/CIexamplePkg/branch/master/graph/badge.svg)](https://codecov.io/gh/o1iv3r/CIexamplePkg?branch=master)
<!-- badges: end -->

This package provdes a quick guide on how to develop an R package from scratch and how use Travis CI. A very nice general introduction can be found here:

[rOpenSci Packages: Development, Maintenance, and Peer Review](https://devguide.ropensci.org/)

Some material is taken from the awesome UseR 2019 tutorial from Colin Gillespie: []{https://www.jumpingrivers.com/t/2019-user-git/#1}

# R package basics

First, create a new package, e.g. using the RStudio GUI. The *usethis* package facilitates all upcoming steps immensely:

```{r eval=FALSE}
library(usethis)
```

Feel free to delete the hello world example (R and Rd file in R and man folder). We'll add new functionality via

```{r eval=FALSE}
use_r("add.R")
```

The code we add is as follows:

```{r eval=FALSE}
add <- function(a,b) {
  return(a+b)
}
```


To see the new function in action run "Install and Restart" from the "Build" tab:

```{r eval=FALSE}
add(7,2)
```

We'll now add more functionality. Note that one should always refer to the package of a function using "::". If you don't do this, the check later gives an error. Thus we refer to all ggplot functions with `ggplot2::fun()`.

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

Finally, we'll ad a license to our package:

```{r eval=FALSE}
use_gpl3_license(name = "Oliver Pfaffel") # change to your name
```

If you are a pipe fan, you can easily make it available via

```{r eval=FALSE}
use_pipe() # Use %>%
```
We do not need it here.


## Documentation

We'll add a news and readme file. 

```{r eval=FALSE}
use_news_md()
use_readme_md() # use_readme_rmd() IF you want to run R code in your readme
```

We change the readme file as follows.

```{r eval=FALSE}
# CIexamplePkg

<!-- badges: start -->
<!-- badges: end -->

The goal of CIexamplePkg is to provide a simple example on how to set up a package for continuous integration.
```

Be sure to keep the news file up to date. You can increment the version number via

```{r eval=FALSE}
use_version()
```

You can also add a vignette, but we'll not do this here.

```{r eval=FALSE}
use_vignette("name_of_vignette")
```

Every R function should have a documentation. We'll change the code of our function to

```{r eval=FALSE}
#' Sum up two variables
#'
#' What is the sum of a and b?
#'
#' @param a numeric
#' @param b numeric
#' @param plot Makes plot if TRUE
#'
#' @return Returns a numeric that is the sum of a and b.
#'
#' @examples
#' add(7,2)
#' add(4,16,plot=TRUE)
#'
#' @export
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


The function will now be exported to the namespace of our package, if we delete the existing NAMESPACE file first.
After "Install and Restart" we build the documentation via

```{r eval=FALSE}
devtools::document()
```

Now the documentation is available via

```{r eval=FALSE}
?add
```


## Checking the package

Now we should check the package (there also is a button for this in RStudio)

```{r eval=FALSE}
devtools::check(document = FALSE)
```

To remove the note about non-standard files on top level, we simply ignore those file when building R

```{r eval=FALSE}
use_build_ignore("name of file to ignore.filetype")
```

## Tests

Every R package should have tests that automatically check core functionality

```{r eval=FALSE}
use_test("add")
```

We'll simply change the code to

```{r eval=FALSE}
test_that("addition works", {
  expect_equal(add(7,2), 9)
})
```

and run the test. It should be successfull.

# Continous integration

## Using github

Run the following commands and allow git to comit all files. Then restart RStudio.

```{r eval=FALSE}
usethis::use_git()
usethis::use_git_config(user.name = "Oliver Pfaffel", user.email = "opfaffel@gmail.com") # change to your name and email
```

Now create a github PAT (personal access token) from the github page and add it to the environment

```{r eval=FALSE}
usethis::edit_r_environ()
```

Add the line GITHUB_PAT=YOUR-PAT, restart R and run

```{r eval=FALSE}
Sys.getenv("GITHUB_PAT")
```

to see if it works. Next we create a github repo via the github website. Then commit and push all files (copy and paste the code suggested at github to the terminal or use the RStudio GUI).

## Travis CI

Make a travis account and log in. Add Travis to your package via

```{r eval=FALSE}
usethis::use_travis()
```

Turn on travis for your repo at https://travis-ci.org/profile/o1iv3r as usethis says (your link will include your repo name).

Add your github PAT to the Travis environment variables via options -> settings -> Environment variables

*NAME: GITHUB_PAT
*VALUE: <token>
    
Travis will now run each time we push to github. Try this out! Note that this might take some time. After a successfull build you might notice the nice badge on your github page.


## Advanced Travis options

Building wrt different R versions:

Add

r:
  - oldrel
  - release
  - devel

to your .travis.yml

This means we can test against three versions of R with no effort

Build only for certain branches via

```{r eval=FALSE}
branches:
  only:
  - master
  - stable
```

or exclude some (experimental) branches via

```{r eval=FALSE}
branches:
  except:
  - legacy
  - experimental
```
## Test coverage

We want Travis not only to run the tests but also to report test coverage. We'll do this via the covr package

```{r eval=FALSE}
use_coverage()
```

Make sure to copy 

```{r eval=FALSE}
r_github_packages:
  - r-lib/covr

after_success:
  - Rscript -e 'covr::codecov()'
```
to your travis.yml


Then got to [](https://codecov.io/) and add your repo. You will get a token that you have to add ad an Travis env variable (similar to your github PAT)

*NAME: CODECOV_TOKEN
*VALUE: <token>

Now commit and push your changes to github and enjoy your new coverage badge.

By the way, the covr package has a nice Addin that graphically shows you test coverage:

```{r eval=FALSE}
library(covr)
# Addins -> Calculate text package coverage
```

