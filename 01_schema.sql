-- =====================================================================
-- NOTA SOBRE ESTE ARCHIVO
-- =====================================================================
-- Este archivo contiene el DDL de PostgreSQL original. NO es necesario
-- para el setup con BigQuery (la arquitectura elegida del proyecto).
--
-- Si quieres correr el proyecto con BigQuery:
--   → Sigue docs/setup_bigquery.md (paso 4: carga CSVs con autodetect).
--   → Luego ejecuta sql/01_setup_views.sql para crear las vistas analíticas.
--
-- Mantenemos este archivo como referencia para quien quiera replicar el
-- proyecto en PostgreSQL local. Demuestra que el modelo dimensional fue
-- pensado desde el inicio con FKs, índices y constraints.
-- =====================================================================

DROP TABLE IF EXISTS order_details CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS client_types CASCADE;
DROP TABLE IF EXISTS order_statuses CASCADE;
DROP TABLE IF EXISTS countries CASCADE;
DROP TABLE IF EXISTS positions CASCADE;

CREATE TABLE countries (
    country_id   INT PRIMARY KEY,
    code         VARCHAR(2) NOT NULL,
    name         VARCHAR(50) NOT NULL,
    continent    VARCHAR(30) NOT NULL
);

CREATE TABLE categories (
    category_id  INT PRIMARY KEY,
    name         VARCHAR(50) NOT NULL,
    description  TEXT
);

CREATE TABLE client_types (
    client_type_id INT PRIMARY KEY,
    name           VARCHAR(30) NOT NULL,
    description    TEXT
);

CREATE TABLE order_statuses (
    order_status_id INT PRIMARY KEY,
    name            VARCHAR(30) NOT NULL,
    description     TEXT
);

CREATE TABLE positions (
    position_id   INT PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    description   TEXT
);

CREATE TABLE locations (
    location_id  INT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    city         VARCHAR(50) NOT NULL,
    country_id   INT NOT NULL REFERENCES countries(country_id),
    address      VARCHAR(200),
    status       BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE employees (
    employee_id        INT PRIMARY KEY,
    name               VARCHAR(50) NOT NULL,
    last_name          VARCHAR(50) NOT NULL,
    email              VARCHAR(120) UNIQUE NOT NULL,
    location_id        INT NOT NULL REFERENCES locations(location_id),
    registration_date  DATE NOT NULL,
    employee_position  INT NOT NULL REFERENCES positions(position_id),
    status             BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE products (
    product_id    INT PRIMARY KEY,
    product_name  VARCHAR(120) NOT NULL,
    category_id   INT NOT NULL REFERENCES categories(category_id),
    price         DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock         INT NOT NULL CHECK (stock >= 0),
    description   TEXT,
    status        BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE clients (
    client_id          INT PRIMARY KEY,
    name               VARCHAR(50) NOT NULL,
    last_name          VARCHAR(50) NOT NULL,
    email              VARCHAR(120) UNIQUE NOT NULL,
    phone              VARCHAR(30),
    registration_date  DATE NOT NULL,
    country_id         INT NOT NULL REFERENCES countries(country_id),
    city               VARCHAR(50),
    client_type_id     INT NOT NULL REFERENCES client_types(client_type_id),
    status             BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE orders (
    order_id          INT PRIMARY KEY,
    client_id         INT NOT NULL REFERENCES clients(client_id),
    location_id       INT NOT NULL REFERENCES locations(location_id),
    employee_id       INT NOT NULL REFERENCES employees(employee_id),
    registration_date DATE NOT NULL,
    order_status_id   INT NOT NULL REFERENCES order_statuses(order_status_id),
    total_amount      DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
    notes             TEXT
);

CREATE TABLE order_details (
    detail_id   INT PRIMARY KEY,
    order_id    INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id  INT NOT NULL REFERENCES products(product_id),
    quantity    INT NOT NULL CHECK (quantity > 0),
    unit_price  DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0)
);

CREATE INDEX idx_orders_client ON orders(client_id);
CREATE INDEX idx_orders_date   ON orders(registration_date);
CREATE INDEX idx_orders_status ON orders(order_status_id);
CREATE INDEX idx_details_order ON order_details(order_id);
CREATE INDEX idx_details_prod  ON order_details(product_id);
CREATE INDEX idx_clients_country ON clients(country_id);
CREATE INDEX idx_clients_type    ON clients(client_type_id);
