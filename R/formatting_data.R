#' Remove Missing Slices 
#'
#' @param x 
#' @param option 
#'
#' @return
#' @export
#'
#' @examples
formatting_data <- function(x, option="remove") {
  missing_index <- c()
  for (i in 1:length(fr_pharma_sm)) {
    if (anyNA(fr_pharma_sm[i], recursive = TRUE)) {
      missing_index <- append(missing_index, i)
      missing_index <- as.numeric(missing_index)
    }
  }
  if (anyNA(x, recursive = TRUE)) {
    warning('You have missing data! \n')
    warning(paste('Missing slice:', missing_index, '\n'))
    switch (option,
            "remove" ={
              warning(paste('Removing missing slices \n'))
              x <- list.remove(x, missing_index)
              x <- lapply(x, function(z) z[-missing_index, -missing_index])
            },
            "replace"={
              warning(paste('Replacing missing slices with central graph \n'))
              x <- if_na(x, consensus(x, method="central.graph"))
            },
            "zero"={
              warning(paste('Replacing missing slice with zeros \n'))
              x <- if_na(x, 0)
            }
    )
  }
  return(x)
}