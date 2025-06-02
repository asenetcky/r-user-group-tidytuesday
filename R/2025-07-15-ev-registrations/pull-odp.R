pull_odp <- function(domain = "https://data.ct.gov/", resource) {
  # validate user input
  checkmate::assert(
    checkmate::check_string(domain),
    checkmate::check_string(
      resource,
      n.chars = 9L
    ),
    combine = "and"
  )

  # construct url
  resource_string <- glue::glue("resource/{resource}.json")

  # construct limit
  limit <- 10000

  # initial params
  offset <- 0
  initial <- TRUE

  # grab all data
  while (TRUE) {
    endpoint <- glue::glue(
      "{domain}{resource_string}?$limit={limit}&$offset={offset}"
    )

    data <-
      httr2::request(endpoint) |>
      httr2::req_perform() |>
      httr2::resp_body_json() |>
      dplyr::bind_rows()

    rows <- nrow(data)

    if (initial) {
      result <- data
      initial <- FALSE
    } else {
      result <- dplyr::bind_rows(result, data)
    }

    if (rows < limit) break

    offset <- offset + limit
  }
  return(result)
}
