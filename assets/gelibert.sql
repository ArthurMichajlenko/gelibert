CREATE TABLE IF NOT EXISTS "consists_from" (
  "di" INTEGER NOT NULL UNIQUE,
  "id" INTEGER,
  "product" TEXT,
  "quantity" REAL,
  "price" REAL,
  "ext_info" TEXT
);
CREATE TABLE IF NOT EXISTS "consists_to" (
  "di" INTEGER NOT NULL UNIQUE,
  "id" INTEGER,
  "product" TEXT,
  "quantity" REAL,
  "price" REAL,
  "ext_info" TEXT
);
CREATE TABLE IF NOT EXISTS "orders" (
  "id" INTEGER NOT NULL UNIQUE,
  "courier_id" INTEGER,
  "client_id" INTEGER,
  "payment_method" TEXT,
  "order_cost" REAL,
  "delivered" INTEGER,
  "delivery_delay" INTEGER,
  "date_start" TEXT,
  "date_finish" TEXT,
  PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "clients" (
  "id" INTEGER NOT NULL UNIQUE,
  "name" TEXT,
  "tel" TEXT,
  "address" TEXT,
  PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "couriers" (
  "id" INTEGER NOT NULL UNIQUE,
  "imei" INTEGER NOT NULL,
  "tel" TEXT,
  "name" TEXT,
  "car_number" TEXT,
  "latitude" REAL,
  "longitude" REAL,
  "address" TEXT,
  "timestamp" DateTime NOT NULL DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')) PRIMARY KEY("id")
);
CREATE TRIGGER IF NOT EXISTS insert_timestamp_trigger
AFTER
INSERT ON couriers BEGIN
UPDATE couriers
SET
  timestamp = datetime(CURRENT_TIMESTAMP, 'localtime')
WHERE
  id = NEW.id;
CREATE TRIGGER IF NOT EXISTS update_timestamp_trigger
AFTER
UPDATE ON couriers BEGIN
UPDATE couriers
SET
  timestamp = datetime(CURRENT_TIMESTAMP, 'localtime')
WHERE
  id = NEW.id;