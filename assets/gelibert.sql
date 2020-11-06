PRAGMA foreign_keys = off;

BEGIN TRANSACTION;-- Таблица: clients

DROP TABLE IF EXISTS clients;

CREATE TABLE clients (
    id      TEXT NOT NULL
                 UNIQUE,
    name    TEXT,
    tel     TEXT,
    address TEXT,
    PRIMARY KEY (
        id
    )
);-- Таблица: consists_from

DROP TABLE IF EXISTS consists_from;

CREATE TABLE consists_from (
    di       INTEGER NOT NULL,
    id       TEXT,
    product  TEXT,
    quantity REAL,
    price    REAL,
    ext_info TEXT,
    CONSTRAINT lnk_orders_consists_from FOREIGN KEY (
        id
    )
    REFERENCES orders (id) ON DELETE CASCADE
                           ON UPDATE CASCADE,
    CONSTRAINT unique_di UNIQUE (
        di
    )
);-- Таблица: consists_to

DROP TABLE IF EXISTS consists_to;

CREATE TABLE consists_to (
    di       INTEGER NOT NULL,
    id       TEXT,
    product  TEXT,
    quantity REAL,
    price    REAL,
    ext_info TEXT,
    CONSTRAINT lnk_orders_consists_to FOREIGN KEY (
        id
    )
    REFERENCES orders (id) ON DELETE CASCADE
                           ON UPDATE CASCADE,
    CONSTRAINT unique_di UNIQUE (
        di
    )
);-- Таблица: couriers

DROP TABLE IF EXISTS couriers;

CREATE TABLE couriers (
    id          TEXT     NOT NULL
                         UNIQUE,
    mac_address TEXT     NOT NULL,
    tel         TEXT,
    name        TEXT,
    car_number  TEXT,
    latitude    REAL,
    longitude   REAL,
    address     TEXT,
    timestamp   DATETIME NOT NULL
                         DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime') ),
    PRIMARY KEY (
        id
    )
);-- Таблица: orders

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id             TEXT    NOT NULL
                           PRIMARY KEY,
    courier_id     TEXT,
    client_id      TEXT,
    payment_method TEXT,
    order_cost     REAL,
    delivered      INTEGER,
    delivery_delay INTEGER,
    date_start     TEXT,
    date_finish    TEXT,
    CONSTRAINT lnk_clients_orders FOREIGN KEY (
        client_id
    )
    REFERENCES clients (id) ON DELETE CASCADE
                            ON UPDATE CASCADE,
    CONSTRAINT lnk_couriers_orders FOREIGN KEY (
        courier_id
    )
    REFERENCES couriers (id) ON DELETE CASCADE
                             ON UPDATE CASCADE,
    CONSTRAINT unique_id UNIQUE (
        id
    )
);-- Триггер: insert_timestamp_trigger

DROP TRIGGER IF EXISTS insert_timestamp_trigger;

CREATE TRIGGER insert_timestamp_trigger
         AFTER INSERT
            ON couriers
BEGIN
    UPDATE couriers
       SET timestamp = datetime(CURRENT_TIMESTAMP, 'localtime') 
     WHERE id = NEW.id;
END;-- Триггер: update_timestamp_trigger

DROP TRIGGER IF EXISTS update_timestamp_trigger;

CREATE TRIGGER update_timestamp_trigger
         AFTER UPDATE
            ON couriers
BEGIN
    UPDATE couriers
       SET timestamp = datetime(CURRENT_TIMESTAMP, 'localtime') 
     WHERE id = NEW.id;
END;

COMMIT TRANSACTION ; 

PRAGMA foreign_keys = on;
