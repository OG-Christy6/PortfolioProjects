/*
Data Exploration Project: COVID-19 Global Trends
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
Author: Christina Meyers
Date: March 2026
*/

/* This project served as my ultimate tool in learning SQL and practice with methodical documentation. 
I used the 'SQL Data Exploration' tutorial from 'Alex the Analyst' on YouTube as a guide.
Here we seek to analyze the COVID-19 Deaths data set and draw insights about its effect across the globe. 
The orignal datasets can be found here: https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbFFJVjFjZ3NWbVZSU1duemNJMjVmMURIV2xRQXxBQ3Jtc0tteGN2czI4M19HTEljX05Sa000Qlo3N3dvZFRzaGN6cVVPT0h2Z0NPOE9rLVJraGVDQV84MkJRRGc0UTl6WGlKejNXNTNwTThIbGctVGdJcXVEQnR6dXJNYkNPdnFBZ0d0X2JFMlJPMGNJSk51RXdWSQ&q=https%3A%2F%2Fgithub.com%2FAlexTheAnalyst%2FPortfolioProjects%2Fblob%2Fmain%2FCovidDeaths.xlsx&v=qfyynHBFOsM 
and https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa3BZTGFwSW5nM3JEUDl5WFVQd1BWUzdXWTJJd3xBQ3Jtc0tsMW41dGdSTnNrMllJTDdYN3hCT1ZiczlyZXZ1OWxGdUExUTRsT3hTR3JUdXpURHhRZl9pVTQ0V21fakpERXRMSC1yYzEzSmVkWV9Ua0ZBYWdnUnhsNTJJRFJlVWFwWS1SNHo2b2dFcWNEa1FpNU9NYw&q=https%3A%2F%2Fgithub.com%2FAlexTheAnalyst%2FPortfolioProjects%2Fblob%2Fmain%2FCovidVaccinations.xlsx&v=qfyynHBFOsM */

-- Data Cleaning 

-- Creating shell tables to import data from Computer to Google Cloud SQL
CREATE TABLE PortfolioProjects.CovidDeaths (
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date TEXT,
    population TEXT,
    total_cases TEXT,
    new_cases TEXT,
    new_cases_smoothed TEXT,
    total_deaths TEXT,
    new_deaths TEXT,
    new_deaths_smoothed TEXT,
    total_cases_per_million TEXT,
    new_cases_per_million TEXT,
    new_cases_smoothed_per_million TEXT,
    total_deaths_per_million TEXT,
    new_deaths_per_million TEXT,
    new_deaths_smoothed_per_million TEXT,
    reproduction_rate TEXT,
    icu_patients TEXT,
    icu_patients_per_million TEXT,
    hosp_patients TEXT,
    hosp_patients_per_million TEXT,
    weekly_icu_admissions TEXT,
    weekly_icu_admissions_per_million TEXT,
    weekly_hosp_admissions TEXT,
    weekly_hosp_admissions_per_million TEXT
);

CREATE TABLE PortfolioProjects.CovidVaccinations (
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date TEXT,
    new_tests_per_thousand TEXT,
    new_tests TEXT,
    total_tests TEXT,
    total_tests_per_thousand TEXT,
    new_tests_smoothed TEXT,
    new_tests_smoothed_per_thousand TEXT,
    positive_rate TEXT,
    tests_per_case TEXT,
    tests_units TEXT,
    total_vaccinations TEXT,
    people_vaccinated TEXT,
    people_fully_vaccinated TEXT,
    new_vaccinations TEXT,
    new_vaccinations_smoothed TEXT,
    total_vaccinations_per_hundred TEXT,
    people_vaccinated_per_hundred TEXT,
    people_fully_vaccinated_per_hundred TEXT,
    new_vaccinations_smoothed_per_million TEXT,
    stringency_index TEXT,
    population_density TEXT,
    median_age TEXT,
    aged_65_older TEXT,
    aged_70_older TEXT,
    gdp_per_capita TEXT,
    extreme_poverty TEXT,
    cardiovasc_death_rate TEXT,
    diabetes_prevalence TEXT,
    female_smokers TEXT,
    male_smokers TEXT,
    handwashing_facilities TEXT,
    hospital_beds_per_thousand TEXT,
    life_expectancy TEXT,
    human_development_index TEXT
);

