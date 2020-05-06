# fitCOVID19_BranchingProcess
The project contains Matlab script files for fitting the parameters of the Branching Process Simulator, available at https://github.com/plamentrayanov/BranchingProcessSimulator .
The project is oriented specifically towards modelling the COVID19 (SARS-CoV-2) epidemics. Some of the required parameters in the simulator are virus-specific, defined as hard-coded values from articles on the subject and observed data. Others are country-specific, for which an optimization procedure is implemented. The procedure aims at estimating the point process mass of the BP (i.e. R0(t), a.k.a R(t)) and the Immigration expectation as a smooth function over time. The procedure required subjectively chosen smoothing parameters that restrict the curvature of R0(t) and Im(t).

The project aims to:
1. Provide an epidemics projection based on the stochastic theory of Branching Processes, as an alternative to the classical SIR, SEIR and other deterministic models.
2. Provide the user with a starting point for testing different hypothesises and project their effect on the epidemics development. The users may provide their own forecasts for R0 and the immigration or use the scenarios defined in the script. As the BranchingProcessSimulator repository provides a much larger set of possible models, the user is encouraged to experiment with different models and assumptions.
3. Demonstrate the uses of Branching Processes to model epidemics.


# Included in the package
Fitted models for Germany, France, Italy, Sweden, Ukraine, Indonesia and Bulgaria are included. The code uses parallel computing and the more CPU cores you have, the more RAM you need. Make sure you have enough RAM to run the simulations on all cores! There are 3 scenarios for the future epidemics development for each country:
1. No change in R0 and Immigration. The value of R0 and Immigration from the last days is taken as a constant for the future development.
2. Decrease in R0 and Immigration, which is more optimistic scenario from what we are currently experiencing.
3. Increase in R0 and no change in Immigration, which is more pessimistic scenario from what we are currently experiencing.

These scenarios produce projections about what will happen if the assumptions on R0 and Immigration are correct. To produce a forecast, you need to forecast the R0 and Immigration. 

The scripts download the latest data automatically from https://www.worldometers.info/coronavirus/ !  You may also use data from https://opendata.ecdc.europa.eu/covid19/casedistribution/csv but you will have to manually download it and the data is more noisy/incorrect.

To run the example model for a country, go to the corresponding directory for that country and run the script. The figures are then saved in ./Figures/ .

The ./lib directory contains common functions used by all scripts inside the subdirectories.

The latest Branching Process Simulator is available at https://github.com/plamentrayanov/BranchingProcessSimulator 
