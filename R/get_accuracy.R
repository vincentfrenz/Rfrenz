#' Get Accuracy of Respondents
#' @description
#' The purpose of this function is to get the accuracy scores for each respondent in a social network based on their perception of the network. This is done by checking the similarity between their perception and a criterion network (i.e., a network that best represents the relations in a network).
#' @usage
#' get_accuracy(sociomatrix, criterion, acc = "pearson", criterion_type = NA)
#'
#' @param sociomatrix  A list of socio matrices that represent respondents.
#' @param criterion A socio matrix that represnts the true network computed from all respondents
#' @param acc The accuracy measure to be computed
#' @param criterion_type The criterion type that has been used
#'
#' @return A dataframe of respondents and there accuracy scores
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
#'
#' @examples
get_accuracy <- function(sociomatrix, criterion, acc="pearson", criterion_type=NA ){
  if(!is.na(criterion_type)){
    criterion_type <- tolower(criterion_type)
    }
  temp_df<-data.frame()
  switch(acc,
         "pearson"={
           temp_df<-data.frame(map_df(1:length(sociomatrix),function(x){
             score<-gcor(sociomatrix[[x]],criterion)
             data.frame(Respondent=x, Score=score,acc,criterion_type)
           }))
         },
         "spearman"={
           temp_df<-map_df(1:length(sociomatrix),function(x){
             score<-cor.test(sociomatrix[[x]],criterion, method="spearman")
             data.frame(Respondent = x,Score = score[['estimate']][[1]],Accuracy = acc,criterion_type)
           })
         },
         "jaccard"={
           temp_df<-map_df(1:length(sociomatrix),function(x){
             score<-jaccard::jaccard(sociomatrix[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc,criterion_type)
           })
         },"kendall"={
           temp_df<-map_df(1:length(sociomatrix),function(x){
             score<-Kendall(sociomatrix[[x]],criterion)
             data.frame(Respondent = x,Score = score[[1]][[1]],Accuracy = acc, criterion_type)
           })
         },"s14"={
           temp_df<-map_df(1:length(sociomatrix),function(x){
             score<-s14(sociomatrix[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc, criterion_type)
           })
         },"mrqap"={
           temp_df<-map_df(1:length(sociomatrix),function(x){
             if(sum(x) != 0){
               score<-mrqap.dsp(criterion~sociomatrix[[x]],directed = "directed" )
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
           temp_df<-map_df(1:length(sociomatrix),function(x){
             score<-gscor(sociomatrix[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc, criterion_type)
           })
         },"CohenK"={
           kap <- list()
           temp_df<-map_df(1:length(sociomatrix),function(x){
             i<-map_dbl(sociomatrix[[x]], function(x){
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
           if (criterion_type == "rlas"){
           temp_df<-map_df(1:length(sociomatrix),function(x){
             #loops throught the number of columns in the criterion netowrk
             map_df(1:length(criterion[,x]), function(j) {
               #for each iteration it runs a correlation test for a sociomatrixs column :SilSys_Ad_mat[[i]][,j] and correlates that against the same column  in the criterion netowrk.
               if(x==j){
                 sociomatrix[[x]][x,j]<-NA
                 score <- cor(sociomatrix[[x]][,x],criterion[,j] )
                 return(data.frame(Respondent_1 = x,Respondent_2 = j,Score = score,Accuracy = acc,criterion_type))

               }else{
                 score <- cor(sociomatrix[[x]][,x],criterion[,j] )
                 return(data.frame(Respondent_1 = x,Respondent_2 = j,Score = score,Accuracy = acc,criterion_type))

               }
             })

           }

           )}else{
             print("Not an RLAS criterion")
           }},'dyadic'={

             temp_df<-map_df(1:length(sociomatrix),function(i){
               wrong <- c()
               totalRelation <- (length(sociomatrix)*length(sociomatrix)-length(sociomatrix))
               # print(totalRelation)
               ACC <- c()
               ACC_norm <- c()
               # wrongCount <- c()

               wrongCount<- map_dbl(1:length(sociomatrix), function(x){
                 count<-map_dbl(1:length(criterion[1,]),function(y){

                   sociomatrix <- sociomatrix[[i]][x,y]
                   crit <- criterion[x,y]

                   if(crit != sociomatrix){
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
             sociomatrix_tiad <- lapply(sociomatrix, triad.census, mode = c("digraph"))
             # make clear that we are doing triad consensus on triads in documentation
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(sociomatrix_tiad),function(i){
               cor_gcor_tri <- NA
               cor_gcor_tri <- gcor(sociomatrix_tiad[[i]], crit_tiad)
               return(data.frame(Respondent = i, Score = cor_gcor_tri ,Accuracy = acc,criterion_type))
             })

           },'triadic spearman'={
             sociomatrix_tiad <- lapply(sociomatrix, triad.census, mode = c("digraph"))
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(sociomatrix_tiad),function(i){
               cor_sp_tri <- NA
               cor_sp_tri <- cor.test(sociomatrix_tiad[[i]], crit_tiad,  method = c("spearman"))
               return(data.frame(Respondent = i, Score = cor_sp_tri$estimate ,Accuracy = acc,criterion_type))
             })
             return(temp_df)
           },'triadic distance'={
             sociomatrix_tiad <- lapply(sociomatrix, triad.census, mode = c("digraph"))
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(sociomatrix_tiad),function(i){
               dist_tri <- NA
               dist_tri <- dist(rbind(sociomatrix_tiad[[i]][1,], crit_tiad[1,]), method = "euclidean")
               score <- 1-(dist_tri[1]/choose(length(sociomatrix), 3))
               return(data.frame(Respondent = i, Score = score ,Accuracy = acc,criterion_type))
             })
             return(temp_df)
           })
}
