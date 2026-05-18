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
