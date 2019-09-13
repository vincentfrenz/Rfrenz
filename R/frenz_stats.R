#' Quickly get back basic descriptive statistics on Accuracy of Respondents.
#'
#'@description This function accepts a dataframe from the output of the \link[Rfrenz:get_accuracy]{get_accuracy()} function and is based on the Score coloumn. The function returns a dataframe with the basic descriptive statistics added to each observation. These statistics as as follows:
#'\describe{
#' \item{\strong{Mean}}{The Average Accuracy Score}
#' \item{\strong{Min}}{The Least Accurate Score}
#' \item{\strong{Max}}{The Most Accuracy Score}
#' \item{\strong{Median}}{The Median of the Accuracy Scores}
#'}
#'
#' @param accuracy_df The accuracy dataframe that results from the \link[Rfrenz:get_accuracy]{get_accuracy()} function.
#' @import dplyr
#' @return
#' @export
frenz_stats <-function(accuracy_df){
  stats_df <- accuracy_df%>%
    summarise(round(mean(Score,na.rm = TRUE), digits = 2),
              round(min(Score,na.rm = TRUE), digits = 2),
              round(max(Score,na.rm = TRUE),digits = 2),
              round(median(Score,na.rm = TRUE), digits = 2))
  #renaming cols name
  colnames(stats_df) <- c("Mean","Min","Max", "Median")
  #In this chunck an NA value is assigned any values that are Nan or infinate
  stats_df$Mean[is.nan(stats_df$Mean)] <- NA
  stats_df$Min[is.infinite(stats_df$Min)] <- NA
  stats_df$Max[is.infinite(stats_df$Max)] <- NA
  stats_df$Median[is.infinite(stats_df$Median)] <- NA

  frenz_Stats <- merge(accuracy_df, stats_df)
}
