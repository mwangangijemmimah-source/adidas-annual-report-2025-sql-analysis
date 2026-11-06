CREATE OR REPLACE FUNCTION clean_num(t text)
RETURNS numeric
LANGUAGE sql
IMMUTABLE
AS $$
    SELECT CASE
        WHEN t IS NULL OR btrim(t) IN ('', '-', '–') THEN NULL
        WHEN btrim(t) ~ '^\([0-9.,]+\)$'
            THEN -(translate(btrim(t), '(),', '')::numeric)
        ELSE replace(
                 translate(btrim(t), ',' || chr(160) || ' ', ''),
                 '−', '-')::numeric
    END
$$;

SELECT clean_num('5,087') AS a,
       clean_num('(12)')  AS b,
       clean_num('(0)')   AS c,
       clean_num('')      AS d;

----Creating tables for Notes_adidas
CREATE TABLE stg_n36_seg_info_i (
    segment                 text,
    net_sales_2025          text,
    net_sales_2024          text,
    gross_profit_2025       text,
    gross_profit_2024       text,
    operating_profit_2025   text,
    operating_profit_2024   text,
    assets_2025             text,
    assets_2024             text
);

CREATE TABLE stg_n36_seg_info_ii (
    segment                 text,
    liabilities_2025        text,
    liabilities_2024        text,
    capex_2025              text,
    capex_2024              text,
    dep_amort_2025          text,
    dep_amort_2024          text,
    impairment_2025         text,
    impairment_2024         text
);

CREATE TABLE stg_n36_seg_revenue (
    segment                 text,
    category                text,
    net_sales_2025          text,
    net_sales_2024          text
);

CREATE TABLE stg_n36_reconciliation (
    measure                 text,
    line_item               text,
    value_2025              text,
    value_2024              text
);

CREATE TABLE stg_n36_geo_market (
    market                  text,
    net_sales_2025          text,
    net_sales_2024          text,
    non_current_assets_2025 text,
    non_current_assets_2024 text
);

TRUNCATE TABLE stg_n36_seg_info_i, stg_n36_seg_info_ii, stg_n36_seg_revenue, stg_n36_reconciliation, stg_n36_geo_market;

INSERT INTO stg_n36_seg_info_i (segment, net_sales_2025, net_sales_2024, gross_profit_2025, gross_profit_2024, operating_profit_2025, operating_profit_2024, assets_2025, assets_2024) VALUES
    ('Europe', '8136', '7551', '4195', '3795', '1692', '1485', '2611', '2149'),
    ('North America', '5087', '5128', '2312', '2210', '544', '480', '1779', '1645'),
    ('Greater China', '3623', '3459', '1904', '1717', '802', '714', '1044', '899'),
    ('Emerging Markets', '3510', '3310', '1784', '1698', '701', '738', '1341', '1272'),
    ('Latin America', '2926', '2772', '1391', '1329', '609', '614', '1290', '1029'),
    ('Japan/South Korea', '1406', '1339', '740', '711', '305', '295', '494', '414'),
    ('Other Businesses', '72', '93', '36', '46', '16', '14', '32', '23');


INSERT INTO stg_n36_seg_info_ii (segment, liabilities_2025, liabilities_2024, capex_2025, capex_2024, dep_amort_2025, dep_amort_2024, impairment_2025, impairment_2024) VALUES
    ('Europe', '212', '187', '68', '84', '259', '256', '-11', '-11'),
    ('North America', '91', '73', '70', '87', '151', '172', '3', '13'),
    ('Greater China', '305', '338', '55', '69', '190', '201', '14', '3'),
    ('Emerging Markets', '130', '151', '61', '72', '164', '160', '3', '(0)'),
    ('Latin America', '133', '112', '37', '26', '67', '59', '1', '(0)'),
    ('Japan/South Korea', '39', '38', '25', '29', '79', '77', '-3', '4'),
    ('Other Businesses', '4', '4', '1', '2', '4', '5', '(0)', '-4');

