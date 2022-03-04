pacman::p_load("tidyverse", "readxl")


d_contacts <- readxl::read_excel("data/raw/mts-contacts.xlsx")
d_responses <- readxl::read_excel("data/raw/mts-survey.xlsx")

# Fix names
d_contacts_01 <- d_contacts |>
    janitor::clean_names()

d_contacts_01

d_responses_01 <- d_responses |>
    slice(-1) |>
    janitor::clean_names()

d_responses_01


# clean join_fields

d_responses_02 <- d_responses_01 |>
    filter(!is.na(recipient_email)) |>
    mutate(
        recipient_email = stringr::str_to_lower(recipient_email)
    )

d_contacts_02 <- d_contacts_01 |>
    mutate(
        recipient_email = stringr::str_to_lower(recipient_email_emails_in_system), 
        email_in_contact = TRUE
    ) |>
    filter(!is.na(recipient_email))


d_joined <- d_responses_02 |>
    left_join(d_contacts_02, by = "recipient_email") |>
    mutate(
        email_in_contact = email_in_contact %in% TRUE
    )

d_joined |>
    count(email_in_contact)

d_joined |> write_csv("data/clean/mts-joined.csv", na = "")
