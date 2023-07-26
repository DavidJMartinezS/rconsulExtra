#' Capas vectoriales division politico-administrativa
#'
#' @description
#' Funciones para obtener información vectorial de las divisiones politico-administraticas subida por IDE Chile.
#' La funcion permite descargar la capa completa, o bien filtrar por extension de un poligono o filtrar un campo.
#'
#' @param shp Objeto sf.
#' @param var Campo que desea filtrar. Los campos disponibles son "CUT_REG", "CUT_PROV", "CUT_COM", "REGION", "PROVINCIA" y "COMUNA".
#' @param val Valores del campo seleccionado por los que se desea filtrar.
#'
#' @return capa vectorial en formato sf
#' @export
#'
#' @importFrom sf st_read st_as_text st_geometry st_transform st_union
#' @importFrom utils download.file unzip
#' @importFrom installr install.7zip
#' @importFrom stringr str_c
#' @importFrom magrittr `%>%`
#'
#' @examples
#' Get_DivisionPoliticoAdministrativa(var = "REGION", val = "Pica")
#' Get_DivisionPoliticoAdministrativa(var = "CUT_REG", val = c("01","05"))
#'
#'
#'
Get_DivisionPoliticoAdministrativa <- function(shp = NULL, var = NULL, val = NULL){
  if (!("7-Zip" %in% list.files("C:/Program Files (x86)"))) {
    installr::install.7zip(page_with_download_url = "C:/Program Files (x86)")
  }
  tf <- tempfile(fileext = ".zip")
  utils::download.file(
    'http://www.ide.cl/descargas/capas/subdere/DivisionPoliticoAdministrativa2020.zip',
    destfile = tf,
    mode = "wb"
  )
  td <- tempdir()
  contenido <-
    utils::unzip(tf, files = 'DivisionPoliticoAdministrativa2020/COMUNA.rar', exdir = td)
  z7 <- shQuote("C:/Program Files (x86)/7-Zip/7z.exe")
  cmd <- paste(z7, "x", contenido, "-aot", paste0("-o", td))
  system(cmd)
  if (is.null(shp)) {
    if (is.null(c(var, val))) {
      data <- sf::st_read(paste0(td, "\\COMUNA\\COMUNAS_2020.shp"))
    } else if (is.null(var) || is.null(val)) {
      stop(
        "Debe ingresar un archivo sf. \nDe lo contrario indicar en `var` la variable que desea filtrar, y en `val` el o los valores que desea obtener del campo seleccionado"
      )
    } else {
      val <- val %>% as.character() %>% stringr::str_c("'", ., "'", collapse = ', ')
      sql <-
        paste0("SELECT * FROM \"COMUNAS_2020\" WHERE ",
               var,
               " IN (",
               val,
               ") ORDER BY CUT_COM ASC")
      data <- sf::st_read(paste0(td, "\\COMUNA\\COMUNAS_2020.shp"),
                          query = sql)
    }
  }
  if (!is.null(shp)) {
    if (is.null(c(var, val))) {
      data <- st_read(
        paste0(td, "\\COMUNA\\COMUNAS_2020.shp"),
        wkt_filter = sf::st_as_text(
          sf::st_geometry(shp %>% sf::st_transform(5360) %>% sf::st_union())
        )
      )
    } else {
      stop("Si ingresa el objeto sf, entonces no debe indicar el resto de los argumentos.")
    }
  }
  unlink(td, recursive = TRUE)
  return(data)
}



