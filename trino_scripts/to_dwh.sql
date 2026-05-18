SET SESSION clickhouse.map_string_as_varchar = true;

INSERT INTO clickhouse.dwh.dim_customer(id, first_name, last_name, age, email, country, postal_code)
WITH mock_data AS (
        SELECT
            *
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            *
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR),
    COALESCE(customer_first_name, ''),
    COALESCE(customer_last_name, ''),
    customer_age,
    COALESCE(customer_email, ''),
    COALESCE(customer_country, ''),
    COALESCE(customer_postal_code, '')
from mock_data;

INSERT INTO clickhouse.dwh.dim_pet(id, type, name, breed, customer_id)
WITH mock_data AS (
        SELECT
            *
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            *
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR),
    COALESCE(customer_pet_type, ''),
    COALESCE(customer_pet_name, ''),
    COALESCE(customer_pet_breed, ''),
    ds.id
from mock_data md
join clickhouse.dwh.dim_customer ds on md.customer_email = ds.email;


INSERT INTO clickhouse.dwh.dim_seller(id, first_name, last_name, email, country, postal_code)
WITH mock_data AS (
        SELECT
            *
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            *
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR),
    COALESCE(seller_first_name, ''),
    COALESCE(seller_last_name, ''),
    COALESCE(seller_email, ''),
    COALESCE(seller_country, ''),
    COALESCE(seller_postal_code, '')
from mock_data;


INSERT INTO clickhouse.dwh.dim_supplier(id, name, contact, email, phone, country, city, address)
WITH mock_data AS (
        SELECT
            *
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            *
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR),
    COALESCE(supplier_name, ''),
    COALESCE(supplier_contact, ''),
    COALESCE(supplier_email, ''),
    COALESCE(supplier_phone, ''),
    COALESCE(supplier_country, ''),
    COALESCE(supplier_city, ''),
    COALESCE(supplier_address, '')
from mock_data;

INSERT INTO clickhouse.dwh.dim_store(id, name, phone, email, country, city, state, address)
WITH mock_data AS (
        SELECT
            *
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            *
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR),
    COALESCE(store_name, ''),
    COALESCE(store_phone, ''),
    COALESCE(store_email, ''),
    COALESCE(store_country, ''),
    COALESCE(store_city, ''),
    COALESCE(store_state, ''),
    COALESCE(store_location, '')
from mock_data;


INSERT INTO clickhouse.dwh.dim_product(id, name, category, price, quantity, pet_category, weight, color, size, description, rating, reviews, release_date, expiry_date,product_material, product_brand)
WITH mock_data AS (
        SELECT
            *
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            *
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR),
    COALESCE(product_name, ''),
    COALESCE(product_category, ''),
    product_price,
    product_quantity,
    COALESCE(pet_category, ''),
    product_weight,
    COALESCE(product_color, ''),
    COALESCE(product_size, ''),
    COALESCE(product_description, ''),
    product_rating,
    product_reviews,
    CAST(DATE_PARSE(product_release_date, '%m/%d/%Y') as Date), 
    CAST(DATE_PARSE(product_expiry_date, '%m/%d/%Y') as Date),
    COALESCE(product_material, ''),
    COALESCE(product_brand, '')
from mock_data;

INSERT INTO clickhouse.dwh.fact_sale(id, sale_date, customer_id, seller_id, product_id, store_id, supplier_id, quantity, total_price)
WITH mock_data AS (
        SELECT
            *
        FROM clickhouse.src.mock_data
    union all 
        SELECT
            *
        FROM postgres.src.mock_data
)
SELECT DISTINCT
    CAST(UUID() AS VARCHAR),
    CAST(DATE_PARSE(sale_date, '%m/%d/%Y') as Date),
    cs.id,
    sl.id,
    pr.id,
    st.id,
    sp.id,
    sale_quantity,
    sale_total_price
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
                                    

