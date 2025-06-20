% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_region.R
\name{get_region}
\alias{get_region}
\title{Get and prepare region}
\usage{
get_region(
  region = NULL,
  buffer = NULL,
  reclabs = NULL,
  aggregate = FALSE,
  verbose = FALSE,
  overwrite = FALSE
)
}
\arguments{
\item{region}{SpatVector. Region selection object defined by extent coordinates, a polygon object or path to dataset, an island, archipelago, country, mountain or plate name from the regions-list. If region is not defined a selection window will pop-up to define the area of interest.}

\item{buffer}{numeric. Draws a buffer around the selected region. For extent, the buffer is 0, otherwise 10000 m.}

\item{reclabs}{character. Dataset or column used for labeling biogeographic shapes. By default the island labeling dataset is used, while if reclabs is set to ‘mnts’ the mountain labeling is used. Otherwise another column from the region object could be used, or a feature from the geonames feature list (e.g., ‘peaks’, ‘peak’) could be specified. Note that any overlapping name from the list geonames features cannot be used. If so, it is recommended to rename your labeling column. Note that in case of a user-defined reclabs column, the concerned column will be replicated in the labs-object under the column name ‘name’.}

\item{aggregate}{boolean. Whether to aggregate biogeographic shapes.}

\item{verbose}{boolean. FALSE: No messages are printed. TRUE: Standard verbose mode. 2: Very verbose mode, displaying detailed information.}

\item{overwrite}{boolean. TRUE: overwrite region and select a new extent via selection window will pop-up.}
}
\value{
A SpatVector object with the labeling polygons for the specified extent coming from spatial object, extent or region name
}
\description{
Retrieve region of interest
}
\examples{

if(interactive()){
# interactive selection
r <- get_region()
# overwrite interactive selection
r <- get_region(overwrite=TRUE)
}

# sample dataset
labs <- sporades()$labs
# labels based on "name" column
r <- get_region(region=labs)
# labels based on specific column
r <- get_region(region=labs[,'plate'],reclabs='plate')
# automatic labeling 
r <- get_region(region=labs, reclabs = FALSE)
# aggregate shapes
r <- get_region(region=labs, aggregate=TRUE)
# define by extent 
library(terra)
e <- terra::ext(labs)
r <- get_region(region=e)
e <- as.vector(e)
r <- get_region(region=e)
# add buffer
r <- get_region(region=e,buffer=10000)
r <- get_region(region=e,buffer=100000)




}
\seealso{
\href{https://uva_ibed_piac.gitlab.io/tabs/articles/Ab-tabs-region.html}{region}
}
