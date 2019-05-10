# toy example for auditory pRF

Assumes population reponds to 1 specific location and to 1 frequency this basically assumes that the gaussian of pRF is either 0 or so small that stimulations at other location do not affect a given neuronal population.

In this example we have 4 locations and only 2 frequencies but this can be adapted.

All of this simplifies things as this way we only have 8 model pRF to compute.

Also the stimulus presented at each location has a different frequency 'content' (this content can be changed).

The script assumes that all the time series are generated with a 1 hz temporal resolution. And we use spm default HRF with TR = 1 second.

## TO DO
- [ ] implement population that respond differently to more than one frequency
- [ ] implment gaussian
