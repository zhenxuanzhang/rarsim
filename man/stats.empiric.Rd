% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/8-stats.R
\name{stats.empiric}
\alias{stats.empiric}
\title{Perform a Statistical Analysis}
\usage{
stats.empiric(
  scheduler,
  reference = NULL,
  how.diverge = diverge.kl.sym,
  how.permute = permute.from.all,
  p = 1000,
  ...
)
}
\arguments{
\item{scheduler}{A \code{scheduler} object.}

\item{reference}{An integer. The list element with control rewards.}

\item{how.diverge}{A \code{diverge} method.}

\item{how.permute}{A \code{permute} method.}

\item{p}{An integer. The number of permutations.}

\item{...}{Null argument.}
}
\value{
A vector of adjusted p-values.
}
\description{
Note that all p-values implicitly describe a two-tailed test
 because divergence has no sign.
}
