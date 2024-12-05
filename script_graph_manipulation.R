#!/usr/bin/env Rscript
library(microbenchmark)

def_mar <- c(5, 4, 4, 2) + 0.1

i <- 1
unit <- "s"

loaded <- read.csv(paste0("benchmark_0", i, ".csv"))
class(loaded) <- c("microbenchmark", class(loaded))
loaded$expr <- factor(loaded$expr, levels = c("naive.not.pruned", "naive.pruned", 
                                              "naive.pruned.no.gaps",
                                              "fast.not.pruned",
                                              "fast.pruned",
                                              "fast.pruned.no.gaps")
)
sum <- summary(loaded, unit=unit)
print(sum)

# loaded2 <- data.frame(loaded)
# loaded2$time <- microbenchmark:::convert_to_unit(loaded, unit)
loaded$time <- microbenchmark:::convert_to_unit(loaded, unit)


# # HORIZONTAL
# par(mar = def_mar + c(0, 5, 0, 0))
# 
# bp <- boxplot(time ~ expr, data=loaded, xlab="time [s]", ylab="", 
#               ylim=NULL, horizontal=T, main="microbenchmark timings", 
#               yaxt = "n")
# tick <- seq_along(bp$names)
# axis(1, at = tick, labels = FALSE)
# text(par("usr")[1] - 1.4, tick, bp$names, srt = 0, xpd = TRUE)

# VERTICAL
par(mar = def_mar + c(3.8, 0, 0, 0))

bp <- boxplot(time ~ expr, data=loaded, ylab="time [s]", xlab="", 
              ylim=NULL, horizontal=F, main="microbenchmark timings", 
              xaxt = "n")
tick <- seq_along(bp$names)
axis(1, at = tick, labels = FALSE)
text(tick, par("usr")[1] - 2, bp$names, srt = 60, xpd = TRUE)