INSERT INTO stg_n36_seg_revenue (segment, category, net_sales_2025, net_sales_2024) VALUES
    ('Europe', 'Footwear', '4675', '4404'),
    ('Europe', 'Apparel', '2923', '2617'),
    ('Europe', 'Accessories', '538', '526'),
    ('North America', 'Footwear', '2857', '2938'),
    ('North America', 'Apparel', '1581', '1496'),
    ('North America', 'Accessories', '649', '694'),
    ('Greater China', 'Footwear', '1904', '1933'),
    ('Greater China', 'Apparel', '1603', '1421'),
    ('Greater China', 'Accessories', '115', '104'),
    ('Emerging Markets', 'Footwear', '2159', '2106'),
    ('Emerging Markets', 'Apparel', '1120', '1006'),
    ('Emerging Markets', 'Accessories', '231', '210'),
    ('Latin America', 'Footwear', '1837', '1792'),
    ('Latin America', 'Apparel', '889', '829'),
    ('Latin America', 'Accessories', '200', '151'),
    ('Japan/South Korea', 'Footwear', '734', '754'),
    ('Japan/South Korea', 'Apparel', '604', '514'),
    ('Japan/South Korea', 'Accessories', '69', '71'),
    ('Other Businesses', 'Footwear', '21', '28'),
    ('Other Businesses', 'Apparel', '42', '53'),
    ('Other Businesses', 'Accessories', '9', '12');

INSERT INTO stg_n36_reconciliation (measure, line_item, value_2025, value_2024) VALUES
    ('net_sales', 'Reportable segments', '23282', '22219'),
    ('net_sales', 'Japan/South Korea', '1406', '1339'),
    ('net_sales', 'Other Businesses', '72', '93'),
    ('net_sales', 'HQ/Consolidation', '51', '32'),
    ('net_sales', 'Total net sales', '24811', '23683'),
    ('gross_profit', 'Reportable segments', '11586', '10749'),
    ('gross_profit', 'Japan/South Korea', '740', '711'),
    ('gross_profit', 'Other Businesses', '36', '46'),
    ('gross_profit', 'HQ/Consolidation', '442', '520'),
    ('gross_profit', 'Gross profit', '12804', '12026'),
    ('operating_profit', 'Operating profit for reportable segments', '4348', '4031'),
    ('operating_profit', 'Operating profit for Japan/South Korea', '305', '295'),
    ('operating_profit', 'Operating profit for Other Businesses', '16', '14'),
    ('operating_profit', 'HQ', '-1512', '-2180'),
    ('operating_profit', 'Central expenditure for marketing', '-1065', '-906'),
    ('operating_profit', 'Consolidation', '-36', '83'),
    ('operating_profit', 'Operating profit', '2056', '1337'),
    ('operating_profit', 'Financial income', '74', '101'),
    ('operating_profit', 'Financial expenses', '-310', '-317'),
    ('operating_profit', 'Income before taxes', '1820', '1121');

INSERT INTO stg_n36_geo_market (market, net_sales_2025, net_sales_2024, non_current_assets_2025, non_current_assets_2024) VALUES
    ('Europe', '8175', '7589', '3367', '3181'),
    ('North America', '5092', '5134', '1098', '1262'),
    ('Greater China', '3636', '3476', '768', '929'),
    ('Emerging Markets', '3510', '3311', '781', '762'),
    ('Latin America', '2928', '2765', '237', '194'),
    ('Japan/South Korea', '1471', '1408', '387', '401');

---check on its own to confirm the counts:
SELECT 'stg_n36_seg_info_i' AS table_name, COUNT(*) AS rows_loaded, 7 AS expected FROM stg_n36_seg_info_i
UNION ALL SELECT 'stg_n36_seg_info_ii', COUNT(*), 7 FROM stg_n36_seg_info_ii
UNION ALL SELECT 'stg_n36_seg_revenue', COUNT(*), 21 FROM stg_n36_seg_revenue
UNION ALL SELECT 'stg_n36_reconciliation', COUNT(*), 20 FROM stg_n36_reconciliation
UNION ALL SELECT 'stg_n36_geo_market', COUNT(*), 6 FROM stg_n36_geo_market;


