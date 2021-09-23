
library(tidyverse)

report_raw <- readxl::read_excel("1. Data/reporte.xlsx")

dat_raw <- report_raw[, -1]
complete_cases <- which(!is.na(dat_raw[, 1]))
dat_raw <- dat_raw[complete_cases, ]

names_dat_raw <- unname(apply(dat_raw[1,], 2, print))
names(dat_raw) <- names_dat_raw

dat_raw <- dat_raw[-1, ] # Quitar la fila de nombres
dat_raw <- janitor::clean_names(dat_raw)

dat_raw <- dat_raw %>%
  mutate(
    distrito = str_replace(distrito,
                           "Prov. Constitucional del Callao",
                           "Callao, Callao")
  ) %>%
  separate(
    col = distrito,
    into = c("reg", "prov", "distr"),
    sep = ","
  ) %>%
  mutate(
    prov = str_squish(prov),
    distr = str_squish(distr),
    distr = str_remove(distr, "distrito: "),
    codigo = str_pad(codigo, 6, pad = "0")
  ) %>%
  rename(ubigeo = codigo)

saveRDS(dat_raw,
        "1. Data/poblacion_inei_2017_detailed.rds")








