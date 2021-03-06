
<!-- README.md is generated from README.Rmd. Please edit that file -->
Quick start
===========

Welcome to the `rarsim` GitHub page! Let's get started.

``` r
library(devtools)
devtools::install_github("tpq/rarsim")
library(rarsim)
```

Response-adaptive randomization (RAR) is a novel approach to experimental design that has the potential to reduce the cost of expensive clinical trials. However, it may be susceptible to inflated Type 1 or Type 2 errors. Simulations can help ensure that the trial design will not introduce spurious results. The rarsim package is designed to make it easier to run simulations for RAR experiments.

To use this package, you must consider two things. First, how do you want to simulate your data? Second, how do you want to schedule your trial?

Simulate the data
-----------------

By convention, this package uses a list of length *K* to represent the *K* arms of the experiment. Each element in the list is a vector of the *N*<sub>*k*</sub> rewards associated with that group. This structure is used for both the `simulator` and the `scheduler` objects. Below, we make a data pool that has 4 groups with 1000 patients in each group.

``` r
set.seed(3220)
pool <- list(
  rpois(1000, 10),
  rpois(1000, 20),
  rpois(1000, 10),
  rpois(1000, 5)
)
```

It is easy to create a `simulator` object from any data pool.

``` r
simulator <- simulator.start(pool = pool)
#> Alert: Use simulator.draw() to draw patients.
```

Alternatively, we make a `simulator` object in one step.

``` r
simulator <- simulator.start.from.unif(mins = c(1, 1, 1, 1), maxes = c(7, 7, 6, 6))
#> Alert: Use simulator.draw() to draw patients.
```

Schedule a trial
----------------

There are a few trial parameters that you must set. This includes the number of patients in each group at the start of the trial during the "burn-in" phase, the number of patients to allocate at each subsequent step in the trial, the total number of steps, the prior means and prior variances, and the sampling method used for response-adaptive allocation.

``` r
N.burn.in = 20
N.allocate = 15
N.trials = 10
K.arm = 4
prior.means = rep(4, K.arm)
prior.vars = rep(1, K.arm)
sampler = sampler.thompson
```

Now we can make the `scheduler object`.

``` r
scheduler <- scheduler.start(prior.means, prior.vars, N.burn.in = N.burn.in, sampler = sampler)
```

A trial is run for `N.trials` steps. In each step, the `scheduler` requests the patient allocations to the `simulator`, and the `simulator` returns the observed rewards for the simulated patients. In pratice, the "rewards"" are generated from an experiment.

``` r
for(trial in 1:N.trials){
  
  request <- getAllocation(scheduler)
  simulator <- simulator.draw(simulator, request)
  rewards <- getDraw(simulator)
  scheduler <- scheduler.update(scheduler, rewards, N.allocate = N.allocate)
}
```

This iterative procedure is wrapped by the `run.trial` function.

``` r
scheduler <- scheduler.start(prior.means, prior.vars, N.burn.in = N.burn.in, sampler = sampler)
simulator <- simulator.start.from.unif(mins = c(1, 1, 1, 1), maxes = c(7, 7, 6, 6))
#> Alert: Use simulator.draw() to draw patients.
scheduler <- run.trial(scheduler, simulator, N.trials = N.trials, N.allocate = N.allocate)
```

Visualization
-------------

We can see how the posterior mean and allocation ratio changes at each step.

``` r
plotAllocation(scheduler)
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" />

We can also visualize how the posterior changes with more data.

``` r
plotHistory(scheduler)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

Known issues
------------

Some known issues include:

-   Expect an error if a `simulator` group pool becomes empty
-   Currently no way to incorporate meta-data

Future work
-----------

Future work will include:

-   Some methods for computing exact p-values from a `scheduler` object
-   Wrappers to estimate Type I and Type II error
