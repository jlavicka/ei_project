As its input, this R script takes absolute figures of ethnic population totals and party vote totals for each political unit. Ecological inference estimates in terms of percentages of each ethnic group are then exported as two summary files and two complete analyses with additional descriptive information, all of which are in an .xlsx format. This method of export is specfic to the author's use and can be adapted to the user's needs through manipulation of the `Export Results` code chunk.

The following indices are in reference to the imported data frame to be written as a vector of integers:
  
  Object `a` holds the column indices for each political party.
  
  Object `b` holds the column indices of each main ethnic group. 
 
  Object `c` holds the column index or indices of the ethnic group labelled `Other`.
 
  Object `d` holds the column index or indices of the ethnic group labelled `Unknown`.

The ethnic groups used to compose objects `c` and `d` are compiled at the user's discretion. If no group applies, either or both objects can be left `NULL`. Objects `a` and `b` must be filled.

The sum of objects `b`,`c`, and `d` is used as the total population of each unit. Percentages of each party and ethnic group are computed in relation to this total population figure. The number of non-voters in each unit are computed as the difference between the total population and the total number of valid votes.

From the`eiPack` R package, `ei.MD.bayes()` is applied to complete the analysis. The R manual is included in the repository. 

Currently, the code does not account for mismatched political units. The total population needs to be greater than the total number of valid votes for each population unit to be included. Mismatched units are dropped from the analysis and exported with the results in a separate Excel tab for further inspection. 

To account for the missing data, future revisions will be made to include mismatched units. The units will be retotaled as a percentage of the valid votes with the assumption of complete voter-turnout and reintroduced into the analysis.



There are still a few bugs that need fixing. If there are any issues please let me know.
