Rfrenz
================
Contributors: Christiaan van Rensburg, Alexander Cawood, Marette Theron (9/13/2019)

Rfrenz is an *experimental* package which aims to simplify the process of computing cognitive social network accuracy by combining various functions from other packages.

Install Instructions
--------------------

Ensure you have the `githubinstall` package installed and the `devtools` package installed

    install.packages('devtools')
    install.packages('githubinstall')

The Rfrenz package can then be loaded using the `library` function.

``` r
install_github("vincentfrenz/Rfrenz")
```

### Generating Test Data

The data generated here is used in the examples below.

``` r
r1 <- matrix(c(0,1,0,1,0,
              0,0,1,1,0,
              1,0,0,1,1,
              0,1,0,0,1,
              0,1,0,1,0),nrow=5, ncol=5)
r2 <- matrix(c(0,1,1,1,0,
              0,0,1,1,0,
              1,0,0,1,0,
              1,1,0,0,1,
              1,1,0,1,0),nrow=5, ncol=5)
r3 <- matrix(c(0,1,1,1,0,
              1,0,1,1,0,
              1,1,0,0,0,
              0,1,0,0,1,
              1,1,0,1,0),nrow=5, ncol=5)
r4 <- matrix(c(0,1,0,1,0,
              1,0,1,1,1,
              1,0,0,1,1,
              0,1,0,0,0,
              0,0,0,1,0),nrow=5, ncol=5)
r5 <- matrix(c(NA,NA,NA,NA,NA,
              NA,NA,NA,NA,NA,
              NA,NA,NA,NA,NA,
              NA,NA,NA,NA,NA,
              NA,NA,NA,NA,NA),nrow=5, ncol=5)

list_respondent <- list(r1,r2,r3,r4,r5)
```

The Rfrenz function
-------------------

This function generates a criterion (true) network given all the perceptions perceived in a network. The criterion network is then compared to all perceptions in order to determine the similarity between a respondent and thier perception of the network.

#### Arguments

`dat` - A list of socio matricies that represent respondents. `criterion` - A true (criterion) netwrok of the socio matricies to be computed. `accuracy` - An accuracy measure to be computed

``` r
rfrenz_acc(list_respondent, criterion = "ILAS", accuracy="s14")
```

    ## [1] "ILAS Criterion"
    ## [1] "S14 Similarity Index"

    ## $criterion
    ##      [,1] [,2] [,3] [,4]
    ## [1,]    0    0    1    0
    ## [2,]    1    0    0    1
    ## [3,]    0    1    0    0
    ## [4,]    1    1    0    0
    ## 
    ## $accuracy
    ##   Respondent     Score Accuracy criterion_type
    ## 1          1 0.8703883      s14           ilas
    ## 2          2 0.6201737      s14           ilas
    ## 3          3 0.6201737      s14           ilas
    ## 4          4 0.7453560      s14           ilas

#### Values

The `rfrenz_acc` function returns a list of 2 items. The first is the criterion network. The second is a dataframe containing an accuracy score for each respondent

The Data
--------

### Get Data

