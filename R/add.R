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
