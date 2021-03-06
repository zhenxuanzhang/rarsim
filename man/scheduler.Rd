% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/1-scheduler-class.R, R/2-scheduler-methods.R,
%   R/3-scheduler-viz.R, R/4-sampler.R
\docType{class}
\name{scheduler}
\alias{scheduler}
\alias{scheduler-class}
\alias{show,scheduler-method}
\alias{getAllocation}
\alias{getHistory}
\alias{getEntropy}
\alias{scheduler.start}
\alias{scheduler.update}
\alias{plotPrior}
\alias{plotPosterior}
\alias{plotHistory}
\alias{plotAllocation}
\alias{sampler.thompson}
\alias{sampler.fixed}
\alias{sampler.auc.cutoff}
\alias{sampler.auc.reference}
\alias{sampler.ucb1}
\alias{sampler.ucb1.normal}
\alias{sampler.epsilon.greedy}
\title{S4 Scheduler Class Object}
\usage{
\S4method{show}{scheduler}(object)

getAllocation(object)

getHistory(object)

getEntropy(scheduler)

scheduler.start(
  prior.mean,
  prior.var,
  N.burn.in,
  sampler = "sampler.thompson",
  heuristic = FALSE,
  prior.nu,
  prior.alpha,
  prior.beta,
  ...
)

scheduler.update(scheduler, data.ingest, N.allocate)

plotPrior(scheduler)

plotPosterior(scheduler)

plotHistory(scheduler)

plotAllocation(scheduler)

sampler.thompson(scheduler, ...)

sampler.fixed(scheduler, ...)

sampler.auc.cutoff(scheduler, cutoff = 0, ...)

sampler.auc.reference(scheduler, reference = NULL, ...)

sampler.ucb1(scheduler, c = 2, batch = TRUE, ...)

sampler.ucb1.normal(scheduler, c = 16, batch = TRUE, ...)

sampler.epsilon.greedy(scheduler, epsilon = 0.1, ...)
}
\arguments{
\item{object, scheduler}{A \code{scheduler} object.}

\item{prior.mean}{A vector of prior means. One mean for each arm}

\item{prior.var}{A vector of prior variances. One variance for each arm.}

\item{N.burn.in}{An integer. The number patients to allocate each arm
during the initial 'burn-in' phase. Ideally, around 20-30 per arm.}

\item{sampler}{A string. The sampling method used to allocate patients.}

\item{heuristic}{A logical. Toggles whether to assume precision is known,
but instead estimate it from the data. When taking this approach,
the conjugate prior distribution is normal.}

\item{prior.nu, prior.alpha, prior.beta}{The prior statistics for each arm.
These apply when the conjugate prior distribution is normal-gamma
(i.e., when \code{heuristic = TRUE}).}

\item{...}{Arguments passed to \code{sampler} function.
For the \code{sampler} itself, a null argument.}

\item{data.ingest}{A list of rewards. Must match the structure of \code{scheduler@ingest}.}

\item{N.allocate}{An integer. The total number of patients to allocate next.}

\item{cutoff}{The cutoff used for \code{sampler.auc.cutoff}.
Allocation is proportional to area under the posterior greater than this cutoff.}

\item{reference}{The reference used for \code{sampler.auc.reference}.
Allocation is proportional to area under the posterior greater than
the posterior mean of this reference.}

\item{c}{The exploration hyper-parameter used by several UCB algorithms.}

\item{batch}{Toggles whether the UCB algorithm should allocate patients
to groups randomly based on the rank of the UCB score.}

\item{epsilon}{The epsilon used for \code{sampler.epsilon.greedy}.
Allocation is to a random group \code{epsilon} percent of the time;
otherwise, it is to the group with the largest posterior mean.}
}
\description{
S4 Scheduler Class Object
}
\section{Slots}{

\describe{
\item{\code{prior.df}}{The degrees-of-freedom for the t-distribution that describes the
uncertainty about the mean. Set to Inf when \code{heuristic = TRUE}.}

\item{\code{prior.mean}}{The prior statistics for each arm.}

\item{\code{prior.var}}{The uncertainty about the mean. When the
conjugate prior distribution is normal-gamma, this slot contains the
variance of the marginal distribution of the mean.}

\item{\code{prior.nu,prior.alpha,prior.beta}}{The prior statistics for each arm.
These apply when the conjugate prior distribution is normal-gamma.}

\item{\code{N.burn.in}}{An integer. The number of patients in each arm at first time step.}

\item{\code{K.arms}}{An integer. The number of experimental groups (also called 'arms').}

\item{\code{step}}{An integer. The number of time steps so far. Each time step is a
kind of 'mini-trial'. This initializes at 0.}

\item{\code{rewards}}{A list of all rewards observed to date.}

\item{\code{meta}}{A list of tables for all rewards and meta-data available.
This is optional, but may be preferred for complex simulations.}

\item{\code{online.count,online.sum,online.mean,online.var,online.prec}}{The empiric statistics observed to date.}

\item{\code{heuristic}}{A logical. Toggles whether to assume precision is known,
but instead estimate it from the data. When taking this approach,
the conjugate prior distribution is normal.}

\item{\code{post.df}}{The degrees-of-freedom for the t-distribution that describes the
uncertainty about the mean. Set to Inf when \code{heuristic = TRUE}.}

\item{\code{post.mean}}{The posterior statistics for each arm.}

\item{\code{post.var}}{The uncertainty about the mean. When the
conjugate prior distribution is normal-gamma, this slot contains the
variance of the marginal distribution of the mean.}

\item{\code{post.nu,post.alpha,post.beta}}{The posterior statistics for each arm.
These apply when the conjugate prior distribution is normal-gamma.}

\item{\code{sampler.args}}{A list. Arguments for the sampling method.}

\item{\code{sampler}}{A string. The sampling method used to allocate patients.}

\item{\code{dynamic.count}}{Like \code{@online.count}, but used by the UCB algorithm.}

\item{\code{allocation}}{A vector of groups to which to allocate new patients.}

\item{\code{ingest}}{A list describing the structure of the data expected
by the next \code{scheduler.update} call. This slot is only
used to verify the incoming data.}

\item{\code{allocation}}{The most recent patient allocations. This slot
implies the structure of the \code{@ingest} slot.}

\item{\code{history.post}}{A table of all posterior statistics and the allocation
ratios at each time step in the experiment. At \code{@step = 0},
the table records the prior statistics and burn-in conditions.}

\item{\code{history}}{A list of lists of all rewards. Unlike \code{@rewards},
the rewards here are organized by time step.}
}}

