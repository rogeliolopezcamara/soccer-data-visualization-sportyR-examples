# Load required libraries
library(sportyR)
library(ggplot2)
library(dplyr)
library(StatsBombR) # Library used to fetch StatsBomb data

############ Getting the data ###################

# Fetch list of all available free competitions from StatsBomb
competitions <- FreeCompetitions()

# Filter to select the UEFA Champions League competition (competition_id = 16)
data <- competitions |> filter(competition_id == 16)

# Fetch matches for the selected competition
matches <- FreeMatches(data)

# Optionally view the matches to choose one for analysis
# View(matches)

# Filter to select a specific match by its ID (match_id = 18236 for a Champions League match)
match_id <- matches |> filter(match_id == 18236)

# Get event data for the selected match
event_data <- get.matchFree(match_id)

# Transform coordinates in the data: separate location into 'location_x' and 'location_y'
event_data['location_x'] <- unlist(event_data$location |> sapply(function(x) { if (is.null(x)) { NA } else { x[1] } }))
event_data['location_y'] <- unlist(event_data$location |> sapply(function(x) { if (is.null(x)) { NA } else { x[2] } }))

################## Example 1: Scatter Plot for Lineups #####################

# Filter data to get the starting lineup information
starting <- event_data |> filter(type.name == 'Starting XI')

# Extract the lineup for a specific team (e.g., Barcelona)
lineup_barcelona <- starting$tactics.lineup[[1]]

# Manually set coordinates and player short names for the lineup plot
x_coords <- c(6, 30, 23, 23, 30, 60, 70, 70, 95, 95, 105)
y_coords <- c(40, 10, 30, 50, 70, 40, 30, 50, 20, 60, 40)
shortname <- c("V.Valdés", "D. Silva", "J. Mascherano", "G. Piqué", "E. Abidal", "S. Busquets", "X. Hernández", "A. Iniesta", "L. Messi", "P. Rodríguez", "D. Villa")

# Add these coordinates and short names as columns to the lineup data
lineup_barcelona['x_coords'] <- x_coords
lineup_barcelona['y_coords'] <- y_coords
lineup_barcelona['s_names'] <- shortname

# Plot the soccer field with the lineup positions as red points and labels for each player
geom_soccer(
  "fifa",
  pitch_updates = list(
    pitch_length = 120,
    pitch_width = 80
  ),
  color_updates = list(
    offensive_half_pitch = '#09AB50',
    defensive_half_pitch = '#09AB50',
    pitch_apron = '#09AB50'
  ),
  x_trans = 60,
  y_trans = 40
) +
  geom_point(data = lineup_barcelona, aes(x = x_coords, y = y_coords), color = 'red', size = 4) +
  geom_text(data = lineup_barcelona, aes(x = x_coords, y = y_coords, label = s_names), hjust = 0, vjust = -1)

################## Example 2: Density Plot for Passes #####################

# Filter event data to get only passing events
passes <- event_data |> filter(type.name == "Pass")

# Plot density of passes on the soccer field
geom_soccer(
  "fifa",
  pitch_updates = list(
    pitch_length = 120,
    pitch_width = 80
  ),
  color_updates = list(
    offensive_half_pitch = '#09AB50',
    defensive_half_pitch = '#09AB50',
    pitch_apron = '#09AB50'
  ),
  x_trans = 60,
  y_trans = 40
) +
  stat_density_2d(data = passes, geom = "raster", aes(x = location_x, y = location_y, fill = after_stat(density), alpha = after_stat(density)), contour = FALSE) +
  scale_fill_viridis_c(option = "A") +
  theme(legend.position = "none")

################## Example 3: Tracking Shots with Arrows #####################

# Filter event data to get only shots
shots <- event_data |> filter(type.name == 'Shot')

# Transform shot end locations into separate columns
shots['end_location_x'] <- unlist(shots$shot.end_location |> sapply(function(x) { if (is.null(x)) { NA } else { x[1] } }))
shots['end_location_y'] <- unlist(shots$shot.end_location |> sapply(function(x) { if (is.null(x)) { NA } else { x[2] } }))

# Plot the soccer field with arrows indicating shot paths
geom_soccer(
  "fifa",
  pitch_updates = list(
    pitch_length = 120,
    pitch_width = 80
  ),
  color_updates = list(
    offensive_half_pitch = '#09AB50',
    defensive_half_pitch = '#09AB50',
    pitch_apron = '#09AB50'
  ),
  x_trans = 60,
  y_trans = 40,
  display_range = "offensive_half_pitch"
) +
  geom_segment(data = shots, aes(x = location_x, y = location_y, xend = end_location_x, yend = end_location_y), arrow = arrow(length = unit(0.3, "cm"))) +
  geom_point(data = shots, aes(x = location_x, y = location_y), colour = 'red') +
  geom_point(data = shots, aes(x = end_location_x, y = end_location_y), colour = 'blue')