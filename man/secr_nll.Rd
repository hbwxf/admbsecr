% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{secr_nll}
\alias{secr_nll}
\title{Evaluating the likelihood using C++}
\usage{
secr_nll(link_pars, dat, get_esa)
}
\arguments{
\item{link_pars}{Parameter values on link scale.}

\item{dat}{Data list.}

\item{get_esa}{Logical. If \code{TRUE} the effective sampling area is returned,
otherwise the negative log-likelihood is returned.}
}
\value{
The value of the negative log-likelihood.
}
\description{
Returns the likelihood for a vector of parameter values.
}

