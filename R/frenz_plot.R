
#' Quickly plotting a criterion network and optionally the respondents accuracy-scores.
#'
#' @description
#' This function can be used to quickly plot a summary of the \link[Rfrenz:get_criterion]{get_criterion()}and \link[Rfrenz:get_accuracy]{get_accuracy()}functions in one place.
#' The function allows you to plot the criterion alone or with an accuracy-score summary in the form of a boxplot. If you want to plot the criterion alone, you only have to pass a criterion-matrix to the function.
#'
#' @usage
#' frenz_plot(crit,criterion="Title Here",accuracy_df)
#'
#' @param crit criterion network returned after \link[Rfrenz:get_criterion]{get_criterion()} is run. The crit is used to plot a criterion network.
#' @param criterion Default="Title Here". The title of the criterionnetwork being plotted.
#' @param accuracy_df Default = FALSE. If you have an accuracy dataframe from the \link[Rfrenz:get_accuracy]{get_accuracy()} function you can past it to the parameter here. A boxplot is plotted of for the various accuracy scores.
#'
#'@examples
#' #Readin data
#' dat <- Rfrenz::hightech_advice
#'
#' #Complete Criterion and Accuracy functions
#' crit <- get_criterion(dat,"CLAS")
#' accr <- get_accuracy(dat, crit, acc = "pearson", criterion_type = "CLAS")
#'
#' #Plug results into Plot function
#' frenz_plot(crit, criterion="Plot CLAS with Pearson Accuracy", accuracy_df= accr)
#'
#'
#' @import ggraph
#' @import ggplot2
#' @import tidygraph
#' @importFrom gridExtra grid.arrange
#'
#'@export
frenz_plot <- function(crit, criterion="Title Here", accuracy_df=FALSE){

  crit_net<- ggraph(as_tbl_graph(crit), layout = 'auto') +
    geom_edge_fan(arrow = arrow(length = unit(0.08, "inches")),start_cap = circle(4,'mm') , end_cap = circle(4, 'mm')) +
    geom_node_point(size = 8, colour = '#84D8E0') +
    geom_node_text(aes(label = name),colour = 'black', vjust = 0.4)+
    ggtitle(criterion)+
    theme_graph()

  if(accuracy_df==TRUE){
    box <- ggplot(accuracy_df, aes(y=Score))+
      geom_boxplot()+
      coord_flip()+
      ylab("Accuracy Scores of Respondents")+
      theme_minimal()+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
      )

    lay <- rbind(c(NA,1,1,1,1,NA),
                 c(NA,1,1,1,1,NA),
                 c(NA,1,1,1,1,NA),
                 c(2,2,2,2,2,2))

    g<-grid.arrange(crit_net,box, layout_matrix=lay)

  }else{
    return(crit_net)
  }

}