-- I imported the data folowing Google Cloud SQL's protocol
-- Remove imported Headers
SELECT * FROM CovidDeaths;

-- This removes the row where the 'date' column literally says the word "date"
DELETE FROM PortfolioProjects.CovidDeaths
WHERE date = 'date' OR iso_code = 'iso_code';

SELECT count(*) AS total_row_count FROM PortfolioProjects.CovidVaccinations;

Select * from CovidVaccinations;
delete from PortfolioProjects.CovidVaccinations
where date = 'date' OR iso_code = 'iso_code';


-- Pour data for CovidDeaths table

ALTER TABLE CovidDeaths
-- Date
ADD COLUMN date_temp DATE,
-- Whole or Decimals Numbers
ADD COLUMN population_new BIGINT,
ADD COLUMN total_cases_new BIGINT,
ADD COLUMN new_cases_new BIGINT,
ADD COLUMN new_cases_smoothed_new DOUBLE,	
ADD COLUMN total_deaths_new	BIGINT,
ADD COLUMN new_deaths_new	BIGINT,
ADD COLUMN new_deaths_smoothed_new DOUBLE,	
ADD COLUMN total_cases_per_million_new	DOUBLE,
ADD COLUMN new_cases_per_million_new	DOUBLE,
ADD COLUMN new_cases_smoothed_per_million_new DOUBLE,	
ADD COLUMN total_deaths_per_million_new	DOUBLE,
ADD COLUMN new_deaths_per_million_new	DOUBLE,
ADD COLUMN new_deaths_smoothed_per_million_new DOUBLE,	
ADD COLUMN reproduction_rate_new DOUBLE,
ADD COLUMN icu_patients_new	DOUBLE,
ADD COLUMN hosp_patients_new	DOUBLE,
ADD COLUMN icu_patients_per_million_new	DOUBLE,
ADD COLUMN hosp_patients_per_million_new DOUBLE,	
ADD COLUMN weekly_icu_admissions_new	BIGINT,
ADD COLUMN weekly_icu_admissions_per_million_new DOUBLE,	
ADD COLUMN weekly_hosp_admissions_new	DOUBLE,
ADD COLUMN weekly_hosp_admissions_per_million_new DOUBLE;

-- Update column values
UPDATE `CovidDeaths`
SET
-- Date
  `date_temp` = STR_TO_DATE(`date`, '%m/%d/%y'),
-- CHANGE: Using DOUBLE for columns that might have hidden decimals
  `population_new` = CAST(NULLIF(`population`, '') AS DOUBLE),
  `total_cases_new` = CAST(NULLIF(`total_cases`, '') AS DOUBLE),
  `new_cases_new` = CAST(NULLIF(`new_cases`, '') AS DOUBLE),
  `new_cases_smoothed_new` = CAST(NULLIF(`new_cases_smoothed`, '') AS DOUBLE),  
  `total_deaths_new` = CAST(NULLIF(`total_deaths`, '') AS DOUBLE),
  `new_deaths_new` = CAST(NULLIF(`new_deaths`, '') AS DOUBLE),
  `new_deaths_smoothed_new` = CAST(NULLIF(`new_deaths_smoothed`, '') AS DOUBLE),  
  `total_cases_per_million_new` = CAST(NULLIF(`total_cases_per_million`, '') AS DOUBLE),
  `new_cases_per_million_new` = CAST(NULLIF(`new_cases_per_million`, '') AS DOUBLE),
  `new_cases_smoothed_per_million_new` = CAST(NULLIF(`new_cases_smoothed_per_million`, '') AS DOUBLE),  
  `total_deaths_per_million_new` = CAST(NULLIF(`total_deaths_per_million`, '') AS DOUBLE),
  `new_deaths_per_million_new` = CAST(NULLIF(`new_deaths_per_million`, '') AS DOUBLE),
  `new_deaths_smoothed_per_million_new` = CAST(NULLIF(`new_deaths_smoothed_per_million`, '') AS DOUBLE),  
  `reproduction_rate_new` = CAST(NULLIF(`reproduction_rate`, '') AS DOUBLE),
  `icu_patients_new` = CAST(NULLIF(`icu_patients`, '') AS DOUBLE),
  `hosp_patients_new` = CAST(NULLIF(`hosp_patients`, '') AS DOUBLE),
  `icu_patients_per_million_new` = CAST(NULLIF(`icu_patients_per_million`, '') AS DOUBLE),
  `hosp_patients_per_million_new` = CAST(NULLIF(`hosp_patients_per_million`, '') AS DOUBLE),  
  `weekly_icu_admissions_new` = CAST(NULLIF(`weekly_icu_admissions`, '') AS DOUBLE),
  `weekly_icu_admissions_per_million_new` = CAST(NULLIF(`weekly_icu_admissions_per_million`, '') AS DOUBLE),  
  `weekly_hosp_admissions_new` = CAST(NULLIF(`weekly_hosp_admissions`, '') AS DOUBLE),
  `weekly_hosp_admissions_per_million_new` = CAST(NULLIF(`weekly_hosp_admissions_per_million`, '') AS DOUBLE);

