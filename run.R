
# make sure a recent version of SpaDES.project is installed
if (tryCatch(packageVersion("SpaDES.project") < "0.0.7.9020", error = function(e) TRUE)) {
  system.time(Require::Install("PredictiveEcology/SpaDES.project@transition (HEAD)"))
  #install.packages("SpaDES.project",
  #                 repos = c("https://predictiveecology.r-universe.dev",
  #                           getOption("repos")))
}
# pkgload::load_all("~/GitHub/SpaDES.project")

out <- SpaDES.project::setupProject(
  modules = c(
    "achubaty/TriSect_Disperse@development",
    "achubaty/TriSect_Impact@development",
    "achubaty/TriSect_RecruitAndDefoliate@Eliot",
    "achubaty/TriSect_ReproMods@Eliot",
    "achubaty/TriSect_SpringInsect@Eliot",
    "achubaty/TriSect_SpringPredator@Eliot",
    "PredictiveEcology/Biomass_borealDataPrep@terra-migration",
    "PredictiveEcology/Biomass_core@Eliot",
    "PredictiveEcology/Biomass_speciesData@terra-migration",
    "PredictiveEcology/Biomass_speciesFactorial",
    "PredictiveEcology/Biomass_speciesParameters@Eliot",
    "PredictiveEcology/TriSect_dataPrep@Eliot",
    "PredictiveEcology/WBI_dataPrep_studyArea@Eliot"
  ),
  sideEffects = {
    if (user("emcintir"))
      googledrive::drive_auth(email = "eliotmcintire@gmail.com", cache = "~/.secret")
    httr::set_config(httr::config(http_version = 0))
  },
  options = list(spades.allowInitDuringSimInit = TRUE,
                 spades.moduleCodeChecks = FALSE,
                 reproducible.showSimilar = TRUE,
                 reproducible.useTerra = TRUE,
                 reproducible.rasterRead = "terra::rast",
                 reproducible.useMemoise = TRUE,
                 reproducible.showSimilarDepth = 5,
                 repos = c("https://predictiveecology.r-universe.dev",
                           getOption("repos"))),
  prov = "AB",
  useGit = FALSE,
  params = list(.globals =
                  list(
                    vegLeadingProportion = 0,
                    .useCache = c(".inputObjects", "init"),
                    studyAreaName = prov,
                    .studyAreaName = prov,
                    .plots = FALSE),
                TriSect_Disperse = list(
                  MaxDistThreshold = 1e3 # in m
                )),
  # These were determined on an ad hoc basis... run, wait for error, add package
  packages = c(
    "NLMR", "microbenchmark",
    "PredictiveEcology/LandR@terra-migration (HEAD)",
    "data.table",
    "PredictiveEcology/reproducible@errorPostProcess (HEAD)",
    "PredictiveEcology/SpaDES.core@findObjects (HEAD)",
    "googledrive"
  ),
  times = list(start = 0, end = 1800) # in days for TriSect
)


out$objects$objectSynonyms <- list(c("PSPmeasure_sppParams", "PSPmeasure"),
                                   c("PSPgis_sppParams", "PSPgis"),
                                   c("PSPplot_sppParams", "PSPplot"))
# pkgload::load_all("~/GitHub/SpaDES.core")
out2 <- do.call(SpaDES.core::simInitAndSpades, out)
