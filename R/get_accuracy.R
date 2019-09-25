#' Get Accuracy of Respondents
#' @description
#' The purpose of this function is to get the accuracy scores for each respondent in a social network based on their perception of the network. This is done by checking the similarity between their perception and a criterion network (i.e., a network that best represents the relations in a network).
#' @usage
#' get_accuracy(dat, criterion, acc = "pearson", criterion_type = NA)
#'
#' @param dat  A list of socio-matrices that represent respondents.
#' @param criterion A socio-matrix that represents the criterion network (i.e., a network that best represents the relations in a network) that is computed from all respondents.
#' @param acc The name of the accuracy measure to be computed. Options: “pearson”, “spearman”, “jaccard”, “kendall”, “s14”, “mrqap”, “gscor”, “CohenK”, “local”, “triadic pearson”, “triadic spearman”, “triadic distance”.
#' @param criterion_type The name of the criterion that has been used.
#'
#' @details
#' The details of each accuracy measure will be explored in this section.
#' \describe{
#'  \item{Pearson Correlation}{The Pearson correlation test is done using a function from the SNA package called \link[sna:gcor]{gcor}. The SNA package states that “gcor” function is used to find the product-moment correlation between adjacency matrices \insertCite{Butts2016}{Rfrenz}. The “gcor” is a specialised form of a standard “cor” correlation. The ”gcor” function focuses more on graph data. Scores larger than 0 show a positive correlation whereas scores below 0 show a negative correlation.}
#'  \item{Spearman Correlation}{The Spearman correlation test is performed using the \link[stats:cor.test]{cor.test} function from the stats package. The estimate value is extracted from the results of the test. This value represents the similarity score computed from the correlation. According to the Stats package the rho statistic is used to compute the estimate value of the ranked based measure of association \insertCite{DeNooy2016}{Rfrenz}. A Spearman correlation test is best suited for data that can be ranked. Scores larger than 0 show a positive correlation whereas scores below 0 show a negative correlation.}
#'  \item{Jaccard Correlation}{The Jaccard similarity coefficient is performed using the \link[jaccard:jaccard]{jaccard} function that is found in the Jaccard package. This function will result in a number between 1 and 0. The closer the value is to 1 the higher the similarity is between the two matrices. The Jaccard similarity coefficient is used in social science as it shows the occurrences of agreements between binary sets of data \insertCite{Marineau2016b}{Rfrenz}.}
#'  \item{Kendall Rank Correlation}{The Kendall rank correlation is performed using the \link[Kendall:Kendall]{kendall} function that is found in the Kendall package.  The Kendall rank correlation or more commonly known as Kendall's tau, is a correlation tool used to measure the ordinal association between two measured variables \insertCite{Kendall1938}{Rfrenz}. The “Kendall” function computes a p-value and if it determined to be significant such that variables are dependent, and therefore there are ties. Then it will checks the similarity between these variables. The Kendall Tau statistic is extracted from the results of this function. }
#'  \item{S14 Similarity Index}{The s14 similarity index is performed using the \link[cssTools:s14]{s14} function that is found in the cssTools package. The s14 function computes the similarity between the two square matrices.  S14 is useful for network data as it shows appropriate sensitivity to small changes and does not distort at extremes \insertCite{Gower1986}{Rfrenz}.}
#'  \item{MRQAP with Double-Semi-Partialing  (DSP)}{MRQAP with DSP is performed using the \link[asnipe:mrqap.dsp]{mrqap.dsp} function that is found in the Asnipe package. This function computes the regression coefficient using the DSP method. The method randomises the p-value with 1000 permutation in order to determine if the matrices are dependent or independent \insertCite{Dekker2003}{Rfrenz}.}
#'  \item{Structural Correlation (gscor)}{The structural correlation between two or more graphs can be determined using the \link[sna:gscor]{gscor} function found in the SNA package. The gscor function finds the product-movement structural correlation. This indicates that it looks at the structure of each network and determines how similar the structure is as opposed to if specific ties were similar between nodes \insertCite{Butts2001}{Rfrenz}. The node labels in the network are permutated in order to determine how similar the structure is to the true network \insertCite{Butts2001}{Rfrenz}.}
#'  \item{Cohens Kappa}{The Cohens Kappa coefficient can be determined using the \link[psych:cohen.kappa]{cohen.kappa} function that can be found in the psych package. This accuracy measure takes the possibility of chance into account (i.e., someone could have merely guessed about a relationship within a given network and the measure takes that probability into account) \insertCite{Cohen1960}{Rfrenz}. Target accuracy measures refer to how accurate a perceiver's agreement would be towards a certain target, where the target would be the relationship between i and j \insertCite{Neal2016}{Rfrenz}.}
#'  \item{Local Accuracy}{The local accuracy is computed by comparing a person's perceptions to a Row dominated local aggregate structure (RLAS). local accuracy tries to see how accurate a person is at knowing the perceptions in a social network based on how they think the people in that network perceive them \insertCite{Casciaro1999}{Rfrenz}. A pearson correlation is performed between a row of a person's perceptions and a row of the RLAS criterion.}
#'  \item{Dyadic Accuracy}{Dyadic accuracy looks at how accurately an individual can perceive a possible dyadic relation between two individuals. To do this it takes one person perceptions and measures its perception of dyadic relations according to the ``true'' network \insertCite{Bondonio1998}{Rfrenz}.}
#'  \item{Triadic (Pearson, Spearman, Distance)}{The triadic accuracy compares the triadic structure of the criterion network and the respondent by means of either a Pearson correlation, Spearman's rank correlation, or Euclidean distance measure. This approach was proposed by \insertCite{Frenz2019;textual}{Rfrenz}  as a means to compare the degree of similarity between the triad census of the actual social network and the triad census of a respondents cognitive slice}
#' }
#'
#'
#' @return A dataframe of respondents and there accuracy scores.
#' @export
#'
#' @import network
#' @import sna
#' @import dplyr
#' @import scales
#' @import purrr
#' @import rlist
#' @import binda
#' @import expss
#' @import tidyr
#' @import qvalue
#' @import BiocManager
#' @import jaccard
#' @import Kendall
#' @import cssTools
#' @import DescTools
#' @import mipfp
#' @import rvest
#' @import readr
#' @import tidyr
#' @import stringr
#' @import rebus
#' @import asnipe
#' @import psych
#' @importFrom Rdpack reprompt
#'
#' @examples
#'
#' @references
#' \insertAllCited{}
get_accuracy <- function(dat, criterion, acc="pearson", criterion_type=NA ){
  if(!is.na(criterion_type)){
    criterion_type <- tolower(criterion_type)
  }
  dat<-formatting_data(dat)
  temp_df<-data.frame()
  switch(acc,
         "pearson"={
           print("Pearson Correlation")
           temp_df<-data.frame(map_df(1:length(dat),function(x){
             score<-gcor(dat[[x]],criterion)
             data.frame(Respondent=x, Score=score,acc,criterion_type)
           }))
         },
         "spearman"={
           print("Spearman Correlation")
           temp_df<-map_df(1:length(dat),function(x){
             score<-cor.test(dat[[x]],criterion, method="spearman")
             data.frame(Respondent = x,Score = score[['estimate']][[1]],Accuracy = acc,criterion_type)
           })
         },
         "jaccard"={
           print("jaccard Correlation")
           temp_df<-map_df(1:length(dat),function(x){
             score<-jaccard::jaccard(dat[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc,criterion_type)
           })
         },"kendall"={
           print("Kendall Rank Correlation")
           temp_df<-map_df(1:length(dat),function(x){
             score<-Kendall(dat[[x]],criterion)
             data.frame(Respondent = x,Score = score[[1]][[1]],Accuracy = acc, criterion_type)
           })
         },"s14"={
           print("S14 Similarity Index")
           temp_df<-map_df(1:length(dat),function(x){
             score<-s14(dat[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc, criterion_type)
           })
         },"mrqap"={
           print("MRQAP with Double-Semi-Partialing (DSP)")
           temp_df<-map_df(1:length(dat),function(x){
             if(sum(x) != 0){
               score<-mrqap.dsp(criterion~dat[[x]],directed = "directed" )
             }
             else{
               NA
             }
             if(!is.na(score)){
               if (names(score$P.values)[1] == "intercept") {
                 mss <- sum((fitted(score) - mean(fitted(score)))^2)
                 df.int <- 1
               }else {
                 mss <- sum(fitted(score)^2)
                 df.int <- 0
               }
               rss <- sum(resid(score)^2)
               r.squared <- mss/(mss + rss)
               adj.r.squared <- 1 - (1 - r.squared) * ((score$n - df.int)/score$df.residual)
               adj.r.squared
               data.frame(Respondent = x,Score = adj.r.squared,Accuracy = acc, criterion_type)
             }
             else{
               data.frame(Respondent = x,Score = NA,Accuracy = acc)
             }

           })
         },"gscor"={
           print("Structural Correlation")
           temp_df<-map_df(1:length(dat),function(x){
             score<-gscor(dat[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc, criterion_type)
           })
         },"CohenK"={
           print("Cohens Kappa Correlation")
           kap <- list()
           temp_df<-map_df(1:length(dat),function(x){
             i<-map_dbl(dat[[x]], function(x){
               x
             })
             j<-map_dbl(criterion, function(x){
               x
             })
             df2<-data.frame(i,j)
             score<-cohen.kappa(df2)[[1]]
             data.frame(Respondent = x,Score = score,Accuracy = acc, criterion_type)

           })
         },"local"={
           print("Local Accuracy")
           if (criterion_type == "rlas"){
           temp_df<-map_df(1:length(dat),function(x){
             #loops throught the number of columns in the criterion netowrk
             map_df(1:length(criterion[,x]), function(j) {
               #for each iteration it runs a correlation test for a sociomatrixs column :SilSys_Ad_mat[[i]][,j] and correlates that against the same column  in the criterion netowrk.
               if(x==j){
                 dat[[x]][x,j]<-NA
                 score <- cor(dat[[x]][,x],criterion[,j] )
                 return(data.frame(Respondent_1 = x,Respondent_2 = j,Score = score,Accuracy = acc,criterion_type))

               }else{
                 score <- cor(dat[[x]][,x],criterion[,j] )
                 return(data.frame(Respondent_1 = x,Respondent_2 = j,Score = score,Accuracy = acc,criterion_type))

               }
             })

           }

           )}else{
             print("Not an RLAS criterion")
           }},'dyadic'={
             print("Dyadic Accuracy")
             temp_df<-map_df(1:length(dat),function(i){
               wrong <- c()
               totalRelation <- (length(dat)*length(dat)-length(dat))
               # print(totalRelation)
               ACC <- c()
               ACC_norm <- c()
               # wrongCount <- c()

               wrongCount<- map_dbl(1:length(dat), function(x){
                 count<-map_dbl(1:length(criterion[1,]),function(y){

                   dat <- dat[[i]][x,y]
                   crit <- criterion[x,y]

                   if(crit != dat){
                     1
                   }else{
                     0
                   }
                 })
                 sum(count)
               })
               wrong <- append(wrong, as.numeric(sum(wrongCount)))
               ACC <- append(ACC, totalRelation - wrong)
               ACC_norm <- (ACC/totalRelation)

               return(data.frame(Respondent = i, Score = ACC_norm ,Accuracy = acc,criterion_type))
             })

           },'triadic pearson'={
             print("triadic pearson")
             sociomatrix_tiad <- lapply(dat, triad.census, mode = c("digraph"))
             # make clear that we are doing triad consensus on triads in documentation
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(sociomatrix_tiad),function(i){
               cor_gcor_tri <- NA
               cor_gcor_tri <- gcor(sociomatrix_tiad[[i]], crit_tiad)
               return(data.frame(Respondent = i, Score = cor_gcor_tri ,Accuracy = acc,criterion_type))
             })

           },'triadic spearman'={
             print("triadic spearman")
             sociomatrix_tiad <- lapply(dat, triad.census, mode = c("digraph"))
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(sociomatrix_tiad),function(i){
               cor_sp_tri <- NA
               cor_sp_tri <- cor.test(sociomatrix_tiad[[i]], crit_tiad,  method = c("spearman"))
               return(data.frame(Respondent = i, Score = cor_sp_tri$estimate ,Accuracy = acc,criterion_type))
             })
             return(temp_df)
           },'triadic distance'={
             print("triadic distance")
             sociomatrix_tiad <- lapply(dat, triad.census, mode = c("digraph"))
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(sociomatrix_tiad),function(i){
               dist_tri <- NA
               dist_tri <- dist(rbind(sociomatrix_tiad[[i]][1,], crit_tiad[1,]), method = "euclidean")
               score <- 1-(dist_tri[1]/choose(length(dat), 3))
               return(data.frame(Respondent = i, Score = score ,Accuracy = acc,criterion_type))
             })
             return(temp_df)
           })
  return(temp_df)
}
