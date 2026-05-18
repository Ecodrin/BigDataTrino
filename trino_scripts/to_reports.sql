SET SESSION clickhouse.map_string_AS_varchar = true;

DROP TABLE IF EXISTS clickhouse.reports.products;
CREATE TABLE IF NOT EXISTS clickhouse.reports.products AS
SELECT DISTINCT
    dp.id AS id,
    dp.name AS name,
    dp.category AS category,
    dp.rating AS rating,
    dp.reviews AS reviews,
    sum(df.total_price) AS total_sum,
    sum(df.quantity) AS total_quantity
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_product dp on df.product_id = dp.id
group by dp.id, dp.name, dp.category, dp.rating, dp.reviews;

DROP TABLE IF EXISTS clickhouse.reports.customers;
CREATE TABLE IF NOT EXISTS clickhouse.reports.customers AS
SELECT DISTINCT
    dc.id AS id,
    dc.first_name AS first_name,
    dc.lASt_name AS lASt_name,
    dc.country AS country,
    avg(df.total_price) AS avg_sum
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_customer dc on df.customer_id = dc.id
group by dc.id, dc.first_name, dc.lASt_name, dc.country;

DROP TABLE IF EXISTS clickhouse.reports.month_sale;
CREATE TABLE IF NOT EXISTS clickhouse.reports.month_sale AS
SELECT DISTINCT
    DATE_FORMAT(df.sale_date, '%M') AS month,
    avg(df.total_price) AS avg_total_price,
    avg(df.quantity) AS avg_quantity
FROM clickhouse.dwh.fact_sale df
group by DATE_FORMAT(df.sale_date, '%M');

DROP TABLE IF EXISTS clickhouse.reports.store;
CREATE TABLE IF NOT EXISTS clickhouse.reports.store AS
SELECT DISTINCT
    ds.id AS id,
    ds.name AS name,
    ds.country AS country,
    ds.city AS city,
    ds.state AS state,
    ds.location AS location,
    sum(df.total_price) AS sum_total_price,
    avg(df.total_price ) AS avg_total_price
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_store ds on df.store_id = ds.id
group by ds.id, ds.name, ds.country, ds.city, ds.state, ds.location;

DROP TABLE IF EXISTS clickhouse.reports.country_supplier;
CREATE TABLE IF NOT EXISTS clickhouse.reports.country_supplier AS
SELECT DISTINCT
    ds.country AS country,
    sum(df.total_price) AS sum_total_price
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_supplier ds on df.supplier_id = ds.id
group by ds.country;

DROP TABLE IF EXISTS clickhouse.reports.product_reviews;
CREATE TABLE IF NOT EXISTS clickhouse.reports.product_reviews AS
SELECT DISTINCT
    dp.id AS id,
    dp.name AS name,
    dp.product_brand AS product_brand,
    dp.rating AS rating,
    dp.reviews AS reviews,
    sum(df.quantity) AS total_quantity
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_product dp on df.product_id = dp.id
group by dp.id, dp.name, dp.product_brand, dp.rating, dp.reviews;