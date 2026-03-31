# COVID-19 Data Exploration Project

## Project Overview
This project involves a comprehensive exploratory data analysis (EDA) of global COVID-19 datasets using **SQL (Google Cloud SQL/MySQL)**. The objective was to transform raw, semi-structured CSV data into a relational database schema to uncover trends in infection rates, mortality, and the global rollout of vaccinations. The project spans the entire data pipeline: from initial schema design and data cleaning to complex multi-table joins and the creation of analytical views for downstream visualization.

---

## Data Sources
The primary dataset used for this analysis was sourced from **[Our World in Data](https://ourworldindata.org/covid-deaths)**, containing daily updated metrics on cases, deaths, hospitalizations, and vaccinations for over 200 countries and territories.
The Covid Deaths dataset can be found here: **[Covid Deaths](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbFFJVjFjZ3NWbVZSU1duemNJMjVmMURIV2xRQXxBQ3Jtc0tteGN2czI4M19HTEljX05Sa000Qlo3N3dvZFRzaGN6cVVPT0h2Z0NPOE9rLVJraGVDQV84MkJRRGc0UTl6WGlKejNXNTNwTThIbGctVGdJcXVEQnR6dXJNYkNPdnFBZ0d0X2JFMlJPMGNJSk51RXdWSQ&q=https%3A%2F%2Fgithub.com%2FAlexTheAnalyst%2FPortfolioProjects%2Fblob%2Fmain%2FCovidDeaths.xlsx&v=qfyynHBFOsM)**
The Covid Vaccinations dataset can be found here: **[Covid Deaths](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa3BZTGFwSW5nM3JEUDl5WFVQd1BWUzdXWTJJd3xBQ3Jtc0tsMW41dGdSTnNrMllJTDdYN3hCT1ZiczlyZXZ1OWxGdUExUTRsT3hTR3JUdXpURHhRZl9pVTQ0V21fakpERXRMSC1yYzEzSmVkWV9Ua0ZBYWdnUnhsNTJJRFJlVWFwWS1SNHo2b2dFcWNEa1FpNU9NYw&q=https%3A%2F%2Fgithub.com%2FAlexTheAnalyst%2FPortfolioProjects%2Fblob%2Fmain%2FCovidVaccinations.xlsx&v=qfyynHBFOsM)**
---

## Skills Demonstrated
* **Joins & CTEs:** Utilized Inner and Left Joins to combine disparate datasets and leveraged Common Table Expressions (CTEs) to perform multi-step calculations on temporary result sets.
* **Window Functions (`PARTITION BY`):** Applied advanced window functions to calculate rolling sums of vaccinations and deaths across specific geographic locations over time.
* **Data Type Transformations (`CAST`, `STR_TO_DATE`):** Cleaned and standardized raw data by converting string-based dates and numeric values into proper `DATE` and `DOUBLE` formats for accurate mathematical processing.
* **Creating Views for Visualization:** Engineered permanent database Views to store complex join logic, providing a streamlined reporting layer for tools like Tableau or Power BI.
* **Schema Architecture:** Designed and executed `ALTER` and `UPDATE` scripts to refactor database tables, ensuring data integrity and optimized query performance.

---

## Key Insights
* **Vaccination Momentum:** By calculating the **Rolling People Vaccinated** versus total population, I identified significant lead-lag relationships between the start of national vaccination campaigns and the subsequent stabilization of death percentages.
* **Data Disparity:** The analysis revealed a high variance in reporting frequency between developed and developing nations, specifically regarding "New Tests" versus "New Cases," highlighting the importance of using `NULLIF` and `COALESCE` logic to handle missing data points in global health metrics.