-- 1. DROP THE OLD COLUMNS
ALTER TABLE `CovidDeaths` 
DROP COLUMN `date`, DROP COLUMN `population`, 
DROP COLUMN `total_cases`, 
DROP COLUMN `new_cases`, 
DROP COLUMN `new_cases_smoothed`, 
DROP COLUMN `total_deaths`, 
DROP COLUMN `new_deaths`, 
DROP COLUMN `new_deaths_smoothed`, 
DROP COLUMN `total_cases_per_million`, 
DROP COLUMN `new_cases_per_million`, 
DROP COLUMN `new_cases_smoothed_per_million`, 
DROP COLUMN `total_deaths_per_million`, 
DROP COLUMN `new_deaths_per_million`, 
DROP COLUMN `new_deaths_smoothed_per_million`, 
DROP COLUMN `reproduction_rate`, 
DROP COLUMN `icu_patients`, 
DROP COLUMN `hosp_patients`, 
DROP COLUMN `icu_patients_per_million`, 
DROP COLUMN `hosp_patients_per_million`, 
DROP COLUMN `weekly_icu_admissions`, 
DROP COLUMN `weekly_icu_admissions_per_million`, 
DROP COLUMN `weekly_hosp_admissions`, 
DROP COLUMN `weekly_hosp_admissions_per_million`;

-- 2. RENAME THE NEW COLUMNS
ALTER TABLE `CovidDeaths` 
RENAME COLUMN `date_temp` TO `date`,
RENAME COLUMN `population_new` TO `population`,
RENAME COLUMN `total_cases_new` TO `total_cases`,
RENAME COLUMN `new_cases_new` TO `new_cases`,
RENAME COLUMN `new_cases_smoothed_new` TO `new_cases_smoothed`,
RENAME COLUMN `total_deaths_new` TO `total_deaths`,
RENAME COLUMN `new_deaths_new` TO `new_deaths`,
RENAME COLUMN `new_deaths_smoothed_new` TO `new_deaths_smoothed`,
RENAME COLUMN `total_cases_per_million_new` TO `total_cases_per_million`,
RENAME COLUMN `new_cases_per_million_new` TO `new_cases_per_million`,
RENAME COLUMN `new_cases_smoothed_per_million_new` TO `new_cases_smoothed_per_million`,
RENAME COLUMN `total_deaths_per_million_new` TO `total_deaths_per_million`,
RENAME COLUMN `new_deaths_per_million_new` TO `new_deaths_per_million`,
RENAME COLUMN `new_deaths_smoothed_per_million_new` TO `new_deaths_smoothed_per_million`,
RENAME COLUMN `reproduction_rate_new` TO `reproduction_rate`,
RENAME COLUMN `icu_patients_new` TO `icu_patients`,
RENAME COLUMN `hosp_patients_new` TO `hosp_patients`,
RENAME COLUMN `icu_patients_per_million_new` TO `icu_patients_per_million`,
RENAME COLUMN `hosp_patients_per_million_new` TO `hosp_patients_per_million`,
RENAME COLUMN `weekly_icu_admissions_new` TO `weekly_icu_admissions`,
RENAME COLUMN `weekly_icu_admissions_per_million_new` TO `weekly_icu_admissions_per_million`,
RENAME COLUMN `weekly_hosp_admissions_new` TO `weekly_hosp_admissions`,
RENAME COLUMN `weekly_hosp_admissions_per_million_new` TO `weekly_hosp_admissions_per_million`;

