#' Rfrenz: Computes cognitive social network accuracy
#'
#' The Rfrenz package provides four categories of important functions:
#' get_data, get_criterion, get_accuracy and get_all
#'
#' @section get_data functions:
#' Reads text files that are saved in a directory and creates a list of matrices. \link[Rfrenz:get_data]{get_data()}
#' @section get_criterion function:
#' Takes in two paramaters, the first being a list of matrices and the second being the name of the criterion that you wish to generate. The function returns a matrix that represents a true network. \link[Rfrenz:get_criterion]{get_criterion()}
#' @section get_accuracy function:
#' Takes in four paramaters, the first being a list of matrices, the second being a matrix representing the criterion network, the third being the name of the accuracy measure to use and the last being the name of the criterion network being used. The function will return a dataframe containing all the repondents accuracy measures. \link[Rfrenz:get_accuracy]{get_accuracy()}
#'@section get_all function:
#'Takes in Three paramaters, the first being a list of matrices, the second being the name of the criterion to use and the third being the name of the accuracy measure you wish to generate. The function will return a dataframe of respondents and there accuracy's. \link[Rfrenz:get_all]{get_all()}
#'
#' @docType package
#' @name Rfrenz
NULL
