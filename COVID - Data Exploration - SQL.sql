

--SELECT *
--FROM PortfolioProject..Covid_Deaths
--ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..Covid_Vaccinations
--ORDER BY 3,4


/* 
-- Looking at Total cases Vs Population
-- Calculating Infection Percentage in India [InfectedPercentage]
-- Shows Percentage of Population Infected by Covid 19 in India
*/

SELECT location, date, total_cases,  population, (total_cases/population)*100 AS InfectedPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location LIKE '%India%'
ORDER BY 1,2


/* 
-- Looking at Total Cases Vs Total Deaths
-- Calculating Death Percentage in India
-- Shows Likelihood of Death Due to Covid 19 Infection in India
*/

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location LIKE '%India%'
ORDER BY 1,2



/*
-- Showing Countries with Highest Infection Rate Compared to population
*/

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS InfectionPercentage
FROM PortfolioProject..Covid_Deaths
--WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY InfectionPercentage DESC


/*
-- Showing Countries with Highest Death Count Compared to Population
*/

SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


/*
-- Showing Continents with the Highest Death Rate Compared to Population
*/

SELECT location, SUM(cast(new_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NULL
and location not in ('World', 'Upper middle income', 'High income', 'Lower middle income', 'European Union', 'Low income', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC


/* -- Showing Daily Global Numbers */

SELECT date, SUM(new_cases) AS TotalCases, SUM(cast(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


/* -- Showing Total Global Numbers */

SELECT SUM(new_cases) AS TotalCases, SUM(cast(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2


/* -- Looking at Total Population Vs Vaccinations*/

With PopVsVac (continent, location, date, population, new_vaccinations, Cumalative_Vaccinations) as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Cumalative_Vaccinations
FROM PortfolioProject..Covid_Deaths as dea
JOIN PortfolioProject..Covid_Vaccinations as vac
		ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (Cumalative_Vaccinations/population)*100 as Vac_Percent
FROM PopVsVac




/*
Creating View to Store Data for later Vizualitions
*/

CREATE VIEW PercentVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Cumalative_Vaccinations
FROM PortfolioProject..Covid_Deaths as dea
JOIN PortfolioProject..Covid_Vaccinations as vac
		ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


SELECT *
FROM PercentVaccinated


