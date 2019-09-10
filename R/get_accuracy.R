#' Get Accuracy of Respondents
#'
#' @param slice  A list of socio matricies that represent respondents.
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
get_accuracy <- function(slice, criterion, acc="pearson", criterion_type="" ){
  temp_df<-data.frame()
  switch(acc,
         "pearson"={
           temp_df<-data.frame(map_df(1:length(slice),function(x){
             score<-gcor(slice[[x]],criterion)
             data.frame(Respondent=x, Score=score,acc,criterion_type)
           }))
         },
         "spearman"={
           temp_df<-map_df(1:length(slice),function(x){
             score<-cor.test(slice[[x]],criterion, method="spearman")
             data.frame(Respondent = x,Score = score[['estimate']][[1]],Accuracy = acc,criterion_type)
           })
         },
         "jaccard"={
           temp_df<-map_df(1:length(slice),function(x){
             score<-jaccard::jaccard(slice[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc,criterion_type)
           })
         },"kendall"={
           temp_df<-map_df(1:length(slice),function(x){
             score<-Kendall(slice[[x]],criterion)
             data.frame(Respondent = x,Score = score[[1]][[1]],Accuracy = acc, criterion_type)
           })
         },"s14"={
           temp_df<-map_df(1:length(slice),function(x){
             score<-s14(slice[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc, criterion_type)
           })
         },"mrqap"={
           temp_df<-map_df(1:length(slice),function(x){
             if(sum(x) != 0){
               score<-mrqap.dsp(criterion~slice[[x]],directed = "directed" )
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
           temp_df<-map_df(1:length(slice),function(x){
             score<-gscor(slice[[x]],criterion)
             data.frame(Respondent = x,Score = score,Accuracy = acc, criterion_type)
           })
         },"kappa"={
           kap <- list()
           temp_df<-map_df(1:length(slice),function(x){
             i<-map_dbl(slice[[x]], function(x){
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
           temp_df<-map_df(1:length(slice),function(x){
             #loops throught the number of columns in the criterion netowrk
             map_df(1:length(criterion[,x]), function(j) {
               #for each iteration it runs a correlation test for a slices column :SilSys_Ad_mat[[i]][,j] and correlates that against the same column  in the criterion netowrk.
               if(x==j){
                 slice[[x]][x,j]<-NA
                 score <- cor(slice[[x]][,x],criterion[,j] )
                 return(data.frame(Respondent_1 = x,Respondent_2 = j,Score = score,Accuracy = acc,criterion_type))
                 # temp<-append(temp,cor(slice[[x]][,j],criterion[,j] ))
               }else{
                 score <- cor(slice[[x]][,x],criterion[,j] )
                 return(data.frame(Respondent_1 = x,Respondent_2 = j,Score = score,Accuracy = acc,criterion_type))
                 # temp<-append(temp,cor(slice[[x]][,j],criterion[,j] ))
               }
             })

           })},'dyadic'={

             temp_df<-map_df(1:length(slice),function(i){
               wrong <- c()
               totalRelation <- (length(slice)*length(slice)-length(slice))
               # print(totalRelation)
               ACC <- c()
               ACC_norm <- c()
               # wrongCount <- c()

               wrongCount<- map_dbl(1:length(slice), function(x){
                 count<-map_dbl(1:length(criterion[1,]),function(y){

                   slice <- slice[[i]][x,y]
                   crit <- criterion[x,y]

                   if(crit != slice){
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
             slice_tiad <- lapply(slice, triad.census, mode = c("digraph"))
             # make clear that we are doing triad consensus on triads in documentation
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(slice_tiad),function(i){
               cor_gcor_tri <- NA
               cor_gcor_tri <- gcor(slice_tiad[[i]], crit_tiad)
               return(data.frame(Respondent = i, Score = cor_gcor_tri ,Accuracy = acc,criterion_type))
             })

           },'triadic spearman'={
             slice_tiad <- lapply(slice, triad.census, mode = c("digraph"))
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(slice_tiad),function(i){
               cor_sp_tri <- NA
               cor_sp_tri <- cor.test(slice_tiad[[i]], crit_tiad,  method = c("spearman"))
               return(data.frame(Respondent = i, Score = cor_sp_tri$estimate ,Accuracy = acc,criterion_type))
             })
             return(temp_df)
           },'triadic distance'={
             slice_tiad <- lapply(slice, triad.census, mode = c("digraph"))
             crit_tiad <- triad.census(criterion, mode = c("digraph"))
             temp_df <- map_df(1:length(slice_tiad),function(i){
               dist_tri <- NA
               dist_tri <- dist(rbind(slice_tiad[[i]][1,], crit_tiad[1,]), method = "euclidean")
               score <- 1-(dist_tri[1]/choose(length(slice), 3))
               return(data.frame(Respondent = i, Score = score ,Accuracy = acc,criterion_type))
             })
             return(temp_df)
           })
}