CREATE TABLE dim_segment (
    segment_name   text PRIMARY KEY,
    is_reportable  boolean NOT NULL,
    is_geographic  boolean NOT NULL
);

INSERT INTO dim_segment (segment_name, is_reportable, is_geographic) VALUES
    ('Europe',            TRUE,  TRUE),
    ('North America',     TRUE,  TRUE),
    ('Greater China',     TRUE,  TRUE),
    ('Emerging Markets',  TRUE,  TRUE),
    ('Latin America',     TRUE,  TRUE),
    ('Japan/South Korea', FALSE, TRUE),
    ('Other Businesses',  FALSE, FALSE);

CREATE TABLE fact_segment_metrics (
    source_report_year  smallint NOT NULL,
    fiscal_year         smallint NOT NULL,
    segment_name        text     NOT NULL REFERENCES dim_segment (segment_name),
    metric              text     NOT NULL,
    value_eur_m         numeric(14,2),
    PRIMARY KEY (source_report_year, fiscal_year, segment_name, metric),
    CONSTRAINT chk_metric CHECK (metric IN (
        'net_sales', 'gross_profit', 'operating_profit', 'assets',
        'liabilities', 'capex', 'dep_amort', 'impairment'))
);

CREATE TABLE fact_segment_sales_category (
    source_report_year  smallint NOT NULL,
    fiscal_year         smallint NOT NULL,
    segment_name        text     NOT NULL REFERENCES dim_segment (segment_name),
    category            text     NOT NULL,
    net_sales_eur_m     numeric(14,2),
    PRIMARY KEY (source_report_year, fiscal_year, segment_name, category),
    CONSTRAINT chk_category CHECK (category IN ('Footwear', 'Apparel', 'Accessories'))
);

CREATE TABLE fact_reconciliation (
    source_report_year  smallint NOT NULL,
    fiscal_year         smallint NOT NULL,
    measure             text     NOT NULL,
    line_item           text     NOT NULL,
    value_eur_m         numeric(14,2),
    PRIMARY KEY (source_report_year, fiscal_year, measure, line_item),
    CONSTRAINT chk_measure CHECK (measure IN ('net_sales', 'gross_profit', 'operating_profit'))
);

CREATE TABLE fact_geo_market (
    source_report_year        smallint NOT NULL,
    fiscal_year               smallint NOT NULL,
    market                    text     NOT NULL,
    net_sales_eur_m           numeric(14,2),
    non_current_assets_eur_m  numeric(14,2),
    PRIMARY KEY (source_report_year, fiscal_year, market)
);


---creating and insterting details of the financial review tables
CREATE TABLE fact_segment_growth (
    source_report_year              smallint NOT NULL,
    segment_name                    text     NOT NULL REFERENCES dim_segment (segment_name),
    net_sales_chg_reported          numeric(6,2),
    net_sales_chg_currency_neutral  numeric(6,2),
    brand_adidas_chg_cn_ex_yeezy    numeric(6,2),
    PRIMARY KEY (source_report_year, segment_name)
);

CREATE TABLE fact_segment_margins (
    source_report_year        smallint NOT NULL,
    fiscal_year               smallint NOT NULL,
    segment_name              text     NOT NULL REFERENCES dim_segment (segment_name),
    gross_margin              numeric(6,3),
    operating_expenses_eur_m  numeric(14,2),
    opex_pct_net_sales        numeric(6,3),
    operating_margin          numeric(6,3),
    PRIMARY KEY (source_report_year, fiscal_year, segment_name)
);

CREATE TABLE fact_group_kpi (
    source_report_year  smallint NOT NULL,
    fiscal_year         smallint NOT NULL,
    metric              text     NOT NULL,
    value               numeric(10,4),
    PRIMARY KEY (source_report_year, fiscal_year, metric)
);

---Inserting values