-- Pour Data for CovidVaccinations table
-- Create temp columns
ALTER TABLE CovidVaccinations
ADD COLUMN date_temp DATE,
ADD COLUMN total_tests_new DOUBLE,
ADD COLUMN new_tests_new DOUBLE,
ADD COLUMN total_tests_per_thousand_new DOUBLE,
ADD COLUMN new_tests_per_thousand_new DOUBLE,
ADD COLUMN new_tests_smoothed_new DOUBLE,
ADD COLUMN new_tests_smoothed_per_thousand_new DOUBLE,
ADD COLUMN positive_rate_new DOUBLE,
ADD COLUMN tests_per_case_new DOUBLE,
ADD COLUMN total_vaccinations_new DOUBLE,
ADD COLUMN people_vaccinated_new DOUBLE,
ADD COLUMN people_fully_vaccinated_new DOUBLE,
ADD COLUMN new_vaccinations_new DOUBLE,
ADD COLUMN new_vaccinations_smoothed_new DOUBLE,
ADD COLUMN total_vaccinations_per_hundred_new DOUBLE,
ADD COLUMN people_vaccinated_per_hundred_new DOUBLE,
ADD COLUMN people_fully_vaccinated_per_hundred_new DOUBLE,
ADD COLUMN new_vaccinations_smoothed_per_million_new DOUBLE,
ADD COLUMN stringency_index_new DOUBLE,
ADD COLUMN population_density_new DOUBLE,
ADD COLUMN median_age_new DOUBLE,
ADD COLUMN aged_65_older_new DOUBLE,
ADD COLUMN aged_70_older_new DOUBLE,
ADD COLUMN gdp_per_capita_new DOUBLE,
ADD COLUMN extreme_poverty_new DOUBLE,
ADD COLUMN cardiovasc_death_rate_new DOUBLE,
ADD COLUMN diabetes_prevalence_new DOUBLE,
ADD COLUMN female_smokers_new DOUBLE,
ADD COLUMN male_smokers_new DOUBLE,
ADD COLUMN handwashing_facilities_new DOUBLE,
ADD COLUMN hospital_beds_per_thousand_new DOUBLE,
ADD COLUMN life_expectancy_new DOUBLE,
ADD COLUMN human_development_index_new DOUBLE;

