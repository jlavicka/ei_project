The R script takes as its input ethnic population totals and party vote totals from each political unit. Ecological inference estimates, in terms of percentages of each ethnic group's vote toward each political party, are then exported with additional descriptive information to an .xlsx file format.

The following indices are in reference to the imported data frame. They each are to be written as a vector of integers.
  
  Object `alpha` contains the column indices of each political party.
  
  Object `bravo` contains the column indices of each main ethnic group. 
 
  Object `charlie` contains the column index or indices of the ethnic group(s) labelled `Other`.
 
  Object `delta` contains the column index or indices of the ethnic group(s) labelled `Unknown`.

The ethnic groups used to compose objects `charlie` and `delta` are compiled at the user's discretion. If no group applies, either or both objects can be left `NULL`. Objects `alpha` and `bravo` must be filled.

Additionally, a string value representing the desired output file name is needed for object `xray`.

The sum of objects `bravo`,`charlie`, and `delta` is used as the total population of each unit. Percentages of each party and ethnic group are computed in relation to this total population figure. The number of non-voters in each unit are computed as the difference between the total population and the total number of valid votes.

From the`eiPack` R package, `ei.MD.bayes()` is used to complete the analysis. This function implements a hierarchical Multinomial-Dirichlet model for ecological inference in RxC tables. Draws from the posterior are obtained with a Metropolis-within-Gibbs algorithm. More information on the methodology can be found in the package's R manual included in the repository. 

Currently, the code does not account for mismatched political units. The total population must be greater than the total number of valid votes for each political unit in order to be included. Mismatched units are dropped from the analysis and exported with the results in a separate Excel tab for further inspection. 

To account for the missing data, future revisions will be made to include mismatched units. The units will be retotaled as a percentage of the valid votes with the assumption of complete voter-turnout, then resubmitted into the analysis.

There are still a few additional bugs that need fixing. If you come across any of these issues please let me know.
