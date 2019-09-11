# Import Text data and convert to Martix
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

#' Get Data
#'
#' @param path Path to the directory where txt files are stored.
#' @param save Default False. TRUE/FALSE  The option to save your matrix into an RDS. If set to TRUE you need to pass a path to "path_out" where your RDS will be stored.
#' @param path_out The Path to a driectory where you want to store the RDS.
#'
#' @return
#' @export
#' @import sna
#' @import gtools
#' @examples
get_data <- function(path, save=FALSE , path_out) {
  filelist <- list.files(path, pattern = "*.txt")
  filelist <- mixedsort(filelist)
  slice_list <- c()
  len <- length(filelist)

  for (i in 1:len) {
    file_path <- paste(path, filelist[i], sep = "")
    slice_list[[i]] <- data.matrix(read.csv(file_path, row.names = 1))
  }
  mat_slice_list <- lapply(slice_list, matrix , nrow = length(slice_list), ncol = length(slice_list))
  socio_mat <- lapply(mat_slice_list, as.sociomatrix.sna)
  if(save == TRUE){
    saveRDS(socio_mat,path_out)
  }
}
