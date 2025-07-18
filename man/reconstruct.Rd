% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reconstruct.R
\name{reconstruct}
\alias{reconstruct}
\title{Reconstruct present- and paleoconfigurations for biogeographic systems}
\usage{
reconstruct(
  x = NULL,
  region = NULL,
  topo = NULL,
  curve = NULL,
  correction = NULL,
  iso = 0,
  reclabs = NULL,
  buffer = NULL,
  aggregate = FALSE,
  units = list(topo = "m", curve = c(names = "yr", value = "m"), correction = "mm/yr"),
  fact = 0,
  noise = 5,
  noiserm = TRUE,
  fillholes = TRUE,
  filename = NULL,
  overwrite = FALSE,
  metrics = c("area"),
  verbose = FALSE
)
}
\arguments{
\item{x}{get_data-object. Prepared object including standardized input datasets (region, topo, curve, correction) with get_data() (optional)}

\item{region}{SpatVector. Region selection object defined by extent coordinates, a polygon object or path to dataset, an island, archipelago, country, mountain or plate name from the regions-list. If region is not defined a selection window will pop-up to define the area of interest.}

\item{topo}{SpatRaster. Topographic/Bathymetric model as SpatRaster or path to dataset. The topo projection is the reference for further outputs.}

\item{curve}{SpatRaster. Curve value, vector, grid or list of grids indicating the relative altitude of a biogeographic system per time period compared to the present. A typical example is a sea level curve indicating the relative sea level position above or below sea level compared to the present.}

\item{correction}{SpatRaster. Correction value, vector, grid, or list of grids to account for spatial-(non-)explicit and temporal (non-)linear changes in the topography (e.g., uplift and subsidence rates, sedimentation and erosion ticknesses)}

\item{iso}{numeric. Vector or list indicating the elevation range of the biogeographic system to reconstruct. By default 0 (coastlines). If provided as a list, the boundary definition of the range can be defined (options are '>' and '>='). By default, the elevation range definition includes the indicated lower bound value (i.e., list(0, '>=')).}

\item{reclabs}{character. Dataset or column used for labeling biogeographic shapes. By default the island labeling dataset is used, while if reclabs is set to ‘mnts’ the mountain labeling is used. Otherwise another column from the region object could be used, or a feature from the geonames feature list (e.g., ‘peaks’, ‘peak’) could be specified. Note that any overlapping name from the list geonames features cannot be used. If so, it is recommended to rename your labeling column. Note that in case of a user-defined reclabs column, the concerned column will be replicated in the labs-object under the column name ‘name’.}

\item{buffer}{numeric. Draws a buffer around the selected region. For extent, the buffer is 0, otherwise 10000 m.}

\item{aggregate}{boolean. Whether to aggregate biogeographic shapes.}

\item{units}{numeric. Units of topo, curve and correction provided as a list (default: units=list(topo='m', curve=c(names='yr', value='m'), correction='mm/yr'))}

\item{fact}{numeric. Resolution factor, increasing the factor will half the resolution.}

\item{noise}{numeric. Maximum number of unlabeled clumped topo pixels considered as noise. Note that clumps of pixels are only considered as noise when their highest points do not intersect with a reference polygon.}

\item{noiserm}{boolean. Whether noise should be removed.}

\item{fillholes}{boolean. fill the holes in polygons, independent from noise (e.g. lakes)}

\item{filename}{character. Path where files will be exported. Default as directory tree. Use .qs2, .rds, .zip to save as qs2, rds or zipped directory tree.}

\item{overwrite}{boolean. Whether to overwrite the output when filename is specified.}

\item{metrics}{character. metrics to calculate for each biogeographic shape, currently only area is implemented.}

\item{verbose}{boolean. FALSE: No messages are printed. TRUE: Standard verbose mode, providing progress bar. 2: Very verbose mode, displaying detailed information.}
}
\value{
object of class tabs including a list of input (topo, labs, curve, correction) and output (recvect, recrast, recarea) datasets
}
\description{
reconstruct paleo or present day landscape using a bathymetric model, island labeling dataset and a seacurve
}
\details{
================================================================================== \cr
INPUT \cr
==================================================================================

input dataset may be topo, curve, correction (optional) and a labs dataset:

\describe{
  \item{\strong{TOPO}}{
    Topographic and/or bathymetric raster used to identify biogeographic shapes for the extent of the selected region.
  }
  \item{\strong{CURVE}}{
    The relative altitude of a biogeographic system per time period compared to the present expressed as a numeric vector (e.g., Lambeck, Cutler, Funza) or raster (e.g., st_curve). In the case of st_curve, the curve is returned for the extent of the selected region and resampled to the resolution of the topo dataset. If the curve is not defined, 0 is returned and a reconstruction is made for the present-day sea level.
  }
  \item{\strong{CORRECTION}}{
    Correction numeric vector or raster harmonized with the curve and resampled to the resolution of the topo dataset. If the input correction raster or numeric vector is defined as a rate (i.e., a single value, a single raster; thus, assuming temporal linear changes in topography), a correction variable (raster/numeric vector) is returned with the same length as the curve, expressing the cumulative topographic change over time. If the correction parameter is not defined, 0 is returned.
  }
  \item{\strong{LABS}}{
    Labeling dataset that is used for naming biogeographic shapes for the extent of the selected region.
  }
}

Returned variables: 

\describe{
  \item{unique_id}{\code{integer}: Unique identifier of a biogeographic shape in the labeling dataset.}
  \item{name}{\code{character}: Name of the biogeographic shape in the labeling dataset. By default this will be derived from the Global Shoreline Vector (GSV; Sayre et al. 2019), or from the mountain inventory v2 (GMBA; Snethlage et al. 2022), when reclabs is set to ‘mnts’. Otherwise, if a custom polygon reference and labeling dataset is used, the name-column will store the content of a by the user specified column. NOTE: If the labeling column is specified by the user, that one will be stored as a duplicate in the labs output under its original name.}
  \item{uniquename}{\code{character}: Concatenated name and unique identifier.}
  \item{refx}{\code{numeric}: X-coordinate (SRID=4326) of the highest point of a biogeographic shape in the labeling dataset. If the labeling dataset are points, the x-coordinate of the point is given.}
  \item{refy}{\code{numeric}: Y-coordinate (SRID=4326) of the highest point of a biogeographic shape in the labeling dataset. If the labeling dataset are points, the y-coordinate of the point is given.}
  \item{refz}{\code{numeric}: Meter above/below present sea level of the highest point within a biogeographic shape extracted through intersection with topo. If the labeling dataset are points, the z of the point is given.}
  \item{refn}{\code{integer}: Number of cells at the resolution of the topo within a biogeographic shape in the labeling dataset. If the labeling dataset are points, the number of cells will equal 1.}
}

Depending from the used labeling dataset (GSV, GMDA, GeoNames) additional other columns are returned.

================================================================================== \cr
OUTPUT \cr
==================================================================================

\describe{
  \item{\strong{RECAREA}}{
    Table expressing the area in square meters for each biogeographic shape per time period.
  }
  \item{\strong{RECRAST}}{
    Raster expressing the reconstruction of a biogeographic region per time period within the extent of the selected region.
  }
  \item{\strong{RECVECT}}{
    Spatial vector expressing the reconstruction per time period, identifying each polygon as a different biogeographic shape. The vector layers include a range of default attributes per biogeographic shape.
    \cr\strong{NOTE:} In case \code{reclabs=FALSE}, biogeographic shapes are merged into a single multipolygon, and all attributes in the vector layers are expressed for the whole region.
  }
}
Returned variables: 

\describe{
  \item{iso}{\code{numeric}: Meter above or below the curve value (e.g., sea level position) defining the lower bound of the range of a biogeographic system}
  \item{period}{\code{character}: Lower bound of a time period expressed in years before/after present for a reconstruction at a specific curve value (e.g., sea level position).}
  \item{curve}{\code{numeric}: Curve value (e.g., sea level position) for that period. In case of a raster (e.g., st_curve; spatial-explicit curve) the average curve value is calculated within the region.}
  \item{unique_id}{\code{integer}: Unique identifier of a biogeographic shape for a time period.}
  \item{area}{\code{numeric}: Size of a biogeographic shape in square meters.}
  \item{n}{\code{integer}: Number of cells at the resolution of the topo within a biogeographic shape; will change if the fact parameter is modified.}
  \item{x}{\code{numeric}: X-coordinate in degrees (SRID=4326) of the highest point within a biogeographic shape extracted through intersection with topo. If the highest point could not be extracted, the centroid of the biogeographic shape is used.}
  \item{y}{\code{numeric}: Y-coordinate in degrees (SRID=4326) of the highest point within a biogeographic shape extracted through intersection with topo. If the highest point could not be extracted, the centroid of the biogeographic shape is used.}
  \item{z}{\code{numeric}: Meter above/below present sea level of the highest point within a biogeographic shape extracted through intersection with topo. If the highest point could not be extracted, the centroid of the biogeographic shape is used.}
  \item{recid}{\code{character}: Reconstructed ID, when biogeographic shapes merge over time it is named after the shape with the highest point. The ID is unique across islands with identical names.}
  \item{recname}{\code{character}: Reconstructed name, when biogeographic shapes merge over time it is named after the shape with the highest point. It can have the following formats:
  \describe{
    \item{\code{S-<PERIOD>-<ID>}}{
      \describe{
        \item{\code{S}}{biogeographic shape identified in topo but not in labeling dataset; or drowned biogeographic shapes that were disconnected from a present-day existing biogeographic shape}
        \item{\code{PERIOD}}{The most recent period the biogeographic shape emerged.}
        \item{\code{ID}}{Identifier.}
      }
    }
    \item{\code{UNKNOWN}}{The name of the biogeographic shape is intersecting with the labeling dataset but unknown (only for the Global Shoreline Vector - i.e. island labeling dataset).}
    \item{\code{UNNAMED}}{The name of the biogeographic shape is intersecting with the labeling dataset but unnamed (only for the Global Shoreline Vector - i.e. island labeling dataset).}
  }
  }
  \item{recnames}{\code{json}: JSON object including the name and ID of intersecting reconstructed polygons (from t0 until ti, where t = time period) within a reconstructed polygon of ti.}
  \item{refnames}{\code{json}: JSON object including the name and ID of intersecting labeling points/polygons (from t0 until ti, where t = time period) within a reconstructed polygon of ti.}
}


=========
}
\examples{

# load data samples
sporades <- sporades()
topo <- sporades$topo
labs <- sporades$labs
correction <- sporades$correction
curve <- sporades$curve

# subset first and last period 
curve <- curve[[c(1,dim(curve)[3])]]

# reconstruct
rec <- reconstruct(topo=topo,
                   region=labs,
                   curve=curve,
                   correction=correction,
                   reclabs='name'
                   )

# metadata
md <- metadata(rec)
                   
\donttest{                   
# export     
dir <- tempdir() # export to temporary directory 
export(rec, paste0(dir,'/sporades.qs2'),overwrite=TRUE) # qs2 (faster and less storage than rds) 
export(rec, paste0(dir,'/sporades.rds'), overwrite=TRUE) # rds / rdata 
export(rec, paste0(dir,'/sporades'), overwrite=TRUE)  # datasets organized in directory  
#export(rec, paste0(dir,'/sporades.zip')) # zipped datasets 
}            
\donttest{                   
# import
rec <- import(filename=paste0(dir,'/sporades.qs2'))
rec <- import(filename=paste0(dir,'/sporades.rds'))
rec <- import(filename=paste0(dir,'/sporades'))
}    
# explore 

## tabs class object
if (interactive()){
explore(rec) # comparison present reference and topo-based
explore(rec, timelapse=3) # paleo reconstruction 
}

## from exported object 
if (interactive()){
explore(paste0(dir,'/sporades.qs2'))
explore(paste0(dir,'/sporades.qs2'), timelapse=1)
}

# get area 
area <- get_area(rec) # using object class tabs 
area <- get_area(rec$recvect) # using recvect 
\donttest{
area <- get_area(paste0(dir,'/sporades.qs2')) # using exported object
unlink(dir)
}

}
\seealso{
\href{https://uva_ibed_piac.gitlab.io/tabs/articles/00-tabs-get-started.html}{get started}

\href{https://uva_ibed_piac.gitlab.io/tabs/articles/Fa-tabs-content.html}{tabs object structure}
}
\author{
Johannes De Groeve
}
