SELECT *,
       CAST(TotalPermits AS FLOAT) / CAST(GrandTotalPermits AS FLOAT) * 100 AS PercentTotalPermits,
       CAST(TotalUnits AS FLOAT) / CAST(GrandTotalUnits AS FLOAT) * 100 AS PercentTotalUnits
FROM (SELECT DISTINCT GeoLocalArea,
             PropertyType,
             SUM(NewPermitsGranted) OVER (PARTITION BY GeoLocalArea,PropertyType) AS TotalPermits,
             SUM(UnitsGranted) OVER (PARTITION BY GeoLocalArea,PropertyType) AS TotalUnits,
             SUM(NewPermitsGranted) OVER (PARTITION BY GeoLocalArea) AS GrandTotalPermits,
             SUM(UnitsGranted) OVER (PARTITION BY GeoLocalArea) AS GrandTotalUnits
      FROM permits_granted_time_series)
ORDER BY GeoLocalArea
