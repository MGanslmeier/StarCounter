# Star Counter: a simple way to create an overview of your Stata outreg2 results

The probably best tool to run a bunch of regressions is Stata. Stata enables you to "outreg" multiple coefficient tables in a standard format. Although running the regressions is quite easy, getting an overview about the robustness of the results is more time-consuming -- especially when the number of regression tables is very large. The script should facilitate this "inspection" process by combining the significance of the coefficients in an overview table.

	source('src/StarCounter.R')
	path <- 'PATH/TO/STATA/OUTREG/DIRECTORY'
	results <- StarCounter(path = path)

When you let the function run over your "outreg" directory, please make sure that all your files include the "Observations" and "VARIABLES" row.