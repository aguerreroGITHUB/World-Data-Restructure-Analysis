--- Just looking tables --- 
select * from indicators;
select * from countries;

--- Regional tables, 2010 data ---
select CountryCode as Region, IndicatorCode, IndicatorName, AVG(Value) as EUU, Year
from indicators where countrycode = 'EUU' AND year = 2010
GROUP BY CountryCode, IndicatorCode, IndicatorName, year
;

select CountryCode as Region, IndicatorCode, IndicatorName, AVG(Value) as USA, Year
from indicators where countrycode = 'USA' AND year = 2010
GROUP BY CountryCode, IndicatorCode, IndicatorName, year
;

select CountryCode as Region, IndicatorCode,IndicatorName, AVG(Value) as CHN, Year
from indicators where countrycode = 'CHN' AND year = 2010
GROUP BY CountryCode, IndicatorCode, IndicatorName, year
;

Select Region, IndicatorCode, IndicatorName, AVG(Value) as ME_NA, Year from indicators i 
	join (Select CountryCode, Region from countries where region = 'Middle East & North Africa') c
	on i.CountryCode = c.CountryCode
where Year = 2010
GROUP BY Region, IndicatorCode, IndicatorName, year
;

Select Region, IndicatorCode, IndicatorName, AVG(Value) as SSA, Year from indicators i 
	join (Select CountryCode, Region from countries where region = 'Sub-Saharan Africa') c
	on i.CountryCode = c.CountryCode
where Year = 2010
GROUP BY Region, IndicatorCode, IndicatorName, year
;

--- NEW STRUCTURE TABLE ---
Select e.IndicatorCode, e.IndicatorName, EUU, USA, CHN, ME_NA, SSA -- All the columsn
from (
  (
  Select CountryCode as Region, IndicatorCode, IndicatorName, AVG(Value) as EUU from indicators
    where CountryCode = 'EUU' and Year = 2010
    GROUP BY CountryCode, IndicatorCode, IndicatorName
    ) as e INNER JOIN                                      -- EUU tabble


  (Select CountryCode as Region, IndicatorCode, IndicatorName, AVG(Value) as USA from indicators
    where CountryCode = 'USA' and Year = 2010
    GROUP BY CountryCode, IndicatorCode, IndicatorName
    ) as u ON e.IndicatorCode = u.IndicatorCode INNER JOIN -- Join USA 2010 data on common indicators with European Union

  (Select CountryCode as Region, IndicatorCode, IndicatorName, AVG(Value) as CHN from indicators
    where CountryCode = 'CHN' and Year = 2010
    GROUP BY CountryCode, IndicatorCode, IndicatorName
    ) as c ON e.IndicatorCode = c.IndicatorCode INNER JOIN -- Join China 2010 data on common indicators with European Union

  (Select Region, IndicatorCode, IndicatorName, AVG(Value) as ME_NA from indicators i 
    join (Select CountryCode, Region from countries where region = 'Middle East & North Africa') c
    on i.CountryCode = c.CountryCode
    where Year = 2010
    GROUP BY Region, IndicatorCode, IndicatorName
    ) as m ON e.IndicatorCode = m.IndicatorCode INNER JOIN -- Join MidEast & NorthAf 2010 data on common indicators with European Union

  (Select Region, IndicatorCode, IndicatorName, AVG(Value) as SSA from indicators i 
    join (Select CountryCode, Region from countries where region = 'Sub-Saharan Africa') c
    on i.CountryCode = c.CountryCode
    where Year = 2010
    GROUP BY Region, IndicatorCode, IndicatorName
    ) as s ON e.IndicatorCode = s.IndicatorCode ) -- Join SubsAf 2010 data on common indicators with European Union
