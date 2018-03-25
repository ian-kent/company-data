library(readr)
library(reshape2)
library("lubridate", lib.loc="/usr/local/lib/R/3.4/site-library")
library("dplyr", lib.loc="/usr/local/lib/R/3.4/site-library")

companies <- read_csv("/Users/iankent/Downloads/BasicCompanyDataAsOneFile-2018-03-01.csv")
postcode_regions <- read_csv("/Users/iankent/Downloads/postcode_districts_with_UK_regions.csv")

companies$RegAddress.PostCodePrefix <- gsub("(\\D+).*", "\\1", companies$RegAddress.PostCode)

companies_region <- merge(companies, postcode_regions, all.x = TRUE, by.x = "RegAddress.PostCodePrefix", by.y = "Postcode prefix")
companies_region$IncorporationDate <- as.Date(companies_region$IncorporationDate, format = "%d/%m/%Y")

# by year: incorporated count by region
# years <- data.frame(addmargins(table(year(companies_region$IncorporationDate), companies_region$`UK region`)))
years <- data.frame(table(year(companies_region$IncorporationDate), companies_region$`UK region`))
years_data <- data.frame(acast(years, Var1~Var2, value.var="Freq"))
years_data_2 <- years_data
years_data_2$England <- years_data_2$East.Midlands + years_data_2$Greater.London + years_data_2$North.East + years_data_2$North.West + years_data_2$South.East + years_data_2$South.West + years_data_2$West.Midlands
years_data_2$Other <- years_data_2$Channel.Islands + years_data_2$Isle.of.Man + years_data_2$Non.geographic
years_data_2 <- subset(years_data_2, select = -c(East.Midlands, Greater.London, North.East, North.West, South.East, South.West, West.Midlands, Channel.Islands, Isle.of.Man, Non.geographic) )

# write.csv(years, file = "/Users/iankent/dev/src/github.com/ian-kent/company-data/incorporations_per_region_by_year.csv")
write.csv(years_data_2, file = "/Users/iankent/dev/src/github.com/ian-kent/company-data/incorporations_per_region_by_year.csv")

# by year: top 10 popular name words

# name_words <- data.frame(table(unlist(strsplit(tolower(companies_region$CompanyName), " "))))
# name_words <- name_words[which(rowSums(name_words) > 0),] 
# year_words %>% group_by(Time, Word)%>%summarise(count=n())
