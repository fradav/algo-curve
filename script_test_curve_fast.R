library(sanssouci)
library(microbenchmark)

set.seed(12)

get_groups <- function(list_groups, leaf_list){
  res <- list()
  for (group in list_groups){
    res <- c(res, list(leaf_list[[group[1]]][1]:rev(leaf_list[[group[2]]])[1]))
  }
  return(list(res = res, total = unlist(res)))
}

pow <- 10
m <- 2 ^ pow
example <- dyadic.from.height(m, pow, 2)
leaf_list <- example$leaf_list
C <- example$C
signal <- 4
mu <- rep(0, m)
H1 <- get_groups(example$C[[6]][c(1, 5, 9, 10)], leaf_list)$total
mu[H1] <- signal

pval <- 1 - pnorm(mu + rnorm(n = m))
alpha <- 0.05
method <- zeta.DKWM
# method <- zeta.trivial
ZL <- zetas.tree(C, leaf_list, method, pval, alpha, refine = TRUE, verbose = FALSE)

# print("The pvalues are:")
# print(pval)
# print("The zetas are:")
# print(ZL)

pruned <- pruning(C, ZL, leaf_list, prune.leafs = FALSE)
pruned.no.gaps <- pruning(C, ZL, leaf_list, prune.leafs = FALSE, delete.gaps = TRUE)

print(nb.elements(C))
print(nb.elements(pruned.no.gaps$C))

perm <- 1:m

print("Comparing execution times:")
mbench <- microbenchmark(naive.not.pruned = curve.V.star.forest.naive(perm, C, ZL, leaf_list),
                         naive.pruned = curve.V.star.forest.naive(perm, pruned$C, pruned$ZL, leaf_list),
                         naive.pruned.no.gaps = curve.V.star.forest.naive(perm, pruned.no.gaps$C, pruned.no.gaps$ZL, leaf_list),
                         fast.not.pruned = curve.V.star.forest.fast(perm, C, ZL, leaf_list),
                         fast.pruned = curve.V.star.forest.fast(perm, pruned$C, pruned$ZL, leaf_list, is.pruned = TRUE),
                         fast.pruned.no.gaps = curve.V.star.forest.fast(perm, pruned.no.gaps$C, pruned.no.gaps$ZL, leaf_list, is.pruned = TRUE),
                         times = 2, check = "equal")
write.csv(mbench, "benchmark_01.csv", row.names = F)
loaded <- read.csv("benchmark_01.csv")
class(loaded) <- c("microbenchmark", class(loaded))
attr(loaded, "unit") <- "t"
# print(loaded)
# boxplot(loaded)
sum <- summary(loaded, unit="s")
sum <- sum[c(4, 5, 6, 1, 2, 3), ]
sum
