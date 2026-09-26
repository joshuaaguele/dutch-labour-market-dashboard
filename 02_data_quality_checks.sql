-- Quality checks for the cleaned CBS provincial labour-market table.
-- Expected for this dataset: 264 rows, 12 provinces, 22 quarters;
-- all other results below should be zero.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT province) AS provinces,
    COUNT(DISTINCT period_key) AS quarters,
    SUM(CASE WHEN
        year IS NULL OR quarter IS NULL OR period_key IS NULL OR
        quarter_start_date IS NULL OR province IS NULL OR
        population_15_75_thousands IS NULL OR
        labour_force_thousands IS NULL OR
        employed_thousands IS NULL OR
        unemployed_thousands IS NULL OR
        unemployment_rate_pct IS NULL OR
        non_labour_force_thousands IS NULL OR
        net_labour_participation_pct IS NULL
    THEN 1 ELSE 0 END) AS rows_with_missing_values
FROM labour_market_clean;

SELECT COUNT(*) AS duplicate_province_quarters
FROM (
    SELECT province, year, quarter
    FROM labour_market_clean
    GROUP BY province, year, quarter
    HAVING COUNT(*) > 1
);

SELECT COUNT(*) AS invalid_periods
FROM labour_market_clean
WHERE quarter NOT BETWEEN 1 AND 4
   OR period_key <> printf('%dQ%d', year, quarter)
   OR quarter_start_date <> printf('%04d-%02d-01', year, 1 + 3 * (quarter - 1));
