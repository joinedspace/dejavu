WITH permit_dev_data AS
(
  SELECT GeoLocalArea AS N,
         MAX(CASE WHEN PropertyType = "single" THEN PercentTotalPermits END) AS percent_single,
         MAX(GrandTotalPermits) AS total_permits
  FROM permits_granted_time_series_cumulative
  GROUP BY N
)
SELECT locale,
       COALESCE(percent_single,0) AS percent_permits_single,
       total_permits,
       percent_dwelling_single_detached,
       avg_pop_age,
       avg_household_size,
       avg_total_individual_income,
       avg_total_household_income,
       percent_commute_0_14*7 + percent_commute_15_29*22 + percent_commute_30_44*37 + percent_commute_45_59*52 + percent_commute_60_*67 AS average_commute_time,
       percent_commute_drive + percent_commute_pool AS percent_commute_drive_driven,
       percent_commute_transit,
       percent_commute_walk + percent_commute_bicycle AS percent_commute_walk_bike,
       percent_home_owner,
       average_rent,
       percent_suitable_housing,
       percent_no_diploma,
       percent_high_school_diploma,
       percent_post_secondary_diploma_degree,
       percent_visible_minority
FROM df_demos_cleaned
  INNER JOIN permit_dev_data
          ON SUBSTRING (locale,0,3) = SUBSTRING (N,0,3)
         AND SUBSTRING (locale,LENGTH (locale) - 2) = SUBSTRING (N,LENGTH (N) - 2)
