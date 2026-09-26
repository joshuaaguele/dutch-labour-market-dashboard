SELECT
    province,
    unemployment_rate_pct,
    net_labour_participation_pct
FROM labour_market_clean
WHERE year = 2026 AND quarter = 2
ORDER BY unemployment_rate_pct DESC;

-- Compare the same quarter five years apart
SELECT
    recent.province,
    earlier.unemployment_rate_pct AS unemployment_2021_q2,
    recent.unemployment_rate_pct AS unemployment_2026_q2,
    ROUND(
        recent.unemployment_rate_pct - earlier.unemployment_rate_pct, 1
    ) AS change_percentage_points
FROM labour_market_clean AS earlier
JOIN labour_market_clean AS recent
    ON earlier.province = recent.province
WHERE earlier.year = 2021 AND earlier.quarter = 2
  AND recent.year = 2026 AND recent.quarter = 2
ORDER BY change_percentage_points DESC;