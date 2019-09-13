#' Import matrix stored as txt into R and convert to Martix
#'
#'@title Get Data
#'
#' @param path Path to the directory where txt files are stored.
#' @param save Default FALSE. If parameter is set to equal TRUE, the matrix will be saved into an `.rds`. If set to TRUE you need to pass a path to "path_out" where your `.rds` will be stored.
#' @param path_out The Path to a driectory where you want to store the `.rds` .
#'
#' @import sna
#' @import gtools
#' @examples get_data("Documents/folder/", save=TRUE , "Documents/folder/data_out/")
#'
#' @export
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
  return(socio_mat)
  if(save == TRUE){
    saveRDS(socio_mat,path_out)
  }
}