The get\_data function can be used to read in data from a directory containing comma seperated binary values in a text files, where each text file represents a respondent. \`\`\`{ Get Data}

get\_data(path, save = FALSE, path\_out)

\`\`\`

### Formating Data

Remove/Replace Missing Slices

This function removes any missing perceptions (slices) from a list of socio-matracies. Three different options exist: removing missing slices, replacing missing slices with central graph or replacing missing values with 0.

#### Missing data is important to consider

Missing data can affect the formation of the actual networks. In order to deal with this, missing perceptions can be set to a blank perception (0), or replaced with an estimate value, or the missing respondents can be omitted.

"remove" This option will omit the missing values completely. Omitting the missing respondents results in effectively sampling the original data (Borgatti, Carley, and Krackhardt 2006).

"replace" This option will replace the missing values of the obeserver with the central graph consensus of the network.

"zero" This option will replace all the missing values of the obeserver with the value 0. This however, can result in inaccurate outcomes (Krackhardt and Kilduff 2002).

``` r
formatting_data(list_respondent, option = "replace")
```

    ## [[1]]
    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]    0    0    1    0    0
    ## [2,]    1    0    0    1    1
    ## [3,]    0    1    0    0    0
    ## [4,]    1    1    1    0    1
    ## [5,]    0    0    1    1    0
    ## 
    ## [[2]]
    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]    0    0    1    1    1
    ## [2,]    1    0    0    1    1
    ## [3,]    1    1    0    0    0
    ## [4,]    1    1    1    0    1
    ## [5,]    0    0    0    1    0
    ## 
    ## [[3]]
    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]    0    1    1    0    1
    ## [2,]    1    0    1    1    1
    ## [3,]    1    1    0    0    0
    ## [4,]    1    1    0    0    1
    ## [5,]    0    0    0    1    0
    ## 
    ## [[4]]
    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]    0    1    1    0    0
    ## [2,]    1    0    0    1    0
    ## [3,]    0    1    0    0    0
    ## [4,]    1    1    1    0    1
    ## [5,]    0    1    1    0    0
    ## 
    ## [[5]]
    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]    0    1    1    0    1
    ## [2,]    1    0    0    1    1
    ## [3,]    1    1    0    0    0
    ## [4,]    1    1    1    0    1
    ## [5,]    0    0    1    1    0

### Mock Data

There are two main public examples of CSS data that is often used for dementration. These two datasets have been loaded into the R enviroment when the Rfrenz package is called.

``` r
head(Rfrenz::hightech_advice, n=2)
```

    ## [[1]]
    ##       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13]
    ##  [1,]    0    1    0    1    0    0    0    1    0     0     0     0     0
    ##  [2,]    1    0    0    1    0    1    1    1    0     0     0     1     0
    ##  [3,]    1    1    0    0    0    0    0    0    0     1     1     1     0
    ##  [4,]    1    1    0    0    0    1    0    1    0     1     1     1     0
    ##  [5,]    1    1    1    0    0    0    0    0    0     1     1     0     0
    ##  [6,]    1    1    1    1    1    0    0    1    1     1     1     1     1
    ##  [7,]    1    1    1    0    1    1    0    1    1     1     1     0     1
    ##  [8,]    1    0    0    1    0    1    1    0    0     0     1     1     0
    ##  [9,]    1    1    1    0    1    1    0    0    0     0     1     0     1
    ## [10,]    0    0    1    0    1    0    0    1    1     0     1     0     1
    ## [11,]    1    1    1    0    1    0    1    1    1     0     0     0     1
    ## [12,]    1    1    0    1    0    1    0    1    0     0     0     0     0
    ## [13,]    1    1    1    0    1    1    0    0    1     1     1     0     0
    ## [14,]    1    1    1    0    1    1    1    1    1     1     1     1     1
    ## [15,]    1    1    1    0    1    1    0    0    1     0     1     0     1
    ## [16,]    1    1    0    1    0    1    0    1    0     1     0     0     0
    ## [17,]    1    1    1    1    1    0    1    1    1     0     1     1     1
    ## [18,]    1    1    1    0    1    0    1    1    1     1     1     1     1
    ## [19,]    1    1    1    0    1    1    0    0    1     1     1     0     1
    ## [20,]    1    1    1    1    1    1    0    1    1     1     1     1     1
    ## [21,]    0    1    0    0    0    1    1    1    0     0     0     1     0
    ##       [,14] [,15] [,16] [,17] [,18] [,19] [,20] [,21]
    ##  [1,]     0     0     1     0     1     0     0     1
    ##  [2,]     0     0     1     1     1     0     0     1
    ##  [3,]     0     0     0     1     1     0     0     0
    ##  [4,]     0     0     1     0     1     0     0     1
    ##  [5,]     1     0     1     1     1     1     1     1
    ##  [6,]     1     1     1     1     1     1     1     1
    ##  [7,]     1     1     1     1     1     1     1     1
    ##  [8,]     0     0     1     1     1     0     1     1
    ##  [9,]     1     1     1     1     1     1     1     0
    ## [10,]     1     1     1     0     1     1     1     0
    ## [11,]     1     1     1     0     1     1     1     0
    ## [12,]     1     1     0     1     1     0     1     1
    ## [13,]     1     1     1     1     1     1     1     0
    ## [14,]     0     1     1     1     1     1     1     1
    ## [15,]     1     0     1     1     1     1     1     1
    ## [16,]     0     0     0     0     1     0     1     0
    ## [17,]     1     1     1     0     1     1     1     1
    ## [18,]     1     1     1     0     0     1     1     1
    ## [19,]     1     1     1     1     1     0     1     0
    ## [20,]     1     1     1     1     1     1     0     0
    ## [21,]     1     0     0     1     1     0     0     0
    ## 
    ## [[2]]
    ##       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13]
    ##  [1,]    0    1    1    1    0    0    0    0    0     0     1     0     0
    ##  [2,]    0    0    0    0    0    1    1    0    0     0     0     0     0
    ##  [3,]    1    1    0    0    0    1    1    0    0     0     0     0     0
    ##  [4,]    1    1    0    0    0    0    0    1    0     0     0     1     0
    ##  [5,]    1    1    0    0    0    0    1    0    0     0     0     0     0
    ##  [6,]    0    1    0    1    0    0    0    0    0     0     1     0     0
    ##  [7,]    0    1    0    0    0    0    0    0    0     0     0     0     0
    ##  [8,]    1    1    0    1    0    0    0    0    0     0     0     0     0
    ##  [9,]    1    1    0    0    0    0    0    0    0     0     0     0     0
    ## [10,]    0    1    0    0    0    0    0    1    0     0     0     0     0
    ## [11,]    1    1    0    0    0    0    1    1    0     0     0     0     0
    ## [12,]    0    1    0    1    0    1    0    0    0     0     0     0     0
    ## [13,]    1    1    0    0    1    0    1    0    0     0     0     0     0
    ## [14,]    0    1    0    0    0    0    1    0    0     0     0     0     0
    ## [15,]    1    1    0    0    1    1    0    0    0     0     0     0     0
    ## [16,]    1    1    0    1    0    0    0    1    0     0     0     0     0
    ## [17,]    0    1    0    0    0    1    0    0    0     0     0     0     0
    ## [18,]    1    1    0    0    0    1    1    0    0     0     1     0     0
    ## [19,]    1    1    0    0    0    0    0    0    0     0     0     0     0
    ## [20,]    1    1    0    1    0    1    1    0    0     0     0     0     0
    ## [21,]    0    1    0    0    0    1    1    0    0     0     0     0     0
    ##       [,14] [,15] [,16] [,17] [,18] [,19] [,20] [,21]
    ##  [1,]     0     0     1     0     1     0     0     0
    ##  [2,]     0     0     0     0     0     0     0     1
    ##  [3,]     1     0     0     0     0     0     0     1
    ##  [4,]     0     0     1     0     1     0     0     1
    ##  [5,]     1     0     1     0     1     0     1     1
    ##  [6,]     0     0     0     0     0     0     0     1
    ##  [7,]     0     0     0     0     0     0     0     1
    ##  [8,]     0     0     0     0     1     0     0     1
    ##  [9,]     1     0     0     0     1     0     1     0
    ## [10,]     0     0     1     0     1     0     0     0
    ## [11,]     0     0     0     0     1     0     0     0
    ## [12,]     0     0     0     0     0     0     0     1
    ## [13,]     1     0     0     0     1     1     1     0
    ## [14,]     0     0     0     0     0     0     0     1
    ## [15,]     1     0     0     0     1     1     1     1
    ## [16,]     0     0     0     0     1     0     0     0
    ## [17,]     0     0     0     0     0     0     0     1
    ## [18,]     0     0     1     0     0     0     0     1
    ## [19,]     1     0     0     0     0     0     1     0
    ## [20,]     1     0     1     0     1     0     0     1
    ## [21,]     0     0     0     0     0     0     0     0

Criterion
---------

Criterion (also called true or actual) networks are representative of the notion of shared or common perceptions of social structures from all observers within a network. Various different algorithms exist to derive these actual networks namely: Local Aggregate Structures (LAS), Consensus Structures and Expert Structures (Krackhardt 1987)(Cornelissen 2019).

#### Local Aggregate Structures (LAS)

LAS is suitable in a context to generate which suggests that only the individuals directly involved in the relation determine the existence of the relation.

##### RLAS: Row-Dominated LAS

An RLAS criterion is created by determining whether or not the perceiver observes the relationship to exist, even though the receiver does not always necessarily deem it to exist (Krackhardt 1987). Thus, the sender of the relationship will be assumed as correct. Function used: consensus from the SNA package (Butts 2016).

##### CLAS: Column-Dominated LAS.

CLAS is created by determining whether or not the receiver of the relation perceives the relation to exist. Thus, the receiver of the relationship will be assumed as correct. Function used: consensus from the SNA package (Butts 2016).

##### ILAS: Intersection LAS

ILAS criterion networks are created by determining whether or not both respondents perceive the tie to exist. Thus, both respondents have to agree on the relationship in order for it to exist (Krackhardt 1987). Function used: consensus from the SNA package (Butts 2016).

##### ULAS: Union LAS

ULAS defines relations to exist if at least one of the respondents involved in the relation perceives it to exist (Krackhardt 1987). Function used: consensus from the SNA package (Butts 2016).

#### Consensus Structures

##### GA: Global Aggregate

Using Global Aggregate to generate actual networks is not so much focused on who perceived a specific relations, but rather how many perceived that relation. This is done by taking the sum of relationships that exists for each observer.

##### GAT: Global Aggregate with a threshold

The threshold is set to measure the proportion of members that perceive a relation between the sender and receiver of the relationship. This corresponds to a “median response” notion of creating an actual network. Function used: consensus from the SNA package (Butts 2016).

##### GAV: Global Aggregate (valued)

To gain a clearer understanding of the global perception of a relation, one could make use of proportions rather than showing only the presence or absence of a perceived relation (i.e. the GAT method). Thus, this method shows which percentage of observers perceived the relationship.

#### Expert Structures

##### SR: Single Reweight

The reweight method takes consensus structure to create an initial criterion network. The reweight method is then applied to give a more accurate representation of the perceptions in the network. This is done is by performing consensus structure reduction on the data again but with different perceivers weighted according to their accuracy in perceiving relations in original criterion network. The single reweight method is when there is only one additional reduction done using the reweighted nodes. Function used: consensus from the SNA package (Butts 2016).

##### IR: Iterative Reweight

Similar to Single Reweight except this method applies multiple reductions to weigh perceivers differently in each iteration. This can be useful when there is a disconnect between different perceptions which results in relations which are not accurate or don't exist. IR tries to find the most accurate perceivers in the network in order to give their perceptions of relations more validity when determining the criterion network. Function used: consensus from the SNA package (Butts 2016).

##### RB: Romney Batchelder

Similar to Single Reweight method but with an exception to the motivation. Romney Batchelder theory's motivation lies in the measurement of shared beliefs in a group. The criterion is built on the “cultural competency” weighted perceptions. Measuring “cultural competency” of respondents is done by determining the correlation between the responses of each individual and the aggregated responses of the group.

##### PCA: Principal Component Analysis.

The PCA method for generating actual networks uses the first component of a network. PCA extracts shared themes among all the respondents within a network (Butts 2016). PCA reduces the dimensions and relationships considered a data set while still maintaining the most important information within it. Function used: consensus from the SNA package (Butts 2016).

##### BAY: Bayesian

Network accuracy model method can be used to generate the criterion network given the probability of false positives and false negatives. For more information see Bayesian. Function used: consensus from the SNA package (Butts 2016).

### Get Criterion

This function generates a criterion (true) network given all the perceptions perceived in a network. Several algorithms for determining criterion networks are available to best suit the context of the network.

#### Arguments:

`dat` - A socio-matrix containing all of the perceptions of a network `criterion` - The criterion network needed to be generated (“RLAS”, “CLAS”, “ILAS”, “ULAS”, “GA”, “GAT”, “GAV”, “SR”, “IR”, “PCA”, “RB”, “BAY”)

``` r
crit <- get_criterion(list_respondent, criterion='RLAS')
```

    ## [1] "RLAS Criterion"

``` r
crit
```

    ##      [,1] [,2] [,3] [,4]
    ## [1,]    0    0    1    0
    ## [2,]    1    0    0    1
    ## [3,]    1    1    0    0
    ## [4,]    1    1    1    0

#### Values:

The function returns a socio-matrix representing the Criterion ('true') Network structure \#\#\#\# Example:

Accuracy
--------

The purpose of this package is to get the accuracy scores for each respondent in a social network based on their perception of the network. This is done by checking the similarity between their perception and a criterion network (i.e., a network that best represents the relations in a network).

#### Interpersonal Accuracy

##### Pearson Correlation

The Pearson correlation test is done using a function from the SNA package called `gcor`. The SNA package states that “gcor” function is used to find the product-moment correlation between adjacency matrices (Butts 2016). The “gcor” is a specialised form of a standard “cor” correlation. The ”gcor” function focuses more on graph data. Scores larger than 0 show a positive correlation whereas scores below 0 show a negative correlation.

##### Spearman Correlation

The Spearman correlation test is performed using the `cor.test` function from the stats package. The estimate value is extracted from the results of the test. This value represents the similarity score computed from the correlation. According to the Stats package the rho statistic is used to compute the estimate value of the ranked based measure of association (De Nooy, Mrvar, and Batagelj 2016). A Spearman correlation test is best suited for data that can be ranked. Scores larger than 0 show a positive correlation whereas scores below 0 show a negative correlation.

##### Jaccard Correlation

The Jaccard similarity coefficient is performed using the `jaccard` function that is found in the Jaccard package. This function will result in a number between 1 and 0. The closer the value is to 1 the higher the similarity is between the two matrices. The Jaccard similarity coefficient is used in social science as it shows the occurrences of agreements between binary sets of data (Marineau 2016).

##### Kendall Rank Correlation

The Kendall rank correlation is performed using the `kendall` function that is found in the Kendall package. The Kendall rank correlation or more commonly known as Kendall's tau, is a correlation tool used to measure the ordinal association between two measured variables (Kendall 1938). The “Kendall” function computes a p-value and if it determined to be significant such that variables are dependent, and therefore there are ties. Then it will checks the similarity between these variables. The Kendall Tau statistic is extracted from the results of this function.

##### S14 Similarity Index

The s14 similarity index is performed using the `s14` function that is found in the cssTools package. The s14 function computes the similarity between the two square matrices. S14 is useful for network data as it shows appropriate sensitivity to small changes and does not distort at extremes (Gower and Legendre 1986).

##### MRQAP with Double-Semi-Partialing (DSP)

MRQAP with DSP is performed using the `mrqap.dsp` function that is found in the Asnipe package. This function computes the regression coefficient using the DSP method. The method randomises the p-value with 1000 permutation in order to determine if the matrices are dependent or independent (Dekker, Krackhardt, and Snijders 2003).

##### Cohens Kappa

The Cohens Kappa coefficient can be determined using the `cohen.kappa` function that can be found in the psych package. This accuracy measure takes the possibility of chance into account (i.e., someone could have merely guessed about a relationship within a given network and the measure takes that probability into account) (Cohen 1960). Target accuracy measures refer to how accurate a perceiver's agreement would be towards a certain target, where the target would be the relationship between i and j (J. W. Neal, Neal, and Cappella 2016).

##### Local Accuracy

The local accuracy is computed by comparing a person's perceptions to a Row dominated local aggregate structure (RLAS). local accuracy tries to see how accurate a person is at knowing the perceptions in a social network based on how they think the people in that network perceive them (Casciaro, Carley, and Krackhardt 1999). A pearson correlation is performed between a row of a person's perceptions and a row of the RLAS criterion.

##### Dyadic Accuracy

Dyadic accuracy looks at how accurately an individual can perceive a possible dyadic relation between two individuals. To do this it takes one person perceptions and measures its perception of dyadic relations according to the “true” network (Bondonio 1998).

#### Intermediate Accuracy

##### Triadic (Pearson, Spearman, Distance)

The triadic accuracy compares the triadic structure of the criterion network and the respondent by means of either a Pearson correlation, Spearman's rank correlation, or Euclidean distance measure. This approach was proposed by Frenz (2019) as a means to compare the degree of similarity between the triad census of the actual social network and the triad census of a respondents cognitive slice.

#### Structural Accuracy

##### Structural Correlation (gscor)

The structural correlation between two or more graphs can be determined using the `gscor` function found in the SNA package. The gscor function finds the product-movement structural correlation. This indicates that it looks at the structure of each network and determines how similar the structure is as opposed to if specific ties were similar between nodes (Butts and Carley 2001). The node labels in the network are permutated in order to determine how similar the structure is to the true network (Butts and Carley 2001).

### Get Accuracy

The purpose of this function is to get the accuracy scores for each respondent in a social network based on their perception of the network. This is done by checking the similarity between their perception and a criterion network (i.e., a network that best represents the relations in a network).

#### Arguments

`dat` - A list of socio matrices that represent respondents. `criterion` - A sociomatrix that represents the criterion network (i.e., a network that best represents the relations in a network) that is computed from all respondents. `acc` - The name of the accuracy measure to be computed. Options: “pearson”, “spearman”, “jaccard”, “kendall”, “s14”, “mrqap”, “gscor”, “CohenK”, “local”, “triadic pearson”, “triadic spearman”, “triadic distance”. `criterion_type` - The name of the criterion that has been used.

``` r
acc_df<- get_accuracy(list_respondent, crit, acc = "pearson", criterion_type = "RLAS")
```

    ## [1] "Pearson Correlation"

``` r
acc_df
```

    ##   Respondent     Score     acc criterion_type
    ## 1          1 0.8366600 pearson           rlas
    ## 2          2 0.8164966 pearson           rlas
    ## 3          3 0.4082483 pearson           rlas
    ## 4          4 0.6250000 pearson           rlas

#### Values

A dataframe of respondents and there accuracy scores. \#\#\#\# Example:

Plotting
--------

### Rfrenz plot

This function can be used to quickly plot a summary of the get\_crit() and get\_accuracy() functions in one place. \#\#\#\# Arguments `crit` - criterion network returned after get\_criterion() is run. the crit is used to plot a criterion network.

`accuracy_df` - accuracy score dataframe that is return after get\_accruacy() from Rfrenze is run. the accruacy\_df is used to plot a boxplot summarising the data

`criterion` - default="RLAS". the criterion name of the criterion being past in crit. is used as a titile for the graph.

``` r
frenz_plot(crit, acc_df,criterion="RLAS")
```

    ## Using `nicely` as default layout

![](README_files/figure-markdown_github/Rfrenz%20plot-1.png)

#### Values

The Plot function returns a network graph of the criterion network that is passed into it and a box and whisker graph showing summary statistics of the data.

Conclusion
----------

References
==========

Bondonio, Daniele. 1998. “Predictors of accuracy in perceiving informal social networks.” *Social Networks* 20 (4): 301–30. doi:[10.1016/S0378-8733(98)00007-0](https://doi.org/10.1016/S0378-8733(98)00007-0).

Borgatti, Stephen P, Kathleen M Carley, and David Krackhardt. 2006. “On the robustness of centrality measures under conditions of imperfect data.” *Social Networks* 28 (2): 124–36. doi:[10.1016/j.socnet.2005.05.001](https://doi.org/10.1016/j.socnet.2005.05.001).

Butts, Carter T. 2016. “sna: Tools for social network analysis.” <https://cran.r-project.org/package=sna>.

Butts, Carter T, and Kathleen M Carley. 2001. “Multivariate methods for inter-structural analysis.” Pittsburgh: Carnegie Mellon University. <http://www.casos.cs.cmu.edu/publications/papers/multiv001a.pdf>.

Casciaro, Tiziana, Kathleen M Carley, and David Krackhardt. 1999. “Positive affectivity and accuracy in social network perception.” *Motivation and Emotion* 23 (4): 285–306. doi:[10.1023/A:1021390826308](https://doi.org/10.1023/A:1021390826308).

Cornelissen, Laurenz Aldu. 2019. “Social network cognition: An empirical investigation of network accuracy and social position.” PhD thesis, Stellenbosch University.

De Nooy, Wouter, Andrej Mrvar, and Vladimir Batagelj. 2016. “Exploratory social network analysis with Pajek.” Cambridge: Cambridge University Press. <http://ebooks.cambridge.org/ref/id/CBO9780511996368>.

Dekker, David, David Krackhardt, and Tom A B Snijders. 2003. “Multicollinearity robust QAP for multiple regression.” *1st Annual Conference of the North American Association for Computational Social and Organizational Science*, 22–25. <http://www.casos.cs.cmu.edu/publications/papers/dekker_2003_multicollinearity.pdf>.

Frenz, Vincent. 2019. “Cognitive structural accuracy.” PhD thesis, Stellenbosch University.

Gower, John C, and P Legendre. 1986. “Metric and Euclidean properties of dissimilarity coefficients.” *Journal of Classification* 3 (1): 5–48. doi:[10.1007/BF01896809](https://doi.org/10.1007/BF01896809).

Kendall, Maurice G. 1938. “A new measure of rank correlation.” *Biometrika* 30 (1): 81–93. <https://www.jstor.org/stable/2332226>.

Krackhardt, David. 1987. “Cognitive social structures.” *Social Networks* 9 (2): 109–34. doi:[10.1016/0378-8733(87)90009-8](https://doi.org/10.1016/0378-8733(87)90009-8).

Krackhardt, David, and Martin Kilduff. 2002. “Structure, culture and Simmelian ties in entrepreneurial firms.” *Social Networks* 24 (3): 279–90.

Marineau, Joshua Eric. 2016. “Trust and distrust network accuracy and career advancement in an organization.” *Group & Organization Management* 42 (4): 487–520. doi:[10.1177/1059601115627529](https://doi.org/10.1177/1059601115627529).

Neal, Jennifer Watling, Zachary P Neal, and Elise Cappella. 2016. “Seeing and being seen: Predictors of accurate perceptions about classmates’ relationships.” *Social Networks* 44. Elsevier B.V.: 1–8. doi:[10.1016/j.socnet.2015.07.002](https://doi.org/10.1016/j.socnet.2015.07.002).
