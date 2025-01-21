--Project Title: COVID-19 Vaccination and Population Analysis:
--Objective:
--To showcase SQL skills by performing advanced data analysis on COVID-19 vaccination and population datasets, focusing on:
--1. Tracking vaccination progress on a daily basis.
--2. Calculating rolling totals of vaccinations for specific countries.
--3. Analyzing the percentage of the population vaccinated over time.
--4. Demonstrating SQL techniques like window functions, joins, and grouping. 
 
--1.View the tables first 20 rows to get ideas and details about data

 SELECT TOP 20 *
FROM CovidDeaths$;

SELECT TOP 20 *
FROM CovidVaccinations$;

 --2.this query show how many COVID-19 total deaths were recorded in Kazakhstan?
 
SELECT location, max(CONVERT(int, (ISNULL(total_deaths, 0)))) as total_death
FROM CovidDeaths$
where location = 'Kazakhstan'  --here it is not that necessary to get rid of null(optional)
group by location;

SELECT max(cast(Total_deaths as int)) as total_deaths
FROM CovidDeaths$
WHERE location = 'Kazakhstan'; --short way 

 --3.finding how many COVID-19 total cases were recorded in Kazakhstan and India?

 select location, max(total_cases) as num_total_case
 from CovidDeaths$
 where location = 'Kazakhstan'
 group by location;

  SELECT max(cast(total_cases as int)) as total_cases
FROM CovidDeaths$
WHERE location = 'India';

 --4.this query shows Which country has the highest number of COVID-19 cases by the end of 2020.

 SELECT TOP 1 location, max(total_cases) AS total_Covid_cases
FROM CovidDeaths$
WHERE date <= '2020-12-31' and location not in ('World', 'Asia', 'Europe', 'European Union', 'northe america')
GROUP BY location
ORDER BY total_Covid_cases DESC;

SELECT TOP 1 location,max(cast(total_cases as int)) as max_cases
FROM CovidDeaths$
WHERE date <= '2020-12-31' and location not in ('World','Europe','North America','Asia','South America','European Union','Africa','United Kingdom')
group by location
order by max_cases desc;


--5. This query calculates the death percentage due to COVID-19 for the location Kazakhstan.
It retrieves and orders the data by location and date.
SELECT 
    location, 
    date, 
    total_deaths, 
    total_cases, 
    ROUND((ISNULL(total_deaths, 0)) / (total_cases) * 100, 2) AS Death_Percentage
FROM 
    CovidDeaths$
WHERE 
    location = 'Kazakhstan'
ORDER BY 
    location, date;
--This query calculates the death percentage due to COVID-19 for locations that include "states" in their names.
It excludes data where the continent information is missing.
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM 
    CovidDeaths$
WHERE 
    location LIKE '%states%' 
    AND continent IS NOT NULL
ORDER BY 
    location, date;

--6. This query calculates the likelihood of dying (Death Percentage) due to COVID-19 for India, grouped by month and year.
SELECT 
    location, 
    FORMAT(date, 'MM-yyyy') AS months,  
    ROUND(SUM(total_deaths) / SUM(total_cases) * 100, 2) AS Death_Percentage
FROM 
    CovidDeaths$
WHERE 
    location = 'India'
GROUP BY 
    location, FORMAT(date, 'MM-yyyy')
ORDER BY 
    FORMAT(date, 'MM-yyyy');
--
SELECT 
    location, 
    FORMAT(date, 'MM-yyyy') AS months, 
    ROUND(SUM(total_cases) / NULLIF(SUM(total_deaths), 0) * 100, 2) AS CaseToDeath_Ratio
FROM 
    CovidDeaths$
WHERE 
    location LIKE '%states%' 
    AND continent IS NOT NULL
GROUP BY 
    location, FORMAT(date, 'MM-yyyy')
ORDER BY 
    location, FORMAT(date, 'MM-yyyy');


--7.this query Shows what percentage of population infected with Covid

SELECT 
    location, 
    population, 
    MAX((total_cases / population) * 100) AS percentage_infected_worldwide
FROM 
    CovidDeaths$
GROUP BY 
    location, population
ORDER BY 
    percentage_infected_worldwide DESC;

--8.alculates the percentage of the population infected in each country and highest infection count  

SELECT 
    location, 
    population, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases / population) * 100) AS PercentPopulationInfected
FROM 
    CovidDeaths$
GROUP BY 
    location, population
ORDER BY 
    PercentPopulationInfected DESC;

--9. This query finds the country with the highest total death count ever recorded due to COVID-19 for each location.

SELECT 
    location, 
    MAX(CAST(total_deaths AS INT)) AS highest_death
FROM 
    CovidDeaths$
WHERE 
    continent IS NOT NULL
GROUP BY 
    location
ORDER BY 
    highest_death DESC;


--10. This query is designed to identify the Top 10 countries with the highest vaccination rates based on the percentage of people fully vaccinated.

SELECT TOP 10 
    location, 
    MAX(people_fully_vaccinated_per_hundred) AS vaccination_per_hundred
FROM 
    CovidVaccinations$
WHERE 
    people_fully_vaccinated_per_hundred IS NOT NULL
GROUP BY 
    location
ORDER BY 
    MAX(people_fully_vaccinated_per_hundred) DESC;

--11.This query effectively identifies the continents most impacted by COVID-19 in terms of death counts. 

SELECT 
    continent, 
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount,
    SUM(CAST(total_cases AS INT)) AS TotalCases
FROM 
    CovidDeaths$
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent
ORDER BY 
    TotalDeathCount DESC;

--12. These queries calculate the rolling total of vaccinations for Kazakhstan and provide insights 
into the percentage of the population that has received at least one COVID-19 vaccine. 

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(INT, vac.new_vaccinations)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.location, dea.date
    ) AS RollingPeopleVaccinated
FROM 
    CovidDeaths$ dea
JOIN 
    CovidVaccinations$ vac
    ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL 
    AND dea.location = 'Kazakhstan'
ORDER BY 
    dea.location, dea.date;
