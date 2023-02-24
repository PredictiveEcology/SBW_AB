
# make sure a recent version of SpaDES.project is installed
if (tryCatch(packageVersion("SpaDES.project") < "0.0.7.9019", error = function(e) TRUE)) {
  install.packages("SpaDES.project",
                   repos = c("https://predictiveecology.r-universe.dev",
                             getOption("repos")))
}
out <- SpaDES.project::setupProject(
  modules = c(
    "achubaty/TriSect_Disperse@development",
    "achubaty/TriSect_Impact@development",
    "achubaty/TriSect_RecruitAndDefoliate@Eliot",
    "achubaty/TriSect_ReproMods@Eliot",
    "achubaty/TriSect_SpringInsect@Eliot",
    "achubaty/TriSect_SpringPredator@Eliot",
    "PredictiveEcology/Biomass_borealDataPrep@development",
    "PredictiveEcology/Biomass_core@development",
    "PredictiveEcology/Biomass_speciesData@development",
    "PredictiveEcology/Biomass_speciesFactorial",
    "PredictiveEcology/Biomass_speciesParameters@development",
    "PredictiveEcology/TriSect_dataPrep",
    "PredictiveEcology/WBI_dataPrep_studyArea@Eliot"
  ),
  sideEffects = {
    if (user("emcintir"))
      googledrive::drive_auth(email = "eliotmcintire@gmail.com", cache = "~/.secret")
  },
  options = list(spades.allowInitDuringSimInit = TRUE,
                 spades.moduleCodeChecks = FALSE,
                 reproducible.showSimilar = TRUE,
                 reproducible.useTerra = TRUE,
                 reproducible.rasterRead = "terra::rast",
                 reproducible.useMemoise = TRUE,
                 reproducible.showSimilarDepth = 5),
  prov = "AB",
  useGit = TRUE,
  params = list(.globals =
                  list(
                    vegLeadingProportion = 0,
                    .useCache = c(".inputObjects", "init"),
                    studyAreaName = prov,
                    .studyAreaName = prov),
                WBI_dataPrep_studyArea =
                  list(
                    studyAreaName = prov
                  )),
  #Biomass_speciesParameters = list(PSPdataTypes = prov)),

  # These were determined on an ad hoc basis... run, wait for error, add package
  packages = c(
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
out2 <- do.call(SpaDES.core::simInitAndSpades, out)