INSERT INTO fact_segment_growth (source_report_year, segment_name, net_sales_chg_reported, net_sales_chg_currency_neutral, brand_adidas_chg_cn_ex_yeezy) VALUES
    (2025, 'Europe', 0.08, 0.08, 0.10),
    (2025, 'North America', -0.01, 0.04, 0.10),
    (2025, 'Greater China', 0.05, 0.09, 0.13),
    (2025, 'Emerging Markets', 0.06, 0.15, 0.17),
    (2025, 'Latin America', 0.06, 0.21, 0.22),
    (2025, 'Japan/South Korea', 0.05, 0.11, 0.14);

INSERT INTO fact_segment_margins (source_report_year, fiscal_year, segment_name, gross_margin, operating_expenses_eur_m, opex_pct_net_sales, operating_margin) VALUES
    (2025, 2025, 'Europe', 0.516, 2504, 0.308, 0.208),
    (2025, 2024, 'Europe', 0.503, 2310, 0.306, 0.197),
    (2025, 2025, 'North America', 0.454, 1792, 0.352, 0.107),
    (2025, 2024, 'North America', 0.431, 1788, 0.349, 0.094),
    (2025, 2025, 'Greater China', 0.526, 1103, 0.305, 0.221),
    (2025, 2024, 'Greater China', 0.496, 1012, 0.293, 0.206),
    (2025, 2025, 'Emerging Markets', 0.508, 1083, 0.309, 0.200),
    (2025, 2024, 'Emerging Markets', 0.513, 959, 0.290, 0.223),
    (2025, 2025, 'Latin America', 0.475, 786, 0.269, 0.208),
    (2025, 2024, 'Latin America', 0.479, 717, 0.259, 0.222),
    (2025, 2025, 'Japan/South Korea', 0.526, 466, 0.332, 0.217),
    (2025, 2024, 'Japan/South Korea', 0.531, 428, 0.320, 0.220);

INSERT INTO fact_group_kpi (source_report_year, fiscal_year, metric, value) VALUES
    (2025, 2025, 'net_sales_growth_currency_neutral', 0.10),
    (2025, 2024, 'net_sales_growth_currency_neutral', 0.12);

----Checking Reload

SELECT (SELECT COUNT(*) FROM fact_segment_growth)  AS growth_rows,
       (SELECT COUNT(*) FROM fact_segment_margins) AS margin_rows,
       (SELECT COUNT(*) FROM fact_group_kpi)       AS kpi_rows;

---comparing operating margin calculated from your Note 36 data against the margin reported

SELECT m.fiscal_year, m.segment_name,
       ROUND(op.value_eur_m / ns.value_eur_m, 3) AS op_margin_calculated,
       m.operating_margin                        AS op_margin_reported
FROM fact_segment_margins m
JOIN fact_segment_metrics ns
  ON ns.source_report_year = m.source_report_year
 AND ns.fiscal_year = m.fiscal_year
 AND ns.segment_name = m.segment_name
 AND ns.metric = 'net_sales'
JOIN fact_segment_metrics op
  ON op.source_report_year = m.source_report_year
 AND op.fiscal_year = m.fiscal_year
 AND op.segment_name = m.segment_name
 AND op.metric = 'operating_profit'
WHERE ROUND(op.value_eur_m / ns.value_eur_m, 3) <> m.operating_margin
ORDER BY m.fiscal_year, m.segment_name;

---Growth of net sales each year

WITH grp AS (
    SELECT fiscal_year, value_eur_m AS net_sales
    FROM fact_reconciliation
    WHERE source_report_year = 2025
      AND measure = 'net_sales'
      AND line_item = 'Total net sales'
)
SELECT g.fiscal_year,
       g.net_sales,
       LAG(g.net_sales) OVER (ORDER BY g.fiscal_year) AS prior_year_sales,
       g.net_sales - LAG(g.net_sales) OVER (ORDER BY g.fiscal_year) AS change_eur_m,
       ROUND((g.net_sales / LAG(g.net_sales) OVER (ORDER BY g.fiscal_year) - 1) * 100, 1) AS reported_growth_pct,
       ROUND(k.value * 100) AS currency_neutral_growth_pct
