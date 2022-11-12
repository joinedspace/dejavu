SELECT *,
       CAST(NewPermitsGranted AS FLOAT) / CAST(TotalPermitsGranted AS FLOAT) * 100 AS PercentNewPermitsGranted,
       CAST(UnitsGranted AS FLOAT) / CAST(TotalUnitsGranted AS FLOAT) * 100 AS PercentUnitsGranted
FROM (SELECT DISTINCT GeoLocalArea,
             IssueYear,
             PropertyType,
             NewPermitsGranted,
             UnitsGranted,
             SUM(NewPermitsGranted) OVER (PARTITION BY GeoLocalArea,IssueYear) AS TotalPermitsGranted,
             SUM(UnitsGranted) OVER (PARTITION BY GeoLocalArea,IssueYear) AS TotalUnitsGranted
      FROM (SELECT GeoLocalArea,
                   IssueYear,
                   --YearMonth,
                   CASE
                     WHEN SpecificUseCategory LIKE '%Multiple Dwelling%' THEN 'multi'
                     ELSE 'single'
                   END AS PropertyType,
                   COUNT(DISTINCT PermitNumber) AS NewPermitsGranted,
                   SUM(CASE WHEN SpecificUseCategory LIKE "%Multiple Dwelling%" THEN Units ELSE 1 END) AS UnitsGranted
            FROM df_permits
              LEFT JOIN df_permits_multi USING (PermitNumber)
            WHERE TypeOfWork = 'New Building'
            AND   SpecificUseCategory <> 'None'
            AND   GeoLocalArea <> 'None'
            AND   PropertyUse LIKE '%Dwelling%'
            GROUP BY GeoLocalArea,
                     IssueYear,
                     PropertyType))
ORDER BY GeoLocalArea,
         IssueYear ASC,
         PropertyType
