#' Remove/replace missing slices
#'
#' @param dat A list of socio-matrices containing all of the perceptions of a network
#' @param option Option whether to remove or replace missing values ("remove", "replace", "zero")
#'
#' @description
#' This function removes any missing perceptions (slices) from a list of socio-matrices. Three different options exist:
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
#' @importFrom sna as.sociomatrix.sna
#' @importFrom expss if_na
#' @importFrom rlist list.remove
#' @importFrom network is.network
#' @importFrom igraph is.igraph
#' @importFrom intergraph asNetwork
#' @importFrom matrixcalc is.square.matrix
#' @examples
#' # Creating list of matrices for exmaple
#' r1 <- matrix(c(0,1,0,1,0,
#' 0,0,1,1,0,
#' 1,0,0,1,1,
#' 0,1,0,0,1,
#' 0,1,0,1,0),nrow=5, ncol=5)
#' r2 <- matrix(c(0,1,1,1,0,
#'                0,0,1,1,0,
#'                1,0,0,1,0,
#'                1,1,0,0,1,
#'                1,1,0,1,0),nrow=5, ncol=5)
#' r3 <- matrix(c(0,1,1,1,0,
#'                1,0,1,1,0,
#'                1,1,0,0,0,
#'                0,1,0,0,1,
#'                1,1,0,1,0),nrow=5, ncol=5)
#' r4 <- matrix(c(0,1,0,1,0,
#'                1,0,1,1,1,
#'                1,0,0,1,1,
#'                0,1,0,0,0,
#'                0,0,0,1,0),nrow=5, ncol=5)
#' r5 <- matrix(c(NA,NA,NA,NA,NA,
#'                NA,NA,NA,NA,NA,
#'                NA,NA,NA,NA,NA,
#'                NA,NA,NA,NA,NA,
#'                NA,NA,NA,NA,NA),nrow=5, ncol=5)
#'
#' list_respondent <- list(r1,r2,r3,r4,r5)
#'
#' formatted_data <- formatting_data(list_respondent, option = "replace")
#'
#' @references
#' \insertAllCited{}
#'
formatting_data <- function(dat, option="remove") {
  len<-length(dat)
  for(x in 1:len){
    rownames(dat[[x]])<-as.character(1:len)
    colnames(dat[[x]])<-as.character(1:len)
  }

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
