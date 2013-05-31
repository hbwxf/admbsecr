## To read in simulation results from a file.
admbsecr.dir <- "~/admbsecr" ## Point this to admbsecr folder.
resfile <- paste(admbsecr.dir, "Results/thresh/2/", sep = "/")
setwd(resfile)
files <- list.files(resfile)
resmats <- list()
resnames <- NULL
j <- 1
## Reading in result matrices.
for (i in files){
  split <- strsplit(i, "\\.")
  name <- split[[1]][1]
  ext <- split[[1]][2]
  if (ext == "txt"){
    assign(name, read.table(i, header = TRUE))
    resnames <- c(resnames, name)
    resmats[[j]] <- get(name)
    j <- j + 1
  }
}
source("pars.r")

## Setting up vectors with estimated D and density objects.
## Everything done in square meters (so densities divided by 10000).
D <- D/10000
xs <- NULL
ys <- NULL
modnames <- NULL
namesD <- NULL
dnames <- NULL
for (i in resnames){
  modname <- substr(i, 1, nchar(i) - 3)
  modnames <- c(modnames, modname)
  name <- paste(modname, "D", sep = "")
  namesD <- c(namesD, name)
  se.name <- paste("se", modname, sep = ".")
  dname <- paste("d", name, sep = "")
  dnames <- c(dnames, dname)
  assign(name, get(i)$D[get(i)$maxgrad > -1 & !is.na(get(i)$D)]/10000)
  assign(dname, density(get(name)))
  assign(se.name, get(i)$se.D[get(i)$maxgrad > -1 & !is.na(get(i)$D)]/10000)
  xs <- c(xs, get(dname)$x)
  ys <- c(ys, get(dname)$y)
}

## Plotting densities.
##pdf(file = paste(resfile, "fig", sep = ""))
plot.new()
plot.window(xlim = range(xs), ylim = c(0, max(ys)))
axis(1)
axis(2, las = 1)
abline(v = D, lty = "dotted")
j <- 1
for (i in dnames){
  lines(get(i), col = j)
  j <- j + 1
}
box()
title(main = "Simulated sampling distributions of animal density",
      xlab = expression(hat(D)), ylab = "Density")
legend(x = "topright", legend = modnames, col = 1:length(modnames), lty = 1)
##dev.off()

## Calculating bias, variance, and mse.
mses <- NULL
for (i in 1:length(modnames)){
  assign(paste(modnames[i], ".bias", sep = ""), mean(get(namesD[i])) - D)
  assign(paste(modnames[i], ".var", sep = ""), var(get(namesD[i])))
  mses <- c(mses, get(paste(modnames[i], ".bias", sep = ""))^2
            + get(paste(modnames[i], ".var", sep = "")))
}
names(mses) <- modnames
sort(mses)

## Calculating CI coverage.
in.ci <- function(ci, par) ci[1] <= par & ci[2] >= par
cov <- NULL
for (i in 1:length(modnames)){
  ds <- get(namesD[i])
  ses <- get(paste("se", modnames[i], sep = "."))
  cis <- matrix(0, nrow = length(ds), ncol = 2)
  cis[, 1] <- ds - 1.96*ses
  cis[, 2] <- ds + 1.96*ses
  cov <- c(cov, mean(apply(cis, 1, in.ci, par = D)))
}
names(cov) <- modnames
sort(cov, decreasing = TRUE)

for (i in namesD){
  print(c(i, length(get(i))))
}

