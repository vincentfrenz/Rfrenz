#' Get accuracy from slices
#'
#' @param slice A list of socio matricies that represent respondents.
#' @param criterion A true netwrok of the socio matricies to be computed.
#' @param accuracy An accuracy measure to be computed
#'
#' @return Returns a list of 2 items. The first is the criterion network. The second is a dataframe containing an accuracy score for each respondent
#' @export
#' @importFrom Rfrenz get_accuracy
#' @importFrom Rfrenz get_criterion
#' @examples
#'
get_all <- function(slice, criterion="RLAS",accuracy="pearson"){
  crit <- get_criterion(slice, criterion)
  acc_df <- get_accuracy(slice, crit,acc = accuracy, criterion_type = criterion)
  all_list <- list(criterion = crit, accuracy = acc_df)
  return(all_list)
}
