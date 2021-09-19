select *
from PortfolioProject..CovidDeath$
where continent is not null
order by 3,4


select *
from PortfolioProject..CovidVaccinations$
order by 3,4



-- Here we select a Data that we are going to be used
select location,date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeath$
where continent is not null
order by 1,2


-- Total Cases Vs Total Dealths 
-- Showing likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeath$
where location= 'India' and continent is not null
order by 1,2



-- Total Cases Vs Population
-- Percentage of population infected with COVID
select location, date, population, total_cases, (total_cases/population)*100 Percent_Population_Infected
from PortfolioProject..CovidDeath$
order by 1,2



-- Looking at Countries with highest Infection Rate compared to population
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as PercentagePopulationInfected
from PortfolioProject..CovidDeath$
group by location, population
order by PercentagePopulationInfected desc



-- Showing Countries with Highest Death Count per Population 
select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeath$
where continent is not null
group by continent
order by TotalDeathCount desc


-- BREAKING THINGS DOWN BY CONTINENT

--Showing Continents with Highest Death Count per Population
select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeath$
where continent is not null
group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath$
where continent is not null
order by 1,2

select date, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath$
where continent is not null
group by date
order by 1,2

 

-- Total Population vs Vaccinations
-- Shows Percentage of Population that recieved at least one COVID vaccine

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeath$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) Over(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Looking for India
select dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeath$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.location= 'India'
order by date



-- Using CTE to perform Calculation on Partition by in previous query
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeath$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac



-- TEMP TABLE
drop Table if exists #PercentagePopulationVaccinated
create Table #PercentagePopulationVaccinated
(
continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int, vac.new_vaccinations)) Over(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeath$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
select *, (RollingPeopleVaccinated/Population)*100
from #PercentagePopulationVaccinated



-- Creating View to store data for later visualizations
Drop view if exists PercentPopulationVaccinated
create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select * 
from PercentPopulationVaccinated