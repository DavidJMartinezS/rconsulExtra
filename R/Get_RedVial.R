#' Capas vectoriales Red Vial
#'
#' @param shp Objeto sf.
#' @param var Campo que desea filtrar. Los campos disponibles son "CUT_REG", "CUT_PROV", "CUT_COM", "REGION", "PROVINCIA" y "COMUNA".
#' @param val Valores del campo seleccionado por los que se desea filtrar.
#'
#' @return Capa vectorial en formato sf. CRS: EPSG: 4326. Unit: degree
#' @export
#'
#' @importFrom sf st_read st_as_text st_geometry st_transform st_union st_zm
#' @importFrom utils download.file unzip
#' @importFrom stringr str_c
#' @importFrom magrittr `%>%`
#'
#' @examples
#' Get_RedVial(var = "ROL", val = "IPA 15")
#' Get_RedVial(var = "CARPETA", val = c("Pavimento Doble Calzada","Grava Tratada"))
#'
Get_RedVial <- function(shp = NULL, var = NULL, val = NULL){
  options(timeout = 2000)
  tf <- tempfile(fileext = ".zip")
  utils::download.file(
    'http://www.mapas.mop.cl/red-vial/Red_Vial_Chile.zip',
    destfile = tf,
    method = "libcurl",
    timeout = 2000,
    range = "bytes=0-500000000"
  )
  td <- tempdir()
  contenido <- utils::unzip(tf, files = 'Red_Vial_Chile/Red_Vial_Chile_31_01_2023.gdb', exdir = td)
  if (is.null(shp)) {
    if (is.null(c(var, val))) {
      data <- sf::st_read(contenido)
    } else if (is.null(var) || is.null(val)) {
      stop(
        "Debe ingresar un archivo sf. \nDe lo contrario indicar en `var` la variable que desea filtrar, y en `val` el o los valores que desea obtener del campo seleccionado"
      )
    } else {
      val <- val %>% as.character() %>% stringr::str_c("'", ., "'", collapse = ', ')
      sql <-
        paste0("SELECT * FROM \"Red_Vial_Chile\" WHERE ",
               var,
               " IN (",
               val,
               ") ORDER BY ROL ASC")
      data <- sf::st_read(contenido,
                          query = sql)
    }
  }
  if (!is.null(shp)) {
    if (is.null(c(var, val))) {
      data <- st_read(
        contenido,
        wkt_filter = sf::st_as_text(
          sf::st_geometry(shp %>% sf::st_transform(5360) %>% sf::st_union())
        )
      )
    } else {
      stop("Si ingresa el objeto sf, entonces no debe indicar el resto de los argumentos.")
    }
  }
  unlink(td, recursive = TRUE)
  data <- data %>% sf::st_transform(4326) %>% sf::st_zm()
  return(data)
}