-- Update column values
UPDATE `CovidVaccinations`
SET
  `date_temp` = STR_TO_DATE(`date`, '%m/%d/%y'),
  `total_tests_new` = CAST(NULLIF(`total_tests`, '') AS DOUBLE),
  `new_tests_new` = CAST(NULLIF(`new_tests`, '') AS DOUBLE),
  `total_tests_per_thousand_new` = CAST(NULLIF(`total_tests_per_thousand`, '') AS DOUBLE),
  `new_tests_per_thousand_new` = CAST(NULLIF(`new_tests_per_thousand`, '') AS DOUBLE),
  `new_tests_smoothed_new` = CAST(NULLIF(`new_tests_smoothed`, '') AS DOUBLE),
  `new_tests_smoothed_per_thousand_new` = CAST(NULLIF(`new_tests_smoothed_per_thousand`, '') AS DOUBLE),
  `positive_rate_new` = CAST(NULLIF(`positive_rate`, '') AS DOUBLE),
  `tests_per_case_new` = CAST(NULLIF(`tests_per_case`, '') AS DOUBLE),
  `total_vaccinations_new` = CAST(NULLIF(`total_vaccinations`, '') AS DOUBLE),
  `people_vaccinated_new` = CAST(NULLIF(`people_vaccinated`, '') AS DOUBLE),
  `people_fully_vaccinated_new` = CAST(NULLIF(`people_fully_vaccinated`, '') AS DOUBLE),
  `new_vaccinations_new` = CAST(NULLIF(`new_vaccinations`, '') AS DOUBLE),
  `new_vaccinations_smoothed_new` = CAST(NULLIF(`new_vaccinations_smoothed`, '') AS DOUBLE),
  `total_vaccinations_per_hundred_new` = CAST(NULLIF(`total_vaccinations_per_hundred`, '') AS DOUBLE),
  `people_vaccinated_per_hundred_new` = CAST(NULLIF(`people_vaccinated_per_hundred`, '') AS DOUBLE),
  `people_fully_vaccinated_per_hundred_new` = CAST(NULLIF(`people_fully_vaccinated_per_hundred`, '') AS DOUBLE),
  `new_vaccinations_smoothed_per_million_new` = CAST(NULLIF(`new_vaccinations_smoothed_per_million`, '') AS DOUBLE),
  `stringency_index_new` = CAST(NULLIF(`stringency_index`, '') AS DOUBLE),
  `population_density_new` = CAST(NULLIF(`population_density`, '') AS DOUBLE),
  `median_age_new` = CAST(NULLIF(`median_age`, '') AS DOUBLE),
  `aged_65_older_new` = CAST(NULLIF(`aged_65_older`, '') AS DOUBLE),
  `aged_70_older_new` = CAST(NULLIF(`aged_70_older`, '') AS DOUBLE),
  `gdp_per_capita_new` = CAST(NULLIF(`gdp_per_capita`, '') AS DOUBLE),
  `extreme_poverty_new` = CAST(NULLIF(`extreme_poverty`, '') AS DOUBLE),
  `cardiovasc_death_rate_new` = CAST(NULLIF(`cardiovasc_death_rate`, '') AS DOUBLE),
  `diabetes_prevalence_new` = CAST(NULLIF(`diabetes_prevalence`, '') AS DOUBLE),
  `female_smokers_new` = CAST(NULLIF(`female_smokers`, '') AS DOUBLE),
  `male_smokers_new` = CAST(NULLIF(`male_smokers`, '') AS DOUBLE),
  `handwashing_facilities_new` = CAST(NULLIF(`handwashing_facilities`, '') AS DOUBLE),
  `hospital_beds_per_thousand_new` = CAST(NULLIF(`hospital_beds_per_thousand`, '') AS DOUBLE),
  `life_expectancy_new` = CAST(NULLIF(`life_expectancy`, '') AS DOUBLE),
  `human_development_index_new` = CAST(NULLIF(`human_development_index`, '') AS DOUBLE);

-- Drop original columns
ALTER TABLE `CovidVaccinations` 
DROP COLUMN `date`, 
DROP COLUMN `total_tests`, 
DROP COLUMN `new_tests`, 
DROP COLUMN `total_tests_per_thousand`, 
DROP COLUMN `new_tests_per_thousand`, 
DROP COLUMN `new_tests_smoothed`, 
DROP COLUMN `new_tests_smoothed_per_thousand`, 
DROP COLUMN `positive_rate`, 
DROP COLUMN `tests_per_case`, 
DROP COLUMN `total_vaccinations`, 
DROP COLUMN `people_vaccinated`, 
DROP COLUMN `people_fully_vaccinated`, 
DROP COLUMN `new_vaccinations`, 
DROP COLUMN `new_vaccinations_smoothed`, 
DROP COLUMN `total_vaccinations_per_hundred`, 
DROP COLUMN `people_vaccinated_per_hundred`, 
DROP COLUMN `people_fully_vaccinated_per_hundred`, 
DROP COLUMN `new_vaccinations_smoothed_per_million`, 
DROP COLUMN `stringency_index`, 
DROP COLUMN `population_density`, 
DROP COLUMN `median_age`, 
DROP COLUMN `aged_65_older`, 
DROP COLUMN `aged_70_older`, 
DROP COLUMN `gdp_per_capita`, 
DROP COLUMN `extreme_poverty`, 
DROP COLUMN `cardiovasc_death_rate`, 
DROP COLUMN `diabetes_prevalence`, 
DROP COLUMN `female_smokers`, 
DROP COLUMN `male_smokers`, 
DROP COLUMN `handwashing_facilities`, 
DROP COLUMN `hospital_beds_per_thousand`, 
DROP COLUMN `life_expectancy`, 
DROP COLUMN `human_development_index`;

