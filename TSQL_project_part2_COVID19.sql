--Queries:
--1.View the tables first 20 rows to get idea and details about data
select TOP 10 *
from CovidDeaths$;

select TOP 20 *
from CovidVaccinations$;

 --2.How many COVID-19 total deaths were recorded in a particular country?
 --(Use - Anyone of the country)
 --- in this data base the death number or case number increases by adds up the previous one 
 --that means the last coulumn is the max number of the deaths and cases
 --so we cannot use the sum funtion here
SELECT location, max(CONVERT(int, (ISNULL(total_deaths, 0)))) as total_death
FROM CovidDeaths$
where location = 'Kazakhstan' ---my way  --here it is not that necessary to get rid of null(optional)
group by location;

SELECT max(cast(Total_deaths as int)) as total_deaths
FROM CovidDeaths$
WHERE location = 'India'; --instructor


 --3.How many COVID-19 total cases were recorded in a particular country?

 select location, max(total_cases) as num_total_case
 from CovidDeaths$
 where location = 'Kazakhstan'
 group by location;

  SELECT max(cast(total_cases as int)) as total_cases
FROM CovidDeaths$
WHERE location = 'India';

 --4.Which country has the highest number of COVID-19 cases by the end of 2020?.
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


--5. Shows likelihood of dying if you contract covid in your country on 
--daily basis - select your country in location filter (Death Percentage)

select location, date, total_deaths, total_cases, round((isnull(total_deaths, 0))/(total_cases)*100,2) as Death_Percentage
From CovidDeaths$
where location = 'Kazakhstan' 
order by location, date; 

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
Where location like '%states%'
and continent is not null 
order by Location, date;


--6.Shows likelihood of dying if you contract covid in your country on 
--monthly basis and investigate further if you receive any unexplained value
--select your country in location filter - Use format function to change 
--regular date into Month year format
select location, FORMAT(date, 'MM-yyyy') as months,  
round((total_deaths)/(total_cases)*100, 2) as Death_Percentage
from CovidDeaths$
where location = 'India';
--group by location, FORMAT(date, 'mm-yyyy'); 

Select Location, FORMAT(date, 'MM-yyyy'), (total_cases)/(total_deaths)*100 as DeathPercentage
From CovidDeaths$
Where location like '%states%' and continent is not null
group by Location,FORMAT(date, 'MM-yyyy')
order by Location, FORMAT(date, 'MM-yyyy');


select format(date,'dd-mm-yyyy')
from CovidDeaths$;


--7.Shows what percentage of population infected with Covid
select location, population, max((total_cases/population))*100 as percentage_infected_worldwide
from CovidDeaths$
group by location, population
order by percentage_infected_worldwide DESC;


--8.Show countries with Highest Infection Rate compared to Population

Select location, Population,  Max((total_cases/population))*100 as worldwide_infected_percentage
From CovidDeaths$
Group by Location, Population
Order by worldwide_infected_percentage DESC;

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc;

--9.Show countries with Highest Death Count ever
 select location, max(cast(total_deaths as int)) as highest_death
 from CovidDeaths$
  where continent is not null
 group by location
 order by highest_death DESC;

 Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
Where continent is not null 
Group by Location
order by TotalDeathCount desc;


 --10.	Which Top 10  country has the highest vaccination rate?
  
 select Top 10 location, max(people_fully_vaccinated_per_hundred) as vaccination_per_thousand
from CovidVaccinations$
group by location
order by max(people_fully_vaccinated_per_hundred) desc;


 --11.	Showing continents with the highest death count ever
 select continent, max(cast(total_deaths as int)) as highest_deaths
 from CovidDeaths$
 where continent is not null
 group by continent
 order by highest_deaths desc;

 Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
Where continent is not null 
Group by continent
order by TotalDeathCount desc;


 -- 12.	Shows Percentage of Population that has received at least one Covid Vaccine
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location and dea.date = vac.date
where dea.continent is not null and dea.location = 'Kazakhstan'
order by dea.location,dea.date;


 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location and dea.date = vac.date
where dea.continent is not null and dea.location = 'India'
order by dea.location,dea.date;

