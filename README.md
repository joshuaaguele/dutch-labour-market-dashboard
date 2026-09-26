# Dutch Labour-Market Analytics Dashboard

A SQL and Power BI project comparing unemployment and labour participation across the 12 Dutch provinces. The dashboard has a province comparison page for a selected quarter and a trend page covering 2021 Q1 through 2026 Q2.

## Data

- **Source:** Statistics Netherlands (CBS), StatLine table **85268NED**. The original export is included in the project folder.
- **Scope of this extract:** 12 provinces × 22 quarters = **264 province-quarter observations**, from 2021 Q1 to 2026 Q2.
- **Units:** Population and labour-force counts are in thousands of people; rates are percentages.
- **Granularity:** One row per province and quarter. The data are provincial aggregates, not individual records.

The source export was imported into SQLite as `raw_labour_market`. The cleaned table `labour_market_clean` keeps the nine source measures and identifiers in simpler field names, removes the ` (PV)` suffix from province labels, and creates `year`, `quarter`, `period_key`, and `quarter_start_date` for analysis. The reported provincial rates are carried over from CBS; they are not recalculated from the rounded counts.

## Files

| File | Purpose |
| --- | --- |
| `01_create_clean_labour_market.sql` | Rebuilds the clean table from the imported raw table. This is a tested reconstruction of the original unsaved script. |
| `02_data_quality_checks.sql` | Checks row count, completeness, unique province-quarter keys, and valid quarter labels/dates. |
| `03_province_analysis.sql` | Ranks provinces in 2026 Q2 and compares 2021 Q2 with 2026 Q2. |
| `04_power_bi_export.sql` | Selects the clean data in province and chronological order for CSV export. |
| `dutch_regional_labour_market.db` | SQLite database with raw and clean tables. |
| `labour_market_clean_for_power_bi.csv` | Cleaned data exported for Power BI. |
| `dutch_regional_market_dash_board.pbix` | Interactive Power BI report. |
| `Dutch_Labour_Market_Dashboard.pdf` | Two-page static view of the report. |
| `85268NED_...` | Original CBS StatLine download; exact local filename may include an export timestamp. |

## Reproduce the analysis

1. Open `dutch_regional_labour_market.db` in DB Browser for SQLite. The supplied database already includes `raw_labour_market` and `labour_market_clean`.
2. To rebuild the clean table, execute `01_create_clean_labour_market.sql`. It replaces **clean-table rows** using `raw_labour_market`, so make a copy of the database first if you want to preserve its current state.
3. Run `02_data_quality_checks.sql`. For this extract, expect **264 rows, 12 provinces, 22 quarters, 0 missing rows, 0 duplicate province-quarters, and 0 invalid periods**.
4. Run `03_province_analysis.sql` for the provincial comparison queries.
5. Run `04_power_bi_export.sql` and export its result as `labour_market_clean_for_power_bi.csv` if you need to refresh the CSV. Open the `.pbix` report in Power BI Desktop. If Power BI cannot find the CSV on another computer, update its data-source path to your local copy, then refresh.

## Dashboard and measures

- **Province comparison:** A quarter slicer filters a ranked bar chart of provincial unemployment rates. Each province has a distinct color and a percentage label.
- **Trend:** A combined unemployment rate and the mean provincial net labour participation rate are shown by quarter. A province slicer filters the trend page.
- **Combined unemployment rate:** `100 × SUM(unemployed_thousands) / SUM(labour_force_thousands)` for the provinces in the current filter context. This is a ratio of summed, rounded counts; it can differ slightly from a published national CBS rate.
- **Average provincial participation:** Arithmetic mean of the selected provinces' `net_labour_participation_pct` values for each quarter. It gives each province equal weight and is **not** a population-weighted national participation rate.

## Interpretation limits

These charts describe associations and trends; they do not establish causes. Source counts are reported in thousands and are rounded, while the provincial rates are supplied separately by CBS. The data and dashboard reflect the selected extract through 2026 Q2; consult the current CBS table for revisions or later quarters. The PDF is a static export, so its slicers are not interactive.