FROM grp g
LEFT JOIN fact_group_kpi k
       ON k.fiscal_year = g.fiscal_year
      AND k.source_report_year = 2025
      AND k.metric = 'net_sales_growth_currency_neutral'
ORDER BY g.fiscal_year;

---Compound Annual Growth rate from 2024 to 2025

WITH ends AS (
    SELECT MAX(value_eur_m) FILTER (WHERE fiscal_year = 2024) AS sales_start,
           MAX(value_eur_m) FILTER (WHERE fiscal_year = 2025) AS sales_end
    FROM fact_reconciliation
    WHERE source_report_year = 2025
      AND measure = 'net_sales'
      AND line_item = 'Total net sales'
)
SELECT sales_start,
       sales_end,
       2025 - 2024 AS years,
       ROUND((POWER(sales_end / sales_start, 1.0 / (2025 - 2024)) - 1) * 100, 2) AS cagr_pct
FROM ends;

--ranking by sales size in each year
SELECT m.fiscal_year,
       m.segment_name,
       m.value_eur_m AS net_sales,
       RANK() OVER (PARTITION BY m.fiscal_year ORDER BY m.value_eur_m DESC) AS size_rank
FROM fact_segment_metrics m
JOIN dim_segment d ON d.segment_name = m.segment_name
WHERE m.metric = 'net_sales'
  AND m.source_report_year = 2025
  AND d.is_geographic
ORDER BY m.fiscal_year, size_rank;

---growth ranking in 2025, reported versus currency-neutral

WITH sales AS (
    SELECT m.segment_name,
           MAX(m.value_eur_m) FILTER (WHERE m.fiscal_year = 2024) AS sales_2024,
           MAX(m.value_eur_m) FILTER (WHERE m.fiscal_year = 2025) AS sales_2025
    FROM fact_segment_metrics m
    JOIN dim_segment d ON d.segment_name = m.segment_name
    WHERE m.metric = 'net_sales'
      AND m.source_report_year = 2025
      AND d.is_geographic
    GROUP BY m.segment_name
)
SELECT s.segment_name,
       ROUND((s.sales_2025 / s.sales_2024 - 1) * 100, 1) AS reported_growth_pct,
       RANK() OVER (ORDER BY s.sales_2025 / s.sales_2024 DESC) AS rank_reported,
       ROUND(g.net_sales_chg_currency_neutral * 100) AS currency_neutral_pct,
       RANK() OVER (ORDER BY g.net_sales_chg_currency_neutral DESC) AS rank_currency_neutral,
       RANK() OVER (ORDER BY s.sales_2025 / s.sales_2024 DESC)
         - RANK() OVER (ORDER BY g.net_sales_chg_currency_neutral DESC) AS places_gained_after_currency_adj
FROM sales s
JOIN fact_segment_growth g
  ON g.segment_name = s.segment_name
 AND g.source_report_year = 2025
ORDER BY rank_reported;

---shares of group sales in each region , does the mix shift

WITH shares AS (
    SELECT fiscal_year,
           segment_name,
           value_eur_m AS net_sales,
           value_eur_m / SUM(value_eur_m) OVER (PARTITION BY fiscal_year) * 100 AS share_pct
    FROM fact_segment_metrics
    WHERE metric = 'net_sales'
      AND source_report_year = 2025
)
SELECT segment_name,
       ROUND(MAX(share_pct) FILTER (WHERE fiscal_year = 2024), 1) AS share_2024_pct,
       ROUND(MAX(share_pct) FILTER (WHERE fiscal_year = 2025), 1) AS share_2025_pct,
       ROUND(MAX(share_pct) FILTER (WHERE fiscal_year = 2025)
           - MAX(share_pct) FILTER (WHERE fiscal_year = 2024), 2) AS shift_pp
FROM shares
GROUP BY segment_name
ORDER BY share_2025_pct DESC;

