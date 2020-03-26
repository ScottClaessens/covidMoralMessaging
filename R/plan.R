# drake plan
plan <- drake_plan(
  # load data
  d = loadData(),
  # fit models
  m1 = fitModel1(d),
  m2 = fitModel2(d),
  m3 = fitModel3(d),
  m4 = fitModel4(d),
  m5 = fitModel5(d),
  # render report
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)