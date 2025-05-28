### functionlize this

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
  limit_string <- glue::glue("$limit={limit}")

  ### combine it all
  initial_endpoint <- glue::glue(
    "{domain}{resource_string}?{limit_string}"
  )

  # for testing
  print(initial_endpoint)

  # initial params
  offset <- 0

  # initial pull - fail fast
  initial_pull <-
    httr2::request(initial_endpoint) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    dplyr::bind_rows()

  # grab all data
  while (condition) {
    offset <- offset + limit
    offset_string <- "$offset={offset}"

    new_endpoint <- glue::glue(
      "{initial_endpoint}&{offset_string}"
    )
  }
}

pull_odp(resource = "y7ky-5wcz")
