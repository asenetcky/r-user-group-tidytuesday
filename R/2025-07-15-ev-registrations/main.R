# EV Registrations

## Env
### Using `renv` but trying to make as `renv` agnostic as possible
library(dplyr) # for data wrangling
library(glue) # for string literals
library(httr2) # for http requests
library(ggplot2) # for data visualizations
library(nanoparquet) # low dependancy parquet files
library(fs) # file manipulations
library(lubridate) # date manipulations
library(forcats) # for factors
library(purrr) # for functional programming

## Data Pull
domain <- "https://data.ct.gov/"
resource <- "resource/y7ky-5wcz.json"

### too lazy to loop through - just going to grab > 70k (should be enough)
### API uses LIMITS and OFFSETS
limit <- 70000L
limit_string <- glue::glue("$limit={limit}")

### combine it all
endpoint <- glue::glue(
    "{domain}{resource}?{limit_string}"
)

### GET request
req <- request(endpoint)
req |> req_dry_run()

### GET response
path <- path_wd("data", "ev-registrations", ext = "parquet")

if (!file_exists(path)) {
    resp <- req_perform(req)

    ### convert resp to data we can use
    data <-
        resp |>
        resp_body_json() |>
        bind_rows() |>
        ### enforcing column types from ODP doco
        mutate(
            across(
                .cols = c(
                    id,
                    vehicleweight,
                    vehicleyear,
                    vehicledeclaredgrossweight,
                    vehiclerecordedgvwr,
                ),
                .fns = as.numeric
            ),
            across(
                .cols = c(
                    registration_date_start,
                    registration_date_expiration
                ),
                .fns = as_date
            )
        )

    ### parquet this for later
    write_parquet(data, path)
}

data <- read_parquet(path)

## Data Exploration

### take a look
glimpse(data)

char_data <-
    data |>
    select(where(is.character))

### sussing out good factor candidates
maybe_factors <-
    map(
        char_data,
        \(var) {
            count(char_data, {{var}}, sort = TRUE)
        }
    )

## Visualization
