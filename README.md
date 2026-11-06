# adidas-annual-report-2025-sql-analysis
SQL analysis of the adidas Annual Report 2025: regional growth, currency effects, channel mix and margins in PostgreSQL
# adidas Annual Report 2025: SQL Analysis

A PostgreSQL analysis of the adidas Annual Report 2025, comparing 2025 with 2024 across regions, channels and profit margins. The project covers the full workflow: loading raw report tables, cleaning them, validating them against each other, and answering seven business questions with SQL.

## Questions and findings

| # | Question | Finding |
|---|---|---|
| 1 | How fast did group net sales grow? | 4.8% in euros, 10% currency-neutral |
| 2 | Which regions grew fastest? | Europe in euros, Latin America in local currency |
| 3 | Has the regional mix shifted? | Slightly: North America -1.1 pp, Europe +0.9 pp |
| 4 | Which region added the most euros? | Europe, EUR 585m |
| 5 | How large is the reported versus currency-neutral gap? | Widest in Latin America at 15.4 points |
| 6 | Is the channel mix moving? | No: 60% wholesale, 40% direct-to-consumer |
| 7 | Which regions are most profitable, and is margin improving? | Greater China has the highest margin, Europe the most profit |

The full write-up with result tables is in [`docs/Adidas_2025_SQL_Analysis.pdf`](docs/Adidas_2025_SQL_Analysis.pdf).

## SQL techniques

`LAG`, `RANK() OVER (PARTITION BY ...)`, `SUM() OVER`, `POWER` for compound growth, conditional aggregation with `FILTER`, `CASE`, CTEs and joins across fact tables.

## Data

Figures come from the adidas Annual Report 2025: Note 36 (segment information), the segment pages of the Financial Review, and the income statement channel table. All values are in EUR millions unless stated. The original report files are not included in this repository; they are available from the [adidas investor relations site](https://report.adidas-group.com/2025/en/services/downloads.html).

## Data model

Raw figures load into text-only staging tables, a `clean_num()` function converts report formatting such as `5,087` and `(12)` into numbers, and typed fact tables hold the cleaned data. Every fact table carries a `source_report_year` column, so restated figures from different reports can be stored side by side.

| Table | Contents |
|---|---|
| `dim_segment` | The seven reporting segments |
| `fact_segment_metrics` | Net sales, gross and operating profit, assets and more, by segment and year |
| `fact_segment_sales_category` | Footwear, apparel and accessories sales by segment |
| `fact_reconciliation` | Bridges from segment totals to group totals |
| `fact_segment_growth` | Reported and currency-neutral growth by segment |
| `fact_segment_margins` | Gross margin, operating expenses and operating margin |
| `fact_channel_sales` | Wholesale and direct-to-consumer net sales |

## Validation

Segment net sales plus HQ/Consolidation reconcile to group net sales (a gap of EUR 51m in 2025 and EUR 31m in 2024 against EUR 32m reported, which is rounding). Operating margins recalculated from Note 36 matched the margins reported in the Financial Review for all 12 segment-year pairs.


## Limitations

The 2025 report contains 2025 and 2024 only, so results are a one-year comparison and not a trend; a multi-year compound growth rate needs 2023 from the 2024 report. Published growth percentages are rounded to whole numbers. Channel figures were keyed manually from the report's income statement page. All euro figures are reported figures and include currency effects.

## Disclaimer

This is an independent educational project and is not affiliated with adidas AG. It is not financial advice.

