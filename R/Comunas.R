#' Comunas Provincias y Regiones
#'
#' Sf de las comunas en sus respectivas provincias y regiones.
#' CRS: EPSG:4326. WGS 84 -- WGS84 - World Geodetic System 1984
#' Unit: degree
#' Coordinate system: Ellipsoidal 2D CS. Axes: latitude, longitude. Orientations: north, east. UoM: degree
#' proj4: "+proj=longlat +datum=WGS84 +no_defs +type=crs"
#'
#' @format ## `LyP`
#' Simple feature collection with 345 features and 9 fields:
#' \describe{
#'   \item{CUT_REG, CUT_PROV, CUT_COM}{Códigos Únicos Territoriales}
#'   \item{REGION, PROVINCIA, COMUNA}{Nombre de las comunas, provincias y regiones}
#'   \item{Area_km2, Length_km}{Área y longitud geodésica de las comunas}
#' }
#' @source <http://www.ide.cl/descargas/capas/subdere/DivisionPoliticoAdministrativa2020.zip>
"Comunas"
