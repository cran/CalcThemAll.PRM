## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----out.width = '80%', echo = FALSE------------------------------------------
knitr::include_graphics("figures/guidelines_table.png")

## ----add_your_own_pesticide, echo=TRUE, warning=FALSE-------------------------
library(CalcThemAll.PRM)
library(DT)
pesticide_info <- CalcThemAll.PRM::pesticide_info #the original 22 pesticides
datatable(pesticide_info, options = list(pageLength = 10,lengthMenu = c(5, 10, 15, 20), scrollX = T))

pesticide_info <- add_your_own_pesticide(pesticides = "Poison", #adding one new pesticide
                                         relative_LORs = 0.023, pesticide_types = "Poison",
                                         distribution_types = "Log-Normal", scales = 0.09,
                                         shape_locations = 0.014)
datatable(pesticide_info, options = list(pageLength = 10,lengthMenu = c(5, 10, 15, 20), scrollX = T))

pesticide_info <- add_your_own_pesticide(pesticides = #adding multiple new pesticides
                                           c("Poison", "Acid", "Sludge"),
                                         relative_LORs = c(0.03, 0.01, 0.5), 
                                         pesticide_types = c("Ghost", "Bug", "Poison"),
                                         distribution_types = c("Log-Normal", "Log-Logistic
                                                                Log-Logistic", "Burr Type III"),
                                         scales = c(0.3, 0.002, 2),
                                         scale_2s = c(NA, 0.04, NA), 
                                         shape_locations = c(1, 0.07, 3),
                                         shape_location_2s = c(NA, 0.14, 2.3),
                                         weights = c(NA, 0.08, NA))
datatable(pesticide_info, options = list(pageLength = 10,lengthMenu = c(5, 10, 15, 20), scrollX = T))


## ----treat_LORs_all_data, echo=TRUE, warning=FALSE----------------------------

datatable(Canto_pesticides, options = list(pageLength = 10,lengthMenu = c(5, 10, 15, 20), scrollX = T)) #Canto pesticide concentrations before LOR treatment

Canto_pesticides_LOR_treated <- treat_LORs_all_data(raw_data = Canto_pesticides, #this is the pesticide concentration data set to be treated
pesticide_info = CalcThemAll.PRM::pesticide_info, #this specifies the pesticide info look-up table
treatment_method = "WQI") #this selects the LOR treatment method

datatable(Canto_pesticides_LOR_treated, options = list(pageLength = 10,lengthMenu = c(5, 10, 15, 20), scrollX = T)) #Canto pesticide concentrations after treatment, LORs should be replaced with either 0.0000001 or LOR replacement value


## ----calculate_daily_average_PRM, echo=TRUE, warning=FALSE--------------------
head(Canto_pesticides_LOR_treated) #Canto pesticide concentrations after LOR treatment

#calculate daily PRM
Canto_daily_PRM <- calculate_daily_average_PRM(LOR_treated_data = Canto_pesticides_LOR_treated)
head(Canto_daily_PRM)


## ----plot_daily_PRM, echo=TRUE, warning=FALSE, out.width = '100%'-------------
#filter daily PRM data for a single site and sampling year
Violet_Town_2017_2018_PRM <- Canto_daily_PRM %>%
 dplyr::filter(.data$`Sampling Year` ==  "2017-2018" &  .data$`Site Name` == "Violet Town")

plot_daily_PRM(daily_PRM_data = Violet_Town_2017_2018_PRM,
               title = F, #this toggles the title on and off
               wet_season_start = "2017-10-02", #start date of the wet season or high-risk window
                                                #this is optional and can be removed with = NULL
               wet_season_length = 182, #length of wet season or high-risk window
               PRM_group = "PSII Herbicide PRM") #PRM group to plot, for all PRM = "Total PRM"


## ----PRM_DT, echo=TRUE, warning=FALSE, out.width = '100%'---------------------
PRM_DT(PRM_data = Canto_daily_PRM, fill_cols = "Total PRM",
 colour_cols = c("PSII Herbicide PRM", "Other Herbicide PRM", "Insecticide PRM"))

## ----calculate_wet_season_PRM, echo=TRUE, warning=FALSE-----------------------
#This calculation can take a few minutes so one site & sampling year is used in this example
Celestial_City_2019_2020_daily_PRM <- Canto_daily_PRM %>% 
  dplyr::filter(`Site Name` == "Celestial City" & `Sampling Year` == "2019-2020")

CC2019_2020_wet_season_Total_PRM <- calculate_wet_season_average_PRM(daily_PRM_data = Celestial_City_2019_2020_daily_PRM, PRM_group = "Total PRM")
#this calculates the wet season average PRM for all pesticide groups in one total value
#to calculate for a specific group define it in "PRM_group ="

CC2019_2020_wet_season_Total_PRM


