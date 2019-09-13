#' Remove/Replace Missing Slices 
#'
#' @param dat 
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
formatting_data <- function(dat, option="remove") {
  if(is.igraph(dat[[1]])) {
    warning('Package can not remove missing values from IGRPAH/TidyGraph data! (Data could be skewed) \n')
    dat <- lapply(dat, asNetwork)
  }
  if(is.network(dat[[1]])) {
    warning('Data converted to a Sociomatrix! \n')
    dat <- lapply(dat, as.sociomatrix.sna)
  }
  if(!is.square.matrix(dat[[1]])) {
    stop("Matrix needs to be square!")
  }
  missing_index <- c()
  for (i in 1:length(dat)) {
    if (anyNA(dat[i], recursive = TRUE)) {
      missing_index <- append(missing_index, i)
      missing_index <- as.numeric(missing_index)
    }
  }
  if (anyNA(dat, recursive = TRUE)) {
    warning('You have missing data! \n')
    warning(paste('Missing slice:', missing_index, '\n'))
    switch (option,
            "remove" ={
              warning(paste('Removing missing slices \n'))
              dat <- list.remove(dat, missing_index)
              dat <- lapply(dat, function(z) z[-missing_index, -missing_index])
            },
            "replace"={
              warning(paste('Replacing missing slices with central graph \n'))
              dat <- if_na(dat, consensus(dat, method="central.graph"))
            },
            "zero"={
              warning(paste('Replacing missing slice with zeros \n'))
              dat <- if_na(dat, 0)
            }
    )
  }
  return(dat)
}