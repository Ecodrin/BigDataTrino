SET SESSION clickhouse.map_string_as_varchar = true;

INSERT INTO clickhouse.reports.products
SELECT DISTINCT
    dp.id,
    dp.name,
    dp.category,
    dp.rating,
    dp.reviews,
    sum(df.total_price) as total_sum,
    sum(df.quantity)
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_product dp on df.product_id = dp.id
group by dp.id, dp.name, dp.category, dp.rating, dp.reviews;

INSERT INTO clickhouse.reports.customers
SELECT DISTINCT
    dc.id,
    dc.first_name,
    dc.last_name,
    dc.country,
    avg(df.total_price) as avg_sum
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_customer dc on df.customer_id = dc.id
group by dc.id, dc.first_name, dc.last_name, dc.country;

INSERT INTO clickhouse.reports.month_sale
SELECT DISTINCT
    DATE_FORMAT(df.sale_date, '%M') AS month,
    avg(df.total_price),
    avg(df.quantity)
FROM clickhouse.dwh.fact_sale df
group by DATE_FORMAT(df.sale_date, '%M');

INSERT INTO clickhouse.reports.store
SELECT DISTINCT
    ds.id,
    ds.name,
    ds.country,
    ds.city,
    ds.state,
    ds.address,
    sum(df.total_price),
    avg(df.total_price)
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_store ds on df.store_id = ds.id
group by ds.id, ds.name, ds.country, ds.city, ds.state, ds.address;

INSERT INTO clickhouse.reports.country_supplier
SELECT DISTINCT
    ds.country,
    sum(df.total_price)
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_supplier ds on df.supplier_id = ds.id
group by ds.country;

INSERT INTO clickhouse.reports.product_reviews
SELECT DISTINCT
    dp.id,
    dp.name,
    dp.product_brand,
    dp.rating,
    dp.reviews,
    sum(df.quantity)
FROM clickhouse.dwh.fact_sale df
join clickhouse.dwh.dim_product dp on df.product_id = dp.id
group by dp.id, dp.name, dp.product_brand, dp.rating, dp.reviews;