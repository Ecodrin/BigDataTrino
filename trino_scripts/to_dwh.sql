SET SESSION clickhouse.map_string_as_varchar = true;

DROP TABLE IF EXISTS clickhouse.dwh.dim_customer;
CREATE TABLE IF NOT EXISTS clickhouse.dwh.dim_customer AS
WITH mock_data AS (
        SELECT
            customer_first_name,
            customer_last_name,
            customer_age,
            customer_email,
            customer_country,
            customer_postal_code
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            customer_first_name,
            customer_last_name,
            customer_age,
            customer_email,
            customer_country,
            customer_postal_code
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR) AS id,
    COALESCE(customer_first_name, '') AS first_name,
    COALESCE(customer_last_name, '') AS last_name,
    customer_age AS age,
    COALESCE(customer_email, '') AS email,
    COALESCE(customer_country, '') AS country,
    COALESCE(customer_postal_code, '') AS postal_code
from mock_data;

DROP TABLE IF EXISTS clickhouse.dwh.dim_pet;
CREATE TABLE IF NOT EXISTS clickhouse.dwh.dim_pet AS
WITH mock_data AS (
        SELECT
            customer_pet_type,
            customer_pet_name,
            customer_pet_breed,
            customer_email
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            customer_pet_type,
            customer_pet_name,
            customer_pet_breed,
            customer_email
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR) AS id,
    COALESCE(customer_pet_type, '') AS type,
    COALESCE(customer_pet_name, '') AS name,
    COALESCE(customer_pet_breed, '') AS breed,
    ds.id as customer_id
from mock_data md
join clickhouse.dwh.dim_customer ds on md.customer_email = ds.email;


DROP TABLE IF EXISTS clickhouse.dwh.dim_seller;
CREATE TABLE IF NOT EXISTS clickhouse.dwh.dim_seller AS
WITH mock_data AS (
        SELECT
            seller_first_name,
            seller_last_name,
            seller_email,
            seller_country,
            seller_postal_code
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            seller_first_name,
            seller_last_name,
            seller_email,
            seller_country,
            seller_postal_code
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR) AS id,
    COALESCE(seller_first_name, '') AS irst_name,
    COALESCE(seller_last_name, '') AS ast_name,
    COALESCE(seller_email, '') AS email,
    COALESCE(seller_country, '') AS country,
    COALESCE(seller_postal_code, '') AS postal_code
from mock_data;


DROP TABLE IF EXISTS clickhouse.dwh.dim_supplier;
CREATE TABLE IF NOT EXISTS clickhouse.dwh.dim_supplier AS
WITH mock_data AS (
        SELECT
            supplier_name,
            supplier_contact,
            supplier_email,
            supplier_phone,
            supplier_country,
            supplier_city,
            supplier_address
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            supplier_name,
            supplier_contact,
            supplier_email,
            supplier_phone,
            supplier_country,
            supplier_city,
            supplier_address
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR) AS id,
    COALESCE(supplier_name, '') AS name,
    COALESCE(supplier_contact, '') AS contact,
    COALESCE(supplier_email, '') AS email,
    COALESCE(supplier_phone, '') AS phone,
    COALESCE(supplier_country, '') AS country,
    COALESCE(supplier_city, '') AS city,
    COALESCE(supplier_address, '') AS address
from mock_data;

DROP TABLE IF EXISTS clickhouse.dwh.dim_store;
CREATE TABLE IF NOT EXISTS clickhouse.dwh.dim_store AS
WITH mock_data AS (
        SELECT
            store_name,
            store_phone,
            store_email,
            store_country,
            store_city,
            store_state,
            store_location
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            store_name,
            store_phone,
            store_email,
            store_country,
            store_city,
            store_state,
            store_location
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR) AS id,
    COALESCE(store_name, '') AS name,
    COALESCE(store_phone, '') AS phone,
    COALESCE(store_email, '') AS email,
    COALESCE(store_country, '') AS country,
    COALESCE(store_city, '') AS city,
    COALESCE(store_state, '') AS state,
    COALESCE(store_location, '') AS location
from mock_data;


DROP TABLE IF EXISTS clickhouse.dwh.dim_product;
CREATE TABLE IF NOT EXISTS clickhouse.dwh.dim_product AS
WITH mock_data AS (
        SELECT
            product_name,
            product_category,
            product_price,
            product_quantity,
            pet_category,
            product_weight,
            product_color,
            product_size,
            product_description,
            product_rating,
            product_reviews,
            product_release_date,
            product_expiry_date,
            product_material,
            product_brand
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            product_name,
            product_category,
            product_price,
            product_quantity,
            pet_category,
            product_weight,
            product_color,
            product_size,
            product_description,
            product_rating,
            product_reviews,
            product_release_date,
            product_expiry_date,
            product_material,
            product_brand
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR) AS id,
    COALESCE(product_name, '') AS name,
    COALESCE(product_category, '') AS category,
    product_price AS price,
    product_quantity AS quantity,
    COALESCE(pet_category, '') AS pet_category,
    product_weight AS weight,
    COALESCE(product_color, '') AS color,
    COALESCE(product_size, '') AS size,
    COALESCE(product_description, '') AS description,
    product_rating AS rating,
    product_reviews AS reviews,
    CAST(DATE_PARSE(product_release_date, '%m/%d/%Y') as Date) AS release_date, 
    CAST(DATE_PARSE(product_expiry_date, '%m/%d/%Y') as Date) AS expiry_date,
    COALESCE(product_material, '') AS product_material,
    COALESCE(product_brand, '') AS product_brand
from mock_data;

DROP TABLE IF EXISTS clickhouse.dwh.fact_sale;
CREATE TABLE IF NOT EXISTS clickhouse.dwh.fact_sale AS
WITH mock_data AS (
        SELECT
            sale_date,
            sale_quantity,
            sale_total_price,
            customer_email,
            seller_email,
            store_email,
            supplier_email,
            product_name,
            product_price,
            product_weight,
            product_brand,
            product_release_date,
            product_expiry_date
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            sale_date,
            sale_quantity,
            sale_total_price,
            customer_email,
            seller_email,
            store_email,
            supplier_email,
            product_name,
            product_price,
            product_weight,
            product_brand,
            product_release_date,
            product_expiry_date
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR) AS id,
    CAST(DATE_PARSE(sale_date, '%m/%d/%Y') as Date) as sale_date,
    cs.id AS customer_id,
    sl.id AS seller_id,
    pr.id AS product_id,
    st.id AS store_id,
    sp.id AS supplier_id,
    sale_quantity AS quantity,
    sale_total_price AS total_price
from mock_data md
join clickhouse.dwh.dim_customer cs on md.customer_email = cs.email
join clickhouse.dwh.dim_seller sl on md.seller_email = sl.email
join clickhouse.dwh.dim_store st on md.store_email = st.email
join clickhouse.dwh.dim_supplier sp on md.supplier_email = sp.email
join clickhouse.dwh.dim_product pr on md.product_name = pr.name
                                    and md.product_price = pr.price
                                    and md.product_weight = pr.weight
                                    and md.product_brand = pr.product_brand
                                    and CAST(DATE_PARSE(md.product_release_date, '%m/%d/%Y') as Date) = pr.release_date
                                    and CAST(DATE_PARSE(md.product_expiry_date, '%m/%d/%Y') as Date) = pr.expiry_date;
                                    