-- Update temp columns to final columns
ALTER TABLE `CovidVaccinations` 
RENAME COLUMN `date_temp` TO `date`,
RENAME COLUMN `total_tests_new` TO `total_tests`,
RENAME COLUMN `new_tests_new` TO `new_tests`,
RENAME COLUMN `total_tests_per_thousand_new` TO `total_tests_per_thousand`,
RENAME COLUMN `new_tests_per_thousand_new` TO `new_tests_per_thousand`,
RENAME COLUMN `new_tests_smoothed_new` TO `new_tests_smoothed`,
RENAME COLUMN `new_tests_smoothed_per_thousand_new` TO `new_tests_smoothed_per_thousand`,
RENAME COLUMN `positive_rate_new` TO `positive_rate`,
RENAME COLUMN `tests_per_case_new` TO `tests_per_case`,
RENAME COLUMN `total_vaccinations_new` TO `total_vaccinations`,
RENAME COLUMN `people_vaccinated_new` TO `people_vaccinated`,
RENAME COLUMN `people_fully_vaccinated_new` TO `people_fully_vaccinated`,
RENAME COLUMN `new_vaccinations_new` TO `new_vaccinations`,
RENAME COLUMN `new_vaccinations_smoothed_new` TO `new_vaccinations_smoothed`,
RENAME COLUMN `total_vaccinations_per_hundred_new` TO `total_vaccinations_per_hundred`,
RENAME COLUMN `people_vaccinated_per_hundred_new` TO `people_vaccinated_per_hundred`,
RENAME COLUMN `people_fully_vaccinated_per_hundred_new` TO `people_fully_vaccinated_per_hundred`,
RENAME COLUMN `new_vaccinations_smoothed_per_million_new` TO `new_vaccinations_smoothed_per_million`,
RENAME COLUMN `stringency_index_new` TO `stringency_index`,
RENAME COLUMN `population_density_new` TO `population_density`,
RENAME COLUMN `median_age_new` TO `median_age`,
RENAME COLUMN `aged_65_older_new` TO `aged_65_older`,
RENAME COLUMN `aged_70_older_new` TO `aged_70_older`,
RENAME COLUMN `gdp_per_capita_new` TO `gdp_per_capita`,
RENAME COLUMN `extreme_poverty_new` TO `extreme_poverty`,
RENAME COLUMN `cardiovasc_death_rate_new` TO `cardiovasc_death_rate`,
RENAME COLUMN `diabetes_prevalence_new` TO `diabetes_prevalence`,
RENAME COLUMN `female_smokers_new` TO `female_smokers`,
RENAME COLUMN `male_smokers_new` TO `male_smokers`,
RENAME COLUMN `handwashing_facilities_new` TO `handwashing_facilities`,
RENAME COLUMN `hospital_beds_per_thousand_new` TO `hospital_beds_per_thousand`,
RENAME COLUMN `life_expectancy_new` TO `life_expectancy`,
RENAME COLUMN `human_development_index_new` TO `human_development_index`;

-- Data Exploration

SELECT * 
From PortfolioProjects.CovidDeaths
Where continent is not null
Order by 3,4;

SELECT * 
From PortfolioProjects.CovidVaccinations
order by 3, 4;

-- Select Data that we are going to be using
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects.CovidDeaths
Order By 1, 2;

