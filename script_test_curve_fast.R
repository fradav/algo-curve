#! /usr/bin/env Rscript
library(sanssouci)
library(microbenchmark)

# args = commandArgs(trailingOnly=TRUE)
# if (length(args) == 0){
#   n_repl <- 1
# } else {
#   n_repl <- args[1]
# }

set.seed(12)

get_groups <- function(list_groups, leaf_list){
  res <- list()
  for (group in list_groups){
    res <- c(res, list(leaf_list[[group[1]]][1]:rev(leaf_list[[group[2]]])[1]))
  }
  return(list(res = res, total = unlist(res)))
}

pow <- 10
alpha <- 0.05

vec_factor <- c(1, 10)
vec_n_repl <- c(100, 10)
vec_method <- c(zeta.DKWM, zeta.trivial)

for (i in 1:4){
  
  factor <- vec_factor[floor((i+1)/2)]
  n_repl <- vec_n_repl[floor((i+1)/2)]
  method <- vec_method[[i %% 2 + 1]]
  
  m <- (2 ^ pow) * factor
  example <- dyadic.from.height(m, pow, 2)
  leaf_list <- example$leaf_list
  C <- example$C
  signal <- 4
  mu <- rep(0, m)
  H1 <- get_groups(example$C[[6]][c(1, 5, 9, 10)], leaf_list)$total
  mu[H1] <- signal
  
  pval <- 1 - pnorm(mu + rnorm(n = m))
  
  ZL <- zetas.tree(C, leaf_list, method, pval, alpha, refine = TRUE, verbose = FALSE)
  
  # print("The pvalues are:")
  # print(pval)
  # print("The zetas are:")
  # print(ZL)
  
  # pruned <- pruning(C, ZL, leaf_list, prune.leafs = FALSE)
  pruned.no.gaps <- pruning(C, ZL, leaf_list, prune.leafs = FALSE, delete.gaps = TRUE)
  
  print(m)
  print(nb.elements(C))
  print(nb.elements(pruned.no.gaps$C))
  
  perm <- 1:m
  
  print("Comparing execution times:")
  mbench <- microbenchmark(naive.not.pruned = curve.V.star.forest.naive(perm, C, ZL, leaf_list),
                           # naive.pruned = curve.V.star.forest.naive(perm, pruned$C, pruned$ZL, leaf_list),
                           naive.pruned = curve.V.star.forest.naive(perm, pruned.no.gaps$C, pruned.no.gaps$ZL, leaf_list),
                           fast.not.pruned = curve.V.star.forest.fast(perm, C, ZL, leaf_list),
                           # fast.pruned = curve.V.star.forest.fast(perm, pruned$C, pruned$ZL, leaf_list, is.pruned = TRUE),
                           fast.pruned = curve.V.star.forest.fast(perm, pruned.no.gaps$C, pruned.no.gaps$ZL, leaf_list, is.pruned = TRUE),
                           times = n_repl, check = "equal")
  write.csv(mbench, paste0("benchmark_0", i, ".csv"), row.names = F)
}
