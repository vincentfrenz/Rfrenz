#' High Tech Managers data on Advice relations
#'
#' These are data collected from the managers of a high-tec company. 
#' The company manufactured high-tech equipment on the west coast of the United States and had just over 100 employees with 21 managers.
#' Each manager was asked to whom do you go to for advice and who is your friend.
#'
#' @docType data
#'
#' @usage data(hightech_advice)
#'
#' @format This data contains a list of Sociomatracies. Each element in the list - a slice - contains a respondent's perception of the network. Each slice exists out of binary data where a '0' corresponds to no relationship obeservered and visa versa.
#'
#' @keywords datasets
#'
#' @references Krackhardt D. (1987). Cognitive social structures. Social Networks, 9, 104-134.
#'
#' @examples
#' data(hightech_advice)
#' slice_6 <- hightech_advice[[6]]
#' slice_6
"hightech_advice"