#' Silicon Systems data on advice relations
#' 
#' Krackhardt asked employees at Silicon Systems, a high-tech firm that was undergoing a union certification campaign, to whom they go to for advice. 
#' These relationships provide insight into the firm's embedded social structure, which many believe plays a strong role in shaping opinion and opinion change.
#'
#' @docType data
#'
#' @usage data(silsys_advice)
#'
#' @format This data contains a list of socio-matrices. Each element in the list - a slice - contains a respondent's perception of the network. Each slice exists out of binary data where a '0' corresponds to no relationship obeservered and visa versa.
#'
#' @keywords datasets
#'
#' @references Krackhardt D. (1987). Cognitive social structures. Social Networks, 9, 104-134.
#'
#' @examples
#' data(silsys_advice)
#' slice_6 <-silsys_advice[[6]]
#' slice_6
NULL
