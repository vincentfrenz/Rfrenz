# Hello, world!
#
# This is an example function named 'hello' 
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B' / 'Ctrl + Shift + B'
#   Check Package:             'Cmd + Shift + E' / 'Ctrl + Shift + E'
#   Test Package:              'Cmd + Shift + T' / 'Ctrl + Shift + T'

#' Get Criterion networks from all perceptions
#'
#' @param sociomatrix 
#' @param criterion 
#'
#' @return
#' @export
#' @import sna
#' @import binda 
#' @examples
#' 
get_criterion <- function(sociomatrix, criterion){
  criterion_upper <- toupper(criterion)
  switch(criterion_upper, 
         "RLAS"={
           print("RLAS Criterion")
           return(consensus(sociomatrix, mode = "diagraph", method="OR.row"))
         },
         "CLAS"={
           print("CLAS Criterion")
           return(consensus(sociomatrix, mode = "diagraph", method="OR.col"))
         },
         "ILAS"={
           print("ILAS Criterion")
           return(consensus(sociomatrix, method="LAS.intersection"))
         },
         "ULAS"={
           print("ULAS Criterion")
           return(consensus(sociomatrix, method="LAS.union"))
         },
         "GA"={
           print("Global Aggregate Criterion")
           dat <- as.sociomatrix.sna(sociomatrix) 
           out <- matrix(data = as.numeric(apply(dat, c(2,3), sum, na.rm = TRUE)), nrow = dim(dat)[2],ncol = dim(dat)[2])
           return(out)
         },
         "GAT"={
           print("Global Aggregate Threshold Criterion")
           return(consensus(sociomatrix, method="central.graph"))
         },
         "GATV"={
           print("Global Aggregate Threshold (VALUED) Criterion")
           dat <- as.sociomatrix.sna(sociomatrix)  
           out <- matrix(data = as.numeric(apply(dat, c(2,3), mean, na.rm = TRUE)), nrow = dim(dat)[2],ncol = dim(dat)[2])
           return(out)
         },
         "SR"={
           print("Single Reweight Criterion")
           return(dichotomize(consensus(sociomatrix, method="single.reweight"), 0.5))
         },
         "IR"={
           print("Iterative Reweight Criterion")
           return(consensus(sociomatrix, method="iterative.reweight", maxiter = 500))
         },
         "RB"={
           print("Romney Batchelder Criterion")
           y <- consensus(sociomatrix, method="romney.batchelder")
           x <- dichotomize(y, 0.5)
           return(x)
         },
         "PCA"={
           print("Principle Component Analysis (PCA) Criterion")
           scale_f<-function(x){(x-min(x))/(max(x)-min(x))}
           return(dichotomize(scale_f(consensus(sociomatrix, method="PCA.reweight")), 0.5))
         },
         "BAY"={
           print("Bayesian Criterion")
           bay_output <- function(x){
             d <- apply(x$net, c(2, 3), mean)
             rownames(d) <- as.vector(x$anames)
             colnames(d) <- as.vector(x$anames)
             unname(as.sociomatrix.sna(d))
           }
           return(dichotomize(bay_output(bbnam(sociomatrix)), 0.5))
         }
  )
}