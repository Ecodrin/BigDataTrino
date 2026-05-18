create database if not exists src;
create database if not exists dwh;
create database if not exists reports;


CREATE TABLE if not exists src.mock_data(
	id integer DEFAULT 0,
	customer_first_name String NULL,
	customer_last_name String NULL,
	customer_age integer NULL,
	customer_email String NULL,
	customer_country String NULL,
	customer_postal_code String NULL,
	customer_pet_type String NULL,
	customer_pet_name String NULL,
	customer_pet_breed String NULL,
	seller_first_name String NULL,
	seller_last_name String NULL,
	seller_email String NULL,
	seller_country String NULL,
	seller_postal_code String NULL,
	product_name String NULL,
	product_category String NULL,
	product_price Decimal(10, 2) NULL,
	product_quantity integer NULL,
	sale_date String NULL,
	sale_customer_id integer NULL,
	sale_seller_id integer NULL,
	sale_product_id integer NULL,
	sale_quantity integer NULL,
	sale_total_price Decimal(10, 2) NULL,
	store_name String NULL,
	store_location String NULL,
	store_city String NULL,
	store_state String NULL,
	store_country String NULL,
	store_phone String NULL,
	store_email String NULL,
	pet_category String NULL,
	product_weight Decimal(10, 2) NULL,
	product_color String NULL,
	product_size String NULL,
	product_brand String NULL,
	product_material String NULL,
	product_description VARCHAR(1024) NULL,
	product_rating Decimal(10, 2) NULL,
	product_reviews integer NULL,
	product_release_date String NULL,
	product_expiry_date String NULL,
	supplier_name String NULL,
	supplier_contact String NULL,
	supplier_email String NULL,
	supplier_phone String NULL,
	supplier_address String NULL,
	supplier_city String NULL,
	supplier_country String NULL
) engine = MergeTree
order by id;


INSERT INTO src.mock_data FROM INFILE '/opt/src_data/MOCK_DATA.csv'     FORMAT CSV;
INSERT INTO src.mock_data FROM INFILE '/opt/src_data/MOCK_DATA (1).csv' FORMAT CSV;
INSERT INTO src.mock_data FROM INFILE '/opt/src_data/MOCK_DATA (2).csv' FORMAT CSV;
INSERT INTO src.mock_data FROM INFILE '/opt/src_data/MOCK_DATA (3).csv' FORMAT CSV;
INSERT INTO src.mock_data FROM INFILE '/opt/src_data/MOCK_DATA (4).csv' FORMAT CSV;

create table if not exists dwh.dim_customer (
    id String,
	first_name String,
	last_name String,
	age INTEGER,
	email String,
	country String,
	postal_code String
) engine = MergeTree
order by id;

create table if not exists dwh.dim_pet (
    id String,
	type String,
	name String,
	breed String,
	customer_id String 
) engine = MergeTree
order by id;

create table if not exists dwh.dim_seller (
    id String,
	first_name String,
	last_name String,
	email String,
	country String,
	postal_code String
) engine = MergeTree
order by id;


create table if not exists dwh.dim_supplier (
    id String,
	name String,
	contact String,
	email String,
	phone String,
	country String,
	city String,
	address String
) engine = MergeTree
order by id;

create table if not exists dwh.dim_store (
    id String,
	name String,
	phone String,
	email String,
	country String,
	city String,
	state String,
	address String
) engine = MergeTree
order by id;

create table if not exists dwh.dim_product (
    id String,
	name String,
	category String,
	price Decimal(10, 2),
	quantity INTEGER,
	pet_category String,
	weight Decimal(10, 2),
	color String,
	size String,
	description String,
	rating Decimal(10, 2),
	reviews INTEGER,
	release_date Date,
	expiry_date Date,
	product_material String,
	product_brand String
) engine = MergeTree
order by id;

create table if not exists dwh.fact_sale (
    id String,
	sale_date Date,
	customer_id String,
	seller_id String,
	product_id String,
	store_id String,
	supplier_id String,
	quantity Integer,
	total_price Decimal(10, 2)
) engine = MergeTree
order by id;


create table if not exists reports.products (
    product_id String,
	product_name String,
	product_category String,
	rating Decimal(10, 2),
	reviews Int32,
	total_sum Decimal(10, 2),
	total_count Int32
) engine = MergeTree
order by total_sum;

create table if not exists reports.customers (
    customer_id String,
	customer_first_name String,
	customer_last_name String,
	customer_country String,
	avg_sum Decimal(10, 2)
) engine = MergeTree
order by avg_sum;

create table if not exists reports.month_sale (
    month String,
	avg_sum Decimal(10, 2),
	avg_count Decimal(10, 2)
) engine = MergeTree
order by month;

create table if not exists reports.store (
    store_id String,
	store_name String,
	store_country String,
	store_city String,
	store_state String,
	store_address String, 
	total_sum Decimal(10, 2),
	avg_sum Decimal(10, 2)
) engine = MergeTree
order by total_sum;

create table if not exists reports.country_supplier (
	supplier_country String,
	total_sum Decimal(10, 2)
) engine = MergeTree
order by supplier_country;

create table if not exists reports.product_reviews (
	product_id String,
	product_name String,
	product_brand String,
	rating Decimal(10, 2),
	reviews UInt32,
	total_quantity Int32
) engine = MergeTree
order by reviews;