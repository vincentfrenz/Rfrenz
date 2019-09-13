
#' Quickly plotting a criterion network and the respondents accuracy.
#'
#' @description
#' This function can be used to quickly plot a summary of the \link[Rfrenz::get_criterion()]{get_criterion()}and \link[Rfrenz::get_accuracy()]{get_accuracy()}functions in one place.
#'
#' @usage
#' frenz_plot(crit, accuracy_df,criterion="RLAS")
#'
#' @param crit criterion network returned after \link[Rfrenz::get_criterion()]{get_criterion()} is run. the crit is used to plot a criterion network.
#' @param accuracy_df accuracy score dataframe that is return after \link[Rfrenz::get_accuracy()]{get_accuracy()}from Rfrenze is run. The accruacy_df is used to plot a boxplot summarising the data
#' @param criterion default="RLAS". the criterion name of the criterion being past in crit. is used as a titile for the graph.
#'
#' @import igraph
#' @import dplyr
#' @import tidyverse
#' @import sna
#' @import gtools
#' @import purrr
#' @import ggplot2
#' @import ggraph
#' @import gridExtra
#'
#'@export
frenz_plot <- function(crit, accuracy_df,criterion="RLAS"){

  crit_net<- ggraph(as_tbl_graph(crit), layout = 'auto') +
    geom_edge_fan(arrow = arrow(length = unit(0.08, "inches")),start_cap = circle(4,'mm') , end_cap = circle(4, 'mm')) +
    geom_node_point(size = 8, colour = '#84D8E0') +
    geom_node_text(aes(label = 1:length(x)),colour = 'black', vjust = 0.4)+
    ggtitle(criterion)+
    theme_graph()


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

}
