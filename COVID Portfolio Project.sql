Select * 
From sample.coviddeaths;

 # Select Data that we are going to use. 

Select Location, date, total_cases, new_cases, total_deaths, population
From sample.coviddeaths
Order by 1, 2;

# Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From sample.coviddeaths
Order by 1;

# Looking at Total Cases vs. Total Deaths in the U.S
# Shows the likelihood of dying if you contract covid in the U.S 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From sample.coviddeaths
Where location like '%states%'
Order by 1;

# Looking at the Total Cases vs. Population
# Shows what percentage of population got Covid
Select Location, date, population, total_cases, (total_cases/population)*100 as Percentage_Population_Infected
From sample.coviddeaths
Where location like '%states%'
Order by 1;

# Looking at Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as Highest_Infection_Count, Max((total_cases/population))*100 as Percentage_Population_Infected
From sample.coviddeaths
Group by Location, Population
Order by Percentage_Population_Infected DESC;

# Showing Countries with Highest Death Count per Population 
Select Location, Max(Total_deaths) as Total_Death_Count
From sample.coviddeaths
Where continent is not null
Group by Location
Order by Total_Death_Count DESC;

# Showing Death Count by Continent
# Showing the Continent with the highest death count
Select continent, Max(Total_deaths) as Total_Death_Count
From sample.coviddeaths
Where continent is not null
Group by continent
Order by Total_Death_Count DESC;

# Global numbers 
Select STR_TO_DATE(date, '%m/%d/%Y')as Date, SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths, (SUM(new_deaths)/SUM(new_cases))*100 as Death_Percentage
From sample.coviddeaths
Where continent is not null
Group by STR_TO_DATE(date, '%m/%d/%Y')
Order by 1;

# Joining two tables together
Select *
From sample.coviddeaths death	
Join sample.covidvaccinations vaccination
	On death.location = vaccination.location
    and death.date = vaccination.date;
    
# Looking at Total population vs Vaccination
With PopulationVSVaccination(Continent, Location, Date, Population, New_vaccinations, Rolling_People_Vaccinated)
as
(
Select death.continent, death.location, STR_TO_DATE(death.date, '%m/%d/%Y') as date, death.population, vaccination.new_vaccinations, SUM(vaccination.new_vaccinations) OVER (Partition by death.location Order by death.location, STR_TO_DATE(death.date, '%m/%d/%Y')) as Rolling_People_Vaccinated
From sample.coviddeaths death	
Join sample.covidvaccinations vaccination
	On death.location = vaccination.location
    and STR_TO_DATE(death.date, '%m/%d/%Y') = STR_TO_DATE(vaccination.date, '%m/%d/%Y')
Where death.continent is not null
# Order by 2,3;
)
Select *, (Rolling_People_Vaccinated/Population)*100 as PercentPopulationVaccinated
From PopulationVSVaccination;

# USE CTE
#With PopulationVSVaccination(continent, location, date, population, Rolling_People_Vaccinated)
#as (


# TEMP table
DROP Table if exists Sample.PercentPopulationVaccinated;
CREATE TABLE Sample.PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime, 
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
);
INSERT INTO Sample.PercentPopulationVaccinated (continent, location, date, population, new_vaccinations,Rolling_People_Vaccinated)
Select death.continent, death.location, STR_TO_DATE(death.date, '%m/%d/%Y'), death.population, vaccination.new_vaccinations, SUM(vaccination.new_vaccinations) OVER (Partition by death.location Order by death.location, STR_TO_DATE(death.date, '%m/%d/%Y')) as Rolling_People_Vaccinated
From sample.coviddeaths death	
Join sample.covidvaccinations vaccination
	On death.location = vaccination.location
    and STR_TO_DATE(death.date, '%m/%d/%Y') = STR_TO_DATE(vaccination.date, '%m/%d/%Y');
Select * , (Rolling_People_Vaccinated/Population)*100
From Sample.PercentPopulationVaccinated;









