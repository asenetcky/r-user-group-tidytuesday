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
  endpoint <- glue::glue(
    "{domain}{resource_string}?{limit_string}"
  )

  print(endpoint)

  # grab all data
  offset <- 0
  initial_pull <- data.frame()

  while (condition) {
  }
}

pull_odp(resource = "y7ky-5wcz")
