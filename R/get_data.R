# Hello, world!
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
  if(save == TRUE){
    saveRDS(mat_slice_list,path_out)
  }
}
