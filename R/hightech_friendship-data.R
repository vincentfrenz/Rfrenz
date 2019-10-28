#' High Tech Managers data on friendship relations
#'
#' @description
#' This data collected from the managers of a high-tech company.
#' The company manufactured high-tech equipment on the west coast of the United States and had just over 100 employees with 21 managers.
#' Each manager was asked with whom they are friends aswell as who they thought of the other managers were friends with. This was recorded and a dataset was made.
#'
#' @docType data
#'
#' @usage Rfrenz::hightech_friendship
#'
#' @format This data contains a list of socio-matrices. Each element in the list - a slice - contains a respondent's perception of the network. Each slice exists out of binary data where a '0' corresponds to no relationship obeservered and visa versa.
#'
#' @keywords datasets
#'
#' @references Krackhardt D. (1987). Cognitive social structures. Social Networks, 9, 104-134.
#'
#' @examples
#' data <- (Rfrenz::hightech_friendship) 
#' slice_6 <- data[[6]]
#' slice_6
"hightech_friendship"
