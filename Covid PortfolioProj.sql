--SELECT * 
--FROM CovidDeaths
--WHERE Continent os not NULL
--ORDER BY 3,4

--SELECT * 
--FROM CovidVaccinations
--ORDER BY 3,4

--Select Data that we are going to be using

--SELECT Location, 
--date, 
--total_cases,
--new_cases,
--total_deaths,
--population
--FROM CovidDeaths
--ORDER By 1,2

--Total Cases vs Total Deaths--


--SELECT Location, 
--date, 
--total_cases,
--total_deaths,
--(total_deaths/total_cases) * 100 as DeathPercentage
--FROM CovidDeaths
--WHERE location LIKE '%states%'
--ORDER By 1,2

--Total Cases VS Popluation in the US
--SELECT Location, 
--date, 
--total_cases,
--population,
--(total_cases/population) * 100 as PopulationPercentage
--FROM CovidDeaths
--WHERE location LIKE '%states%'
--ORDER By 1,2

--Total Cases VS Population 
--SELECT Location, 
--date, 
--total_cases,
--population,
--(total_cases/population) * 100 as PopulationPercentageInfected
--FROM CovidDeaths
----WHERE location LIKE '%states%'--
--ORDER By 1,2

----Countries with highest rates
--SELECT Location,  
--population,
--MAX(total_cases) as HighestInfectionCount,
--MAX((total_cases/population)) * 100 as PopulationPercentageInfected
--FROM CovidDeaths
----WHERE location LIKE '%states%'--
--GROUP BY location, population
--ORDER By PopulationPercentageInfected DESC

--Shows Countries with highest death count per population
--SELECT Location,  
--MAX(cast(total_deaths as int)) as TotalDeathCount
--FROM CovidDeaths
----WHERE location LIKE '%states%'--
--WHERE continent is NOT NULL
--GROUP BY location
--ORDER By TotalDeathCount DESC

----By Continent

--SELECT continent,  
--MAX(cast(total_deaths as int)) as TotalDeathCount
--FROM CovidDeaths
---WHERE location LIKE '%states%'--
--WHERE continent is NOT NULL
--GROUP BY continent
--ORDER By TotalDeathCount DESC

--By location with Null
--SELECT location,  
--MAX(cast(total_deaths as int)) as TotalDeathCount
--FROM CovidDeaths
----WHERE location LIKE '%states%'--
--WHERE continent is NULL
--GROUP BY location
--ORDER By TotalDeathCount DESC

--SELECT continent,  
--MAX(cast(total_deaths as int)) as TotalDeathCount
--FROM CovidDeaths
----WHERE location LIKE '%states%'--
--WHERE continent is NOT NULL
--GROUP BY continent
--ORDER By TotalDeathCount DESC


--Global numbers
--SELECT 
--date, 
--SUM(new_cases) as TotalCases,
--SUM(cast(new_deaths as int)) as TotalDeaths,
--SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as TotalDeathPercentage
--FROM CovidDeaths
--WHERE continent is NOT NULL
--Group By date
--ORDER By 1,2


-- Global numbers Total Cases
--SELECT  
--SUM(new_cases) as TotalCases,
--SUM(cast(new_deaths as int)) as TotalDeaths,
--SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as TotalDeathPercentage
--FROM CovidDeaths
--WHERE continent is NOT NULL
--ORDER By 1,2


--Join
SELECT *
FROM CovidDeaths dea
Join CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date

--Total population vs vaccination
--SELECT dea.continent, 
--dea.location, 
--dea.date, 
--dea.population,
--vac.new_vaccinations
--FROM CovidDeaths dea
--Join CovidVaccinations vac
--ON dea.location = vac.location 
--AND dea.date = vac.date
--WHERE dea.continent is NOT NULL
--ORDER BY 2, 3

--SUM total population vs vaccination
--SELECT dea.continent, 
--dea.location, 
--dea.date, 
--dea.population,
--vac.new_vaccinations as int,
--SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingpeopleVaccinated

--FROM CovidDeaths dea
--Join CovidVaccinations vac
--ON dea.location = vac.location 
--AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2, 3


----USE CTE
--With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--SELECT dea.continent, 
--dea.location, 
--dea.date, 
--dea.population,
--vac.new_vaccinations as int,
--SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingpeopleVaccinated

--FROM CovidDeaths dea
--Join CovidVaccinations vac
--ON dea.location = vac.location 
--AND dea.date = vac.date
--WHERE dea.continent is not null
----ORDER BY 2, 3
--)
--SELECT *, (RollingPeopleVaccinated/Population) * 100
--FROM PopVsVac

----TEMP Table

--DROP Table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--date datetime,
--population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)


--Insert into #PercentPopulationVaccinated
--SELECT dea.continent, 
--dea.location, 
--dea.date, 
--dea.population,
--vac.new_vaccinations,
--SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated

--FROM CovidDeaths dea
--Join CovidVaccinations vac
--ON dea.location = vac.location 
--AND dea.date = vac.date
----WHERE dea.continent is not null
----ORDER BY 2, 3

--SELECT *, (RollingPeopleVaccinated/Population) * 100
--FROM #PercentPopulationVaccinated


--View
--SELECT  
--SUM(new_cases) as TotalCases,
--SUM(cast(new_deaths as int)) as TotalDeaths,
--SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as TotalDeathPercentage
--FROM CovidDeaths
--WHERE continent is NOT NULL
--ORDER By 1,2

Create View PercentPopulationVaccinated as
SELECT dea.continent, 
dea.location, 
dea.date, 
dea.population,
vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated

FROM CovidDeaths dea
Join CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3