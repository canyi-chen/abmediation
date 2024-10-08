\dontrun{
  ## Load libraries
  library(abmediation)

  if (require(future.apply)) {
    library(future.apply)
    plan(multisession, workers = 4)
  } else {
    future_replicate <- replicate
  }


  ## Set up parameters
  M.family <- gaussian()
  Y.family <- gaussian()

  simulation <- function(alpha_S = 0, beta_M = 0) {
    data <- generate_all_data(
      n = 500,
      alpha_S = alpha_S,
      beta_M = beta_M,
      M.family = M.family,
      Y.family = Y.family
    )
    S <- data$S
    M <- data$M
    Y <- data$Y
    X <- data$X

    out <- ab.mediation(
      S,
      M,
      Y,
      X,
      M.family = M.family,
      Y.family = Y.family,
      lambda = 2,
      B = 199
    )
    out
  }

  set.seed(2)
  simulation(1 / 8, 1 / 8)


  ## Empirical distribution of the p value
  # the number of replication for approximating the distribution of the p value
  Nreps <- 200
  alpha_S <- beta_M <- 0
  output <- future_replicate(Nreps, simulation(0, 0))


  plot(
    seq(0, 1, 0.01),
    quantile(unlist(output[2, ]), probs = seq(0, 1, 0.01)),
    pch = 1,
    cex = 1.2,
    cex.lab = 1.3,
    cex.axis = 1.3,
    ylab = "Sample Quantiles",
    xlab = "Theoretical Quantiles",
    type = "p",
    xlim = c(0, 1),
    ylim = c(0, 1),
    lwd = 1.2
  )
  abline(0, 1, col = "orange")

}