-- Looking at total Cases vs Total Deaths per Country
-- Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProjects.CovidDeaths
Where location like '%state%'
Order By 1, 2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population contracted Covid
Select location, date, population, total_cases, (total_cases/population)*100 as PercentInfected
From PortfolioProjects.CovidDeaths
Where location like '%states%'
Order By 1,2;

-- Looking at Countries with Highest Infection Rate compared to Population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentInfected
From PortfolioProjects.CovidDeaths
-- Where location like '%states%'
Group by Location, Population
Order By PercentInfected desc;

-- Showing Countries with Highest Death Count per Population
-- cast as int in SQL, but in mySQL cast as signed for pos and unsigned for neg 
Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProjects.CovidDeaths
Where continent is not null
Group by location
Order By TotalDeathCount desc
Limit 1000000 offset 4;

-- LET'S BREAK THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProjects.CovidDeaths
Where continent IS NOT NULL AND continent != '' -- Checks for both true nulls
Group by continent 
Order By TotalDeathCount desc;

-- Global Numbers
Select date, SUM(total_cases) as TotalCases, 
SUM(new_cases) as TotalNewCases, 
SUM(new_deaths) as NewDeaths, 
SUM(new_deaths)/SUM(new_cases)* 100 as TotalDeathPercentage
From PortfolioProjects.CovidDeaths
Where continent IS NOT NULL AND continent != ''
Group By date
Order By 1,2;

-- Joining our Covid Deaths table and Covid Vaccinations table
Select *
From PortfolioProjects.CovidDeaths dea
Join PortfolioProjects.CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date;

-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProjects.CovidDeaths dea
Join PortfolioProjects.CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent != ''
Order By 2,3;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS DECIMAL(20,2))) OVER (Partition by dea.location Order By dea.location, 
	dea.date) as RollingPeopleVaccinated -- only run sum by country
From PortfolioProjects.CovidDeaths dea
Join PortfolioProjects.CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date
WHERE vac.new_vaccinations IS NOT NULL and dea.continent != ''
Order By 2,3;

-- Advanced Logic

-- USE CTE 
-- Remeber column ordering must match in the 'With' and 'SELECT statements'
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS DECIMAL(20,2))) OVER (Partition by dea.location Order By dea.location, 
	dea.date) as RollingPeopleVaccinated -- only run sum by country
From PortfolioProjects.CovidDeaths dea
Join PortfolioProjects.CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date
-- WHERE vac.new_vaccinations IS NOT NULL and dea.continent != ''
Where dea.continent is not null or dea.continent != ''
)
Select *, (RollingPeopleVaccinated/population) * 100
From PopvsVac;


-- Temp Table
DROP Table if exists PercentPopulationVaccinated;
CREATE Table PercentPopulationVaccinated
(
  `continent` TEXT,
  `location` TEXT,
  `date` DATE,
  `population` DOUBLE,
  `new_vaccinations` DOUBLE,
  `RollingPeopleVaccinated` DOUBLE
);

Insert into PercentPopulationVaccinated
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS DECIMAL(20,2))) OVER (Partition by dea.location Order By dea.location, 
	dea.date) as RollingPeopleVaccinated -- only run sum by country
From PortfolioProjects.CovidDeaths dea
Join PortfolioProjects.CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date;
-- WHERE vac.new_vaccinations IS NOT NULL and dea.continent != ''
-- Where dea.continent is not null or dea.continent != ''

Select *, (RollingPeopleVaccinated/population) * 100
From PercentPopulationVaccinated;

-- Final View
-- Create View to store date for later visualizations
DROP Table IF EXISTS PortfolioProjects.PercentPopulationVaccinated;

CREATE VIEW PortfolioProjects.PercentPopulationVaccinated AS
Select 
  dea.continent, 
  dea.location, 
  dea.date, 
  dea.population, 
  vac.new_vaccinations, 
  SUM(CAST(vac.new_vaccinations AS DECIMAL(20,2))) OVER (Partition by dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated -- only run sum by country
From PortfolioProjects.CovidDeaths dea
Join PortfolioProjects.CovidVaccinations vac
	On dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null or dea.continent != '';

Select * From PortfolioProjects.PercentPopulationVaccinated 

