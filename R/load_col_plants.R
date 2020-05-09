#' Load Catalog of Life taxonomic data subsetted to vascular plants
#'
#' @param col_file Path to Catalog of Life taxonomic data
#' subsetted to vascular plants (downloaded from Catalog
#' of Life website)
#'
#' @return Tibble. taxonID, acceptedNameUsageID, parentNameUsageID
#' columns will be numeric, everything else character.
#'
#' @examples
#' \dontrun{
#' # Create a temporary working directory
#' library(fs)
#' temp_dir <- tempdir()
#' dir_create(temp_dir)
#'
#' # Download Catalog of Life plants taxonomy
#' download.file(
#'   "http://www.catalogueoflife.org/DCA_Export/zip/archive-kingdom-plantae-phylum-tracheophyta-bl3.zip",
#'   fs::path(temp_dir, "archive-kingdom-plantae-phylum-tracheophyta-bl3.zip")
#'   )
#'
#' # Unzip the downloaded folder
#' unzip(
#'   fs::path(temp_dir, "archive-kingdom-plantae-phylum-tracheophyta-bl3.zip"),
#'   files = "taxa.txt",
#'   exdir = temp_dir
#' )
#'
#' # Load the CoL plants dataset
#' load_col_plants(fs::path(temp_dir, "taxa.txt"))
#'
#' # Cleanup
#' fs::dir_delete(temp_dir)
#' }
load_col_plants <- function (col_file) {

  # First get colnames, and use these to specify column type.
  # taxonID, acceptedNameUsageID, parentNameUsageID need to be numeric.
  col_plants_cols <- colnames(readr::read_tsv(col_file, n_max = 1, col_types = readr::cols()))

  col_spec <- dplyr::case_when(
    stringr::str_detect(
      col_plants_cols,
      "taxonID|acceptedNameUsageID|parentNameUsageID"
    ) ~ "n",
    TRUE ~ "c"
  )

  col_spec <- paste(col_spec, collapse = "")

  readr::read_tsv(
    col_file,
    col_types = col_spec)

}
