#' Title
#'
#' @param slice
#' @param criterion
#' @param accuracy
#'
#' @return
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
