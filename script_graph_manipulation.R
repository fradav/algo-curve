#! /usr/bin/env Rscript

# library(microbenchmark)
#
# def_mar <- c(5, 4, 4, 2) + 0.1
#
# i <- 4
# unit <- "s"
#
# loaded <- read.csv(paste0("benchmark_0", i, ".csv"))
# class(loaded) <- c("microbenchmark", class(loaded))
# loaded$expr <- factor(loaded$expr, levels = c("naive.not.pruned",
#                                               "naive.pruned",
#                                               # "naive.pruned.no.gaps",
#                                               "fast.not.pruned",
#                                               "fast.pruned"
#                                               # "fast.pruned.no.gaps"
#                                               )
# )
# sum <- summary(loaded, unit=unit)
# print(sum)
#
# # loaded2 <- data.frame(loaded)
# # loaded2$time <- microbenchmark:::convert_to_unit(loaded, unit)
# loaded$time <- microbenchmark:::convert_to_unit(loaded, unit)
#
#
# # # HORIZONTAL
# # par(mar = def_mar + c(0, 5, 0, 0))
# #
# # bp <- boxplot(time ~ expr, data=loaded, xlab="time [s]", ylab="",
# #               ylim=NULL, horizontal=T, main="microbenchmark timings",
# #               yaxt = "n")
# # tick <- seq_along(bp$names)
# # axis(1, at = tick, labels = FALSE)
# # text(par("usr")[1] - 1.4, tick, bp$names, srt = 0, xpd = TRUE)
#
# # VERTICAL
# par(mar = def_mar + c(3.8, 0, 0, 0))
#
# bp <- boxplot(time ~ expr, data=loaded, ylab="time [s]", xlab="",
#               ylim=NULL, horizontal=F, main="microbenchmark timings",
#               xaxt = "n")
# tick <- seq_along(bp$names)
# axis(1, at = tick, labels = FALSE)
# text(tick, par("usr")[1] - 170, bp$names, srt = 60, xpd = TRUE)
#
#
# #####
library(microbenchmark)

unit <- "s"
loaded_list <- list()
summary_list <- list()

for (i in 1:4) {
  loaded <- read.csv(paste0("benchmark_0", i, ".csv"))
  class(loaded) <- c("microbenchmark", class(loaded))
  loaded$expr <- factor(
    loaded$expr,
    levels = c(
      "naive.not.pruned",
      "naive.pruned",
      # "naive.pruned.no.gaps",
      "fast.not.pruned",
      "fast.pruned"
      # "fast.pruned.no.gaps"
    )
  )
  loaded$time <- microbenchmark:::convert_to_unit(loaded, unit)
  loaded_list[[i]] <- loaded
  summary_list[[i]] <- summary(loaded)
}

##
def_mar <- c(5, 4, 4, 2) + 0.1

shift_fig <- c(1.9, 1.8, 120, 170)
shift_fig <- rep(0, 4)

par(mfrow = c(2, 2))

for (i in 1:4) {
  par(mar = def_mar + c(3.8, 0, 0, 0))
  
  bp <- boxplot(
    time ~ expr,
    data = loaded_list[[i]],
    ylab = "log seconds",
    xlab = "method",
    ylim = NULL,
    horizontal = F,
    main = paste0("Comp. time, scenario ", i),
    xaxt = "n",
    log = "y"
  )
  tick <- seq_along(bp$names)
  axis(1, at = tick, labels = FALSE)
  text(tick,
       par("usr")[1] - shift_fig[i],
       bp$names,
       srt = 60,
       xpd = TRUE)
}
