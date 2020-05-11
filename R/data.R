#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

#' stk
#'
#' Kaarten met informatie over het gebied 'Rome' (Friesland).
#'
#' \itemize{
#'   \item \code{Veg}: 1 = blauwgrasland; 0 = geen blauwgrasland.
#'   \item \code{GVG}, \code{GLG}, \code{GHG}: resp. gemiddelde voorjaarsgrondwaterstand, laagste grondwaterstand en hoogste grondwaterstand (cm-mv).
#'   \item \code{GVGtovKl}, \code{GLGtovKl}: resp. Gemiddelde voorjaarsgrondwaterstand en laagste grondwaterstand (cm tov keileemniveau).
#'   \item \code{Gt}: grondwatertrap: 10=Gt I; 20=Gt II; 25=Gt II-ster ; 30=Gt III; 35=Gt III-ster; 40=Gt IV; 45=Gt IV-ster; 50=Gt V;
#'     55=Gt V-ster; 60=Gt VI; 70=Gt VII; 75=Gt VII-ster
#'   \item \code{Bofek}: Bofek codes (\url{https://www.wur.nl/nl/show/Bodemkaart-1-50-000.htm})
#'   \item \code{DiepteKl}: Diepte van de keileem (cm=mv)
#' }
#'
#' @examples
#' \dontrun{plot(stk$Veg)}
#'
"stk"

#' ahn: Maaiveldhoogte in het onderzoeksgebied 'Rome' (Friesland).
#'
#' Bron: AHN5 (resolutie 5x5 meter); (\url{https://www.ahn.nl/})
#' Eenheid: m+NAP.
"ahn"

#' sampled_area: Kaart van sample-punten in het gebied 'Rome' (Friesland).
#'
#' In de sample punten (resolutie 5x5 meter) met de waarde 1 is van \emph{alle} rasters in de raster stack "stk" informatie aanwezig.
#' in de sample punten met een waarde 0 is (in een deel van de rasters of van alle rasters) deze informatie niet aanwezig.
"sampled_area"




