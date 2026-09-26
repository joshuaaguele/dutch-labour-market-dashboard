-- Rebuild labour_market_clean from the imported CBS StatLine raw_labour_market table.
-- Source: CBS StatLine table 85268NED, 12 provinces, 2021 Q1–2026 Q2.
-- Prerequisite: raw_labour_market already exists with the column names below.
-- Run in DB Browser for SQLite after opening dutch_regional_labour_market.db.
-- The script replaces the rows in labour_market_clean; it does not edit raw data.

BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS labour_market_clean (
    year INT,
    quarter INT,
    period_key TEXT,
    quarter_start_date TEXT,
    province TEXT,
    population_15_75_thousands INT,
    labour_force_thousands INT,
    employed_thousands INT,
    unemployed_thousands INT,
    unemployment_rate_pct REAL,
    non_labour_force_thousands INT,
    net_labour_participation_pct REAL
);

DELETE FROM labour_market_clean;

INSERT INTO labour_market_clean (
    year, quarter, period_key, quarter_start_date, province,
    population_15_75_thousands, labour_force_thousands,
    employed_thousands, unemployed_thousands, unemployment_rate_pct,
    non_labour_force_thousands, net_labour_participation_pct
)
SELECT
    CAST(substr("Perioden", 1, 4) AS INTEGER),
    CAST(substr("Perioden", 6, 1) AS INTEGER),
    substr("Perioden", 1, 4) || 'Q' || substr("Perioden", 6, 1),
    printf('%s-%02d-01', substr("Perioden", 1, 4),
           1 + 3 * (CAST(substr("Perioden", 6, 1) AS INTEGER) - 1)),
    substr("Regio's", 1, length("Regio's") - 5), -- remove trailing ' (PV)'
    "Beroeps- en niet-beroepsbevolking (x 1 000)",
    "Beroepsbevolking/Beroepsbevolking (x 1 000)",
    "Beroepsbevolking/Werkzame beroepsbevolking/Werkzame beroepsbevolking (x 1 000)",
    "Beroepsbevolking/Werkloze beroepsbevolking (x 1 000)",
    "Beroepsbevolking/Werkloosheidspercentage (%)",
    "Niet-beroepsbevolking (x 1 000)",
    "Netto arbeidsparticipatie (%)"
FROM raw_labour_market;

CREATE UNIQUE INDEX IF NOT EXISTS idx_labour_market_province_period
    ON labour_market_clean(province, year, quarter);

COMMIT;

-- Expected for the supplied database: 264 rows, 12 provinces, 22 quarters.
SELECT COUNT(*) AS rows, COUNT(DISTINCT province) AS provinces,
       COUNT(DISTINCT period_key) AS quarters
FROM labour_market_clean;