\section{Methods}{

\code{show:} Method to show \code{scheduler} object.
}

\section{Getters}{

\code{getAllocation:} Method to retrieve allocations from a \code{scheduler} object.
 This function returns a vector of groups to which to allocate new patients.


\code{getHistory:} Method to retrieve history from a \code{scheduler} object.
 This function returns a table of all posterior statistics and the allocation
 ratios at each time step in the experiment.


\code{getEntropy:} Method to retrieve allocation entropy from a
 \code{scheduler} object. This function returns the entropy of
 the allocation ratios at each time step.
}

\section{Setters}{

\code{scheduler.start:} Method to initiate a \code{scheduler} object.
 This function returns an updated \code{scheduler} object.


\code{scheduler.start:} Method to update a \code{scheduler} object with new data.
 This function returns an updated \code{scheduler} object.
}

\section{Plotters}{

\code{plotPrior:} Method to plot prior distributions.


\code{plotPosterior:} Method to plot the most recent posterior distributions.


\code{plotHistory:} Method to plot all posterior distributions.


\code{plotAllocation:} Method to plot the allocation ratios for each time step.
}

\section{Samplers}{

\code{sampler.thompson:} Method to allocate patients by Thompson sampling.
 This function returns an integer corresponding to the group
 to which the patient is randomly allocated.


\code{sampler.fixed:} Method to allocate patients at a fixed ratio.
 This function returns an integer corresponding to the group
 to which the patient is randomly allocated.


\code{sampler.auc.cutoff:} Method to allocate patients proportional to the
 probability that the posterior expected reward is greater than a cutoff.
 This function returns an integer corresponding to the group
 to which the patient is randomly allocated.


\code{sampler.auc.reference:} Method to allocate patients proportional to the
 probability that the posterior expected reward is greater than a reference.
 This function returns an integer corresponding to the group
 to which the patient is randomly allocated.


\code{sampler.ucb1:} Method to allocate patients based on a UCB algorithm,
 assuming that the rewards fall within the range of 0 and 1.
 This function returns an integer corresponding to the group
 to which the patient is randomly allocated.


\code{sampler.ucb1.normal:} Method to allocate patients based on a UCB algorithm,
 assuming that the rewards are normally distributed.
 This function returns an integer corresponding to the group
 to which the patient is randomly allocated.


\code{sampler.epsilon.greedy:} Method to allocate patients based on
 an epsilon-greedy algorithm. By default, \code{epsilon = 0.1}.
 This function returns an integer corresponding to the group
 to which the patient is randomly allocated.
}

