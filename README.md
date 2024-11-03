Soccer Data Visualization with sportyR

Overview

The sportyR package is a tool designed to create visualizations of sports fields, and it’s especially useful for soccer analytics. This repository provides R scripts with examples of:

	•	Plotting soccer fields with sportyR
	•	Customizing field layouts, colors, and orientations
	•	Overlaying data such as player positions, passing density, and shot paths using ggplot2

Requirements

This repository requires the following R packages:

	•	sportyR - for field plotting
	•	ggplot2 - for data visualizations on the field
	•	dplyr - for data manipulation
	•	StatsBombR - for accessing soccer match data from StatsBomb

Installation

To install the required packages, run the following commands in your R environment:

install.packages("sportyR")
install.packages("ggplot2")
install.packages("dplyr")

For StatsBombR, you may need to install it from GitHub

install.packages("remotes")
remotes::install_github("statsbomb/StatsBombR")

Data Source

The data used in this repository is provided by StatsBomb. All rights and credits belong to StatsBomb. Please refer to their terms of use for any data-related queries.

Examples

This repository includes the following examples:

	1.	Scatter Plot for Lineups: Displays starting positions of players on a soccer field.
	2.	Density Plot for Passes: Uses stat_density_2d to create a density plot of passes.
	3.	Shot Path Tracking: Visualizes shot paths using geom_segment to show starting and ending points of shots.
