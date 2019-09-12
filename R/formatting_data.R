#' Remove/Replace Missing Slices 
#'
#' @param x 
#' @param option 
#'
#' @return
#' @export
#' @import expss
#' @import rlist
#' @import network
#' @import igraph
#' @import intergraph
#' @import matrixcalc
#' @examples
formatting_data <- function(x, option="remove") {
  if(is.igraph(x[[1]])) {
    warning('Package can not remove missing values from IGRPAH/TidyGraph data! (Data could be skewed) \n')
    x <- lapply(x, asNetwork)
  }
  if(is.network(x[[1]])) {
    warning('Data converted to a Sociomatrix! \n')
    x <- lapply(x, as.sociomatrix.sna)
  }
  if(!is.square.matrix(x[[1]])) {
    stop("Matrix needs to be square!")
  }
  missing_index <- c()
  for (i in 1:length(x)) {
    if (anyNA(x[i], recursive = TRUE)) {
      missing_index <- append(missing_index, i)
      missing_index <- as.numeric(missing_index)
    }
  }
  if (anyNA(x, recursive = TRUE)) {
    warning('You have missing data! \n')
    warning(paste('Missing slice:', missing_index, '\n'))
    switch (option,
            "remove" ={
              warning(paste('Removing missing slices \n'))
              x <- list.remove(x, missing_index)
              x <- lapply(x, function(z) z[-missing_index, -missing_index])
            },
            "replace"={
              warning(paste('Replacing missing slices with central graph \n'))
              x <- if_na(x, consensus(x, method="central.graph"))
            },
            "zero"={
              warning(paste('Replacing missing slice with zeros \n'))
              x <- if_na(x, 0)
            }
    )
  }
  return(x)
}