BEGIN TRANSACTION;
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
  "imei" INTEGER NOT NULL UNIQUE,
  "tel" TEXT,
  "name" TEXT,
  "car_number" TEXT,
  "latitude" REAL,
  "longitude" REAL,
  "address" TEXT,
  PRIMARY KEY("id")
);
INSERT INTO "consists_from"
VALUES
  (0, 0, 'Бутыль 19л', 2.0, 0, 'Тара на возврат');
INSERT INTO "consists_from"
VALUES
  (1, 0, 'Куллер', 1.0, 800.00, '');
INSERT INTO "consists_from"
VALUES
  (4, 1, 'Бутыль 19л', 3.0, 0.0, 'Тара на возврат');
INSERT INTO "consists_from"
VALUES
  (5, 2, 'Бутыль 19л', 1.0, 0.0, 'Тара на возврат');
INSERT INTO "consists_from"
VALUES
  (6, 2, 'Куллер', 1.0, 920.0, '201');
INSERT INTO "consists_to"
VALUES
  (0, 0, 'Вода', 2.0, 49.0, '');
INSERT INTO "consists_to"
VALUES
  (1, 0, 'Куллер', 1.0, 920.0, '239561953');
INSERT INTO "consists_to"
VALUES
  (2, 1, 'A/U Cristalina 19L N/G', 2.0, 45.0, '');
INSERT INTO "consists_to"
VALUES
  (3, 2, 'Куллер', 1.0, 840.00, '2104580236');
INSERT INTO "consists_to"
VALUES
  (4, 2, 'Вода', 50.0, 4.0, '');
INSERT INTO "consists_to"
VALUES
  (5, 3, 'Куллер', 1.0, 710.00, '3003016782');
INSERT INTO "orders"
VALUES
  (
    0,
    1,
    0,
    'По перечислению',
    1018.00,
    0,
    0,
    '2020-03-09 09:00:00',
    ''
  );
INSERT INTO "orders"
VALUES
  (
    1,
    1,
    1,
    'Счет-фактура',
    90.0,
    0,
    0,
    '2020-03-09 09:00:00',
    ''
  );
INSERT INTO "orders"
VALUES
  (
    2,
    1,
    2,
    'По перечислению',
    1040.0,
    0,
    0,
    '2020-03-09 09:00:00',
    ''
  );
INSERT INTO "orders"
VALUES
  (
    3,
    1,
    3,
    'Наличные',
    710.0,
    0,
    0,
    '2020-03-09 09:00:00',
    ''
  );
INSERT INTO "clients"
VALUES
  (
    0,
    'BC MOLDOVA-AGROBANK SA',
    '+37369512340',
    'Кишинев, ул. Эминеску 39'
  );
INSERT INTO "clients"
VALUES
  (
    1,
    'Iumas-Link SRL',
    '+37323120234',
    'Бельцы, ул. Стрыйская 25'
  );
INSERT INTO "clients"
VALUES
  (
    2,
    'Raut SA',
    '+37369133792',
    'Balti, str. Decebal 10'
  );
INSERT INTO "clients"
VALUES
  (
    3,
    'Boldescu Ion',
    '+373222503478',
    'Chisinau, str. Pushkina 56'
  );
INSERT INTO "couriers"
VALUES
  (
    0,
    123456789012300,
    '+37369122113',
    'Попов Олег',
    'BLBB347',
    0.0,
    0.0,
    'str.Iorga 25'
  );
COMMIT;