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
  # prepare report
  response = responsePlot(d),
  loo = looCompare(m1, m2, m3, m4),
  int = intPlot(m4),
  postShare = postSharePlot(m3),
  a1 = above1(m3),
  handWash = handWashPlot(m5),
  a2 = above2(m5),
  # render html report
  report = rmarkdown::render(
    input = "report.Rmd",
    output_format = c("html_document", 
                      "md_document"),
    quiet = TRUE
  )
)