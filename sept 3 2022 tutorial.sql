
--looking at total population vs vaccinations




select*
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date



select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

where dea.continent is not null

order by 2, 3



select 'location', 'new_Tests'
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	
	on dea.location = vac.location
	and dea.date = vac.date



	--looking at total population vs vaccintions

	--use CTE (cannot use a column we created to do calulations)(use CTE to do this)


with PopvsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

where dea.continent is not null

--order by 2, 3

)
select *, (rollingpeoplevaccinated/population)*100
from popvsvac



--temp table
drop table if exists #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
Population numeric,
New_Vaccinations numeric, 
rollingpeoplevaccinated numeric
)


Insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

where dea.continent is not null

order by 2, 3


select *, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated



--creating view to store data for later visualization

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

where dea.continent is not null

--order by 2, 3

