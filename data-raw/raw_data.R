## code to save package data in the correct format in the folder 'data'.

library(magrittr)
library(dplyr)
library(sp)
library(raster)
library(rgdal)
#library(caret)

crsAfoort <- sp::CRS("+init=epsg:28992") # epsg projection 28992 - amersfoort

# Functie om de grondwatertrap te berekenen. GHG/GLG in m-mv.
getGt <- function( GHG, GLG ) {
  if (is.na(GHG)|(is.na(GLG))) {
    return(NA)
  }
  if ( GLG <= 0.50 ) {Gt <- 10} else          # (A, B, C) 1 )
  {
    if ( GLG <= 0.80 ) {
      if      ( GHG <= 0.25 ) {Gt <- 20 }     # A 2
      else if ( GHG <= 0.40 ) {Gt <- 25 }     # B 2
      else                    {Gt <- 40 }     # C 2
    } else if ( GLG <= 1.20 ) {
      if      ( GHG <= 0.25 ) {Gt <- 30}      # A 3
      else if ( GHG <= 0.40 ) {Gt <- 35}      # B 3
      else if ( GHG <= 0.80 ) {Gt <- 40}      # C 3
      else                    {Gt <- 70}      # D 3
    } else {
      if      ( GHG <= 0.25 ) {Gt <- 50}      # A 4
      else if ( GHG <= 0.40 ) {Gt <- 55}      # B 4
      else if ( GHG <= 0.80 ) {Gt <- 60}      # C 4
      else if ( GHG <= 1.40 ) {Gt <- 70}      # D 4
      else                     Gt <- 75       # E 4
    }
  }
  return(Gt)
}

# Maak een raster kaart waaruit blijkt op welke lokaties er complete
# informatie beschikbaar is om een model mee te bouwen.
# 0 = incomplete informatie; 1 = complete informatie.
# stk
get_raster_of_sampled_area <- function( stk ){
  df <- as.data.frame(stk)
  ok <- stats::complete.cases(df)
  x <- raster::raster(stk)
  x[] <- as.numeric(ok)
  return(x$layer)
}

# Lees rasters (ruwe gegevens).
gvgcm <- raster::raster("data-raw/gvgcm5clipped.tif"); sp::proj4string(gvgcm) <- crsAfoort
glgcm <- raster::raster("data-raw/glgcm5clipped.tif"); sp::proj4string(glgcm) <- crsAfoort
ghgcm <- raster::raster("data-raw/ghgcm5clipped.tif"); sp::proj4string(ghgcm) <- crsAfoort
blauwgraslanden <- raster::raster("data-raw/Blauwgraslanden samengevoegd.tif"); sp::proj4string(blauwgraslanden) <- crsAfoort
dieptekeileem <- raster::raster("data-raw/Dieptekeileem.tif"); sp::proj4string(dieptekeileem) <- crsAfoort
bofek2012 <- raster::raster("data-raw/Bofek2012.tif"); sp::proj4string(bofek2012) <- crsAfoort
ahn <- raster::raster("data-raw/ahn5/hdr.adf"); sp::proj4string(ahn) <- crsAfoort
inventarisatiegebied <- raster::raster("data-raw/Inventarisatiegebied.tif"); sp::proj4string(inventarisatiegebied) <- crsAfoort

# Projecteer rasters op raster "gvgcm".
blauwgraslanden %<>% raster::projectRaster( to = gvgcm , method = "ngb" )
dieptekeileem %<>% raster::projectRaster( to = gvgcm , method = "bilinear" )
bofek2012 %<>% raster::projectRaster( to = gvgcm , method = "ngb" )
inventarisatiegebied %<>% raster::projectRaster( to = gvgcm , method = "ngb" )

#Vervang in raster "inventarisatiegebied" de NA's door 0; de rest wordt 1
inventarisatiegebied[is.na(inventarisatiegebied[])] <- 0 # Replace NA by 0
inventarisatiegebied[inventarisatiegebied[]>0] <- 1

# Maak geen onderscheid in 'blauwgraslanden' (=1) en 'blauwgraslanden (goed ontwikkeld)' (=2)
blauwgraslanden[blauwgraslanden[]>0] <- 1

# Vervang in het inventarisatiegebied de NA waarden van "blauwgraslanden" door 0
setnul <- inventarisatiegebied[]==1 & ( is.na(blauwgraslanden[]) )
blauwgraslanden[setnul] <- 0

# Bepaal de te hanteren extent van de rasters
xmin <- max(raster::bbox(blauwgraslanden)[1,1], raster::bbox(gvgcm)[1,1], raster::bbox(glgcm)[1,1],
            raster::bbox(ghgcm)[1,1], raster::bbox(bofek2012)[1,1], raster::bbox(dieptekeileem)[1,1])
xmax <- min(raster::bbox(blauwgraslanden)[1,2], raster::bbox(gvgcm)[1,2], raster::bbox(glgcm)[1,2],
            raster::bbox(ghgcm)[1,2], raster::bbox(bofek2012)[1,2], raster::bbox(dieptekeileem)[1,2])
ymin <- max(raster::bbox(blauwgraslanden)[2,1], raster::bbox(gvgcm)[2,1], raster::bbox(glgcm)[2,1],
            raster::bbox(ghgcm)[2,1], raster::bbox(bofek2012)[2,1], raster::bbox(dieptekeileem)[2,1])
ymax <- min(raster::bbox(blauwgraslanden)[2,2], raster::bbox(gvgcm)[2,2], raster::bbox(glgcm)[2,2],
            raster::bbox(ghgcm)[2,2], raster::bbox(bofek2012)[2,2], raster::bbox(dieptekeileem)[2,2])
newextent <- c(xmin, xmax, ymin, ymax)

# Knip de rasters op de te hanteren extent
gvgcm %<>% crop(newextent)
glgcm %<>% crop(newextent)
ghgcm %<>% crop(newextent)
blauwgraslanden  %<>% crop(newextent)
dieptekeileem %<>% crop(newextent)
bofek2012 %<>% crop(newextent)
ahn %<>% crop(newextent)

# Bereken de gvg en glg tov de bovenkant van de keileem (cm)
gvgcmkl <- dieptekeileem-gvgcm #gvg (cm) tov keileem bovenkant
glgcmkl <- dieptekeileem-glgcm #glg (cm) tov keileem bovenkant

# Calculate Gt
gt <- raster::overlay( ghgcm/100, glgcm/100, fun=Vectorize(getGt) )

# Maak raster stack van rasters (behalve het raster "inventarisatiegebied" en "ahn") en voeg
# namen toe
stk <- raster::addLayer(blauwgraslanden,gvgcm,glgcm,ghgcm,gt,gvgcmkl,glgcmkl,bofek2012,dieptekeileem)
names(stk) <- c("Veg","GVG","GLG","GHG","Gt","GVGtovKl","GLGtovKl","Bofek","DiepteKl")

# Maak raster kaart waaruit blijkt op welke lokaties er complete
# informatie beschikbaar is om een model mee te bouwen.
sampled_area <- get_raster_of_sampled_area(stk)

# Save package data.
usethis::use_data(stk, overwrite = TRUE)
usethis::use_data(ahn, overwrite = TRUE)
usethis::use_data(sampled_area, overwrite = TRUE)
