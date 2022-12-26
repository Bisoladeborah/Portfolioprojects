
select * From portfolio..CovidDeath
where continent is not null
order by 3,4


select * from portfolio..Covidvaccination
order by 3,4

 select location, date, total_cases, new_cases, total_deaths, population
FROM portfolio..CovidDeath
ORDER BY 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Deathpercentage
FROM portfolio..CovidDeath
where location like 'nigeria'
and continent is not null
ORDER BY 1,2

select location, date, total_cases, population, (total_cases/population)*100 as Covidpercentage
FROM portfolio..CovidDeath
where location like 'nigeria'
ORDER BY 1,2

select location, population, MAX(total_cases) AS highestinfectioncount, MAX(total_cases/population)*100 AS Covidpercentage
FROM portfolio..CovidDeath
group by location, population
ORDER BY covidpercentage desc

select location, MAX(cast(total_deaths as int) ) AS Totaldeathcount
FROM portfolio..CovidDeath
where continent is not null
group by location
ORDER BY Totaldeathcount desc

select continent, MAX(cast(total_deaths as int) ) AS Totaldeathcount
FROM portfolio..CovidDeath
where continent is not null
group by continent
ORDER BY Totaldeathcount desc

select continent, population, MAX(total_cases) AS highestinfectioncount, MAX(total_cases/population)*100 AS Covidpercentage
FROM portfolio..CovidDeath
group by continent, population
ORDER BY covidpercentage desc

select date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths as INT) ) AS total_deaths,SUM(cast(new_deaths as INT) )/SUM(New_cases)*100 AS Deathpercentage
FROM portfolio..CovidDeath
where continent is not null
--Group by date
ORDER BY 1,2

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations) ) OVER (partition by dea.location order by dea.location, dea.date) AS Rollingpeoplevaccinated
FROM portfolio..CovidDeath dea
JOIN portfolio..covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3




with popvsVac (continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated) 
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations) ) OVER (partition by dea.location order by dea.location, dea.date) AS Rollingpeoplevaccinated
FROM portfolio..CovidDeath dea
JOIN portfolio..covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (Rollingpeoplevaccinated/population)*100 as rollingpercentage
from popvsVac

DROP table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations) ) OVER (partition by dea.location order by dea.location, dea.date) AS Rollingpeoplevaccinated
FROM portfolio..CovidDeath dea
JOIN portfolio..covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null

select *, (Rollingpeoplevaccinated/population)*100 as rollingpercentage
from #percentpopulationvaccinated




create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations) ) OVER (partition by dea.location order by dea.location, dea.date) AS Rollingpeoplevaccinated
FROM portfolio..CovidDeath dea
JOIN portfolio..covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated

