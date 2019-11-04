#' Get Criterion networks from all perceptions
#'
#' @param dat A list of socio-matrices containing all of the perceptions of a network
#' @param criterion The criterion network needed to be generated (“RLAS”, “CLAS”, “ILAS”, “ULAS”, “GA”, “GAT”, “GAV”, “SR”, “IR”, “PCA”, “RB”, “BAY”)
#'
#'
#' @description
#' This function generates a criterion (true) network given all the perceptions perceived in a  network. Several algorithms for determining criterion networks are available to best suit the context of the network.
#'@usage
#'get_criterion(dat, criterion=”RLAS”)
#'
#' @details
#' Criterion (also called true or actual) networks are representative of the notion of shared or common perceptions of social structures from all observers within a network. Various different algorithms exist to derive these actual networks namely: Local Aggregate Structures (LAS), Consensus Structures and Expert Structures \insertCite{Krackhardt1987a}{Rfrenz}\insertCite{Cornelissen2019}{Rfrenz}.
#'
#'\strong{Local Aggregate Structures (LAS)}
#'
#'LAS is suitable in a context to generate which suggests that only the individuals directly involved in the relation determine the existence of the relation.
#'\describe{
#' \item{RLAS: Row-Dominated LAS}{An RLAS criterion is created by determining whether or not the perceiver observes the relationship to exist, even though the receiver does not always necessarily deem it to exist \insertCite{Krackhardt1987a}{Rfrenz}. Thus, the sender of the relationship will be assumed as correct. Function used: \link[sna:consensus]{consensus} from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#' \item{CLAS: Column-Dominated LAS.}{CLAS is created by determining whether or not the receiver of the relation perceives the relation to exist. Thus, the receiver of the relationship will be assumed as correct. Function used: \link[sna:consensus]{consensus} from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#' \item{ILAS: Intersection LAS}{ILAS criterion networks are created by determining whether or not both respondents perceive the tie to exist. Thus, both respondents have to agree on the relationship in order for it to exist \insertCite{Krackhardt1987a}{Rfrenz}. Function used: \link[sna:consensus]{consensus} from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#' \item{ULAS: Union LAS}{ULAS defines relations to exist if at least one of the respondents involved in the relation perceives it to exist \insertCite{Krackhardt1987a}{Rfrenz}. Function used: \link[sna:consensus]{consensus} from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#' }
#'
#' \strong{Consensus Structures}
#' \describe{
#' \item{GA: Global Aggregate}{Using Global Aggregate to generate actual networks is not so much focused on who perceived a specific relations, but rather how many perceived that relation. This is done by taking the sum of relationships that exists for each observer.}
#' \item{GAT: Global Aggregate with a threshold}{The threshold is set to measure the proportion of members that perceive a relation between the sender and receiver of the relationship. This corresponds to a “median response” notion of creating an actual network. Function used: \link[sna:consensus]{consensus}from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#' \item{GAV: Global Aggregate (valued)}{To gain a clearer understanding of the global perception of a relation, one could make use of proportions rather than showing only the presence or absence of a perceived relation (i.e. the GAT method). Thus, this method shows which percentage of observers perceived the relationship.}
#' }
#'
#' \strong{Expert Structures}
#' \describe{
#' \item{SR: Single Reweight}{The reweight method takes consensus structure to create an initial criterion network. The reweight method is then applied to give a more accurate representation of the perceptions in the network. This is done is by performing consensus structure reduction on the data again but with different perceivers weighted according to their accuracy in perceiving relations in original criterion network. The single reweight method is when there is only one additional reduction done using the reweighted nodes. Function used: \link[sna:consensus]{consensus} from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#' \item{IR: Iterative Reweight}{Similar to Single Reweight except this method applies multiple reductions to weigh perceivers differently in each iteration. This can be useful when there is a disconnect between different perceptions which results in relations which are not accurate or don't exist. IR tries to find the most accurate perceivers in the network in order to give their perceptions of relations more validity when determining the criterion network. Function used: \link[sna:consensus]{consensus} from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#' \item{RB: Romney Batchelder}{Similar to Single Reweight method but with an exception to the motivation. Romney Batchelder theory's motivation lies in the measurement of shared beliefs in a group.  The criterion is built on the “cultural competency” weighted perceptions. Measuring “cultural competency” of respondents is done by determining the correlation between the responses of each individual and the aggregated responses of the group.}
#' \item{PCA: Principal Component Analysis.}{The PCA method for generating actual networks uses the first component of a network. PCA extracts shared themes among all the respondents within a network \insertCite{Butts2016}{Rfrenz}. PCA reduces the dimensions and relationships considered a data set while still maintaining the most important information within it. Function used: \link[sna:consensus]{consensus} from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#' \item{BAY: Bayesian}{Network accuracy model method can be used to generate the criterion network given the probability of false positives and false negatives. For more information see Bayesian. Function used: \link[sna:bbnam]{consensus}  from the SNA package \insertCite{Butts2016}{Rfrenz}.}
#'}
#'@return
#'A socio-matrix representing the Criterion ('true') Network structure
#'
#'@author
#'Christiaan van Rensburg, Alex Cawood, Marette Theron
#'
#' @return
#' @export
#' @importFrom sna consensus
#' @importFrom sna as.sociomatrix.sna
#' @importFrom sna bbnam
#' @importFrom binda dichotomize
#' @importFrom Rdpack reprompt
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
#' crit <- get_criterion(list_respondents, criterion='RLAS')
#'
#' @references
#' \insertAllCited{}
#'
get_criterion <- function(dat, criterion="RLAS"){
  criterion_upper <- toupper(criterion)
  len<-length(dat)
  dat <- formatting_data(dat)
  names <- colnames(dat[[1]])
  crit<-NULL

  switch(criterion_upper,
         "RLAS"={
           print("RLAS Criterion")
           crit<-(consensus(dat, mode = "diagraph", method="OR.row"))
         },
         "CLAS"={
           print("CLAS Criterion")
           crit<-(consensus(dat, mode = "diagraph", method="OR.col"))
         },
         "ILAS"={
           print("ILAS Criterion")
           crit<-(consensus(dat, method="LAS.intersection"))
         },
         "ULAS"={
           print("ULAS Criterion")
           crit<-(consensus(dat, method="LAS.union"))
         },
         "GA"={
           print("Global Aggregate Criterion")
           d <- as.sociomatrix.sna(dat)
           out <- matrix(data = as.numeric(apply(d, c(2,3), sum, na.rm = TRUE)), nrow = dim(d)[2],ncol = dim(d)[2])
           crit<-(out)
         },
         "GAT"={
           print("Global Aggregate Threshold Criterion")
           crit<-(consensus(dat, method="central.graph"))
         },
         "GAV"={
           print("Global Aggregate valued Criterion")
           d <- as.sociomatrix.sna(dat)
           out <- matrix(data = as.numeric(apply(d, c(2,3), mean, na.rm = TRUE)), nrow = dim(d)[2],ncol = dim(d)[2])
           crit<-(out)
         },
         "SR"={
           print("Single Reweight Criterion")
           crit<-(dichotomize(consensus(dat, method="single.reweight"), 0.5))
         },
         "IR"={
           print("Iterative Reweight Criterion")
           crit<-(consensus(dat, method="iterative.reweight", maxiter = 500))
         },
         "RB"={
           print("Romney Batchelder Criterion")
           y <- consensus(dat, method="romney.batchelder")
           dat <- dichotomize(y, 0.5)
           crit<-(dat)
         },
         "PCA"={
           print("Principle Component Analysis (PCA) Criterion")
           scale_f<-function(x){(x-min(x))/(max(x)-min(x))}
           crit<-(dichotomize(scale_f(consensus(dat, method="PCA.reweight")), 0.5))
         },
         "BAY"={
           print("Bayesian Criterion")
           bay_output <- function(x){
             d <- apply(x$net, c(2, 3), mean)
             rownames(d) <- as.vector(x$anames)
             colnames(d) <- as.vector(x$anames)
             unname(as.sociomatrix.sna(d))
           }
           crit<-(dichotomize(bay_output(bbnam(dat)), 0.5))
         }
  )
  rownames(crit)<-names
  colnames(crit)<-names
  return(crit)
}
