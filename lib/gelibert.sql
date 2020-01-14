BEGIN TRANSACTION;
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
INSERT INTO "consists_from" VALUES (0,'ProductFrom_0/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (0,'ProductFrom_0/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (0,'ProductFrom_0/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (0,'ProductFrom_0/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (1,'ProductFrom_1/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (1,'ProductFrom_1/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (1,'ProductFrom_1/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (1,'ProductFrom_1/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (2,'ProductFrom_2/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (2,'ProductFrom_2/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (2,'ProductFrom_2/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (2,'ProductFrom_2/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (3,'ProductFrom_3/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (3,'ProductFrom_3/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (3,'ProductFrom_3/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (3,'ProductFrom_3/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (4,'ProductFrom_4/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (4,'ProductFrom_4/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (4,'ProductFrom_4/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (4,'ProductFrom_4/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (5,'ProductFrom_5/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (5,'ProductFrom_5/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (5,'ProductFrom_5/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (5,'ProductFrom_5/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (6,'ProductFrom_6/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (6,'ProductFrom_6/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (6,'ProductFrom_6/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (6,'ProductFrom_6/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (7,'ProductFrom_7/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (7,'ProductFrom_7/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (7,'ProductFrom_7/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (7,'ProductFrom_7/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (8,'ProductFrom_8/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (8,'ProductFrom_8/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (8,'ProductFrom_8/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (8,'ProductFrom_8/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (9,'ProductFrom_9/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (9,'ProductFrom_9/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (9,'ProductFrom_9/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (9,'ProductFrom_9/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (10,'ProductFrom_10/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (10,'ProductFrom_10/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (10,'ProductFrom_10/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (10,'ProductFrom_10/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (11,'ProductFrom_11/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (11,'ProductFrom_11/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (11,'ProductFrom_11/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (11,'ProductFrom_11/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (12,'ProductFrom_12/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (12,'ProductFrom_12/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (12,'ProductFrom_12/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (12,'ProductFrom_12/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (13,'ProductFrom_13/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (13,'ProductFrom_13/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (13,'ProductFrom_13/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (13,'ProductFrom_13/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (14,'ProductFrom_14/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (14,'ProductFrom_14/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (14,'ProductFrom_14/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (14,'ProductFrom_14/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (15,'ProductFrom_15/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (15,'ProductFrom_15/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (15,'ProductFrom_15/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (15,'ProductFrom_15/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (16,'ProductFrom_16/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (16,'ProductFrom_16/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (16,'ProductFrom_16/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (16,'ProductFrom_16/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (17,'ProductFrom_17/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (17,'ProductFrom_17/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (17,'ProductFrom_17/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (17,'ProductFrom_17/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (18,'ProductFrom_18/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (18,'ProductFrom_18/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (18,'ProductFrom_18/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (18,'ProductFrom_18/3',4.0,0.8);
INSERT INTO "consists_from" VALUES (19,'ProductFrom_19/0',1.0,0.2);
INSERT INTO "consists_from" VALUES (19,'ProductFrom_19/1',2.0,0.4);
INSERT INTO "consists_from" VALUES (19,'ProductFrom_19/2',3.0,0.6);
INSERT INTO "consists_from" VALUES (19,'ProductFrom_19/3',4.0,0.8);
INSERT INTO "consists_to" VALUES (0,'ProductTo_0/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (0,'ProductTo_0/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (0,'ProductTo_0/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (0,'ProductTo_0/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (1,'ProductTo_1/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (1,'ProductTo_1/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (1,'ProductTo_1/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (1,'ProductTo_1/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (2,'ProductTo_2/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (2,'ProductTo_2/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (2,'ProductTo_2/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (2,'ProductTo_2/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (3,'ProductTo_3/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (3,'ProductTo_3/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (3,'ProductTo_3/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (3,'ProductTo_3/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (4,'ProductTo_4/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (4,'ProductTo_4/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (4,'ProductTo_4/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (4,'ProductTo_4/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (5,'ProductTo_5/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (5,'ProductTo_5/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (5,'ProductTo_5/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (5,'ProductTo_5/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (6,'ProductTo_6/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (6,'ProductTo_6/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (6,'ProductTo_6/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (6,'ProductTo_6/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (7,'ProductTo_7/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (7,'ProductTo_7/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (7,'ProductTo_7/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (7,'ProductTo_7/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (8,'ProductTo_8/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (8,'ProductTo_8/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (8,'ProductTo_8/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (8,'ProductTo_8/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (9,'ProductTo_9/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (9,'ProductTo_9/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (9,'ProductTo_9/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (9,'ProductTo_9/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (10,'ProductTo_10/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (10,'ProductTo_10/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (10,'ProductTo_10/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (10,'ProductTo_10/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (11,'ProductTo_11/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (11,'ProductTo_11/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (11,'ProductTo_11/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (11,'ProductTo_11/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (12,'ProductTo_12/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (12,'ProductTo_12/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (12,'ProductTo_12/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (12,'ProductTo_12/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (13,'ProductTo_13/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (13,'ProductTo_13/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (13,'ProductTo_13/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (13,'ProductTo_13/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (14,'ProductTo_14/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (14,'ProductTo_14/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (14,'ProductTo_14/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (14,'ProductTo_14/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (15,'ProductTo_15/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (15,'ProductTo_15/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (15,'ProductTo_15/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (15,'ProductTo_15/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (16,'ProductTo_16/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (16,'ProductTo_16/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (16,'ProductTo_16/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (16,'ProductTo_16/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (17,'ProductTo_17/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (17,'ProductTo_17/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (17,'ProductTo_17/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (17,'ProductTo_17/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (18,'ProductTo_18/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (18,'ProductTo_18/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (18,'ProductTo_18/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (18,'ProductTo_18/3',4.0,1.2);
INSERT INTO "consists_to" VALUES (19,'ProductTo_19/0',1.0,0.3);
INSERT INTO "consists_to" VALUES (19,'ProductTo_19/1',2.0,0.6);
INSERT INTO "consists_to" VALUES (19,'ProductTo_19/2',3.0,0.9);
INSERT INTO "consists_to" VALUES (19,'ProductTo_19/3',4.0,1.2);
INSERT INTO "orders" VALUES (0,1,0,'Cash',5.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (1,1,1,'Cash',15.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (2,2,2,'Cash',25.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (3,3,3,'Cash',35.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (4,4,4,'Cash',45.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (5,5,5,'Cash',55.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (6,6,6,'Cash',65.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (7,7,7,'Cash',75.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (8,8,8,'Cash',85.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (9,9,9,'Cash',95.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (10,10,10,'Cash',105.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (11,11,11,'Cash',115.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (12,12,12,'Cash',125.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (13,13,13,'Cash',135.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (14,14,14,'Cash',145.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (15,15,15,'Cash',155.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (16,16,16,'Cash',165.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (17,17,17,'Cash',175.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (18,18,18,'Cash',185.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "orders" VALUES (19,19,19,'Cash',195.0,0,0,'2019-12-01 16:35:32','');
INSERT INTO "clients" VALUES (0,'Name_0','Tel_0','Address_0');
INSERT INTO "clients" VALUES (1,'Name_1','Tel_1','Address_1');
INSERT INTO "clients" VALUES (2,'Name_2','Tel_2','Address_2');
INSERT INTO "clients" VALUES (3,'Name_3','Tel_3','Address_3');
INSERT INTO "clients" VALUES (4,'Name_4','Tel_4','Address_4');
INSERT INTO "clients" VALUES (5,'Name_5','Tel_5','Address_5');
INSERT INTO "clients" VALUES (6,'Name_6','Tel_6','Address_6');
INSERT INTO "clients" VALUES (7,'Name_7','Tel_7','Address_7');
INSERT INTO "clients" VALUES (8,'Name_8','Tel_8','Address_8');
INSERT INTO "clients" VALUES (9,'Name_9','Tel_9','Address_9');
INSERT INTO "clients" VALUES (10,'Name_10','Tel_10','Address_10');
INSERT INTO "clients" VALUES (11,'Name_11','Tel_11','Address_11');
INSERT INTO "clients" VALUES (12,'Name_12','Tel_12','Address_12');
INSERT INTO "clients" VALUES (13,'Name_13','Tel_13','Address_13');
INSERT INTO "clients" VALUES (14,'Name_14','Tel_14','Address_14');
INSERT INTO "clients" VALUES (15,'Name_15','Tel_15','Address_15');
INSERT INTO "clients" VALUES (16,'Name_16','Tel_16','Address_16');
INSERT INTO "clients" VALUES (17,'Name_17','Tel_17','Address_17');
INSERT INTO "clients" VALUES (18,'Name_18','Tel_18','Address_18');
INSERT INTO "clients" VALUES (19,'Name_19','Tel_19','Address_19');
INSERT INTO "couriers" VALUES (0,123456789012300,'Tel_0','Name_0','CarNumber_0',0.0,0.0,'Address_0');
INSERT INTO "couriers" VALUES (1,123456789012301,'Tel_1','Name_1','CarNumber_1',0.0,0.0,'Address_1');
INSERT INTO "couriers" VALUES (2,123456789012302,'Tel_2','Name_2','CarNumber_2',0.0,0.0,'Address_2');
INSERT INTO "couriers" VALUES (3,123456789012303,'Tel_3','Name_3','CarNumber_3',0.0,0.0,'Address_3');
INSERT INTO "couriers" VALUES (4,123456789012304,'Tel_4','Name_4','CarNumber_4',0.0,0.0,'Address_4');
INSERT INTO "couriers" VALUES (5,123456789012305,'Tel_5','Name_5','CarNumber_5',0.0,0.0,'Address_5');
INSERT INTO "couriers" VALUES (6,123456789012306,'Tel_6','Name_6','CarNumber_6',0.0,0.0,'Address_6');
INSERT INTO "couriers" VALUES (7,123456789012307,'Tel_7','Name_7','CarNumber_7',0.0,0.0,'Address_7');
INSERT INTO "couriers" VALUES (8,123456789012308,'Tel_8','Name_8','CarNumber_8',0.0,0.0,'Address_8');
INSERT INTO "couriers" VALUES (9,123456789012309,'Tel_9','Name_9','CarNumber_9',0.0,0.0,'Address_9');
INSERT INTO "couriers" VALUES (10,123456789012310,'Tel_10','Name_10','CarNumber_10',0.0,0.0,'Address_10');
INSERT INTO "couriers" VALUES (11,123456789012311,'Tel_11','Name_11','CarNumber_11',0.0,0.0,'Address_11');
INSERT INTO "couriers" VALUES (12,123456789012312,'Tel_12','Name_12','CarNumber_12',0.0,0.0,'Address_12');
INSERT INTO "couriers" VALUES (13,123456789012313,'Tel_13','Name_13','CarNumber_13',0.0,0.0,'Address_13');
INSERT INTO "couriers" VALUES (14,123456789012314,'Tel_14','Name_14','CarNumber_14',0.0,0.0,'Address_14');
INSERT INTO "couriers" VALUES (15,123456789012315,'Tel_15','Name_15','CarNumber_15',0.0,0.0,'Address_15');
INSERT INTO "couriers" VALUES (16,123456789012316,'Tel_16','Name_16','CarNumber_16',0.0,0.0,'Address_16');
INSERT INTO "couriers" VALUES (17,123456789012317,'Tel_17','Name_17','CarNumber_17',0.0,0.0,'Address_17');
INSERT INTO "couriers" VALUES (18,123456789012318,'Tel_18','Name_18','CarNumber_18',0.0,0.0,'Address_18');
INSERT INTO "couriers" VALUES (19,123456789012319,'Tel_19','Name_19','CarNumber_19',0.0,0.0,'Address_19');
COMMIT;