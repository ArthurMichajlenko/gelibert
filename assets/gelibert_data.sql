BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "consists_from" (
	"di" INTEGER NOT NULL UNIQUE,
	"id"	INTEGER,
	"product"	TEXT,
	"quantity"	REAL,
	"price"	REAL,
	"ext_info" TEXT
);
CREATE TABLE IF NOT EXISTS "consists_to" (
	"di" INTEGER NOT NULL UNIQUE,
	"id"	INTEGER,
	"product"	TEXT,
	"quantity"	REAL,
	"price"	REAL,
	"ext_info" TEXT
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
INSERT INTO "consists_from" VALUES (0,0,'ProductFrom_0/0',1.0,0.2,'000');
INSERT INTO "consists_from" VALUES (1,0,'ProductFrom_0/1',2.0,0.4,'001');
INSERT INTO "consists_from" VALUES (2,0,'ProductFrom_0/2',3.0,0.6,'002');
INSERT INTO "consists_from" VALUES (3,0,'ProductFrom_0/3',4.0,0.8,'003');
INSERT INTO "consists_from" VALUES (4,1,'ProductFrom_1/0',1.0,0.2,'100');
INSERT INTO "consists_from" VALUES (5,1,'ProductFrom_1/1',2.0,0.4,'101');
INSERT INTO "consists_from" VALUES (6,1,'ProductFrom_1/2',3.0,0.6,'102');
INSERT INTO "consists_from" VALUES (7,1,'ProductFrom_1/3',4.0,0.8,'103');
INSERT INTO "consists_from" VALUES (8,2,'ProductFrom_2/0',1.0,0.2,'200');
INSERT INTO "consists_from" VALUES (9,2,'ProductFrom_2/1',2.0,0.4,'201');
INSERT INTO "consists_from" VALUES (10,2,'ProductFrom_2/2',3.0,0.6,'202');
INSERT INTO "consists_from" VALUES (11,2,'ProductFrom_2/3',4.0,0.8,'203');
INSERT INTO "consists_from" VALUES (12,3,'ProductFrom_3/0',1.0,0.2,'300');
INSERT INTO "consists_from" VALUES (13,3,'ProductFrom_3/1',2.0,0.4,'301');
INSERT INTO "consists_from" VALUES (14,3,'ProductFrom_3/2',3.0,0.6,'302');
INSERT INTO "consists_from" VALUES (15,3,'ProductFrom_3/3',4.0,0.8,'303');
INSERT INTO "consists_from" VALUES (16,4,'ProductFrom_4/0',1.0,0.2,'400');
INSERT INTO "consists_from" VALUES (17,4,'ProductFrom_4/1',2.0,0.4,'401');
INSERT INTO "consists_from" VALUES (18,4,'ProductFrom_4/3',4.0,0.8,'402');
INSERT INTO "consists_from" VALUES (19,4,'ProductFrom_4/2',3.0,0.6,'403');
INSERT INTO "consists_from" VALUES (20,5,'ProductFrom_5/0',1.0,0.2,'500');
INSERT INTO "consists_from" VALUES (21,5,'ProductFrom_5/1',2.0,0.4,'501');
INSERT INTO "consists_from" VALUES (22,5,'ProductFrom_5/2',3.0,0.6,'502');
INSERT INTO "consists_from" VALUES (23,5,'ProductFrom_5/3',4.0,0.8,'503');
INSERT INTO "consists_from" VALUES (24,6,'ProductFrom_6/0',1.0,0.2,'600');
INSERT INTO "consists_from" VALUES (25,6,'ProductFrom_6/1',2.0,0.4,'601');
INSERT INTO "consists_from" VALUES (26,6,'ProductFrom_6/2',3.0,0.6,'602');
INSERT INTO "consists_from" VALUES (27,6,'ProductFrom_6/3',4.0,0.8,'603');
INSERT INTO "consists_from" VALUES (28,7,'ProductFrom_7/0',1.0,0.2,'700');
INSERT INTO "consists_from" VALUES (29,7,'ProductFrom_7/1',2.0,0.4,'701');
INSERT INTO "consists_from" VALUES (30,7,'ProductFrom_7/2',3.0,0.6,'702');
INSERT INTO "consists_from" VALUES (31,7,'ProductFrom_7/3',4.0,0.8,'703');
INSERT INTO "consists_from" VALUES (32,8,'ProductFrom_8/0',1.0,0.2,'800');
INSERT INTO "consists_from" VALUES (33,8,'ProductFrom_8/1',2.0,0.4,'801');
INSERT INTO "consists_from" VALUES (34,8,'ProductFrom_8/2',3.0,0.6,'802');
INSERT INTO "consists_from" VALUES (35,8,'ProductFrom_8/3',4.0,0.8,'803');
INSERT INTO "consists_from" VALUES (36,9,'ProductFrom_9/0',1.0,0.2,'900');
INSERT INTO "consists_from" VALUES (37,9,'ProductFrom_9/1',2.0,0.4,'901');
INSERT INTO "consists_from" VALUES (38,9,'ProductFrom_9/2',3.0,0.6,'902');
INSERT INTO "consists_from" VALUES (39,9,'ProductFrom_9/3',4.0,0.8,'903');
INSERT INTO "consists_from" VALUES (40,10,'ProductFrom_10/0',1.0,0.2,'1000');
INSERT INTO "consists_from" VALUES (41,10,'ProductFrom_10/1',2.0,0.4,'1001');
INSERT INTO "consists_from" VALUES (42,10,'ProductFrom_10/2',3.0,0.6,'1002');
INSERT INTO "consists_from" VALUES (43,10,'ProductFrom_10/3',4.0,0.8,'1003');
INSERT INTO "consists_from" VALUES (44,11,'ProductFrom_11/0',1.0,0.2,'1100');
INSERT INTO "consists_from" VALUES (45,11,'ProductFrom_11/1',2.0,0.4,'1101');
INSERT INTO "consists_from" VALUES (46,11,'ProductFrom_11/2',3.0,0.6,'1102');
INSERT INTO "consists_from" VALUES (47,11,'ProductFrom_11/3',4.0,0.8,'1103');
INSERT INTO "consists_from" VALUES (48,12,'ProductFrom_12/0',1.0,0.2,'1200');
INSERT INTO "consists_from" VALUES (49,12,'ProductFrom_12/1',2.0,0.4,'1201');
INSERT INTO "consists_from" VALUES (50,12,'ProductFrom_12/2',3.0,0.6,'1202');
INSERT INTO "consists_from" VALUES (51,12,'ProductFrom_12/3',4.0,0.8,'1203');
INSERT INTO "consists_from" VALUES (52,13,'ProductFrom_13/0',1.0,0.2,'1300');
INSERT INTO "consists_from" VALUES (53,13,'ProductFrom_13/1',2.0,0.4,'1301');
INSERT INTO "consists_from" VALUES (54,13,'ProductFrom_13/2',3.0,0.6,'1302');
INSERT INTO "consists_from" VALUES (55,13,'ProductFrom_13/3',4.0,0.8,'1303');
INSERT INTO "consists_from" VALUES (56,14,'ProductFrom_14/0',1.0,0.2,'1400');
INSERT INTO "consists_from" VALUES (57,14,'ProductFrom_14/1',2.0,0.4,'1401');
INSERT INTO "consists_from" VALUES (58,14,'ProductFrom_14/2',3.0,0.6,'1402');
INSERT INTO "consists_from" VALUES (59,14,'ProductFrom_14/3',4.0,0.8,'1403');
INSERT INTO "consists_from" VALUES (60,15,'ProductFrom_15/0',1.0,0.2,'1500');
INSERT INTO "consists_from" VALUES (61,15,'ProductFrom_15/1',2.0,0.4,'1501');
INSERT INTO "consists_from" VALUES (62,15,'ProductFrom_15/2',3.0,0.6,'1502');
INSERT INTO "consists_from" VALUES (63,15,'ProductFrom_15/3',4.0,0.8,'1503');
INSERT INTO "consists_from" VALUES (64,16,'ProductFrom_16/0',1.0,0.2,'1600');
INSERT INTO "consists_from" VALUES (65,16,'ProductFrom_16/1',2.0,0.4,'1601');
INSERT INTO "consists_from" VALUES (66,16,'ProductFrom_16/2',3.0,0.6,'1602');
INSERT INTO "consists_from" VALUES (67,16,'ProductFrom_16/3',4.0,0.8,'1603');
INSERT INTO "consists_from" VALUES (68,17,'ProductFrom_17/0',1.0,0.2,'1700');
INSERT INTO "consists_from" VALUES (69,17,'ProductFrom_17/1',2.0,0.4,'1701');
INSERT INTO "consists_from" VALUES (80,17,'ProductFrom_17/2',3.0,0.6,'1702');
INSERT INTO "consists_from" VALUES (81,17,'ProductFrom_17/3',4.0,0.8,'1703');
INSERT INTO "consists_from" VALUES (82,18,'ProductFrom_18/0',1.0,0.2,'1800');
INSERT INTO "consists_from" VALUES (83,18,'ProductFrom_18/1',2.0,0.4,'1801');
INSERT INTO "consists_from" VALUES (84,18,'ProductFrom_18/2',3.0,0.6,'1802');
INSERT INTO "consists_from" VALUES (85,18,'ProductFrom_18/3',4.0,0.8,'1803');
INSERT INTO "consists_from" VALUES (86,19,'ProductFrom_19/0',1.0,0.2,'1900');
INSERT INTO "consists_from" VALUES (87,19,'ProductFrom_19/1',2.0,0.4,'1901');
INSERT INTO "consists_from" VALUES (88,19,'ProductFrom_19/2',3.0,0.6,'1902');
INSERT INTO "consists_from" VALUES (89,19,'ProductFrom_19/3',4.0,0.8,'1903');
INSERT INTO "consists_to" VALUES (0,0,'ProductTo_0/0',1.0,0.3,'010');
INSERT INTO "consists_to" VALUES (1,0,'ProductTo_0/1',2.0,0.6,'011');
INSERT INTO "consists_to" VALUES (2,0,'ProductTo_0/2',3.0,0.9,'012');
INSERT INTO "consists_to" VALUES (3,0,'ProductTo_0/3',4.0,1.2,'013');
INSERT INTO "consists_to" VALUES (4,1,'ProductTo_1/0',1.0,0.3,'110');
INSERT INTO "consists_to" VALUES (5,1,'ProductTo_1/1',2.0,0.6,'111');
INSERT INTO "consists_to" VALUES (6,1,'ProductTo_1/2',3.0,0.9,'112');
INSERT INTO "consists_to" VALUES (7,1,'ProductTo_1/3',4.0,1.2,'113');
INSERT INTO "consists_to" VALUES (8,2,'ProductTo_2/0',1.0,0.3,'210');
INSERT INTO "consists_to" VALUES (9,2,'ProductTo_2/1',2.0,0.6,'211');
INSERT INTO "consists_to" VALUES (10,2,'ProductTo_2/2',3.0,0.9,'212');
INSERT INTO "consists_to" VALUES (11,2,'ProductTo_2/3',4.0,1.2,'213');
INSERT INTO "consists_to" VALUES (12,3,'ProductTo_3/0',1.0,0.3,'310');
INSERT INTO "consists_to" VALUES (13,3,'ProductTo_3/1',2.0,0.6,'311');
INSERT INTO "consists_to" VALUES (14,3,'ProductTo_3/2',3.0,0.9,'312');
INSERT INTO "consists_to" VALUES (15,3,'ProductTo_3/3',4.0,1.2,'313');
INSERT INTO "consists_to" VALUES (16,4,'ProductTo_4/0',1.0,0.3,'410');
INSERT INTO "consists_to" VALUES (17,4,'ProductTo_4/1',2.0,0.6,'411');
INSERT INTO "consists_to" VALUES (18,4,'ProductTo_4/2',3.0,0.9,'412');
INSERT INTO "consists_to" VALUES (19,4,'ProductTo_4/3',4.0,1.2,'413');
INSERT INTO "consists_to" VALUES (20,5,'ProductTo_5/0',1.0,0.3,'510');
INSERT INTO "consists_to" VALUES (21,5,'ProductTo_5/1',2.0,0.6,'511');
INSERT INTO "consists_to" VALUES (22,5,'ProductTo_5/2',3.0,0.9,'512');
INSERT INTO "consists_to" VALUES (23,5,'ProductTo_5/3',4.0,1.2,'513');
INSERT INTO "consists_to" VALUES (24,6,'ProductTo_6/0',1.0,0.3,'610');
INSERT INTO "consists_to" VALUES (25,6,'ProductTo_6/1',2.0,0.6,'611');
INSERT INTO "consists_to" VALUES (26,6,'ProductTo_6/2',3.0,0.9,'612');
INSERT INTO "consists_to" VALUES (27,6,'ProductTo_6/3',4.0,1.2,'613');
INSERT INTO "consists_to" VALUES (28,7,'ProductTo_7/0',1.0,0.3,'710');
INSERT INTO "consists_to" VALUES (29,7,'ProductTo_7/1',2.0,0.6,'711');
INSERT INTO "consists_to" VALUES (30,7,'ProductTo_7/2',3.0,0.9,'712');
INSERT INTO "consists_to" VALUES (31,7,'ProductTo_7/3',4.0,1.2,'713');
INSERT INTO "consists_to" VALUES (32,8,'ProductTo_8/0',1.0,0.3,'810');
INSERT INTO "consists_to" VALUES (33,8,'ProductTo_8/1',2.0,0.6,'811');
INSERT INTO "consists_to" VALUES (34,8,'ProductTo_8/2',3.0,0.9,'812');
INSERT INTO "consists_to" VALUES (35,8,'ProductTo_8/3',4.0,1.2,'813');
INSERT INTO "consists_to" VALUES (36,9,'ProductTo_9/0',1.0,0.3,'910');
INSERT INTO "consists_to" VALUES (37,9,'ProductTo_9/1',2.0,0.6,'911');
INSERT INTO "consists_to" VALUES (38,9,'ProductTo_9/2',3.0,0.9,'912');
INSERT INTO "consists_to" VALUES (39,9,'ProductTo_9/3',4.0,1.2,'913');
INSERT INTO "consists_to" VALUES (40,10,'ProductTo_10/0',1.0,0.3,'1010');
INSERT INTO "consists_to" VALUES (41,10,'ProductTo_10/1',2.0,0.6,'1011');
INSERT INTO "consists_to" VALUES (42,10,'ProductTo_10/2',3.0,0.9,'1012');
INSERT INTO "consists_to" VALUES (43,10,'ProductTo_10/3',4.0,1.2,'1013');
INSERT INTO "consists_to" VALUES (44,11,'ProductTo_11/0',1.0,0.3,'1110');
INSERT INTO "consists_to" VALUES (45,11,'ProductTo_11/1',2.0,0.6,'1111');
INSERT INTO "consists_to" VALUES (46,11,'ProductTo_11/2',3.0,0.9,'1112');
INSERT INTO "consists_to" VALUES (47,11,'ProductTo_11/3',4.0,1.2,'1113');
INSERT INTO "consists_to" VALUES (48,12,'ProductTo_12/0',1.0,0.3,'1210');
INSERT INTO "consists_to" VALUES (49,12,'ProductTo_12/1',2.0,0.6,'1211');
INSERT INTO "consists_to" VALUES (50,12,'ProductTo_12/2',3.0,0.9,'1212');
INSERT INTO "consists_to" VALUES (51,12,'ProductTo_12/3',4.0,1.2,'1213');
INSERT INTO "consists_to" VALUES (52,13,'ProductTo_13/0',1.0,0.3,'1310');
INSERT INTO "consists_to" VALUES (53,13,'ProductTo_13/1',2.0,0.6,'1311');
INSERT INTO "consists_to" VALUES (54,13,'ProductTo_13/2',3.0,0.9,'1312');
INSERT INTO "consists_to" VALUES (55,13,'ProductTo_13/3',4.0,1.2,'1313');
INSERT INTO "consists_to" VALUES (56,14,'ProductTo_14/0',1.0,0.3,'1410');
INSERT INTO "consists_to" VALUES (57,14,'ProductTo_14/1',2.0,0.6,'1411');
INSERT INTO "consists_to" VALUES (58,14,'ProductTo_14/2',3.0,0.9,'1412');
INSERT INTO "consists_to" VALUES (59,14,'ProductTo_14/3',4.0,1.2,'1413');
INSERT INTO "consists_to" VALUES (60,15,'ProductTo_15/0',1.0,0.3,'1510');
INSERT INTO "consists_to" VALUES (61,15,'ProductTo_15/1',2.0,0.6,'1511');
INSERT INTO "consists_to" VALUES (62,15,'ProductTo_15/2',3.0,0.9,'1512');
INSERT INTO "consists_to" VALUES (63,15,'ProductTo_15/3',4.0,1.2,'1513');
INSERT INTO "consists_to" VALUES (64,16,'ProductTo_16/0',1.0,0.3,'1610');
INSERT INTO "consists_to" VALUES (65,16,'ProductTo_16/1',2.0,0.6,'1611');
INSERT INTO "consists_to" VALUES (66,16,'ProductTo_16/2',3.0,0.9,'1612');
INSERT INTO "consists_to" VALUES (67,16,'ProductTo_16/3',4.0,1.2,'1613');
INSERT INTO "consists_to" VALUES (68,17,'ProductTo_17/0',1.0,0.3,'1710');
INSERT INTO "consists_to" VALUES (69,17,'ProductTo_17/1',2.0,0.6,'1711');
INSERT INTO "consists_to" VALUES (80,17,'ProductTo_17/2',3.0,0.9,'1712');
INSERT INTO "consists_to" VALUES (81,17,'ProductTo_17/3',4.0,1.2,'1713');
INSERT INTO "consists_to" VALUES (82,18,'ProductTo_18/0',1.0,0.3,'1810');
INSERT INTO "consists_to" VALUES (83,18,'ProductTo_18/1',2.0,0.6,'1811');
INSERT INTO "consists_to" VALUES (84,18,'ProductTo_18/2',3.0,0.9,'1812');
INSERT INTO "consists_to" VALUES (85,18,'ProductTo_18/3',4.0,1.2,'1813');
INSERT INTO "consists_to" VALUES (86,19,'ProductTo_19/0',1.0,0.3,'1910');
INSERT INTO "consists_to" VALUES (87,19,'ProductTo_19/1',2.0,0.6,'1911');
INSERT INTO "consists_to" VALUES (88,19,'ProductTo_19/2',3.0,0.9,'1912');
INSERT INTO "consists_to" VALUES (89,19,'ProductTo_19/3',4.0,1.2,'1913');
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