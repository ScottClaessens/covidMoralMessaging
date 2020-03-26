# custom functions

loadData <- function() {
  # from https://osf.io/cytgj/
  df <- read.csv("data/COVID19 Study 1 DATA.csv", header=TRUE, stringsAsFactors=FALSE)
  
  df$ID <- 1:nrow(df)

  df$gender <- as_factor(df$gender)
  df$gender_binary <- as_factor(df$gender_binary)
  df$gender_binary_numeric <- as.numeric(df$gender_binary)
  
  df$source_condition <- as_factor(df$source_condition)
  df$source_condition <- fct_relevel(df$source_condition,
                                     "Citizen", "Leader")
  
  df$message_condition <- as_factor(df$message_condition)
  df$message_condition <- fct_relevel(df$message_condition,
                                      "Deontological", "Virtue", "Utilitarian", "Non-Moral")
  
  df$race <- as_factor(df$race)
  df$race <- fct_relevel(df$race,"White", "Black", "Asian","Unspecified")
  
  df$children <- as_factor(df$children)
  df$education <- as_factor(df$education)
  df$health_condition <- as_factor(df$health_condition)
  df$political_party <- as_factor(df$political_party)
  df$employment <- as_factor(df$employment)
  df$employer_home_support <- as_factor(df$employer_home_support)
  df$living_situation <- as_factor(df$living_situation)
  df$covid_cases_local <- as_factor(df$covid_cases_local)
  df$covid_cases_personal <- as_factor(df$covid_cases_personal)
  df$forced_choice_message <- as_factor(df$forced_choice_message)
  
  df %>% mutate(employment_rec = if_else(employment == "Full-Time", 1, 0)) -> df
  
  # get as long data frame for analysis
  df <-
    df %>%
    pivot_longer(cols = starts_with("self_"),
                 names_to = "behaviour",
                 values_to = "response")
  return(df)
}

fitModel1 <- function(d) {
  out <- brm(response ~ 1 + (1 | behaviour) + (1 | ID),
             data = d, family = cumulative,
             prior = c(prior(normal(0, 1.5), class = Intercept),
                       prior(student_t(3, 0, 2), class = sd)),
             iter = 4000, warmup = 2000, chains = 4, cores = 4,
             control = list(adapt_delta = 0.99))
  out <- add_criterion(out, "loo")
  return(out)
}

fitModel2 <- function(d) {
  out <- brm(response ~ 1 + source_condition + (1 + source_condition | behaviour) + (1 | ID),
             data = d, family = cumulative,
             prior = c(prior(normal(0, 1.5), class = Intercept),
                       prior(normal(0, 1), class = b),
                       prior(student_t(3, 0, 2), class = sd)),
             iter = 4000, warmup = 2000, chains = 4, cores = 4,
             control = list(adapt_delta = 0.99))
  out <- add_criterion(out, "loo")
  return(out)
}

fitModel3 <- function(d) {
  out <- brm(response ~ 1 + message_condition + (1 + message_condition | behaviour) + (1 | ID),
             data = d, family = cumulative,
             prior = c(prior(normal(0, 1.5), class = Intercept),
                       prior(normal(0, 1), class = b),
                       prior(student_t(3, 0, 2), class = sd)),
             iter = 4000, warmup = 2000, chains = 4, cores = 4,
             control = list(adapt_delta = 0.99))
  out <- add_criterion(out, "loo")
  return(out)
}

fitModel4 <- function(d) {
  out <- brm(response ~ 1 + source_condition*message_condition + 
               (1 + source_condition*message_condition | behaviour) + 
               (1 | ID),
             data = d, family = cumulative,
             prior = c(prior(normal(0, 1.5), class = Intercept),
                       prior(normal(0, 1), class = b),
                       prior(student_t(3, 0, 2), class = sd)),
             iter = 4000, warmup = 2000, chains = 4, cores = 4,
             control = list(adapt_delta = 0.99))
  out <- add_criterion(out, "loo")
  return(out)
}

fitModel5 <- function(d) {
  out <- brm(response ~ 1 + source_condition*message_condition + 
               (1 + source_condition*message_condition | behaviour) + 
               (1 | ID) +
               # controls
               gender + age + race + education_numeric + income + employment_rec + 
               overall_conservatism + religiosity,
             data = d, family = cumulative,
             prior = c(prior(normal(0, 1.5), class = Intercept),
                       prior(normal(0, 1), class = b),
                       prior(student_t(3, 0, 2), class = sd)),
             iter = 4000, warmup = 2000, chains = 4, cores = 4,
             control = list(adapt_delta = 0.99))
  out <- add_criterion(out, "loo")
  return(out)
}