--region which added the most euros of sales as opposed to the highest percentage growth?
WITH sales AS (
    SELECT m.segment_name,
           MAX(m.value_eur_m) FILTER (WHERE m.fiscal_year = 2024) AS sales_2024,
           MAX(m.value_eur_m) FILTER (WHERE m.fiscal_year = 2025) AS sales_2025
    FROM fact_segment_metrics m
    JOIN dim_segment d ON d.segment_name = m.segment_name
    WHERE m.metric = 'net_sales'
      AND m.source_report_year = 2025
      AND d.is_geographic
    GROUP BY m.segment_name
)
SELECT segment_name,
       sales_2024,
       sales_2025,
       sales_2025 - sales_2024 AS added_eur_m,
       RANK() OVER (ORDER BY sales_2025 - sales_2024 DESC) AS euro_rank,
       ROUND((sales_2025 / sales_2024 - 1) * 100, 1) AS growth_pct,
       RANK() OVER (ORDER BY sales_2025 / sales_2024 DESC) AS pct_rank
FROM sales
ORDER BY added_eur_m DESC;

---How large is the gap between reported and currency neutral growth which region has the widest case
WITH reg AS (
    SELECT m.segment_name,
           MAX(m.value_eur_m) FILTER (WHERE m.fiscal_year = 2025)
         / MAX(m.value_eur_m) FILTER (WHERE m.fiscal_year = 2024) - 1 AS reported_growth
    FROM fact_segment_metrics m
    JOIN dim_segment d ON d.segment_name = m.segment_name
    WHERE m.metric = 'net_sales'
      AND m.source_report_year = 2025
      AND d.is_geographic
    GROUP BY m.segment_name
)
SELECT r.segment_name,
       ROUND(r.reported_growth * 100, 1) AS reported_pct,
       ROUND(g.net_sales_chg_currency_neutral * 100) AS currency_neutral_pct,
       ROUND((g.net_sales_chg_currency_neutral - r.reported_growth) * 100, 1) AS gap_pp,
       CASE
           WHEN g.net_sales_chg_currency_neutral - r.reported_growth >= 0.10 THEN 'Large'
           WHEN g.net_sales_chg_currency_neutral - r.reported_growth >= 0.05 THEN 'Moderate'
           ELSE 'Small'
       END AS currency_drag,
       RANK() OVER (ORDER BY g.net_sales_chg_currency_neutral - r.reported_growth DESC) AS gap_rank
FROM reg r
JOIN fact_segment_growth g
  ON g.segment_name = r.segment_name
 AND g.source_report_year = 2025
ORDER BY gap_rank;

--- Regions which are more profitable 

WITH m AS (
    SELECT fiscal_year,
           segment_name,
           gross_margin,
           operating_margin,
           LAG(gross_margin)     OVER (PARTITION BY segment_name ORDER BY fiscal_year) AS prior_gross_margin,
           LAG(operating_margin) OVER (PARTITION BY segment_name ORDER BY fiscal_year) AS prior_operating_margin
    FROM fact_segment_margins
    WHERE source_report_year = 2025
)
SELECT m.segment_name,
       op.value_eur_m                                   AS operating_profit_eur_m,
       ROUND(m.operating_margin * 100, 1)               AS op_margin_pct,
       RANK() OVER (ORDER BY m.operating_margin DESC)   AS margin_rank,
       ROUND((m.operating_margin - m.prior_operating_margin) * 100, 1) AS op_margin_change_pp,
       CASE
           WHEN m.operating_margin > m.prior_operating_margin THEN 'Improving'
           WHEN m.operating_margin < m.prior_operating_margin THEN 'Declining'
           ELSE 'Flat'
       END                                              AS op_margin_trend,
       ROUND(m.gross_margin * 100, 1)                   AS gross_margin_pct,
       ROUND((m.gross_margin - m.prior_gross_margin) * 100, 1) AS gross_margin_change_pp
FROM m
JOIN fact_segment_metrics op
  ON  op.source_report_year = 2025
  AND op.fiscal_year        = m.fiscal_year
  AND op.segment_name       = m.segment_name
  AND op.metric             = 'operating_profit'
WHERE m.fiscal_year = 2025
ORDER BY margin_rank, m.segment_name;