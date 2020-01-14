CREATE TABLE IF NOT EXISTS "consists_from" (
	"id"	INTEGER,
	"product"	TEXT,
	"quantity"	REAL,
	"price"	REAL
);
CREATE TABLE IF NOT EXISTS "consists_to" (
	"id"	INTEGER,
	"product"	TEXT,
	"quantity"	REAL,
	"price"	REAL
);
CREATE TABLE IF NOT EXISTS "orders" (
	"id"	INTEGER NOT NULL UNIQUE,
	"courier_id"	INTEGER,
	"client_id"	INTEGER,
	"payment_method"	TEXT,
	"order_cost"	REAL,
	"delivered"	INTEGER,
	"delivery_delay"	INTEGER,
	"date_start"	TEXT,
	"date_finish"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "clients" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT,
	"tel"	TEXT,
	"address"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "couriers" (
	"id"	INTEGER NOT NULL UNIQUE,
	"imei"	INTEGER NOT NULL UNIQUE,
	"tel"	TEXT,
	"name"	TEXT,
	"car_number"	TEXT,
	"latitude"	REAL,
	"longitude"	REAL,
	"address"	TEXT,
	PRIMARY KEY("id")
);