#' Remove/Replace Missing (NA) Slices 
#'
#' @param dat A List of socio-matracies containing all of the perceptions of a network
#' @param option Opstion whether to remove or replace missing values ("remove", "replace", "zero")
#' 
#' @description
#' This function removes any missing perceptions (slices) from a list of socio-matracies. Three different options exist:
#' removing missing slices, replacing missing slices with central graph or replacing missing values with 0.
#' 
#' @details 
#' Missing data can affect the formation of the actual networks. In order to deal with this,
#' missing perceptions can be set to a blank perception (0),
#' or replaced with an estimate value, or the missing respondents can be omitted.
#' \describe{
#' \item{"remove"}{This option will omit the missing values completely. Omitting the missing respondents results in effectively sampling the original data \insertCite{Borgatti2006}{Rfrenz}.}
#' \item{"replace"}{This option will replace the missing values of the obeserver with the central graph consensus of the network.}
#' \item{"zero"}{This option will replace all the missing values of the obeserver with the value 0. This however, can result in inaccurate outcomes \insertCite{Krackhardt2002}{Rfrenz}.}
#' }
#' @return
#' A list of socio-matracies with the removed/replaced slices within the list
#' 
#' @author
#' Christiaan van Rensburg, Alex Cawood, Marette Theron
#' 
#' @export
#' @import expss
#' @import rlist
#' @import network
#' @import igraph
#' @import intergraph
#' @import matrixcalc
#' @examples
#' @references 
#' \insertAllCited{}
#' 
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