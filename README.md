
# DataBlauwgraslandRome

<!-- badges: start -->
<!-- badges: end -->

Deze R-library bevat drie datasets die betrekking hebben op het gebied 'Rome' (Friesland).

* stk
* ahn
* sampled_area

De datasets zijn verkregen door het verwerken van de basis informatie in de folder `data-raw`. 
De verwerking is gedaan met het script `raw_data.R` in deze folder. 

## Dataset 'stk'

* `Veg`: Voorkomen van blauwgrasland.
* `GVG`, `GLG`, `GHG`: resp. gemiddelde voorjaarsgrondwaterstand, laagste grondwaterstand en hoogste grondwaterstand (cm-mv).
* `GVGtovKl`, `GLGtovKl`: resp. Gemiddelde voorjaarsgrondwaterstand en laagste grondwaterstand (cm tov keileemniveau).
* `Gt`: grondwatertrap.
* `Bofek`: Bofek codes [https://www.wur.nl/nl/show/Bodemkaart-1-50-000.htm].
* `DiepteKl`: Diepte van de keileem (cm-mv).

## Dataset 'ahn'
Maaiveldhoogte in het onderzoeksgebied 'Rome' (Friesland).

## Dataset 'sampled_area'
Kaart van sample-punten in het gebied 'Rome' (Friesland).

## Installatie

U kunt de datasets 'DataBlauwgraslandRome' als volgt installeren in R:

```R
devtools::install_github("KVIsweco/DataBlauwgraslandRome")
```

De datasets zijn daarna gereed voor gebruik als u deze inleest met:

`library("DataBlauwgraslandRome")`

## Documentatie
De documentatie van de verschillende datasets is als volgt beschikbaar: 

`?stk` `?ahn` of `?sampled_area`.

