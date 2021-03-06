# Packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(purrr)
library(eiPack)
library(writexl)


# Inputs
df <- read_csv()

#### output name
xray <- ""

#### party column indices
alpha <- c()

#### main ethnic group indices
bravo <- c()

#### column indices to be combined into other group
charlie <- c()

#### column indices to be combined into unknown group
delta <- c()

########################################################################

# Data Prep

colnames(df) -> df_colnames

data.frame("p" = rep("p", length(alpha)), "n" = 1:length(alpha)) %>% 
  unite(p, n, col = "partyid", sep = "") %>% 
  cbind(party = df_colnames[alpha]) -> partyid

if (is.null(delta) == TRUE & is.null(charlie) == FALSE){
  df %>% 
    mutate(pop = rowSums(df[c(bravo,charlie)]),
           valid = rowSums(df[alpha]),
           novote = pop - valid,
           Other = rowSums(df[charlie])) %>% 
      relocate(c(pop, valid, novote, Other), .after = last_col()) -> df1
  
  df1[c(bravo,ncol(df1))] -> agg
  
  df1 %>% 
      filter(pop > 0) %>% 
      filter(novote >= 0) -> df
    
    df1 %>%
      filter(pop > 0) %>% 
      filter(novote < 0) %>% 
      mutate(novote = 0) -> df_na -> df_na1
    
  df_na1[alpha]/df_na1$valid -> df_na1[alpha]
    
  df_na1[c(bravo,ncol(df_na1)-c(0,1))]/df_na1$pop -> df_na1[c(bravo,ncol(df_na1)-c(0,1))]
    
  df[c(alpha,bravo,ncol(df)-c(0,1))]/df$pop -> df[c(alpha,bravo,ncol(df)-c(0,1))]
    
  rbind(df, df_na1) -> df; rm(df_na1); rm(df1)
    
  names(df)[alpha] <- partyid$partyid
  
  } else if (is.null(charlie) == TRUE & is.null(delta) == FALSE) {
    df %>% 
    mutate(pop = rowSums(df[c(bravo,delta)]),
           valid = rowSums(df[alpha]),
           novote = pop - valid,
           Unknown = rowSums(df[delta])) %>%
    relocate(c(pop, valid, novote, Unknown), .after = last_col()) -> df1

    df1[c(bravo,ncol(df1))] -> agg
    
    df1 %>% 
      filter(pop > 0) %>% 
      filter(novote >= 0) -> df
    
    df1 %>%
      filter(pop > 0) %>% 
      filter(novote < 0) %>% 
      mutate(novote = 0) -> df_na -> df_na1
  
  df_na1[alpha]/df_na1$valid -> df_na1[alpha]
  
  df_na1[c(bravo,ncol(df_na1)-c(0,1))]/df_na1$pop -> df_na1[c(bravo,ncol(df_na1)-c(0,1))]
  
  df[c(alpha,bravo,ncol(df)-c(0,1))]/df$pop -> df[c(alpha,bravo,ncol(df)-c(0,1))]
  
  rbind(df, df_na1) -> df;rm(df_na1); rm(df1)
  
  names(df)[alpha] <- partyid$partyid
  
  } else if (is.null(delta) == TRUE & is.null(charlie) == TRUE){
  df %>% 
      mutate(pop = rowSums(df[c(bravo,charlie,delta)]),
             valid = rowSums(df[alpha]),
             novote = pop - valid) %>% 
      relocate(c(pop, valid, novote), .after = last_col()) -> df1
  
  df1[bravo] -> agg
  
  df1 %>% 
      filter(pop > 0) %>% 
      filter(novote >= 0) -> df
    
    df1 %>%
      filter(pop > 0) %>% 
      filter(novote < 0) %>% 
      mutate(novote = 0) -> df_na -> df_na1
  
  df_na1[alpha]/df_na1$valid -> df_na1[alpha]
  
  df_na1[c(bravo,ncol(df_na1))]/df_na1$pop -> df_na1[c(bravo,ncol(df_na1))]
  
  df[c(alpha,bravo,ncol(df))]/df$pop -> df[c(alpha,bravo,ncol(df))]
  
  rbind(df, df_na1) -> df; rm(df_na1); rm(df1)
  
  names(df)[alpha] <- partyid$partyid
  
  } else {
    df %>% 
      mutate(pop = rowSums(df[c(bravo,charlie,delta)]),
             valid = rowSums(df[alpha]),
             novote = pop - valid,
             Unknown = rowSums(df[delta]),
             Other = rowSums(df[charlie])) %>% 
      relocate(c(pop, valid, novote, Unknown, Other), .after = last_col()) -> df1
    
    df1[c(bravo,ncol(df1)-c(0,1))] -> agg
    
    df1 %>% 
      filter(pop > 0) %>% 
      filter(novote >= 0) -> df
    
    df1 %>%
      filter(pop > 0) %>% 
      filter(novote < 0) %>% 
      mutate(novote = 0) -> df_na -> df_na1
    
    df_na1[alpha]/df_na1$valid -> df_na1[alpha]
    
    df_na1[c(bravo,ncol(df_na1)-c(0:2))]/df_na1$pop -> df_na1[c(bravo,ncol(df_na1)-c(0:2))]
    
    df[c(alpha,bravo,ncol(df)-c(0:2))]/df$pop -> df[c(alpha,bravo,ncol(df)-c(0:2))]
    
    rbind(df, df_na1) -> df; rm(df_na1); rm(df1)
    
    names(df)[alpha] <- partyid$partyid
}
```

# Model
set.seed(42)

if (is.null(charlie) == TRUE & is.null(delta) == FALSE | is.null(delta) == TRUE & is.null(charlie) == FALSE){
  
  tune.out <- tuneMD(as.matrix(df[c(alpha,ncol(df)-1)]) ~ as.matrix(df[c(bravo,ncol(df))]), covariate = NULL, data = df, ntunes = 10, totaldraws = 10000, total = "pop")
  
  ei.out <- ei.MD.bayes(as.matrix(df[c(alpha,ncol(df)-1)]) ~ as.matrix(df[c(bravo,ncol(df))]), total = "pop", data = df, tune.list = tune.out, sample = 10000, thin = 2, burnin = 2000)
 
      } else if (is.null(charlie) == TRUE & is.null(delta) == TRUE){
  
        tune.out <- tuneMD(as.matrix(df[c(alpha,ncol(df))]) ~ as.matrix(df[bravo]), covariate = NULL, data = df, ntunes = 10, totaldraws = 10000, total = "pop")
 
         ei.out <- ei.MD.bayes(as.matrix(df[c(alpha,ncol(df))]) ~ as.matrix(df[bravo]), total = "pop", data = df, tune.list = tune.out, sample = 10000, thin = 2, burnin = 2000)
  
         } else {
  
           tune.out <- tuneMD(as.matrix(df[c(alpha,ncol(df)-2)]) ~ as.matrix(df[c(bravo,ncol(df)-c(0,1))]), covariate = NULL, data = df, ntunes = 10, totaldraws = 10000, total = "pop")
  
           ei.out <- ei.MD.bayes(as.matrix(df[c(alpha,ncol(df)-2)]) ~ as.matrix(df[c(bravo,ncol(df)-c(0,1))]), total = "pop", data = df, tune.list = tune.out, sample = 10000, thin = 2, burnin = 2000)
           }

# National Estimates
## add mean of ei estimates
as.data.frame(ei.out$draws$Cell.counts)  %>% 
  map(mean) %>% 
  as.data.frame() %>% 
  gather(key = "ethn_party", value = "mean") %>% 
  mutate(mean = round(mean, 2),
         ethn_party = str_replace(ethn_party, "^ccount\\.", "")) %>% 
  separate(ethn_party, sep = "\\.(?=p[[:digit:]])|\\.(?=novote)", into = c("ethn", "partyid")) %>% 
  mutate(partyid = as.factor(partyid)) -> ei.est
## add standard deviation of ei estimates
as.data.frame(ei.out$draws$Cell.counts)  %>% 
  map(sd) %>% 
  as.data.frame() %>% 
  gather(value = "sd") %>%
  mutate(sd = round(sd, 2)) %>% 
  select(sd) -> ei.est[,4]
## add sum and percent of ethnic group totals from original dataset
agg %>% 
  map(sum) %>% 
  as.data.frame() %>%
  gather(key = "ethn", value = "total") %>% 
  right_join(ei.est, by = "ethn") %>% 
  mutate(percent = round((mean/total*100), 2)) %>% 
  select(ethn, partyid, mean, sd, total, percent) -> ei.est
## add sum and percent of ethnic group totals from ei estimates
ei.est %>% 
  group_by(ethn) %>% 
  summarise(est_total = sum(mean)) %>% 
  right_join(ei.est, by = "ethn") %>% 
  mutate(est_percent = round((mean/est_total*100), 2)) %>% 
  select(ethn, partyid, mean, sd, total, percent, est_total, est_percent) -> ei.est
## add sum and percent of voting population - totals minus novote party
ei.est %>% 
  filter(partyid != "novote") %>% 
  group_by(ethn) %>% 
  summarise(est_vot_total = sum(mean)) %>% 
  right_join(ei.est, by = "ethn") %>% 
  mutate(est_vot_percent = round((mean/est_vot_total*100), 2)) %>%
  select(ethn, partyid, mean, sd, total, percent, est_total, est_percent, est_vot_total, est_vot_percent) -> ei.est
## attach party names
full_join(ei.est, partyid, by = "partyid") -> ei.est
ei.est[,c(1,11,2:10)] -> ei.est

# Table
ei.est %>% 
  group_by(ethn, party) %>% 
  summarise(est_vot_percent) %>% 
  spread(ethn, est_vot_percent) -> tbl
tbl[1:nrow(tbl) - 1,] -> tbl

# Codebook
read.me <- data.frame(name = c("table",
                               "output",
                               "realigned data",
                               "",
                               "ethn",
                               "party",
                               "mean",
                               "sd",
                               "total",
                               "percent", 
                               "est_total", 
                               "est_percent", 
                               "est_vot_total", 
                               "est_vot_percent",
                               "",
                               "political parties",
                               "# of political parties",
                               "ethnic groups",
                               "groups merged into 'Other' category",
                               "groups merged into 'Unknown' category",
                               "# of ethnic groups (including 'Other' and 'Unknown')",
                               "",
                               "# of political units",
                               "# of realigned observations"
                               ), 
                      description = c("summary - percentage of votes cast by respective ethnic group for respective party relative to total number of votes cast by respective ethnic group", 
                                      "ei results of national estimates with major ethnic groups listed by party",
                                      "observations where total valid votes are greater than total population; dropped from analysis",
                                      "",
                                      "ethnic group", 
                                      "political party - coded relative to order of party in original dataset from left to right", 
                                      "average of ei estimates for number of votes cast by respective ethnic group for respective party", 
                                      "standard error of ei estimates for number of votes cast by respective ethnic group for respective party", 
                                      "total ethnic group population from original dataset", 
                                      "percentage of votes cast by respective ethnic group for respective party relative to original ethnic group population", 
                                      "total ethnic group population from ei results", 
                                      "percentage of votes cast by respective ethnic group for respective party relative to ethnic group population from ei reuslts", 
                                      "total number of votes cast by respective ethnic group", 
                                      "percentage of votes cast by respective ethnic group for respective party relative to total number of votes cast by respective ethnic group",
                                      "",
                                      gsub("^c\\(|\\)$", "", paste(as.data.frame(partyid$party))),
                                      nrow(tbl),
                                      gsub("^c\\(|\\)$", "", paste(as.data.frame(df_colnames[bravo]))),
                                      if (is.null(charlie) == TRUE){
                                        paste("NA")
                                      } else {
                                      gsub("^c\\(|\\)$", "", paste(as.data.frame(df_colnames[charlie])))},
                                      if (is.null(delta) == TRUE){
                                        paste("NA")
                                      } else {
                                      gsub("^c\\(|\\)$", "", paste(as.data.frame(df_colnames[delta])))},
                                      ncol(tbl) - 1,
                                      "",
                                      nrow(df),
                                      nrow(df_na)
                                      ))

# Export Results
sheets <- list("read.me" = read.me, "table" = tbl, "output" = ei.est, "realigned data" = df_na)
write_xlsx(sheets, path = xray)
