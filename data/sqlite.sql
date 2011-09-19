PRAGMA synchronous = OFF;
PRAGMA journal_mode = MEMORY;
BEGIN TRANSACTION;
CREATE TABLE "acl_group" (
  "id" int(11) NOT NULL ,
  "parent_id" int(11) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "acl_group_FK_1" FOREIGN KEY ("parent_id") REFERENCES "acl_group" ("id") ON DELETE CASCADE
);
INSERT INTO "acl_group" VALUES (1,NULL,1,14,'2011-09-16 20:04:49','2011-09-16 20:04:49','en',0);
INSERT INTO "acl_group" VALUES (98,1,2,3,'2011-09-16 20:04:49','2011-09-16 20:04:49','en',0);
INSERT INTO "acl_group" VALUES (99,1,4,13,'2011-09-16 20:04:49','2011-09-16 20:04:49','en',0);
INSERT INTO "acl_group" VALUES (100,99,5,6,'2011-09-16 20:04:49','2011-09-16 20:04:49','en',0);
INSERT INTO "acl_group" VALUES (101,99,7,8,'2011-09-16 20:04:49','2011-09-16 20:04:49','en',0);
INSERT INTO "acl_group" VALUES (102,99,9,10,'2011-09-16 20:04:49','2011-09-16 20:04:49','en',0);
INSERT INTO "acl_group" VALUES (103,99,11,12,'2011-09-16 20:04:49','2011-09-16 20:04:49','en',0);
CREATE TABLE "acl_group_i18n" (
  "name" varchar(255) DEFAULT NULL,
  "description" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "acl_group_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "acl_group" ("id") ON DELETE CASCADE
);
INSERT INTO "acl_group_i18n" VALUES (NULL,NULL,1,'en');
INSERT INTO "acl_group_i18n" VALUES ('anonymous',NULL,98,'en');
INSERT INTO "acl_group_i18n" VALUES ('authenticated',NULL,99,'en');
INSERT INTO "acl_group_i18n" VALUES ('administrator',NULL,100,'en');
INSERT INTO "acl_group_i18n" VALUES ('editor',NULL,101,'en');
INSERT INTO "acl_group_i18n" VALUES ('contributor',NULL,102,'en');
INSERT INTO "acl_group_i18n" VALUES ('translator',NULL,103,'en');
CREATE TABLE "acl_permission" (
  "id" int(11) NOT NULL ,
  "user_id" int(11) DEFAULT NULL,
  "group_id" int(11) DEFAULT NULL,
  "object_id" int(11) DEFAULT NULL,
  "action" varchar(255) DEFAULT NULL,
  "grant_deny" int(11) NOT NULL DEFAULT '0',
  "conditional" text,
  "constants" text,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "acl_permission_FK_1" FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE,
  CONSTRAINT "acl_permission_FK_2" FOREIGN KEY ("group_id") REFERENCES "acl_group" ("id") ON DELETE CASCADE,
  CONSTRAINT "acl_permission_FK_3" FOREIGN KEY ("object_id") REFERENCES "object" ("id") ON DELETE CASCADE
);
INSERT INTO "acl_permission" VALUES (1,NULL,98,NULL,'read',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (2,NULL,98,1,'readReference',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (3,NULL,99,NULL,'read',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (4,NULL,99,1,'readReference',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (5,NULL,100,NULL,NULL,1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (6,NULL,101,NULL,'create',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (7,NULL,101,NULL,'update',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (8,NULL,101,NULL,'delete',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (9,NULL,101,1,'viewDraft',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (10,NULL,101,1,'publish',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (11,NULL,101,1,'readMaster',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (12,NULL,102,1,'create',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (13,NULL,102,3,'create',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (14,NULL,102,1,'update',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (15,NULL,102,3,'update',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (16,NULL,102,1,'viewDraft',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (17,NULL,102,1,'readMaster',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
INSERT INTO "acl_permission" VALUES (18,NULL,103,NULL,'translate',1,NULL,NULL,'2011-09-16 20:04:49','2011-09-16 20:04:49',0);
CREATE TABLE "acl_user_group" (
  "id" int(11) NOT NULL ,
  "user_id" int(11) NOT NULL,
  "group_id" int(11) NOT NULL,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "acl_user_group_FK_1" FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE,
  CONSTRAINT "acl_user_group_FK_2" FOREIGN KEY ("group_id") REFERENCES "acl_group" ("id") ON DELETE CASCADE
);
INSERT INTO "acl_user_group" VALUES (2,278,100,0);
INSERT INTO "acl_user_group" VALUES (3,278,101,0);
INSERT INTO "acl_user_group" VALUES (4,278,102,0);
CREATE TABLE "actor" (
  "id" int(11) NOT NULL,
  "corporate_body_identifiers" varchar(255) DEFAULT NULL,
  "entity_type_id" int(11) DEFAULT NULL,
  "description_status_id" int(11) DEFAULT NULL,
  "description_detail_id" int(11) DEFAULT NULL,
  "description_identifier" varchar(255) DEFAULT NULL,
  "source_standard" varchar(255) DEFAULT NULL,
  "parent_id" int(11) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "actor_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "actor_FK_2" FOREIGN KEY ("entity_type_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "actor_FK_3" FOREIGN KEY ("description_status_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "actor_FK_4" FOREIGN KEY ("description_detail_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "actor_FK_5" FOREIGN KEY ("parent_id") REFERENCES "actor" ("id")
);
INSERT INTO "actor" VALUES (3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,2,'en');
INSERT INTO "actor" VALUES (278,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,4,'en');
CREATE TABLE "actor_i18n" (
  "authorized_form_of_name" varchar(255) DEFAULT NULL,
  "dates_of_existence" varchar(255) DEFAULT NULL,
  "history" text,
  "places" text,
  "legal_status" text,
  "functions" text,
  "mandates" text,
  "internal_structures" text,
  "general_context" text,
  "institution_responsible_identifier" varchar(255) DEFAULT NULL,
  "rules" text,
  "sources" text,
  "revision_history" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "actor_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "actor" ("id") ON DELETE CASCADE
);
INSERT INTO "actor_i18n" VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,'en');
INSERT INTO "actor_i18n" VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,278,'en');
CREATE TABLE "contact_information" (
  "actor_id" int(11) NOT NULL,
  "primary_contact" int(4) DEFAULT NULL,
  "contact_person" varchar(255) DEFAULT NULL,
  "street_address" text,
  "website" varchar(255) DEFAULT NULL,
  "email" varchar(255) DEFAULT NULL,
  "telephone" varchar(255) DEFAULT NULL,
  "fax" varchar(255) DEFAULT NULL,
  "postal_code" varchar(255) DEFAULT NULL,
  "country_code" varchar(255) DEFAULT NULL,
  "longitude" float DEFAULT NULL,
  "latitude" float DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "contact_information_FK_1" FOREIGN KEY ("actor_id") REFERENCES "actor" ("id") ON DELETE CASCADE
);
CREATE TABLE "contact_information_i18n" (
  "contact_type" varchar(255) DEFAULT NULL,
  "city" varchar(255) DEFAULT NULL,
  "region" varchar(255) DEFAULT NULL,
  "note" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "contact_information_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "contact_information" ("id") ON DELETE CASCADE
);
CREATE TABLE "digital_object" (
  "id" int(11) NOT NULL,
  "information_object_id" int(11) DEFAULT NULL,
  "usage_id" int(11) DEFAULT NULL,
  "mime_type" varchar(50) DEFAULT NULL,
  "media_type_id" int(11) DEFAULT NULL,
  "name" varchar(255) DEFAULT NULL,
  "path" varchar(1000) DEFAULT NULL,
  "sequence" int(11) DEFAULT NULL,
  "byte_size" int(11) DEFAULT NULL,
  "checksum" varchar(255) DEFAULT NULL,
  "checksum_type_id" int(11) DEFAULT NULL,
  "parent_id" int(11) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "digital_object_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "digital_object_FK_2" FOREIGN KEY ("information_object_id") REFERENCES "information_object" ("id"),
  CONSTRAINT "digital_object_FK_3" FOREIGN KEY ("usage_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "digital_object_FK_4" FOREIGN KEY ("media_type_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "digital_object_FK_5" FOREIGN KEY ("checksum_type_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "digital_object_FK_6" FOREIGN KEY ("parent_id") REFERENCES "digital_object" ("id")
);
CREATE TABLE "event" (
  "id" int(11) NOT NULL,
  "start_date" date DEFAULT NULL,
  "start_time" time DEFAULT NULL,
  "end_date" date DEFAULT NULL,
  "end_time" time DEFAULT NULL,
  "type_id" int(11) NOT NULL,
  "information_object_id" int(11) DEFAULT NULL,
  "actor_id" int(11) DEFAULT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "event_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "event_FK_2" FOREIGN KEY ("type_id") REFERENCES "term" ("id") ON DELETE CASCADE,
  CONSTRAINT "event_FK_3" FOREIGN KEY ("information_object_id") REFERENCES "information_object" ("id") ON DELETE CASCADE,
  CONSTRAINT "event_FK_4" FOREIGN KEY ("actor_id") REFERENCES "actor" ("id")
);
CREATE TABLE "event_i18n" (
  "name" varchar(255) DEFAULT NULL,
  "description" text,
  "date" varchar(255) DEFAULT NULL,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "event_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "event" ("id") ON DELETE CASCADE
);
CREATE TABLE "function" (
  "id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  "parent_id" int(11) DEFAULT NULL,
  "description_status_id" int(11) DEFAULT NULL,
  "description_detail_id" int(11) DEFAULT NULL,
  "description_identifier" varchar(255) DEFAULT NULL,
  "source_standard" varchar(255) DEFAULT NULL,
  "lft" int(11) DEFAULT NULL,
  "rgt" int(11) DEFAULT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "function_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "function_FK_2" FOREIGN KEY ("type_id") REFERENCES "term" ("id"),
  CONSTRAINT "function_FK_3" FOREIGN KEY ("parent_id") REFERENCES "function" ("id"),
  CONSTRAINT "function_FK_4" FOREIGN KEY ("description_status_id") REFERENCES "term" ("id"),
  CONSTRAINT "function_FK_5" FOREIGN KEY ("description_detail_id") REFERENCES "term" ("id")
);
CREATE TABLE "function_i18n" (
  "authorized_form_of_name" varchar(255) DEFAULT NULL,
  "classification" varchar(255) DEFAULT NULL,
  "dates" varchar(255) DEFAULT NULL,
  "description" text,
  "history" text,
  "legislation" text,
  "institution_identifier" text,
  "revision_history" text,
  "rules" text,
  "sources" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "function_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "function" ("id") ON DELETE CASCADE
);
CREATE TABLE "historical_event" (
  "id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  "start_date" date DEFAULT NULL,
  "start_time" time DEFAULT NULL,
  "end_date" date DEFAULT NULL,
  "end_time" time DEFAULT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "historical_event_FK_1" FOREIGN KEY ("id") REFERENCES "term" ("id") ON DELETE CASCADE,
  CONSTRAINT "historical_event_FK_2" FOREIGN KEY ("type_id") REFERENCES "term" ("id")
);
CREATE TABLE "information_object" (
  "id" int(11) NOT NULL,
  "identifier" varchar(255) DEFAULT NULL,
  "oai_local_identifier" int(11) NOT NULL ,
  "level_of_description_id" int(11) DEFAULT NULL,
  "collection_type_id" int(11) DEFAULT NULL,
  "repository_id" int(11) DEFAULT NULL,
  "parent_id" int(11) DEFAULT NULL,
  "description_status_id" int(11) DEFAULT NULL,
  "description_detail_id" int(11) DEFAULT NULL,
  "description_identifier" varchar(255) DEFAULT NULL,
  "source_standard" varchar(255) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "information_object_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "information_object_FK_2" FOREIGN KEY ("level_of_description_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "information_object_FK_3" FOREIGN KEY ("collection_type_id") REFERENCES "term" ("id"),
  CONSTRAINT "information_object_FK_4" FOREIGN KEY ("repository_id") REFERENCES "repository" ("id"),
  CONSTRAINT "information_object_FK_5" FOREIGN KEY ("parent_id") REFERENCES "information_object" ("id"),
  CONSTRAINT "information_object_FK_6" FOREIGN KEY ("description_status_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "information_object_FK_7" FOREIGN KEY ("description_detail_id") REFERENCES "term" ("id") ON DELETE SET NULL
);
INSERT INTO "information_object" VALUES (1,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,2,'en');
CREATE TABLE "information_object_i18n" (
  "title" varchar(255) DEFAULT NULL,
  "alternate_title" varchar(255) DEFAULT NULL,
  "edition" varchar(255) DEFAULT NULL,
  "extent_and_medium" text,
  "archival_history" text,
  "acquisition" text,
  "scope_and_content" text,
  "appraisal" text,
  "accruals" text,
  "arrangement" text,
  "access_conditions" text,
  "reproduction_conditions" text,
  "physical_characteristics" text,
  "finding_aids" text,
  "location_of_originals" text,
  "location_of_copies" text,
  "related_units_of_description" text,
  "institution_responsible_identifier" varchar(255) DEFAULT NULL,
  "rules" text,
  "sources" text,
  "revision_history" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "information_object_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "information_object" ("id") ON DELETE CASCADE
);
INSERT INTO "information_object_i18n" VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'en');
CREATE TABLE "map" (
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);
CREATE TABLE "map_i18n" (
  "title" varchar(255) DEFAULT NULL,
  "description" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "map_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "map" ("id") ON DELETE CASCADE
);
CREATE TABLE "menu" (
  "parent_id" int(11) DEFAULT NULL,
  "name" varchar(255) DEFAULT NULL,
  "path" varchar(255) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "menu_FK_1" FOREIGN KEY ("parent_id") REFERENCES "menu" ("id") ON DELETE CASCADE
);
INSERT INTO "menu" VALUES (NULL,NULL,NULL,1,84,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',1,0);
INSERT INTO "menu" VALUES (1,'mainMenu',NULL,2,53,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',2,0);
INSERT INTO "menu" VALUES (1,'quickLinks',NULL,54,67,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',3,0);
INSERT INTO "menu" VALUES (1,'browse',NULL,68,83,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',4,0);
INSERT INTO "menu" VALUES (2,'add','informationobject/add',3,14,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',5,0);
INSERT INTO "menu" VALUES (2,'taxonomies','taxonomy/list',15,16,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',6,0);
INSERT INTO "menu" VALUES (2,'import','object/importSelect',17,20,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',7,0);
INSERT INTO "menu" VALUES (2,'admin','user/list',21,52,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',9,0);
INSERT INTO "menu" VALUES (5,'addInformationObject','informationobject/add',4,5,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',10,0);
INSERT INTO "menu" VALUES (5,'addActor','actor/add',6,7,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',11,0);
INSERT INTO "menu" VALUES (5,'addRepository','repository/add',8,9,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',12,0);
INSERT INTO "menu" VALUES (5,'addTerm','term/add',10,11,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',13,0);
INSERT INTO "menu" VALUES (5,'addFunction','function/add',12,13,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',14,0);
INSERT INTO "menu" VALUES (7,'importXml','object/importSelect',18,19,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',15,0);
INSERT INTO "menu" VALUES (9,'users','user/list',22,31,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',16,0);
INSERT INTO "menu" VALUES (16,'userProfile','user/index?slug=%currentSlug%',23,24,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',17,0);
INSERT INTO "menu" VALUES (16,'userInformationObjectAcl','user/indexInformationObjectAcl?slug=%currentSlug%',25,26,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',18,0);
INSERT INTO "menu" VALUES (16,'userActorAcl','user/indexActorAcl?slug=%currentSlug%',27,28,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',19,0);
INSERT INTO "menu" VALUES (16,'userTermAcl','user/indexTermAcl?slug=%currentSlug%',29,30,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',20,0);
INSERT INTO "menu" VALUES (9,'groups','aclGroup/list',32,41,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',21,0);
INSERT INTO "menu" VALUES (21,'groupProfile','aclGroup/index?id=%currentId%',33,34,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',22,0);
INSERT INTO "menu" VALUES (21,'groupInformationObjectAcl','aclGroup/indexInformationObjectAcl?id=%currentId%',35,36,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',23,0);
INSERT INTO "menu" VALUES (21,'groupActorAcl','aclGroup/indexActorAcl?id=%currentId%',37,38,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',24,0);
INSERT INTO "menu" VALUES (21,'groupTermAcl','aclGroup/indexTermAcl?id=%currentId%',39,40,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',25,0);
INSERT INTO "menu" VALUES (9,'staticPages','staticpage/list',42,43,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',26,0);
INSERT INTO "menu" VALUES (9,'menu','menu/list',44,45,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',27,0);
INSERT INTO "menu" VALUES (9,'plugins','sfPluginAdminPlugin/index',46,47,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',28,0);
INSERT INTO "menu" VALUES (9,'settings','settings/list',48,49,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',29,0);
INSERT INTO "menu" VALUES (9,'descriptionUpdates','search/descriptionUpdates',50,51,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',30,0);
INSERT INTO "menu" VALUES (3,'home','@homepage',55,56,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',31,0);
INSERT INTO "menu" VALUES (3,'about','staticpage/index?slug=about',57,58,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',32,0);
INSERT INTO "menu" VALUES (3,'help','http://ica-atom.org/doc/index.php?title=User_manual',59,60,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',33,0);
INSERT INTO "menu" VALUES (3,'myProfile','%profile%',61,62,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',34,0);
INSERT INTO "menu" VALUES (3,'login','user/login',63,64,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',35,0);
INSERT INTO "menu" VALUES (3,'logout','user/logout',65,66,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',36,0);
INSERT INTO "menu" VALUES (4,'browseInformationObjects','informationobject/browse',69,70,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',37,0);
INSERT INTO "menu" VALUES (4,'browseActors','actor/browse',71,72,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',38,0);
INSERT INTO "menu" VALUES (4,'browseRepositories','repository/browse',73,74,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',39,0);
INSERT INTO "menu" VALUES (4,'browseFunctions','function/browse',75,76,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',40,0);
INSERT INTO "menu" VALUES (4,'browseSubjects','taxonomy/browse?id=35',77,78,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',41,0);
INSERT INTO "menu" VALUES (4,'browsePlaces','taxonomy/browse?id=42',79,80,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',42,0);
INSERT INTO "menu" VALUES (4,'browseDigitalObjects','digitalobject/list',81,82,'2011-09-16 20:04:50','2011-09-16 20:04:50','en',43,0);
CREATE TABLE "menu_i18n" (
  "label" varchar(255) DEFAULT NULL,
  "description" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "menu_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "menu" ("id") ON DELETE CASCADE
);
INSERT INTO "menu_i18n" VALUES (NULL,NULL,1,'en');
INSERT INTO "menu_i18n" VALUES (NULL,NULL,2,'en');
INSERT INTO "menu_i18n" VALUES (NULL,NULL,3,'en');
INSERT INTO "menu_i18n" VALUES ('Browse',NULL,4,'en');
INSERT INTO "menu_i18n" VALUES ('Hinzufügen',NULL,5,'de');
INSERT INTO "menu_i18n" VALUES ('Add',NULL,5,'en');
INSERT INTO "menu_i18n" VALUES ('agregar',NULL,5,'es');
INSERT INTO "menu_i18n" VALUES ('??????',NULL,5,'fa');
INSERT INTO "menu_i18n" VALUES ('ajouter',NULL,5,'fr');
INSERT INTO "menu_i18n" VALUES ('aggiungi',NULL,5,'it');
INSERT INTO "menu_i18n" VALUES ('toevoegen',NULL,5,'nl');
INSERT INTO "menu_i18n" VALUES ('adicionar',NULL,5,'pt');
INSERT INTO "menu_i18n" VALUES ('uporabniški',NULL,5,'sl');
INSERT INTO "menu_i18n" VALUES ('Taxonomies',NULL,6,'en');
INSERT INTO "menu_i18n" VALUES ('Import',NULL,7,'en');
INSERT INTO "menu_i18n" VALUES ('importar',NULL,7,'es');
INSERT INTO "menu_i18n" VALUES ('???? ????',NULL,7,'fa');
INSERT INTO "menu_i18n" VALUES ('importer',NULL,7,'fr');
INSERT INTO "menu_i18n" VALUES ('importa',NULL,7,'it');
INSERT INTO "menu_i18n" VALUES ('import',NULL,7,'nl');
INSERT INTO "menu_i18n" VALUES ('importar',NULL,7,'pt');
INSERT INTO "menu_i18n" VALUES ('uvoz',NULL,7,'sl');
INSERT INTO "menu_i18n" VALUES ('Administrator',NULL,9,'de');
INSERT INTO "menu_i18n" VALUES ('Admin',NULL,9,'en');
INSERT INTO "menu_i18n" VALUES ('administrador',NULL,9,'es');
INSERT INTO "menu_i18n" VALUES ('????',NULL,9,'fa');
INSERT INTO "menu_i18n" VALUES ('administrer',NULL,9,'fr');
INSERT INTO "menu_i18n" VALUES ('amministra',NULL,9,'it');
INSERT INTO "menu_i18n" VALUES ('administrator',NULL,9,'sl');
INSERT INTO "menu_i18n" VALUES ('Archival descriptions',NULL,10,'en');
INSERT INTO "menu_i18n" VALUES ('Descripción archivística',NULL,10,'es');
INSERT INTO "menu_i18n" VALUES ('description archivistique',NULL,10,'fr');
INSERT INTO "menu_i18n" VALUES ('descrizione archivistica',NULL,10,'it');
INSERT INTO "menu_i18n" VALUES ('archivistische beschrijving',NULL,10,'nl');
INSERT INTO "menu_i18n" VALUES ('descrição arquivística',NULL,10,'pt');
INSERT INTO "menu_i18n" VALUES ('arhivski opisi',NULL,10,'sl');
INSERT INTO "menu_i18n" VALUES ('Authority records',NULL,11,'en');
INSERT INTO "menu_i18n" VALUES ('Registro de autoridad',NULL,11,'es');
INSERT INTO "menu_i18n" VALUES ('fichier d''autorité',NULL,11,'fr');
INSERT INTO "menu_i18n" VALUES ('record di autorità',NULL,11,'it');
INSERT INTO "menu_i18n" VALUES ('geautoriseerd bestand',NULL,11,'nl');
INSERT INTO "menu_i18n" VALUES ('registro de autoridade',NULL,11,'pt');
INSERT INTO "menu_i18n" VALUES ('normativni zapisi',NULL,11,'sl');
INSERT INTO "menu_i18n" VALUES ('Archival institutions',NULL,12,'en');
INSERT INTO "menu_i18n" VALUES ('Institución archivística',NULL,12,'es');
INSERT INTO "menu_i18n" VALUES ('institution',NULL,12,'fr');
INSERT INTO "menu_i18n" VALUES ('istituzione archivistica',NULL,12,'it');
INSERT INTO "menu_i18n" VALUES ('archiefinstelling',NULL,12,'nl');
INSERT INTO "menu_i18n" VALUES ('instituição arquivística',NULL,12,'pt');
INSERT INTO "menu_i18n" VALUES ('arhivske ustanove',NULL,12,'sl');
INSERT INTO "menu_i18n" VALUES ('Terms',NULL,13,'en');
INSERT INTO "menu_i18n" VALUES ('descripteurs',NULL,13,'fr');
INSERT INTO "menu_i18n" VALUES ('termine',NULL,13,'it');
INSERT INTO "menu_i18n" VALUES ('term',NULL,13,'nl');
INSERT INTO "menu_i18n" VALUES ('termo',NULL,13,'pt');
INSERT INTO "menu_i18n" VALUES ('izraz',NULL,13,'sl');
INSERT INTO "menu_i18n" VALUES ('Functions',NULL,14,'en');
INSERT INTO "menu_i18n" VALUES ('XML',NULL,15,'en');
INSERT INTO "menu_i18n" VALUES ('Users',NULL,16,'en');
INSERT INTO "menu_i18n" VALUES ('usuarios',NULL,16,'es');
INSERT INTO "menu_i18n" VALUES ('???????',NULL,16,'fa');
INSERT INTO "menu_i18n" VALUES ('utilisateurs',NULL,16,'fr');
INSERT INTO "menu_i18n" VALUES ('utenti',NULL,16,'it');
INSERT INTO "menu_i18n" VALUES ('gebruikers',NULL,16,'nl');
INSERT INTO "menu_i18n" VALUES ('usuários',NULL,16,'pt');
INSERT INTO "menu_i18n" VALUES ('uporabniki',NULL,16,'sl');
INSERT INTO "menu_i18n" VALUES ('Profile',NULL,17,'en');
INSERT INTO "menu_i18n" VALUES ('Profil',NULL,17,'fr');
INSERT INTO "menu_i18n" VALUES ('Archival description permissions',NULL,18,'en');
INSERT INTO "menu_i18n" VALUES ('Authority record permissions',NULL,19,'en');
INSERT INTO "menu_i18n" VALUES ('Taxonomy permissions',NULL,20,'en');
INSERT INTO "menu_i18n" VALUES ('Groups',NULL,21,'en');
INSERT INTO "menu_i18n" VALUES ('Profile',NULL,22,'en');
INSERT INTO "menu_i18n" VALUES ('Profil',NULL,22,'fr');
INSERT INTO "menu_i18n" VALUES ('Archival description permissions',NULL,23,'en');
INSERT INTO "menu_i18n" VALUES ('Authority record permissions',NULL,24,'en');
INSERT INTO "menu_i18n" VALUES ('Taxonomy permissions',NULL,25,'en');
INSERT INTO "menu_i18n" VALUES ('Static pages',NULL,26,'en');
INSERT INTO "menu_i18n" VALUES ('páginas estáticas',NULL,26,'es');
INSERT INTO "menu_i18n" VALUES ('????? ?????',NULL,26,'fa');
INSERT INTO "menu_i18n" VALUES ('pages statiques',NULL,26,'fr');
INSERT INTO "menu_i18n" VALUES ('pagine statiche',NULL,26,'it');
INSERT INTO "menu_i18n" VALUES ('statische pagina''s',NULL,26,'nl');
INSERT INTO "menu_i18n" VALUES ('páginas estáticas',NULL,26,'pt');
INSERT INTO "menu_i18n" VALUES ('stati?na stran',NULL,26,'sl');
INSERT INTO "menu_i18n" VALUES ('Menus',NULL,27,'en');
INSERT INTO "menu_i18n" VALUES ('menus',NULL,27,'fr');
INSERT INTO "menu_i18n" VALUES ('Plugins',NULL,28,'en');
INSERT INTO "menu_i18n" VALUES ('Einstellungen',NULL,29,'de');
INSERT INTO "menu_i18n" VALUES ('Settings',NULL,29,'en');
INSERT INTO "menu_i18n" VALUES ('configuración',NULL,29,'es');
INSERT INTO "menu_i18n" VALUES ('???????',NULL,29,'fa');
INSERT INTO "menu_i18n" VALUES ('paramètres',NULL,29,'fr');
INSERT INTO "menu_i18n" VALUES ('impostazioni',NULL,29,'it');
INSERT INTO "menu_i18n" VALUES ('instellingen',NULL,29,'nl');
INSERT INTO "menu_i18n" VALUES ('configurações',NULL,29,'pt');
INSERT INTO "menu_i18n" VALUES ('nastavitve',NULL,29,'sl');
INSERT INTO "menu_i18n" VALUES ('Description updates',NULL,30,'en');
INSERT INTO "menu_i18n" VALUES ('Startseite',NULL,31,'de');
INSERT INTO "menu_i18n" VALUES ('Home',NULL,31,'en');
INSERT INTO "menu_i18n" VALUES ('inicio',NULL,31,'es');
INSERT INTO "menu_i18n" VALUES ('???? ????',NULL,31,'fa');
INSERT INTO "menu_i18n" VALUES ('accueil',NULL,31,'fr');
INSERT INTO "menu_i18n" VALUES ('pagina iniziale',NULL,31,'it');
INSERT INTO "menu_i18n" VALUES ('home',NULL,31,'nl');
INSERT INTO "menu_i18n" VALUES ('inicio',NULL,31,'pt');
INSERT INTO "menu_i18n" VALUES ('domov',NULL,31,'sl');
INSERT INTO "menu_i18n" VALUES ('Über',NULL,32,'de');
INSERT INTO "menu_i18n" VALUES ('About',NULL,32,'en');
INSERT INTO "menu_i18n" VALUES ('acerca',NULL,32,'es');
INSERT INTO "menu_i18n" VALUES ('?????? ??',NULL,32,'fa');
INSERT INTO "menu_i18n" VALUES ('à propos',NULL,32,'fr');
INSERT INTO "menu_i18n" VALUES ('informazioni su',NULL,32,'it');
INSERT INTO "menu_i18n" VALUES ('over',NULL,32,'nl');
INSERT INTO "menu_i18n" VALUES ('sobre',NULL,32,'pt');
INSERT INTO "menu_i18n" VALUES ('o tem',NULL,32,'sl');
INSERT INTO "menu_i18n" VALUES ('Hilfe',NULL,33,'de');
INSERT INTO "menu_i18n" VALUES ('Help',NULL,33,'en');
INSERT INTO "menu_i18n" VALUES ('ayuda',NULL,33,'es');
INSERT INTO "menu_i18n" VALUES ('??????',NULL,33,'fa');
INSERT INTO "menu_i18n" VALUES ('aide',NULL,33,'fr');
INSERT INTO "menu_i18n" VALUES ('aiuto',NULL,33,'it');
INSERT INTO "menu_i18n" VALUES ('help',NULL,33,'nl');
INSERT INTO "menu_i18n" VALUES ('ajuda',NULL,33,'pt');
INSERT INTO "menu_i18n" VALUES ('pomo?',NULL,33,'sl');
INSERT INTO "menu_i18n" VALUES ('My profile',NULL,34,'en');
INSERT INTO "menu_i18n" VALUES ('mon profil',NULL,34,'fr');
INSERT INTO "menu_i18n" VALUES ('Log in',NULL,35,'en');
INSERT INTO "menu_i18n" VALUES ('iniciar sesión',NULL,35,'es');
INSERT INTO "menu_i18n" VALUES ('???? ?? ?????',NULL,35,'fa');
INSERT INTO "menu_i18n" VALUES ('ouverture de session',NULL,35,'fr');
INSERT INTO "menu_i18n" VALUES ('accesso',NULL,35,'it');
INSERT INTO "menu_i18n" VALUES ('inloggen',NULL,35,'nl');
INSERT INTO "menu_i18n" VALUES ('entrar',NULL,35,'pt');
INSERT INTO "menu_i18n" VALUES ('prijava',NULL,35,'sl');
INSERT INTO "menu_i18n" VALUES ('Abmelden',NULL,36,'de');
INSERT INTO "menu_i18n" VALUES ('Log out',NULL,36,'en');
INSERT INTO "menu_i18n" VALUES ('cerrar sesión',NULL,36,'es');
INSERT INTO "menu_i18n" VALUES ('????',NULL,36,'fa');
INSERT INTO "menu_i18n" VALUES ('fermeture de session',NULL,36,'fr');
INSERT INTO "menu_i18n" VALUES ('esci',NULL,36,'it');
INSERT INTO "menu_i18n" VALUES ('uitloggen',NULL,36,'nl');
INSERT INTO "menu_i18n" VALUES ('sair',NULL,36,'pt');
INSERT INTO "menu_i18n" VALUES ('izhod',NULL,36,'sl');
INSERT INTO "menu_i18n" VALUES ('Archival descriptions',NULL,37,'en');
INSERT INTO "menu_i18n" VALUES ('Authority records',NULL,38,'en');
INSERT INTO "menu_i18n" VALUES ('Archival institutions',NULL,39,'en');
INSERT INTO "menu_i18n" VALUES ('Functions',NULL,40,'en');
INSERT INTO "menu_i18n" VALUES ('Subjects',NULL,41,'en');
INSERT INTO "menu_i18n" VALUES ('Places',NULL,42,'en');
INSERT INTO "menu_i18n" VALUES ('Digital objects',NULL,43,'en');
CREATE TABLE "note" (
  "object_id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  "scope" varchar(255) DEFAULT NULL,
  "user_id" int(11) DEFAULT NULL,
  "parent_id" int(11) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "note_FK_1" FOREIGN KEY ("object_id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "note_FK_2" FOREIGN KEY ("type_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "note_FK_3" FOREIGN KEY ("user_id") REFERENCES "user" ("id"),
  CONSTRAINT "note_FK_4" FOREIGN KEY ("parent_id") REFERENCES "note" ("id")
);
INSERT INTO "note" VALUES (111,123,'QubitTerm',NULL,NULL,1,2,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',1,0);
INSERT INTO "note" VALUES (111,121,NULL,NULL,NULL,3,4,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',2,0);
INSERT INTO "note" VALUES (113,123,'QubitTerm',NULL,NULL,5,6,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',3,0);
INSERT INTO "note" VALUES (113,121,NULL,NULL,NULL,7,8,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',4,0);
INSERT INTO "note" VALUES (114,123,'QubitTerm',NULL,NULL,9,10,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',5,0);
INSERT INTO "note" VALUES (114,121,NULL,NULL,NULL,11,12,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',6,0);
INSERT INTO "note" VALUES (115,123,'QubitTerm',NULL,NULL,13,14,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',7,0);
INSERT INTO "note" VALUES (115,121,NULL,NULL,NULL,15,16,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',8,0);
INSERT INTO "note" VALUES (117,123,'QubitTerm',NULL,NULL,17,18,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',9,0);
INSERT INTO "note" VALUES (117,121,NULL,NULL,NULL,19,20,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',10,0);
INSERT INTO "note" VALUES (118,123,'QubitTerm',NULL,NULL,21,22,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',11,0);
INSERT INTO "note" VALUES (118,121,NULL,NULL,NULL,23,24,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',12,0);
INSERT INTO "note" VALUES (167,123,'QubitTerm',NULL,NULL,25,26,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',13,0);
INSERT INTO "note" VALUES (167,121,NULL,NULL,NULL,27,28,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',14,0);
INSERT INTO "note" VALUES (169,123,'QubitTerm',NULL,NULL,29,30,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',15,0);
INSERT INTO "note" VALUES (169,121,NULL,NULL,NULL,31,32,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',16,0);
INSERT INTO "note" VALUES (168,123,'QubitTerm',NULL,NULL,33,34,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',17,0);
INSERT INTO "note" VALUES (168,121,NULL,NULL,NULL,35,36,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',18,0);
INSERT INTO "note" VALUES (170,123,'QubitTerm',NULL,NULL,37,38,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',19,0);
INSERT INTO "note" VALUES (170,121,NULL,NULL,NULL,39,40,'2011-09-16 20:04:56','2011-09-16 20:04:56','en',20,0);
CREATE TABLE "note_i18n" (
  "content" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "note_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "note" ("id") ON DELETE CASCADE
);
INSERT INTO "note_i18n" VALUES ('Creator',1,'en');
INSERT INTO "note_i18n" VALUES ('Produtor',1,'es');
INSERT INTO "note_i18n" VALUES ('Producteur',1,'fr');
INSERT INTO "note_i18n" VALUES ('Vervaardiger',1,'nl');
INSERT INTO "note_i18n" VALUES ('Produtor',1,'pt');
INSERT INTO "note_i18n" VALUES ('ISAD(G) 3.2.1, 3.1.3; DC 1.1 core element (Creator); Rules for Archival Description 1.4B',2,'en');
INSERT INTO "note_i18n" VALUES ('Custodian',3,'en');
INSERT INTO "note_i18n" VALUES ('Custodiador',3,'es');
INSERT INTO "note_i18n" VALUES ('Détenteur',3,'fr');
INSERT INTO "note_i18n" VALUES ('Beheerder',3,'nl');
INSERT INTO "note_i18n" VALUES ('Custodiador',3,'pt');
INSERT INTO "note_i18n" VALUES ('Rules for Archival Description 1.7C',4,'en');
INSERT INTO "note_i18n" VALUES ('Publisher',5,'en');
INSERT INTO "note_i18n" VALUES ('Publicador',5,'es');
INSERT INTO "note_i18n" VALUES ('Éditeur',5,'fr');
INSERT INTO "note_i18n" VALUES ('Uitgever',5,'nl');
INSERT INTO "note_i18n" VALUES ('Publicador',5,'pt');
INSERT INTO "note_i18n" VALUES ('DC 1.1 element (Publisher); Rules for Archival Description 1.4, 1.8B8',6,'en');
INSERT INTO "note_i18n" VALUES ('Contributor',7,'en');
INSERT INTO "note_i18n" VALUES ('Colaborador',7,'es');
INSERT INTO "note_i18n" VALUES ('Collaborateur',7,'fr');
INSERT INTO "note_i18n" VALUES ('Contribuant',7,'nl');
INSERT INTO "note_i18n" VALUES ('Colaborador',7,'pt');
INSERT INTO "note_i18n" VALUES ('DC 1.1 element (Contributor)',8,'en');
INSERT INTO "note_i18n" VALUES ('Collector',9,'en');
INSERT INTO "note_i18n" VALUES ('Collectionneur',9,'fr');
INSERT INTO "note_i18n" VALUES ('Verzamelaar',9,'nl');
INSERT INTO "note_i18n" VALUES ('Coletor',9,'pt');
INSERT INTO "note_i18n" VALUES ('Rules for Archival Description 1.4A6, 1.8B8a',10,'en');
INSERT INTO "note_i18n" VALUES ('Accumulator',11,'en');
INSERT INTO "note_i18n" VALUES ('ISAD(G) 3.1.3; Rules for Archival Description 1.4A6, 1.8B8a',12,'en');
INSERT INTO "note_i18n" VALUES ('Reproducer',13,'en');
INSERT INTO "note_i18n" VALUES ('Rules for Archival Description 1.4A5',14,'en');
INSERT INTO "note_i18n" VALUES ('Broadcaster',15,'en');
INSERT INTO "note_i18n" VALUES ('Rules for Archival Description 8.4F',16,'en');
INSERT INTO "note_i18n" VALUES ('Distributor',17,'en');
INSERT INTO "note_i18n" VALUES ('Rules for Archival Description 1.4, 1.8B8',18,'en');
INSERT INTO "note_i18n" VALUES ('Manufacturer',19,'en');
INSERT INTO "note_i18n" VALUES ('Rules for Archival Description 1.4G',20,'en');
CREATE TABLE "oai_harvest" (
  "id" int(11) NOT NULL ,
  "oai_repository_id" int(11) NOT NULL,
  "start_timestamp" datetime DEFAULT NULL,
  "end_timestamp" datetime DEFAULT NULL,
  "last_harvest" datetime DEFAULT NULL,
  "last_harvest_attempt" datetime DEFAULT NULL,
  "metadataPrefix" varchar(255) DEFAULT NULL,
  "set" varchar(255) DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "oai_harvest_FK_1" FOREIGN KEY ("oai_repository_id") REFERENCES "oai_repository" ("id") ON DELETE CASCADE
);
CREATE TABLE "oai_repository" (
  "id" int(11) NOT NULL ,
  "name" varchar(512) DEFAULT NULL,
  "uri" varchar(255) DEFAULT NULL,
  "admin_email" varchar(255) DEFAULT NULL,
  "earliest_timestamp" datetime DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);
CREATE TABLE "object" (
  "class_name" varchar(255) DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "serial_number" int(11) NOT NULL DEFAULT '0'
);
INSERT INTO "object" VALUES ('QubitInformationObject','2011-09-16 20:04:49','2011-09-16 20:04:49',1,0);
INSERT INTO "object" VALUES ('QubitActor','2011-09-16 20:04:49','2011-09-16 20:04:49',3,0);
INSERT INTO "object" VALUES ('QubitStaticPage','2011-09-16 20:04:50','2011-09-16 20:04:50',4,0);
INSERT INTO "object" VALUES ('QubitStaticPage','2011-09-16 20:04:50','2011-09-16 20:04:50',5,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',30,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',31,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',32,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',33,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',34,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',35,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',36,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',37,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',38,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',40,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',41,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',42,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',43,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',44,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',45,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',46,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',47,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',48,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',49,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',50,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',51,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',52,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',53,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',54,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',55,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',56,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',57,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',59,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',60,0);
INSERT INTO "object" VALUES ('QubitTaxonomy','2011-09-16 20:04:51','2011-09-16 20:04:51',61,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',110,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',111,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',113,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',114,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',115,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',117,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',118,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',119,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',120,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',121,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:51','2011-09-16 20:04:51',122,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',123,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',124,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',125,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',126,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',127,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',128,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',129,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',130,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',131,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',132,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',133,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',135,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',136,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',137,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',138,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',139,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',140,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',141,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',142,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',143,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',144,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',145,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',146,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',147,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',148,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',149,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',150,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',151,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',152,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',153,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',154,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',155,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',156,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',157,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',158,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',159,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',160,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',161,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',162,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',163,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',164,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',165,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:52','2011-09-16 20:04:52',166,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',167,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',168,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',169,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',170,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',171,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',172,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',173,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',174,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',175,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',176,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',177,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',178,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',179,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',180,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',181,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',182,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',183,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',184,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',185,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',186,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',187,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',188,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',189,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',190,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',191,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:53','2011-09-16 20:04:53',192,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',193,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',194,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',195,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',196,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',197,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',198,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',199,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',200,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',201,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',202,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',203,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',204,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',205,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',206,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',207,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',208,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',209,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',210,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',211,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',212,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',213,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',214,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',215,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',216,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',217,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',218,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',219,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',220,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',221,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',222,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',223,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',224,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',225,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',226,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',227,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',228,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',229,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',230,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',231,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:54','2011-09-16 20:04:54',232,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',233,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',234,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',235,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',236,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',237,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',238,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',239,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',240,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',241,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',242,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',243,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',244,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',245,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',246,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',247,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',248,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',249,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',250,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',251,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',252,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',253,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',254,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',255,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',256,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',257,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',258,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',259,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',260,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',261,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',262,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',263,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',264,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',265,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',266,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',267,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',268,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',269,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',270,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',271,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',272,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',273,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',274,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',275,0);
INSERT INTO "object" VALUES ('QubitTerm','2011-09-16 20:04:55','2011-09-16 20:04:55',276,0);
INSERT INTO "object" VALUES ('QubitUser','2011-09-16 20:07:23','2011-09-16 20:07:48',278,0);
CREATE TABLE "object_term_relation" (
  "id" int(11) NOT NULL,
  "object_id" int(11) NOT NULL,
  "term_id" int(11) NOT NULL,
  "start_date" date DEFAULT NULL,
  "end_date" date DEFAULT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "object_term_relation_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "object_term_relation_FK_2" FOREIGN KEY ("object_id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "object_term_relation_FK_3" FOREIGN KEY ("term_id") REFERENCES "term" ("id") ON DELETE CASCADE
);
CREATE TABLE "other_name" (
  "object_id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "other_name_FK_1" FOREIGN KEY ("object_id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "other_name_FK_2" FOREIGN KEY ("type_id") REFERENCES "term" ("id") ON DELETE SET NULL
);
CREATE TABLE "other_name_i18n" (
  "name" varchar(255) DEFAULT NULL,
  "note" varchar(255) DEFAULT NULL,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "other_name_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "other_name" ("id") ON DELETE CASCADE
);
CREATE TABLE "physical_object" (
  "id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  "parent_id" int(11) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "physical_object_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "physical_object_FK_2" FOREIGN KEY ("type_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "physical_object_FK_3" FOREIGN KEY ("parent_id") REFERENCES "physical_object" ("id")
);
CREATE TABLE "physical_object_i18n" (
  "name" varchar(255) DEFAULT NULL,
  "description" text,
  "location" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "physical_object_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "physical_object" ("id") ON DELETE CASCADE
);
CREATE TABLE "place" (
  "id" int(11) NOT NULL,
  "country_id" int(11) DEFAULT NULL,
  "type_id" int(11) DEFAULT NULL,
  "longtitude" float DEFAULT NULL,
  "latitude" float DEFAULT NULL,
  "altitude" float DEFAULT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "place_FK_1" FOREIGN KEY ("id") REFERENCES "term" ("id") ON DELETE CASCADE,
  CONSTRAINT "place_FK_2" FOREIGN KEY ("country_id") REFERENCES "term" ("id"),
  CONSTRAINT "place_FK_3" FOREIGN KEY ("type_id") REFERENCES "term" ("id")
);
CREATE TABLE "place_i18n" (
  "street_address" text,
  "city" varchar(255) DEFAULT NULL,
  "region" varchar(255) DEFAULT NULL,
  "postal_code" varchar(255) DEFAULT NULL,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "place_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "place" ("id") ON DELETE CASCADE
);
CREATE TABLE "place_map_relation" (
  "id" int(11) NOT NULL,
  "place_id" int(11) NOT NULL,
  "map_id" int(11) NOT NULL,
  "map_icon_image_id" int(11) DEFAULT NULL,
  "map_icon_description" text,
  "type_id" int(11) DEFAULT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "place_map_relation_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "place_map_relation_FK_2" FOREIGN KEY ("place_id") REFERENCES "place" ("id") ON DELETE CASCADE,
  CONSTRAINT "place_map_relation_FK_3" FOREIGN KEY ("map_id") REFERENCES "map" ("id") ON DELETE CASCADE,
  CONSTRAINT "place_map_relation_FK_4" FOREIGN KEY ("map_icon_image_id") REFERENCES "digital_object" ("id"),
  CONSTRAINT "place_map_relation_FK_5" FOREIGN KEY ("type_id") REFERENCES "term" ("id")
);
CREATE TABLE "property" (
  "object_id" int(11) NOT NULL,
  "scope" varchar(255) DEFAULT NULL,
  "name" varchar(255) DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "property_FK_1" FOREIGN KEY ("object_id") REFERENCES "object" ("id") ON DELETE CASCADE
);
CREATE TABLE "property_i18n" (
  "value" varchar(255) DEFAULT NULL,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "property_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "property" ("id") ON DELETE CASCADE
);
CREATE TABLE "relation" (
  "id" int(11) NOT NULL,
  "subject_id" int(11) NOT NULL,
  "object_id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  "start_date" date DEFAULT NULL,
  "end_date" date DEFAULT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "relation_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "relation_FK_2" FOREIGN KEY ("subject_id") REFERENCES "object" ("id"),
  CONSTRAINT "relation_FK_3" FOREIGN KEY ("object_id") REFERENCES "object" ("id"),
  CONSTRAINT "relation_FK_4" FOREIGN KEY ("type_id") REFERENCES "term" ("id")
);
CREATE TABLE "repository" (
  "id" int(11) NOT NULL,
  "identifier" varchar(255) DEFAULT NULL,
  "desc_status_id" int(11) DEFAULT NULL,
  "desc_detail_id" int(11) DEFAULT NULL,
  "desc_identifier" varchar(255) DEFAULT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "repository_FK_1" FOREIGN KEY ("id") REFERENCES "actor" ("id") ON DELETE CASCADE,
  CONSTRAINT "repository_FK_2" FOREIGN KEY ("desc_status_id") REFERENCES "term" ("id") ON DELETE SET NULL,
  CONSTRAINT "repository_FK_3" FOREIGN KEY ("desc_detail_id") REFERENCES "term" ("id") ON DELETE SET NULL
);
CREATE TABLE "repository_i18n" (
  "geocultural_context" text,
  "collecting_policies" text,
  "buildings" text,
  "holdings" text,
  "finding_aids" text,
  "opening_times" text,
  "access_conditions" text,
  "disabled_access" text,
  "research_services" text,
  "reproduction_services" text,
  "public_facilities" text,
  "desc_institution_identifier" varchar(255) DEFAULT NULL,
  "desc_rules" text,
  "desc_sources" text,
  "desc_revision_history" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "repository_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "repository" ("id") ON DELETE CASCADE
);
CREATE TABLE "rights" (
  "object_id" int(11) NOT NULL,
  "permission_id" int(11) DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "rights_FK_1" FOREIGN KEY ("object_id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "rights_FK_2" FOREIGN KEY ("permission_id") REFERENCES "term" ("id")
);
CREATE TABLE "rights_actor_relation" (
  "id" int(11) NOT NULL,
  "rights_id" int(11) NOT NULL,
  "actor_id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "rights_actor_relation_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "rights_actor_relation_FK_2" FOREIGN KEY ("rights_id") REFERENCES "rights" ("id") ON DELETE CASCADE,
  CONSTRAINT "rights_actor_relation_FK_3" FOREIGN KEY ("actor_id") REFERENCES "actor" ("id") ON DELETE CASCADE,
  CONSTRAINT "rights_actor_relation_FK_4" FOREIGN KEY ("type_id") REFERENCES "term" ("id")
);
CREATE TABLE "rights_i18n" (
  "description" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "rights_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "rights" ("id") ON DELETE CASCADE
);
CREATE TABLE "rights_term_relation" (
  "rights_id" int(11) NOT NULL,
  "term_id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  "description" text,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "rights_term_relation_FK_1" FOREIGN KEY ("rights_id") REFERENCES "rights" ("id") ON DELETE CASCADE,
  CONSTRAINT "rights_term_relation_FK_2" FOREIGN KEY ("term_id") REFERENCES "term" ("id") ON DELETE CASCADE,
  CONSTRAINT "rights_term_relation_FK_3" FOREIGN KEY ("type_id") REFERENCES "term" ("id")
);
CREATE TABLE "setting" (
  "name" varchar(255) DEFAULT NULL,
  "scope" varchar(255) DEFAULT NULL,
  "editable" int(4) DEFAULT '0',
  "deleteable" int(4) DEFAULT '0',
  "source_culture" varchar(7) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
);
INSERT INTO "setting" VALUES ('plugins',NULL,0,0,'en',1,0);
INSERT INTO "setting" VALUES ('version',NULL,0,0,'en',2,0);
INSERT INTO "setting" VALUES ('upload_dir',NULL,0,0,'en',3,0);
INSERT INTO "setting" VALUES ('reference_image_maxwidth',NULL,1,0,'en',4,0);
INSERT INTO "setting" VALUES ('hits_per_page',NULL,1,0,'en',5,0);
INSERT INTO "setting" VALUES ('multi_repository',NULL,1,0,'en',6,0);
INSERT INTO "setting" VALUES ('sort_treeview_informationobject',NULL,1,0,'en',7,0);
INSERT INTO "setting" VALUES ('defaultPubStatus',NULL,1,0,'en',8,0);
INSERT INTO "setting" VALUES ('informationobject','default_template',1,0,'en',9,0);
INSERT INTO "setting" VALUES ('actor','default_template',1,0,'en',10,0);
INSERT INTO "setting" VALUES ('repository','default_template',1,0,'en',11,0);
INSERT INTO "setting" VALUES ('informationobject','ui_label',1,0,'en',12,0);
INSERT INTO "setting" VALUES ('actor','ui_label',1,0,'en',13,0);
INSERT INTO "setting" VALUES ('creator','ui_label',1,0,'en',14,0);
INSERT INTO "setting" VALUES ('repository','ui_label',1,0,'en',15,0);
INSERT INTO "setting" VALUES ('function','ui_label',1,0,'en',16,0);
INSERT INTO "setting" VALUES ('term','ui_label',1,0,'en',17,0);
INSERT INTO "setting" VALUES ('subject','ui_label',1,0,'en',18,0);
INSERT INTO "setting" VALUES ('collection','ui_label',1,0,'en',19,0);
INSERT INTO "setting" VALUES ('holdings','ui_label',1,0,'en',20,0);
INSERT INTO "setting" VALUES ('place','ui_label',1,0,'en',21,0);
INSERT INTO "setting" VALUES ('name','ui_label',1,0,'en',22,0);
INSERT INTO "setting" VALUES ('digitalobject','ui_label',1,0,'en',23,0);
INSERT INTO "setting" VALUES ('physicalobject','ui_label',1,0,'en',24,0);
INSERT INTO "setting" VALUES ('mediatype','ui_label',1,0,'en',25,0);
INSERT INTO "setting" VALUES ('materialtype','ui_label',1,0,'en',26,0);
INSERT INTO "setting" VALUES ('en','i18n_languages',1,0,'en',27,0);
INSERT INTO "setting" VALUES ('fr','i18n_languages',1,1,'en',28,0);
INSERT INTO "setting" VALUES ('es','i18n_languages',1,1,'en',29,0);
INSERT INTO "setting" VALUES ('nl','i18n_languages',1,1,'en',30,0);
INSERT INTO "setting" VALUES ('pt','i18n_languages',1,1,'en',31,0);
INSERT INTO "setting" VALUES ('oai_enabled','oai',1,0,'en',32,0);
INSERT INTO "setting" VALUES ('oai_repository_code','oai',1,0,'en',33,0);
INSERT INTO "setting" VALUES ('resumption_token_limit','oai',1,0,'en',34,0);
INSERT INTO "setting" VALUES ('inherit_code_informationobject',NULL,1,0,'en',35,0);
INSERT INTO "setting" VALUES ('toggleDescription',NULL,0,0,'en',36,0);
INSERT INTO "setting" VALUES ('toggleLogo',NULL,0,0,'en',37,0);
INSERT INTO "setting" VALUES ('toggleTitle',NULL,0,0,'en',38,0);
INSERT INTO "setting" VALUES ('check_for_updates',NULL,0,0,'en',39,0);
INSERT INTO "setting" VALUES ('explode_multipage_files',NULL,0,0,'en',40,0);
INSERT INTO "setting" VALUES ('show_tooltips',NULL,0,0,'en',41,0);
INSERT INTO "setting" VALUES ('siteTitle',NULL,0,0,'en',42,0);
INSERT INTO "setting" VALUES ('siteDescription',NULL,0,0,'en',43,0);
CREATE TABLE "setting_i18n" (
  "value" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "setting_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "setting" ("id") ON DELETE CASCADE
);
INSERT INTO "setting_i18n" VALUES ('a:14:{i:0;s:15:"sfCaribouPlugin";i:1;s:17:"sfEhriThemePlugin";i:2;s:10:"sfDcPlugin";i:3;s:11:"sfEacPlugin";i:4;s:11:"sfEadPlugin";i:5;s:13:"sfIsaarPlugin";i:6;s:12:"sfIsadPlugin";i:7;s:16:"sfEhriIsadPlugin";i:8;s:12:"sfIsdfPlugin";i:9;s:14:"sfIsdiahPlugin";i:10;s:18:"sfEhriIsdiahPlugin";i:11;s:12:"sfModsPlugin";i:12;s:11:"sfRadPlugin";i:13;s:12:"sfSkosPlugin";}',1,'en');
INSERT INTO "setting_i18n" VALUES ('62',2,'en');
INSERT INTO "setting_i18n" VALUES ('uploads',3,'en');
INSERT INTO "setting_i18n" VALUES ('480',4,'en');
INSERT INTO "setting_i18n" VALUES ('10',5,'en');
INSERT INTO "setting_i18n" VALUES ('1',6,'en');
INSERT INTO "setting_i18n" VALUES ('none',7,'en');
INSERT INTO "setting_i18n" VALUES ('159',8,'en');
INSERT INTO "setting_i18n" VALUES ('isad',9,'en');
INSERT INTO "setting_i18n" VALUES ('isaar',10,'en');
INSERT INTO "setting_i18n" VALUES ('isdiah',11,'en');
INSERT INTO "setting_i18n" VALUES ('Archival description',12,'en');
INSERT INTO "setting_i18n" VALUES ('Authority record',13,'en');
INSERT INTO "setting_i18n" VALUES ('Urheber/Bestandsbildner',14,'de');
INSERT INTO "setting_i18n" VALUES ('Creator',14,'en');
INSERT INTO "setting_i18n" VALUES ('Produtor',14,'es');
INSERT INTO "setting_i18n" VALUES ('Producteur',14,'fr');
INSERT INTO "setting_i18n" VALUES ('Soggetto produttore',14,'it');
INSERT INTO "setting_i18n" VALUES ('Archiefvormer',14,'nl');
INSERT INTO "setting_i18n" VALUES ('Produtor',14,'pt');
INSERT INTO "setting_i18n" VALUES ('Ustvarjalci',14,'sl');
INSERT INTO "setting_i18n" VALUES ('Archival institution',15,'en');
INSERT INTO "setting_i18n" VALUES ('Function',16,'en');
INSERT INTO "setting_i18n" VALUES ('Función',16,'es');
INSERT INTO "setting_i18n" VALUES ('Fonction',16,'fr');
INSERT INTO "setting_i18n" VALUES ('Funçao',16,'pt');
INSERT INTO "setting_i18n" VALUES ('Begriff',17,'de');
INSERT INTO "setting_i18n" VALUES ('Term',17,'en');
INSERT INTO "setting_i18n" VALUES ('Término',17,'es');
INSERT INTO "setting_i18n" VALUES ('Descripteur',17,'fr');
INSERT INTO "setting_i18n" VALUES ('Termine',17,'it');
INSERT INTO "setting_i18n" VALUES ('Term',17,'nl');
INSERT INTO "setting_i18n" VALUES ('Termo',17,'pt');
INSERT INTO "setting_i18n" VALUES ('Deskriptorji',17,'sl');
INSERT INTO "setting_i18n" VALUES ('Gegenstand',18,'de');
INSERT INTO "setting_i18n" VALUES ('Subject',18,'en');
INSERT INTO "setting_i18n" VALUES ('Termo',18,'es');
INSERT INTO "setting_i18n" VALUES ('Sujet',18,'fr');
INSERT INTO "setting_i18n" VALUES ('Soggetto',18,'it');
INSERT INTO "setting_i18n" VALUES ('Onderwerp',18,'nl');
INSERT INTO "setting_i18n" VALUES ('Assunto',18,'pt');
INSERT INTO "setting_i18n" VALUES ('Osebe',18,'sl');
INSERT INTO "setting_i18n" VALUES ('Sammlung',19,'de');
INSERT INTO "setting_i18n" VALUES ('Fonds',19,'en');
INSERT INTO "setting_i18n" VALUES ('fundo',19,'es');
INSERT INTO "setting_i18n" VALUES ('collection',19,'fr');
INSERT INTO "setting_i18n" VALUES ('collezione',19,'it');
INSERT INTO "setting_i18n" VALUES ('collectie',19,'nl');
INSERT INTO "setting_i18n" VALUES ('fundo/coleção',19,'pt');
INSERT INTO "setting_i18n" VALUES ('zbirke',19,'sl');
INSERT INTO "setting_i18n" VALUES ('Bestand',20,'de');
INSERT INTO "setting_i18n" VALUES ('Holdings',20,'en');
INSERT INTO "setting_i18n" VALUES ('Coleções',20,'es');
INSERT INTO "setting_i18n" VALUES ('Collections',20,'fr');
INSERT INTO "setting_i18n" VALUES ('Patrimoni',20,'it');
INSERT INTO "setting_i18n" VALUES ('Collecties',20,'nl');
INSERT INTO "setting_i18n" VALUES ('Acervo',20,'pt');
INSERT INTO "setting_i18n" VALUES ('Fondi',20,'sl');
INSERT INTO "setting_i18n" VALUES ('Ort',21,'de');
INSERT INTO "setting_i18n" VALUES ('Place',21,'en');
INSERT INTO "setting_i18n" VALUES ('Place',21,'es');
INSERT INTO "setting_i18n" VALUES ('Lieu',21,'fr');
INSERT INTO "setting_i18n" VALUES ('Luogo',21,'it');
INSERT INTO "setting_i18n" VALUES ('Plaats',21,'nl');
INSERT INTO "setting_i18n" VALUES ('Local',21,'pt');
INSERT INTO "setting_i18n" VALUES ('Kraji',21,'sl');
INSERT INTO "setting_i18n" VALUES ('Name',22,'de');
INSERT INTO "setting_i18n" VALUES ('Name',22,'en');
INSERT INTO "setting_i18n" VALUES ('Name',22,'es');
INSERT INTO "setting_i18n" VALUES ('Nom',22,'fr');
INSERT INTO "setting_i18n" VALUES ('Nome',22,'it');
INSERT INTO "setting_i18n" VALUES ('Naam',22,'nl');
INSERT INTO "setting_i18n" VALUES ('Nome',22,'pt');
INSERT INTO "setting_i18n" VALUES ('Imena',22,'sl');
INSERT INTO "setting_i18n" VALUES ('Digitales Objekt',23,'de');
INSERT INTO "setting_i18n" VALUES ('Digital object',23,'en');
INSERT INTO "setting_i18n" VALUES ('Digital object',23,'es');
INSERT INTO "setting_i18n" VALUES ('Objet numérique',23,'fr');
INSERT INTO "setting_i18n" VALUES ('Oggetto digitale',23,'it');
INSERT INTO "setting_i18n" VALUES ('Digitaal object',23,'nl');
INSERT INTO "setting_i18n" VALUES ('Objeto digital',23,'pt');
INSERT INTO "setting_i18n" VALUES ('Digitalni objekti',23,'sl');
INSERT INTO "setting_i18n" VALUES ('Physisches Objekt',24,'de');
INSERT INTO "setting_i18n" VALUES ('Physical storage',24,'en');
INSERT INTO "setting_i18n" VALUES ('Physical storage',24,'es');
INSERT INTO "setting_i18n" VALUES ('Objet physique',24,'fr');
INSERT INTO "setting_i18n" VALUES ('Oggetto fisico',24,'it');
INSERT INTO "setting_i18n" VALUES ('Fysieke opslag',24,'nl');
INSERT INTO "setting_i18n" VALUES ('Objeto físico',24,'pt');
INSERT INTO "setting_i18n" VALUES ('Skladiš?a',24,'sl');
INSERT INTO "setting_i18n" VALUES ('Medientyp',25,'de');
INSERT INTO "setting_i18n" VALUES ('Media type',25,'en');
INSERT INTO "setting_i18n" VALUES ('Media type',25,'es');
INSERT INTO "setting_i18n" VALUES ('Type de support',25,'fr');
INSERT INTO "setting_i18n" VALUES ('Tipo di media',25,'it');
INSERT INTO "setting_i18n" VALUES ('Bestandsformaat',25,'nl');
INSERT INTO "setting_i18n" VALUES ('Tipo de mídia',25,'pt');
INSERT INTO "setting_i18n" VALUES ('Tip medija',25,'sl');
INSERT INTO "setting_i18n" VALUES ('Materialart',26,'de');
INSERT INTO "setting_i18n" VALUES ('Material type',26,'en');
INSERT INTO "setting_i18n" VALUES ('Type de document',26,'fr');
INSERT INTO "setting_i18n" VALUES ('Tipo di materiale',26,'it');
INSERT INTO "setting_i18n" VALUES ('Gênero documental',26,'pt');
INSERT INTO "setting_i18n" VALUES ('Tip materiala',26,'sl');
INSERT INTO "setting_i18n" VALUES ('en',27,'en');
INSERT INTO "setting_i18n" VALUES ('fr',28,'en');
INSERT INTO "setting_i18n" VALUES ('es',29,'en');
INSERT INTO "setting_i18n" VALUES ('nl',30,'en');
INSERT INTO "setting_i18n" VALUES ('pt',31,'en');
INSERT INTO "setting_i18n" VALUES ('0',32,'en');
INSERT INTO "setting_i18n" VALUES ('',33,'en');
INSERT INTO "setting_i18n" VALUES ('100',34,'en');
INSERT INTO "setting_i18n" VALUES ('1',35,'en');
INSERT INTO "setting_i18n" VALUES ('1',36,'en');
INSERT INTO "setting_i18n" VALUES ('1',37,'en');
INSERT INTO "setting_i18n" VALUES ('1',38,'en');
INSERT INTO "setting_i18n" VALUES ('1',39,'en');
INSERT INTO "setting_i18n" VALUES ('0',40,'en');
INSERT INTO "setting_i18n" VALUES ('1',41,'en');
INSERT INTO "setting_i18n" VALUES ('Testing EHRI',42,'en');
INSERT INTO "setting_i18n" VALUES ('Just a test',43,'en');
CREATE TABLE "slug" (
  "object_id" int(11) NOT NULL,
  "slug" varchar(255) NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "slug_FK_1" FOREIGN KEY ("object_id") REFERENCES "object" ("id")
);
INSERT INTO "slug" VALUES (1,'IgPHg',1,0);
INSERT INTO "slug" VALUES (3,'kMZGR',2,0);
INSERT INTO "slug" VALUES (4,'home',3,0);
INSERT INTO "slug" VALUES (5,'about',4,0);
INSERT INTO "slug" VALUES (30,'mdkI',5,0);
INSERT INTO "slug" VALUES (31,'description-detail-levels',6,0);
INSERT INTO "slug" VALUES (32,'actor-entity-types',7,0);
INSERT INTO "slug" VALUES (33,'description-statuses',8,0);
INSERT INTO "slug" VALUES (34,'levels-of-description',9,0);
INSERT INTO "slug" VALUES (35,'subjects',10,0);
INSERT INTO "slug" VALUES (36,'actor-name-types',11,0);
INSERT INTO "slug" VALUES (37,'note-types',12,0);
INSERT INTO "slug" VALUES (38,'repository-types',13,0);
INSERT INTO "slug" VALUES (40,'event-types',14,0);
INSERT INTO "slug" VALUES (41,'qubit-setting-labels',15,0);
INSERT INTO "slug" VALUES (42,'places',16,0);
INSERT INTO "slug" VALUES (43,'isdf-function-types',17,0);
INSERT INTO "slug" VALUES (44,'historical-events',18,0);
INSERT INTO "slug" VALUES (45,'collection-types',19,0);
INSERT INTO "slug" VALUES (46,'media-types',20,0);
INSERT INTO "slug" VALUES (47,'digital-object-usages',21,0);
INSERT INTO "slug" VALUES (48,'physical-object-type',22,0);
INSERT INTO "slug" VALUES (49,'relation-type',23,0);
INSERT INTO "slug" VALUES (50,'material-type',24,0);
INSERT INTO "slug" VALUES (51,'rad-note',25,0);
INSERT INTO "slug" VALUES (52,'rad-title-note',26,0);
INSERT INTO "slug" VALUES (53,'mods-resource-type',27,0);
INSERT INTO "slug" VALUES (54,'dublin-core-types',28,0);
INSERT INTO "slug" VALUES (55,'actor-relation-type',29,0);
INSERT INTO "slug" VALUES (56,'relation-note-types',30,0);
INSERT INTO "slug" VALUES (57,'term-relation-types',31,0);
INSERT INTO "slug" VALUES (59,'status-types',32,0);
INSERT INTO "slug" VALUES (60,'publication-status',33,0);
INSERT INTO "slug" VALUES (61,'function-relation-type',34,0);
INSERT INTO "slug" VALUES (110,'y26jN',35,0);
INSERT INTO "slug" VALUES (111,'creation',36,0);
INSERT INTO "slug" VALUES (113,'custody',37,0);
INSERT INTO "slug" VALUES (114,'publication',38,0);
INSERT INTO "slug" VALUES (115,'contribution',39,0);
INSERT INTO "slug" VALUES (117,'collection',40,0);
INSERT INTO "slug" VALUES (118,'accumulation',41,0);
INSERT INTO "slug" VALUES (119,'title-note',42,0);
INSERT INTO "slug" VALUES (120,'publication-note',43,0);
INSERT INTO "slug" VALUES (121,'source-note',44,0);
INSERT INTO "slug" VALUES (122,'scope-note',45,0);
INSERT INTO "slug" VALUES (123,'display-note',46,0);
INSERT INTO "slug" VALUES (128,'archival-material',47,0);
INSERT INTO "slug" VALUES (129,'published-material',48,0);
INSERT INTO "slug" VALUES (130,'artefact-material',49,0);
INSERT INTO "slug" VALUES (131,'corporate-body',50,0);
INSERT INTO "slug" VALUES (132,'person',51,0);
INSERT INTO "slug" VALUES (133,'family',52,0);
INSERT INTO "slug" VALUES (135,'audio',53,0);
INSERT INTO "slug" VALUES (136,'image',54,0);
INSERT INTO "slug" VALUES (137,'text',55,0);
INSERT INTO "slug" VALUES (138,'video',56,0);
INSERT INTO "slug" VALUES (139,'other',57,0);
INSERT INTO "slug" VALUES (166,'external-uri',58,0);
INSERT INTO "slug" VALUES (140,'master',59,0);
INSERT INTO "slug" VALUES (141,'reference',60,0);
INSERT INTO "slug" VALUES (142,'thumbnail',61,0);
INSERT INTO "slug" VALUES (143,'compound',62,0);
INSERT INTO "slug" VALUES (144,'location',63,0);
INSERT INTO "slug" VALUES (145,'container',64,0);
INSERT INTO "slug" VALUES (146,'artefact',65,0);
INSERT INTO "slug" VALUES (147,'has-physical-object',66,0);
INSERT INTO "slug" VALUES (124,'archivist-s-note',67,0);
INSERT INTO "slug" VALUES (126,'other-descriptive-data',68,0);
INSERT INTO "slug" VALUES (125,'general-note',69,0);
INSERT INTO "slug" VALUES (148,'parallel-form',70,0);
INSERT INTO "slug" VALUES (149,'other-form',71,0);
INSERT INTO "slug" VALUES (150,'hierarchical',72,0);
INSERT INTO "slug" VALUES (151,'temporal',73,0);
INSERT INTO "slug" VALUES (152,'7XnH',75,0);
INSERT INTO "slug" VALUES (153,'associative',76,0);
INSERT INTO "slug" VALUES (154,'description',77,0);
INSERT INTO "slug" VALUES (155,'date-display',78,0);
INSERT INTO "slug" VALUES (156,'alternative-label',79,0);
INSERT INTO "slug" VALUES (157,'Ktz7',81,0);
INSERT INTO "slug" VALUES (158,'yHMY',83,0);
INSERT INTO "slug" VALUES (159,'draft',84,0);
INSERT INTO "slug" VALUES (160,'published',85,0);
INSERT INTO "slug" VALUES (127,'maintenance-note',86,0);
INSERT INTO "slug" VALUES (161,'name-access-points',87,0);
INSERT INTO "slug" VALUES (162,'QJdd3',89,0);
INSERT INTO "slug" VALUES (163,'15Ci',91,0);
INSERT INTO "slug" VALUES (164,'tleV',93,0);
INSERT INTO "slug" VALUES (165,'standardized-form',94,0);
INSERT INTO "slug" VALUES (167,'reproduction',95,0);
INSERT INTO "slug" VALUES (168,'distribution',96,0);
INSERT INTO "slug" VALUES (169,'broadcasting',97,0);
INSERT INTO "slug" VALUES (170,'manufacturing',98,0);
INSERT INTO "slug" VALUES (171,'box',99,0);
INSERT INTO "slug" VALUES (172,'cardboard-box',100,0);
INSERT INTO "slug" VALUES (173,'hollinger-box',101,0);
INSERT INTO "slug" VALUES (174,'folder',102,0);
INSERT INTO "slug" VALUES (175,'filing-cabinet',103,0);
INSERT INTO "slug" VALUES (176,'map-cabinet',104,0);
INSERT INTO "slug" VALUES (177,'shelf',105,0);
INSERT INTO "slug" VALUES (178,'final',106,0);
INSERT INTO "slug" VALUES (179,'revised',107,0);
INSERT INTO "slug" VALUES (180,'W5qcq',109,0);
INSERT INTO "slug" VALUES (181,'full',110,0);
INSERT INTO "slug" VALUES (182,'partial',111,0);
INSERT INTO "slug" VALUES (183,'minimal',112,0);
INSERT INTO "slug" VALUES (184,'fonds',113,0);
INSERT INTO "slug" VALUES (185,'subfonds',114,0);
INSERT INTO "slug" VALUES (186,'OQdny',116,0);
INSERT INTO "slug" VALUES (187,'series',117,0);
INSERT INTO "slug" VALUES (188,'subseries',118,0);
INSERT INTO "slug" VALUES (189,'file',119,0);
INSERT INTO "slug" VALUES (190,'item',120,0);
INSERT INTO "slug" VALUES (191,'information-object',121,0);
INSERT INTO "slug" VALUES (192,'person-organization',122,0);
INSERT INTO "slug" VALUES (193,'creator',123,0);
INSERT INTO "slug" VALUES (194,'repository',124,0);
INSERT INTO "slug" VALUES (195,'term',125,0);
INSERT INTO "slug" VALUES (196,'subject',126,0);
INSERT INTO "slug" VALUES (197,'PtmRa',128,0);
INSERT INTO "slug" VALUES (198,'holdings',129,0);
INSERT INTO "slug" VALUES (199,'archival-description',130,0);
INSERT INTO "slug" VALUES (200,'authority-record',131,0);
INSERT INTO "slug" VALUES (201,'qqMI1',133,0);
INSERT INTO "slug" VALUES (202,'archival-institution',134,0);
INSERT INTO "slug" VALUES (203,'international',135,0);
INSERT INTO "slug" VALUES (204,'national',136,0);
INSERT INTO "slug" VALUES (205,'regional',137,0);
INSERT INTO "slug" VALUES (206,'provincial-state',138,0);
INSERT INTO "slug" VALUES (207,'community',139,0);
INSERT INTO "slug" VALUES (208,'religious',140,0);
INSERT INTO "slug" VALUES (209,'university',141,0);
INSERT INTO "slug" VALUES (210,'municipal',142,0);
INSERT INTO "slug" VALUES (211,'aboriginal',143,0);
INSERT INTO "slug" VALUES (212,'educational',144,0);
INSERT INTO "slug" VALUES (213,'medical',145,0);
INSERT INTO "slug" VALUES (214,'military',146,0);
INSERT INTO "slug" VALUES (215,'private',147,0);
INSERT INTO "slug" VALUES (216,'place',148,0);
INSERT INTO "slug" VALUES (217,'name',149,0);
INSERT INTO "slug" VALUES (218,'digital-object',150,0);
INSERT INTO "slug" VALUES (219,'physical-object',151,0);
INSERT INTO "slug" VALUES (220,'physical-storage',152,0);
INSERT INTO "slug" VALUES (221,'media-type',153,0);
INSERT INTO "slug" VALUES (222,'open-information-management-toolkit',154,0);
INSERT INTO "slug" VALUES (223,'conservation-note',155,0);
INSERT INTO "slug" VALUES (224,'architectural-drawing',156,0);
INSERT INTO "slug" VALUES (225,'cartographic-material',157,0);
INSERT INTO "slug" VALUES (226,'graphic-material',158,0);
INSERT INTO "slug" VALUES (227,'moving-images',159,0);
INSERT INTO "slug" VALUES (228,'multiple-media',160,0);
INSERT INTO "slug" VALUES (229,'object',161,0);
INSERT INTO "slug" VALUES (230,'philatelic-record',162,0);
INSERT INTO "slug" VALUES (231,'sound-recording',163,0);
INSERT INTO "slug" VALUES (232,'technical-drawing',164,0);
INSERT INTO "slug" VALUES (233,'textual-record',165,0);
INSERT INTO "slug" VALUES (234,'edition',166,0);
INSERT INTO "slug" VALUES (235,'physical-description',167,0);
INSERT INTO "slug" VALUES (236,'conservation',168,0);
INSERT INTO "slug" VALUES (237,'accompanying-material',169,0);
INSERT INTO "slug" VALUES (238,'publisher-s-series',170,0);
INSERT INTO "slug" VALUES (239,'alpha-numeric-designations',171,0);
INSERT INTO "slug" VALUES (240,'rights',172,0);
INSERT INTO "slug" VALUES (241,'D5pF',174,0);
INSERT INTO "slug" VALUES (242,'variations-in-title',175,0);
INSERT INTO "slug" VALUES (243,'source-of-title-proper',176,0);
INSERT INTO "slug" VALUES (244,'parallel-titles-and-other-title-information',177,0);
INSERT INTO "slug" VALUES (245,'continuation-of-title',178,0);
INSERT INTO "slug" VALUES (246,'statements-of-responsibility',179,0);
INSERT INTO "slug" VALUES (247,'attributions-and-conjectures',180,0);
INSERT INTO "slug" VALUES (248,'1d5q',182,0);
INSERT INTO "slug" VALUES (249,'cartographic',183,0);
INSERT INTO "slug" VALUES (250,'notated-music',184,0);
INSERT INTO "slug" VALUES (251,'KjAtR',186,0);
INSERT INTO "slug" VALUES (252,'sound-recording-musical',187,0);
INSERT INTO "slug" VALUES (253,'sound-recording-nonmusical',188,0);
INSERT INTO "slug" VALUES (254,'still-image',189,0);
INSERT INTO "slug" VALUES (255,'moving-image',190,0);
INSERT INTO "slug" VALUES (256,'three-dimensional-object',191,0);
INSERT INTO "slug" VALUES (257,'software-multimedia',192,0);
INSERT INTO "slug" VALUES (258,'mixed-material',193,0);
INSERT INTO "slug" VALUES (259,'FlmU',195,0);
INSERT INTO "slug" VALUES (260,'dataset',196,0);
INSERT INTO "slug" VALUES (261,'event',197,0);
INSERT INTO "slug" VALUES (262,'SWeA8',199,0);
INSERT INTO "slug" VALUES (263,'interactive-resource',200,0);
INSERT INTO "slug" VALUES (264,'53AXd',202,0);
INSERT INTO "slug" VALUES (265,'iajK',204,0);
INSERT INTO "slug" VALUES (266,'service',205,0);
INSERT INTO "slug" VALUES (267,'software',206,0);
INSERT INTO "slug" VALUES (268,'sound',207,0);
INSERT INTO "slug" VALUES (269,'A0BL',209,0);
INSERT INTO "slug" VALUES (270,'5drP',211,0);
INSERT INTO "slug" VALUES (271,'function',212,0);
INSERT INTO "slug" VALUES (272,'subfunction',213,0);
INSERT INTO "slug" VALUES (273,'business-process',214,0);
INSERT INTO "slug" VALUES (274,'activity',215,0);
INSERT INTO "slug" VALUES (275,'task',216,0);
INSERT INTO "slug" VALUES (276,'transaction',217,0);
INSERT INTO "slug" VALUES (278,'377G',219,0);
CREATE TABLE "static_page" (
  "id" int(11) NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "static_page_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE
);
INSERT INTO "static_page" VALUES (4,'en');
INSERT INTO "static_page" VALUES (5,'en');
CREATE TABLE "static_page_i18n" (
  "title" varchar(255) DEFAULT NULL,
  "content" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "static_page_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "static_page" ("id") ON DELETE CASCADE
);
INSERT INTO "static_page_i18n" VALUES ('Willkommen','Das ist die standardmäßige Homepage von ICA-AtoM. Dabei handelt es sich um eine Beta-Version, die nach wie vor weiter entwickelt und getestet wird.

ICA-AtoM ist eine vollständig webbasierte Anwendung zur Archiverschließung. Sie basiert auf den Standards des <a href="http://www.ica.org/">Internationalen Archivrats</a> (ICA). <i>AtoM</i> ist ein Akronym für <i>Access to Memory</i>.

Der ICA und seine <a href="http://ica-atom.org/about#partners">Projekpartner</a> machen diese Anwendung als Open-Source-Software zugänglich, um archivischen Institutionen eine frei zugänglichen und einfach zu benutzende Möglichkeit anzubieten, ihre Bestände online vorzustellen. Auf der Seite <a href="about">Über ICA-Atom</a> erfahren Sie Näheres zum Projekt.

<h2>Hilfe</h2>

Benützen Sie das online <a href="http://ica-atom.org/docs">Benützerhandbuch</a> um mehr über die Funktionen dieses Programms zu erfahren oder wählen Sie die Schaltfläche
<i>blättern</i>, um einige Beispieldaten zu sehen.',4,'de');
INSERT INTO "static_page_i18n" VALUES ('Welcome','This is the default homepage for ICA-AtoM. This is a beta version that is still under active development and testing.

ICA-AtoM is a fully web based archival description application that is based on <a href="http://www.ica.org/">International Council on Archives</a> (ICA) standards. <i>AtoM</i> is an acronymn for <i>Access to Memory</i>.

The ICA and its <a href="http://ica-atom.org/about#partners">project collaborators</a> are making this application available as open source software to provide archival institutions with a free and easy to use option for putting their archival collections online. See the <a href="about">about page</a> to learn more about the ICA-AtoM project.

See the online <a href="http://ica-atom.org/docs">documentation</a> to learn more about using the software or press the <i>browse</i> button on the right to view some sample data.',4,'en');
INSERT INTO "static_page_i18n" VALUES ('Bienvenido','Ésta es la página inicial por defecto de ICA-AtoM, una versión beta aún en etapa de desarrollo.

ICA-AtoM es una aplicación para la descripción archivística localizada en la red que cumple estándares <a href="http://www.ica.org/">Consejo Internacional de Archivos</a> (CIA). <i>AtoM</i> es el acrónimo de <i>Access to Memory</i>.

El CIA y sus colaboradores en el proyecto <a href="http://ica-atom.org/about#partners">project collaborators</a> han concebido esta aplicación como un software de código abierto cuyo propósito es ofrecer a las instituciones archivísticas una alternativa gratuita y de fácil uso para publicar sus colecciones en línea. Si desea leer más sobre el proyecto ICA-AtoM, sírvase consultar <a href="about">Acerca</a>.

Si desea más información sobre cómo utilizar el software, vaya a <a href="http://ica-atom.org/docs">documentation</a> o si desea desplegar ejemplos de datos pulse el botón <i>Navegar</i> que se muestra a su derecha.',4,'es');
INSERT INTO "static_page_i18n" VALUES ('Bienvenue','Vous êtes sur la page d''accueil de ICA-AtoM. Il s''agit d''une version beta qui est toujours en cours de développement et de test.

ICA-AtoM est une application Web de description archivistique qui s''appuie sur les normes du <a href="http://www.ica.org/">Conseil International des Archives</a> (ICA). <i>AtoM</i> est un acronyme anglais signifiant <i>Access to Memory (Accès à la Mémoire)</i>.

L''ICA et ses <a href="http://ica-atom.org/about#partners">partenaires de projet </a>rendent cette application disponible en code source libre afin de fournir aux services d''archives une solution gratuite et facile à utiliser pour mettre leurs fonds d''archives en ligne. Voir la page <a href="about">à propos</a> pour en apprendre davantage au sujet du projet ICA-AtoM.

Voir la <a href="http://ica-atom.org/docs">documentation en ligne</a> pour apprendre à utiliser le logiciel ou appuyez le bouton <i>parcourir</i> à droite pour voir quelques données-échantillons.',4,'fr');
INSERT INTO "static_page_i18n" VALUES ('Benvenuti','Questa è la pagina predefinita di ICA-AtoM. Si tratta di una prima versione beta ed è ancora in fase di sviluppo e di test.

ICA-AtoM è un applicazione per la descrizione archivistica interamente online, basata sugli standard dell''<a href="http://www.ica.org/">International Council on Archives</a> (ICA). AtoM è un acronimo per <i>Access to Memory</i>.

ICA e i suoi <a href="http://ica-atom.org/about#partners">collaboratori nel progetto</a> stanno sviluppando questa applicazione open source per fornire alle istituzioni archivistiche una semplice e gratuita opzione per rendere disponibile in linea il loro patrimonio archivistico. Si veda la pagina delle <a href="about">informazioni</a> per ulteriori indicazioni sul progetto ICA-AtoM.

È possibile consultare la <a href="http://ica-atom.org/docs">documentazione</a> per informazioni su come utilizzare il software o, utilizzando il pulsante <i>naviga</i> sulla destra, è possibile vedere alcuni esempi.',4,'it');
INSERT INTO "static_page_i18n" VALUES ('?????','? ????? ICA-AtoM 1.0.7.?? ??????. ? ????????? ?? ?????? ?? ??????. 

ICA-AtoM? ''??????????''(ICA) ??? ??? ??? ?????? ????????.AtoM? ??? ?? ??(Access to Memory)? ????.

ICA? ICA? ''???? ???''?? ???????? ?? ???? ?? ??? ????? ????? ? ?? ? ??????? ???? ?????? ???? ??. ICA-AtoM ????? ?? ? ?? ???  ''? ???''? ???.  

? ????? ??? ?? ? ?? ??? ??? ''??????''? ??, ?? ???? ??? ??? ''????'' ??? ????.    ',4,'ko');
INSERT INTO "static_page_i18n" VALUES ('Welkom','Dit is de standaard homepage voor ICA-AtoM. Dit is een beta-versie die nog steeds verder wordt ontwikkeld en getest.

ICA-AtoM is een volledig web-gebaseerd archivistische beschrijvingsapplicatie die is gebaseerd op <a href="http://www.ica.org/">International Council on Archives</a> (ICA) standaarden. <i>AtoM</i> is een acroniem voor <i>Acces to Memory</i>.

De ICA en haar <a href="http://ica-atom.org/about#partners">partners in dit project</a> maken deze applicatie als open-source software om zo archiefinstellingen te voorzien van een vrij en eenvoudig te gebruiken mogelijkheid om haar archiefcollectie online te plaatsen. Zie de <a href="about">over... pagina</a> om meer te weten te komen over het ICA-AtoM project.

Zie de online <a href="http://ica-atom.org/docs">documentatie</a> om meer te weten te komen over het gebruik van de software of klik op de <i>bladeren</i> knop rechts om voorbeeld gegevens te bekijken.',4,'nl');
INSERT INTO "static_page_i18n" VALUES ('Bem vindo(a)','Essa é a página inicial padrão do ICA-AtoM. Essa ainda é uma versão beta e em contínuo desenvolvimento e teste.

ICA-AtoM é um aplicativo para web destinado a apoiar as atividades de Descrição Arquivística em conformidade com os padrões do <a href="http://www.ica.org/">Conselho Internacional de Arquivos</a> (CIA). <i>AtoM</i> é um acrônimo para <i>Access to Memory</i>, ou, Acesso à Memória, em inglês.

O CIA e os <a href="http://ica-atom.org/about#partners">colaboradores do projeto</a> ICA-AtoM estão disponibilizando esse aplicativo como um software livre, de forma que as instituições arquivísticas tenham acesso a um sistema gratuito, fácil de usar e que as permitam disponibilizar seus acervos arquivísticos on-line.

Acesse a <a href="http://ica-atom.org/docs">documentação</a> online para aprender mais acerca do uso desse software ou clique no botão <i>navegar</i> no lado direito para visualizar algumas descrições de exemplo.',4,'pt');
INSERT INTO "static_page_i18n" VALUES ('Dobrodošli','Nahajate se na doma?i strani programa ICA-AtoM. Ta je v zgodnji beta verziji, zato je v aktivnem razvoju in testiranju.

ICA-AtoM je spletna aplikacija za opisovanje arhivskega gradiva, ki temelji na standardih <a href="http://www.ica.org/">Mednarodnega arhivskega sveta</a> (International Council on Archives - ICA). <i>AtoM</i> je akronim za <i>Access to Memory</i>.

ICA in njegovi <a href="http://ica-atom.org/about#partners">sodelavci v projektu</a> so pripravili to aplikacijo dostopno kot odprtokodno, da bi zagotovili arhivskim institucijam možnost proste in hitro postavitve njihovih zbirk "online". Glej <a href="page/about">about page</a> na kateri izveš ve? o ICA-AtoM projektu.

Glej "online" <a href="http://ica-atom.org/docs">dokumentacijo</a>, kjer najdeš ve? o uporabi tega programa ali klikni gumb <i>brskaj</i> na desni, kjer boš našel(a) nekaj primerov.',4,'sl');
INSERT INTO "static_page_i18n" VALUES ('Über','Dies ist die vorgegebene Seite <i>Über</i> der Open-Source Anwendung zur archivischen Erschließung ICA-AtoM. Für den Einstieg in ICA-AtoM benützen Sie die <a href="http://ica-atom.org/docs">Dokumentation</a>. Hier erfahren Sie, wie Sie die Anwendung an die Gestaltung ihrer Webseite anpassen und editieren können.

ICA-AtoM ist ein <a href="http://ica-atom.org/about#partners">gemeinschaftliches Projekt</a>. Es möchte der internationalen archivarischen Gemeinschaft eine freie, auf Open-Source basierende Software-Anwendung zur Verfügung stellen, um Archivbestände in Übereinstimmung mit den ICA-Standards erschließen zu können.

Ziel ist es, eine einfache, vielsprachige, komplett webbasierte Anwendung zur Verfügung zu stellen, die es Institutionen erlaubt, ihre Archivbestände online vorzustellen.',5,'de');
INSERT INTO "static_page_i18n" VALUES ('About','This is the default <i>About</i> page for the ICA-AtoM open source archival description application. See the online <a href="http://ica-atom.org/docs">documentation</a> to learn how to get started with ICA-AtoM, including how to customize and edit this page to suit your own website.

ICA-AtoM is a <a href="http://ica-atom.org/about#partners">collaborative project</a> with the aim to provide the international archival community with a free, open source software application to manage archival descriptions in accord with ICA standards.

The goal is to provide an easy to use, multilingual application that is fully web based and will allow institutions to make their archival collections available online.',5,'en');
INSERT INTO "static_page_i18n" VALUES ('Acerca','Ésta es la página por defecto <i>Acerca</i> de la aplicación para descripción archivística de código abierto ICA-AtoM. Para información sobre cómo utilizar ICA-AtoM, personalizar y editar esta página según las características de su propio sitio Web, consulte <a href="http://ica-atom.org/docs">documentation</a> .

El proyecto ICA-AtoM <a href="http://ica-atom.org/about#partners">collaborative project</a> tiene por objetivo proporcionar a la comunidad archivística internacional una aplicación gratuita de código abierto para la administración descripciones archivísticas en cumplimiento con estándares ICA.

La meta es poner a disposición del usuario una aplicación multilingüe, de fácil uso y situada en la red, que permita a las instituciones publicar sus colecciones archivísticas en línea.',5,'es');
INSERT INTO "static_page_i18n" VALUES ('À propos','Vous êtes sur la page <i>À propos</i> du logiciel libre de description archivistique ICA-AtoM. Voir la <a href="http://ica-atom.org/docs">documentation en ligne </a> pour apprendre à utiliser ICA-AtoM, l''adapter à vos besoins et modifier cette page afin qu''elle convienne à votre propre site Web.

ICA-AtoM est un <a href="http://ica-atom.org/about#partners">projet collaboratif</a> ayant pour but de fournir à la communauté archivistique internationale une application gratuite, disponible en code source libre, permettant de gérer des descriptions archivistiques conformément aux normes de l''ICA.

Le but est de fournir une application facile à utiliser, multilingue et entièrement basée sur le Web qui permettra aux institutions de rendre accessible en ligne leurs collections archivistiques.',5,'fr');
INSERT INTO "static_page_i18n" VALUES ('Informazioni','Questa è la pagina predefinita per le <i>Informazioni su</i> ICA-AtoM, un''applicazione open-source per la descrizione archivistica. Si veda la <a href="http://ica-atom.org/docs">documentazione</a> in linea per informazioni su come iniziare con ICA-AtoM, come personalizzare e tradurre questa pagina per adattarla al proprio sito web.

ICA-AtoM è un <a href="http://ica-atom.org/about#partners">progetto collaborativo</a> con lo scopo di mettere a disposizione della comunità archivistica internazionale un software gratis, libero e open source per gestire le descrizioni archivistiche nel rispetto degli standard ICA.

L''obiettivo è fornire un''applicazione semplice e multilingua, accessibile interamente online e che permetta alle istituzioni di rendere fruibili online i propri fondi.',5,'it');
INSERT INTO "static_page_i18n" VALUES ('ICA-AtoM ? ??','? ??? ???? ICA-AtoM ???? ???? ?? ?????? ?? ?????. ? ICA-AtoM ??? ?? ??? ??? ??? ''??????''? ??. ???? ? ???? ??? ????? ?? ?????? ??? ???? ??.

ICA-AtoM? ?????? ??? ICA ??? ?? ???? ??? ??? ? ?? ?? ?? ???? ????? ??????? ????? ???? ??? ?? ??????.

? ????? ??? ????? ?? ??????? ?? ???? ??? ????? ??? ? ?? ?? ???? ?? ???? ??????? ????? ??.',5,'ko');
INSERT INTO "static_page_i18n" VALUES ('Over...','Dit is de standaard <i>over...</i> pagina voor de ICA-AtoM open-source archivistisch beschrijvingsapplicatie. Kijk naar de online <a href="http://ica-atom.org/docs">documentatie</a> om te leren hoe van start te gaan met deze applicatie, inclusief het aanpassen en bewerken van deze pagina om binnen uw eigen webpagina in te passen.

ICA-AtoM is een <a href="http://ica-atom.org/about#partners">samenwerkingsproject</a> met het doel om de internationale archiefwereld te voorzien van een vrij, open-source software applicatie om hun archiefbeschrijvingen te beheren conform de ICA-standaarden.

Het doel is om een eenvoudig te gebruiken, meertalige applicatie, dat volledig web-gebaseerd is beschikbaar te stellen. Het geeft instellingen de mogelijkheid om hun archiefcollecties online beschikbaar te stellen.',5,'nl');
INSERT INTO "static_page_i18n" VALUES ('Sobre o ICA-AtoM','Essa é a página padrão <i>Sobre</i> do ICA-AtoM, um aplicativo de código-fonte aberto para descrição arquivística. Acesse a <a href="http://ica-atom.org/docs">documentação</a> online para aprender como começar a usar o ICA-AtoM, incluindo como personalizar e editar essa página para incluí-la em seu site.

ICA-AtoM é <a href="http://ica-atom.org/about#partners">projeto colaborativo</a> que visa prover a comunidade arquivística internacional de um software aplicativo gratuito e de código-fonte aberto, para gerenciamento de descrições arquivísticas em conformidade às normas do Conselho Internacional de Arquivos (ICA).

O objetivo é disponibilizar um aplicativo fácil de usar, multilíngue, e totalmente baseado na web, permitindo que instituições possam disponibilizar seus acervos arquivísticos on-line.',5,'pt');
INSERT INTO "static_page_i18n" VALUES ('O tem','To je prednastavljena <i>About</i> stran za ICA-AtoM odprtokodno aplikacijo za popisovanje arhivskega gradiva. Glej "online" <a href="http://ica-atom.org/docs">documentation</a>, kjer izveš ve? o tem kako za?eti delo s programom, vklju?no s tem, kako preoblikovati in urediti to stran za lastne potrebe.

ICA in njegovi <a href="http://ica-atom.org/about#partners">sodelavci v projektu</a> so pripravili za potrebe mednarodne arhivske skupnosti prosto dostopno in odprtokodno aplikacijo za upravljanje arhivskih opisov v skladu z ICA standardi.

Naš cilj je pripraviti uporabno, ve?jezikovno spletno aplikacijo, ki bo omogo?ala ustanovam "on line" predstavitev njihovih arhivskih zbirk.',5,'sl');
CREATE TABLE "status" (
  "object_id" int(11) NOT NULL,
  "type_id" int(11) DEFAULT NULL,
  "status_id" int(11) DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "status_FK_1" FOREIGN KEY ("object_id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "status_FK_2" FOREIGN KEY ("type_id") REFERENCES "term" ("id") ON DELETE CASCADE,
  CONSTRAINT "status_FK_3" FOREIGN KEY ("status_id") REFERENCES "term" ("id") ON DELETE CASCADE
);
INSERT INTO "status" VALUES (1,158,159,'2011-09-16 20:04:56','2011-09-16 20:04:56',1,0);
CREATE TABLE "system_event" (
  "type_id" int(11) DEFAULT NULL,
  "object_class" varchar(255) DEFAULT NULL,
  "object_id" int(11) DEFAULT NULL,
  "pre_event_snapshot" text,
  "post_event_snapshot" text,
  "date" datetime DEFAULT NULL,
  "user_id" int(11) DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "id" int(11) NOT NULL ,
  "serial_number" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("id")
  CONSTRAINT "system_event_FK_1" FOREIGN KEY ("type_id") REFERENCES "term" ("id"),
  CONSTRAINT "system_event_FK_2" FOREIGN KEY ("user_id") REFERENCES "user" ("id")
);
CREATE TABLE "taxonomy" (
  "id" int(11) NOT NULL,
  "usage" varchar(255) DEFAULT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "parent_id" int(11) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "taxonomy_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "taxonomy_FK_2" FOREIGN KEY ("parent_id") REFERENCES "taxonomy" ("id")
);
INSERT INTO "taxonomy" VALUES (30,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',NULL,1,60,'en');
INSERT INTO "taxonomy" VALUES (31,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,2,3,'en');
INSERT INTO "taxonomy" VALUES (32,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,4,5,'en');
INSERT INTO "taxonomy" VALUES (33,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,6,7,'en');
INSERT INTO "taxonomy" VALUES (34,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,8,9,'en');
INSERT INTO "taxonomy" VALUES (35,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,10,11,'en');
INSERT INTO "taxonomy" VALUES (36,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,12,13,'en');
INSERT INTO "taxonomy" VALUES (37,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,14,15,'en');
INSERT INTO "taxonomy" VALUES (38,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,16,17,'en');
INSERT INTO "taxonomy" VALUES (40,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,18,19,'en');
INSERT INTO "taxonomy" VALUES (41,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,20,21,'en');
INSERT INTO "taxonomy" VALUES (42,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,22,23,'en');
INSERT INTO "taxonomy" VALUES (43,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,24,25,'en');
INSERT INTO "taxonomy" VALUES (44,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,26,27,'en');
INSERT INTO "taxonomy" VALUES (45,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,28,29,'en');
INSERT INTO "taxonomy" VALUES (46,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,30,31,'en');
INSERT INTO "taxonomy" VALUES (47,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,32,33,'en');
INSERT INTO "taxonomy" VALUES (48,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,34,35,'en');
INSERT INTO "taxonomy" VALUES (49,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,36,37,'en');
INSERT INTO "taxonomy" VALUES (50,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,38,39,'en');
INSERT INTO "taxonomy" VALUES (51,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,40,41,'en');
INSERT INTO "taxonomy" VALUES (52,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,42,43,'en');
INSERT INTO "taxonomy" VALUES (53,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,44,45,'en');
INSERT INTO "taxonomy" VALUES (54,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,46,47,'en');
INSERT INTO "taxonomy" VALUES (55,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,48,49,'en');
INSERT INTO "taxonomy" VALUES (56,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,50,51,'en');
INSERT INTO "taxonomy" VALUES (57,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,52,53,'en');
INSERT INTO "taxonomy" VALUES (59,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,54,55,'en');
INSERT INTO "taxonomy" VALUES (60,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,56,57,'en');
INSERT INTO "taxonomy" VALUES (61,NULL,'2011-09-16 20:04:51','2011-09-16 20:04:51',30,58,59,'en');
CREATE TABLE "taxonomy_i18n" (
  "name" varchar(255) DEFAULT NULL,
  "note" text,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "taxonomy_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "taxonomy" ("id") ON DELETE CASCADE
);
INSERT INTO "taxonomy_i18n" VALUES (NULL,NULL,30,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Detailgrad der Erschließung',NULL,31,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Description Detail Levels',NULL,31,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Descripción detalles de niveles',NULL,31,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Niveaux de détail de la description',NULL,31,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('livelli della completezza della descrizione',NULL,31,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Niveaus van detailbeschrijving',NULL,31,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Níveis de detalhamento descritivo',NULL,31,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('podroben opis nivoja',NULL,31,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Rechtspersönlichkeit',NULL,32,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Actor Entity Types',NULL,32,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Types d''entité producteurs',NULL,32,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipi di entità dell''agente',NULL,32,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Soorten entiteiten',NULL,32,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Tipos de entidade',NULL,32,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip entitet ustvarjalcev',NULL,32,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Erschließungsstatus',NULL,33,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Description Statuses',NULL,33,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Statuts de la description',NULL,33,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('stati della descrizione',NULL,33,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Beschrijvingsstatus',NULL,33,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Status da descrição',NULL,33,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('statusi opisa',NULL,33,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Erschließungsstufe',NULL,34,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Levels of description',NULL,34,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Niveles de descripción',NULL,34,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Niveau de description',NULL,34,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('livelli di descrizione',NULL,34,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Beschrijvingsniveaus',NULL,34,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Níveis de descrição',NULL,34,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('nivo popisa',NULL,34,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Themen',NULL,35,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Subjects',NULL,35,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Materias',NULL,35,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Sujets',NULL,35,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('soggetti',NULL,35,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Onderwerpen',NULL,35,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Assuntos',NULL,35,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('osebe',NULL,35,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Bezeichnung',NULL,36,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Actor Name Types',NULL,36,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Types de noms de producteurs',NULL,36,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipi di nome dell''agente',NULL,36,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Soorten naam van entiteiten',NULL,36,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Tipos de nome',NULL,36,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip imen ustvarjalcev',NULL,36,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Anmerkungsarten',NULL,37,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Note types',NULL,37,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Types de notes',NULL,37,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipi di nota',NULL,37,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Soorten aantekeningen',NULL,37,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Tipos de nota',NULL,37,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip opomb',NULL,37,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Aufbewahrungsart',NULL,38,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Repository Types',NULL,38,'en');
INSERT INTO "taxonomy_i18n" VALUES ('tipos de repositorios',NULL,38,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Types de services d''archives',NULL,38,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipi di deposito',NULL,38,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Soorten bewaarplaatsen',NULL,38,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Tipos de entidades custodiadoras',NULL,38,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip skladiš?a',NULL,38,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Ereignistyp',NULL,40,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Event Types','Used to describe the types of Events that Actors and InformationObjects are related to.',40,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Tipo de evento',NULL,40,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Types d''événement',NULL,40,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipi di evento',NULL,40,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Soorten gebeurtenisen',NULL,40,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Tipos de evento',NULL,40,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip dogodka',NULL,40,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Qubit Einstellungskennzeichen',NULL,41,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Qubit Setting Labels','An internal, uneditable taxonomy used to store and translate alternate app setting labels used in different Qubit distributions',41,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Etiquetas de configuración de Qubit',NULL,41,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Étiquettes des paramètres Qubit',NULL,41,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('etichette delle impostazioni di Qubit',NULL,41,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Qubit instellings labels',NULL,41,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Etiquetas de configuração do Qubit',NULL,41,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('Qubit nastavitve label',NULL,41,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Orte',NULL,42,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Places',NULL,42,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Lugares',NULL,42,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Lieux',NULL,42,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('luoghi',NULL,42,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Plaatsen',NULL,42,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Locais',NULL,42,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('kraji',NULL,42,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('ISDF Funktionen',NULL,43,'de');
INSERT INTO "taxonomy_i18n" VALUES ('ISDF Function Types',NULL,43,'en');
INSERT INTO "taxonomy_i18n" VALUES ('ISDF Tipos de Funcion',NULL,43,'es');
INSERT INTO "taxonomy_i18n" VALUES ('ISDF Types de Fonction',NULL,43,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('ISDF Tipi di Funzion',NULL,43,'it');
INSERT INTO "taxonomy_i18n" VALUES ('ISDF Functie Soorten',NULL,43,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('ISDF Tipos de Funções',NULL,43,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('ISDF Tip Funkcija',NULL,43,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Historische Ereignisse',NULL,44,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Historical Events',NULL,44,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Sucesos históricos',NULL,44,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Événements historiques',NULL,44,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('eventi storici',NULL,44,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Historische gebeurtenissen',NULL,44,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Eventos históricos',NULL,44,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('zgodovinski dogodki',NULL,44,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Bestandsart',NULL,45,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Collection Types',NULL,45,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Tipos de colecciones',NULL,45,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Types de collections',NULL,45,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipi di collezione',NULL,45,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Soorten collectie',NULL,45,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Tipos de acervo',NULL,45,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip zbirke',NULL,45,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Medientyp',NULL,46,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Media Types',NULL,46,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Types de supports',NULL,46,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipi di media',NULL,46,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Bestandsformaten',NULL,46,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Tipos de mídia',NULL,46,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip medija',NULL,46,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Repräsentationsformen digitaler Objekte',NULL,47,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Digital Object Usages',NULL,47,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Usos do los objetivos digitales',NULL,47,'es');
INSERT INTO "taxonomy_i18n" VALUES ('Usages d''objets numériques',NULL,47,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('usi dell''oggetto digitale',NULL,47,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Gebruik digitaal object',NULL,47,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Usos do objeto digital',NULL,47,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('raba digitalnega objekta',NULL,47,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Art des Physischen Objekts',NULL,48,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Physical Object Type',NULL,48,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Type d''objet physique',NULL,48,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipo di oggetto fisico',NULL,48,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Soorten fysieke objecten',NULL,48,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Localização física',NULL,48,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip fizi?nega objekta',NULL,48,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Bezugsart',NULL,49,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Relation Type',NULL,49,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Type de relation',NULL,49,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipo di relazione',NULL,49,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Soorten relaties',NULL,49,'nl');
INSERT INTO "taxonomy_i18n" VALUES ('Tipo de relação',NULL,49,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip povezave',NULL,49,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('Materialart',NULL,50,'de');
INSERT INTO "taxonomy_i18n" VALUES ('Material Type',NULL,50,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Types de documents',NULL,50,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipo di materiale',NULL,50,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Tipo de suporte',NULL,50,'pt');
INSERT INTO "taxonomy_i18n" VALUES ('tip materiala',NULL,50,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('RAD Eintrag',NULL,51,'de');
INSERT INTO "taxonomy_i18n" VALUES ('RAD Note','Note types that occur specifically within the Canadian Council of Archives'' ''Rules for Archival Description (RAD)''',51,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Note RDDA',NULL,51,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('nota RAD',NULL,51,'it');
INSERT INTO "taxonomy_i18n" VALUES ('RAD opombe',NULL,51,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('RAD Titeleintrag',NULL,52,'de');
INSERT INTO "taxonomy_i18n" VALUES ('RAD Title Note','Title note types that occur specifically within the Canadian Council of Archives'' ''Rules for Archival Description (RAD)''',52,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Note de titre RDDA',NULL,52,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('nota al titolo RAD',NULL,52,'it');
INSERT INTO "taxonomy_i18n" VALUES ('RAD naslov opombe',NULL,52,'sl');
INSERT INTO "taxonomy_i18n" VALUES ('MODS Resource Type','Fixed values for the typeOfResource element as prescribed by the The Library of Congress'' ''Metadata Object Description Schema (MODS)''',53,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Types de ressources MODS',NULL,53,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipo di risorsa MODS',NULL,53,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Dublin Core Types','Fixed values for the DC Type element as prescribed by the DCMI Type Vocabulary',54,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Types Dublin Core',NULL,54,'fr');
INSERT INTO "taxonomy_i18n" VALUES ('tipi Dublin Core',NULL,54,'it');
INSERT INTO "taxonomy_i18n" VALUES ('Actor Relation Type','Actor-to-Actor relationship categories defined by the ICA ISAAR (CPF) specification, 2nd Edition, Section 5.3.2, ''Category of relationship''.',55,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Relation Note Types',NULL,56,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Term Relation Types',NULL,57,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Status Types',NULL,59,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Publication Status',NULL,60,'en');
INSERT INTO "taxonomy_i18n" VALUES ('Function Relation Type','Function-to-function relationship categories defined by the ICA ISDF specification, 1st Edition, Section 5.3.3, ''Category of relationship''.',61,'en');
CREATE TABLE "term" (
  "id" int(11) NOT NULL,
  "taxonomy_id" int(11) NOT NULL,
  "code" varchar(255) DEFAULT NULL,
  "parent_id" int(11) DEFAULT NULL,
  "lft" int(11) NOT NULL,
  "rgt" int(11) NOT NULL,
  "source_culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id")
  CONSTRAINT "term_FK_1" FOREIGN KEY ("id") REFERENCES "object" ("id") ON DELETE CASCADE,
  CONSTRAINT "term_FK_2" FOREIGN KEY ("taxonomy_id") REFERENCES "taxonomy" ("id") ON DELETE CASCADE,
  CONSTRAINT "term_FK_3" FOREIGN KEY ("parent_id") REFERENCES "term" ("id")
);
INSERT INTO "term" VALUES (110,30,NULL,NULL,1,328,'en');
INSERT INTO "term" VALUES (111,40,NULL,110,2,3,'en');
INSERT INTO "term" VALUES (113,40,NULL,110,4,5,'en');
INSERT INTO "term" VALUES (114,40,NULL,110,6,7,'en');
INSERT INTO "term" VALUES (115,40,NULL,110,8,9,'en');
INSERT INTO "term" VALUES (117,40,NULL,110,10,11,'en');
INSERT INTO "term" VALUES (118,40,NULL,110,12,13,'en');
INSERT INTO "term" VALUES (119,37,NULL,110,14,15,'en');
INSERT INTO "term" VALUES (120,37,NULL,110,16,17,'en');
INSERT INTO "term" VALUES (121,37,NULL,110,18,19,'en');
INSERT INTO "term" VALUES (122,37,NULL,110,20,21,'en');
INSERT INTO "term" VALUES (123,37,NULL,110,22,23,'en');
INSERT INTO "term" VALUES (124,37,NULL,110,78,79,'en');
INSERT INTO "term" VALUES (125,37,NULL,110,82,83,'en');
INSERT INTO "term" VALUES (126,37,NULL,110,80,81,'en');
INSERT INTO "term" VALUES (127,37,NULL,110,110,111,'en');
INSERT INTO "term" VALUES (128,45,NULL,110,24,25,'en');
INSERT INTO "term" VALUES (129,45,NULL,110,26,27,'en');
INSERT INTO "term" VALUES (130,45,NULL,110,28,29,'en');
INSERT INTO "term" VALUES (131,32,NULL,110,30,31,'en');
INSERT INTO "term" VALUES (132,32,NULL,110,32,33,'en');
INSERT INTO "term" VALUES (133,32,NULL,110,34,35,'en');
INSERT INTO "term" VALUES (135,46,NULL,110,36,37,'en');
INSERT INTO "term" VALUES (136,46,NULL,110,38,39,'en');
INSERT INTO "term" VALUES (137,46,NULL,110,40,41,'en');
INSERT INTO "term" VALUES (138,46,NULL,110,42,43,'en');
INSERT INTO "term" VALUES (139,46,NULL,110,44,45,'en');
INSERT INTO "term" VALUES (140,47,NULL,110,48,49,'en');
INSERT INTO "term" VALUES (141,47,NULL,110,50,51,'en');
INSERT INTO "term" VALUES (142,47,NULL,110,52,53,'en');
INSERT INTO "term" VALUES (143,47,NULL,110,54,55,'en');
INSERT INTO "term" VALUES (144,48,NULL,110,56,57,'en');
INSERT INTO "term" VALUES (145,48,NULL,110,58,73,'en');
INSERT INTO "term" VALUES (146,48,NULL,110,74,75,'en');
INSERT INTO "term" VALUES (147,49,NULL,110,76,77,'en');
INSERT INTO "term" VALUES (148,36,NULL,110,84,85,'en');
INSERT INTO "term" VALUES (149,36,NULL,110,86,87,'en');
INSERT INTO "term" VALUES (150,55,NULL,110,88,89,'en');
INSERT INTO "term" VALUES (151,55,NULL,110,90,91,'en');
INSERT INTO "term" VALUES (152,55,NULL,110,92,93,'en');
INSERT INTO "term" VALUES (153,55,NULL,110,94,95,'en');
INSERT INTO "term" VALUES (154,56,NULL,110,96,97,'en');
INSERT INTO "term" VALUES (155,56,NULL,110,98,99,'en');
INSERT INTO "term" VALUES (156,57,NULL,110,100,101,'en');
INSERT INTO "term" VALUES (157,57,NULL,110,102,103,'en');
INSERT INTO "term" VALUES (158,59,NULL,110,104,105,'en');
INSERT INTO "term" VALUES (159,60,NULL,110,106,107,'en');
INSERT INTO "term" VALUES (160,60,NULL,110,108,109,'en');
INSERT INTO "term" VALUES (161,49,NULL,110,112,113,'en');
INSERT INTO "term" VALUES (162,61,NULL,110,114,115,'en');
INSERT INTO "term" VALUES (163,61,NULL,110,116,117,'en');
INSERT INTO "term" VALUES (164,61,NULL,110,118,119,'en');
INSERT INTO "term" VALUES (165,36,NULL,110,120,121,'en');
INSERT INTO "term" VALUES (166,47,NULL,110,46,47,'en');
INSERT INTO "term" VALUES (167,40,NULL,110,122,123,'en');
INSERT INTO "term" VALUES (168,40,NULL,110,124,125,'en');
INSERT INTO "term" VALUES (169,40,NULL,110,126,127,'en');
INSERT INTO "term" VALUES (170,40,NULL,110,128,129,'en');
INSERT INTO "term" VALUES (171,48,NULL,145,59,64,'en');
INSERT INTO "term" VALUES (172,48,NULL,171,60,61,'en');
INSERT INTO "term" VALUES (173,48,NULL,171,62,63,'en');
INSERT INTO "term" VALUES (174,48,NULL,145,65,66,'en');
INSERT INTO "term" VALUES (175,48,NULL,145,67,68,'en');
INSERT INTO "term" VALUES (176,48,NULL,145,69,70,'en');
INSERT INTO "term" VALUES (177,48,NULL,145,71,72,'en');
INSERT INTO "term" VALUES (178,33,NULL,110,130,131,'en');
INSERT INTO "term" VALUES (179,33,NULL,110,132,133,'en');
INSERT INTO "term" VALUES (180,33,NULL,110,134,135,'en');
INSERT INTO "term" VALUES (181,31,NULL,110,136,137,'en');
INSERT INTO "term" VALUES (182,31,NULL,110,138,139,'en');
INSERT INTO "term" VALUES (183,31,NULL,110,140,141,'en');
INSERT INTO "term" VALUES (184,34,NULL,110,142,143,'en');
INSERT INTO "term" VALUES (185,34,NULL,110,144,145,'en');
INSERT INTO "term" VALUES (186,34,NULL,110,146,147,'en');
INSERT INTO "term" VALUES (187,34,NULL,110,148,149,'en');
INSERT INTO "term" VALUES (188,34,NULL,110,150,151,'en');
INSERT INTO "term" VALUES (189,34,NULL,110,152,153,'en');
INSERT INTO "term" VALUES (190,34,NULL,110,154,155,'en');
INSERT INTO "term" VALUES (191,41,NULL,110,156,157,'en');
INSERT INTO "term" VALUES (192,41,NULL,110,158,159,'en');
INSERT INTO "term" VALUES (193,41,NULL,110,160,161,'en');
INSERT INTO "term" VALUES (194,41,NULL,110,162,163,'en');
INSERT INTO "term" VALUES (195,41,NULL,110,164,165,'en');
INSERT INTO "term" VALUES (196,41,NULL,110,166,167,'en');
INSERT INTO "term" VALUES (197,41,NULL,110,168,169,'en');
INSERT INTO "term" VALUES (198,41,NULL,110,170,171,'en');
INSERT INTO "term" VALUES (199,41,NULL,110,172,173,'en');
INSERT INTO "term" VALUES (200,41,NULL,110,174,175,'en');
INSERT INTO "term" VALUES (201,41,NULL,110,176,177,'en');
INSERT INTO "term" VALUES (202,41,NULL,110,178,179,'en');
INSERT INTO "term" VALUES (203,38,NULL,110,180,181,'en');
INSERT INTO "term" VALUES (204,38,NULL,110,182,183,'en');
INSERT INTO "term" VALUES (205,38,NULL,110,184,185,'en');
INSERT INTO "term" VALUES (206,38,NULL,110,186,187,'en');
INSERT INTO "term" VALUES (207,38,NULL,110,188,189,'en');
INSERT INTO "term" VALUES (208,38,NULL,110,190,191,'en');
INSERT INTO "term" VALUES (209,38,NULL,110,192,193,'en');
INSERT INTO "term" VALUES (210,38,NULL,110,194,195,'en');
INSERT INTO "term" VALUES (211,38,NULL,110,196,197,'en');
INSERT INTO "term" VALUES (212,38,NULL,110,198,199,'en');
INSERT INTO "term" VALUES (213,38,NULL,110,200,201,'en');
INSERT INTO "term" VALUES (214,38,NULL,110,202,203,'en');
INSERT INTO "term" VALUES (215,38,NULL,110,204,205,'en');
INSERT INTO "term" VALUES (216,41,NULL,110,206,207,'en');
INSERT INTO "term" VALUES (217,41,NULL,110,208,209,'en');
INSERT INTO "term" VALUES (218,41,NULL,110,210,211,'en');
INSERT INTO "term" VALUES (219,41,NULL,110,212,213,'en');
INSERT INTO "term" VALUES (220,41,NULL,110,214,215,'en');
INSERT INTO "term" VALUES (221,41,NULL,110,216,217,'en');
INSERT INTO "term" VALUES (222,41,NULL,110,218,219,'en');
INSERT INTO "term" VALUES (223,37,NULL,110,220,221,'en');
INSERT INTO "term" VALUES (224,50,NULL,110,222,223,'en');
INSERT INTO "term" VALUES (225,50,NULL,110,224,225,'en');
INSERT INTO "term" VALUES (226,50,NULL,110,226,227,'en');
INSERT INTO "term" VALUES (227,50,NULL,110,228,229,'en');
INSERT INTO "term" VALUES (228,50,NULL,110,230,231,'en');
INSERT INTO "term" VALUES (229,50,NULL,110,232,233,'en');
INSERT INTO "term" VALUES (230,50,NULL,110,234,235,'en');
INSERT INTO "term" VALUES (231,50,NULL,110,236,237,'en');
INSERT INTO "term" VALUES (232,50,NULL,110,238,239,'en');
INSERT INTO "term" VALUES (233,50,NULL,110,240,241,'en');
INSERT INTO "term" VALUES (234,51,NULL,110,242,243,'en');
INSERT INTO "term" VALUES (235,51,NULL,110,244,245,'en');
INSERT INTO "term" VALUES (236,51,NULL,110,246,247,'en');
INSERT INTO "term" VALUES (237,51,NULL,110,248,249,'en');
INSERT INTO "term" VALUES (238,51,NULL,110,250,251,'en');
INSERT INTO "term" VALUES (239,51,NULL,110,252,253,'en');
INSERT INTO "term" VALUES (240,51,NULL,110,254,255,'en');
INSERT INTO "term" VALUES (241,51,NULL,110,256,257,'en');
INSERT INTO "term" VALUES (242,52,NULL,110,258,259,'en');
INSERT INTO "term" VALUES (243,52,NULL,110,260,261,'en');
INSERT INTO "term" VALUES (244,52,NULL,110,262,263,'en');
INSERT INTO "term" VALUES (245,52,NULL,110,264,265,'en');
INSERT INTO "term" VALUES (246,52,NULL,110,266,267,'en');
INSERT INTO "term" VALUES (247,52,NULL,110,268,269,'en');
INSERT INTO "term" VALUES (248,53,NULL,110,270,271,'en');
INSERT INTO "term" VALUES (249,53,NULL,110,272,273,'en');
INSERT INTO "term" VALUES (250,53,NULL,110,274,275,'en');
INSERT INTO "term" VALUES (251,53,NULL,110,276,277,'en');
INSERT INTO "term" VALUES (252,53,NULL,110,278,279,'en');
INSERT INTO "term" VALUES (253,53,NULL,110,280,281,'en');
INSERT INTO "term" VALUES (254,53,NULL,110,282,283,'en');
INSERT INTO "term" VALUES (255,53,NULL,110,284,285,'en');
INSERT INTO "term" VALUES (256,53,NULL,110,286,287,'en');
INSERT INTO "term" VALUES (257,53,NULL,110,288,289,'en');
INSERT INTO "term" VALUES (258,53,NULL,110,290,291,'en');
INSERT INTO "term" VALUES (259,54,NULL,110,292,293,'en');
INSERT INTO "term" VALUES (260,54,NULL,110,294,295,'en');
INSERT INTO "term" VALUES (261,54,NULL,110,296,297,'en');
INSERT INTO "term" VALUES (262,54,NULL,110,298,299,'en');
INSERT INTO "term" VALUES (263,54,NULL,110,300,301,'en');
INSERT INTO "term" VALUES (264,54,NULL,110,302,303,'en');
INSERT INTO "term" VALUES (265,54,NULL,110,304,305,'en');
INSERT INTO "term" VALUES (266,54,NULL,110,306,307,'en');
INSERT INTO "term" VALUES (267,54,NULL,110,308,309,'en');
INSERT INTO "term" VALUES (268,54,NULL,110,310,311,'en');
INSERT INTO "term" VALUES (269,54,NULL,110,312,313,'en');
INSERT INTO "term" VALUES (270,54,NULL,110,314,315,'en');
INSERT INTO "term" VALUES (271,43,NULL,110,316,317,'en');
INSERT INTO "term" VALUES (272,43,NULL,110,318,319,'en');
INSERT INTO "term" VALUES (273,43,NULL,110,320,321,'en');
INSERT INTO "term" VALUES (274,43,NULL,110,322,323,'en');
INSERT INTO "term" VALUES (275,43,NULL,110,324,325,'en');
INSERT INTO "term" VALUES (276,43,NULL,110,326,327,'en');
CREATE TABLE "term_i18n" (
  "name" varchar(255) DEFAULT NULL,
  "id" int(11) NOT NULL,
  "culture" varchar(7) NOT NULL,
  PRIMARY KEY ("id","culture"),
  CONSTRAINT "term_i18n_FK_1" FOREIGN KEY ("id") REFERENCES "term" ("id") ON DELETE CASCADE
);
INSERT INTO "term_i18n" VALUES (NULL,110,'en');
INSERT INTO "term_i18n" VALUES ('Anlage',111,'de');
INSERT INTO "term_i18n" VALUES ('Creation',111,'en');
INSERT INTO "term_i18n" VALUES ('Criação',111,'es');
INSERT INTO "term_i18n" VALUES ('Production',111,'fr');
INSERT INTO "term_i18n" VALUES ('Creazione',111,'it');
INSERT INTO "term_i18n" VALUES ('Vervaardig',111,'nl');
INSERT INTO "term_i18n" VALUES ('Produção',111,'pt');
INSERT INTO "term_i18n" VALUES ('Ustvarjanje',111,'sl');
INSERT INTO "term_i18n" VALUES ('Verwahrung',113,'de');
INSERT INTO "term_i18n" VALUES ('Custody',113,'en');
INSERT INTO "term_i18n" VALUES ('Custódia',113,'es');
INSERT INTO "term_i18n" VALUES ('Conservation',113,'fr');
INSERT INTO "term_i18n" VALUES ('Conservazione',113,'it');
INSERT INTO "term_i18n" VALUES ('Beheer',113,'nl');
INSERT INTO "term_i18n" VALUES ('Custódia',113,'pt');
INSERT INTO "term_i18n" VALUES ('Skrbništvo',113,'sl');
INSERT INTO "term_i18n" VALUES ('Veröffentlichung',114,'de');
INSERT INTO "term_i18n" VALUES ('Publication',114,'en');
INSERT INTO "term_i18n" VALUES ('Publicação',114,'es');
INSERT INTO "term_i18n" VALUES ('Publication',114,'fr');
INSERT INTO "term_i18n" VALUES ('Pubblicazione',114,'it');
INSERT INTO "term_i18n" VALUES ('Publicatie',114,'nl');
INSERT INTO "term_i18n" VALUES ('Publicação',114,'pt');
INSERT INTO "term_i18n" VALUES ('Publikaciranje',114,'sl');
INSERT INTO "term_i18n" VALUES ('Beitrag',115,'de');
INSERT INTO "term_i18n" VALUES ('Contribution',115,'en');
INSERT INTO "term_i18n" VALUES ('Contribuição',115,'es');
INSERT INTO "term_i18n" VALUES ('Contribution',115,'fr');
INSERT INTO "term_i18n" VALUES ('Contributo',115,'it');
INSERT INTO "term_i18n" VALUES ('Bijdrage',115,'nl');
INSERT INTO "term_i18n" VALUES ('Contribuição',115,'pt');
INSERT INTO "term_i18n" VALUES ('Prispevek',115,'sl');
INSERT INTO "term_i18n" VALUES ('Sammlung',117,'de');
INSERT INTO "term_i18n" VALUES ('Collection',117,'en');
INSERT INTO "term_i18n" VALUES ('Colección',117,'es');
INSERT INTO "term_i18n" VALUES ('Collection',117,'fr');
INSERT INTO "term_i18n" VALUES ('Collezione',117,'it');
INSERT INTO "term_i18n" VALUES ('Collectie',117,'nl');
INSERT INTO "term_i18n" VALUES ('Coleção',117,'pt');
INSERT INTO "term_i18n" VALUES ('Zbirka',117,'sl');
INSERT INTO "term_i18n" VALUES ('Bildung',118,'de');
INSERT INTO "term_i18n" VALUES ('Accumulation',118,'en');
INSERT INTO "term_i18n" VALUES ('Accumulation',118,'fr');
INSERT INTO "term_i18n" VALUES ('Accumulazione',118,'it');
INSERT INTO "term_i18n" VALUES ('Acumulação',118,'pt');
INSERT INTO "term_i18n" VALUES ('Zbiranje',118,'sl');
INSERT INTO "term_i18n" VALUES ('Anmerkung zum Titel (?)',119,'de');
INSERT INTO "term_i18n" VALUES ('Title note',119,'en');
INSERT INTO "term_i18n" VALUES ('Note de titre',119,'fr');
INSERT INTO "term_i18n" VALUES ('Nota del titolo',119,'it');
INSERT INTO "term_i18n" VALUES ('Titel aantekening',119,'nl');
INSERT INTO "term_i18n" VALUES ('Nota de título',119,'pt');
INSERT INTO "term_i18n" VALUES ('Opombe naslova',119,'sl');
INSERT INTO "term_i18n" VALUES ('Anmerkung zur Veröffentlichung',120,'de');
INSERT INTO "term_i18n" VALUES ('Publication note',120,'en');
INSERT INTO "term_i18n" VALUES ('Nota de publicación',120,'es');
INSERT INTO "term_i18n" VALUES ('Bibliographie',120,'fr');
INSERT INTO "term_i18n" VALUES ('Nota bibliografica',120,'it');
INSERT INTO "term_i18n" VALUES ('Notitie Publicaties',120,'nl');
INSERT INTO "term_i18n" VALUES ('Nota de publicação',120,'pt');
INSERT INTO "term_i18n" VALUES ('Opombe objav',120,'sl');
INSERT INTO "term_i18n" VALUES ('Anmerkung zur Quelle',121,'de');
INSERT INTO "term_i18n" VALUES ('Source note',121,'en');
INSERT INTO "term_i18n" VALUES ('Nota de fuente',121,'es');
INSERT INTO "term_i18n" VALUES ('Sources',121,'fr');
INSERT INTO "term_i18n" VALUES ('Nota sulla fonte',121,'it');
INSERT INTO "term_i18n" VALUES ('Notitie bron',121,'nl');
INSERT INTO "term_i18n" VALUES ('Nota de fonte',121,'pt');
INSERT INTO "term_i18n" VALUES ('Opombe virov',121,'sl');
INSERT INTO "term_i18n" VALUES ('Anmerkung  zum Umfang',122,'de');
INSERT INTO "term_i18n" VALUES ('Scope note',122,'en');
INSERT INTO "term_i18n" VALUES ('Nota de alcance',122,'es');
INSERT INTO "term_i18n" VALUES ('Note d''application',122,'fr');
INSERT INTO "term_i18n" VALUES ('Nota di ambito',122,'it');
INSERT INTO "term_i18n" VALUES ('Notitie toepassingsgebied',122,'nl');
INSERT INTO "term_i18n" VALUES ('Nota de âmbito',122,'pt');
INSERT INTO "term_i18n" VALUES ('Opombe namena',122,'sl');
INSERT INTO "term_i18n" VALUES ('Anmerkung zur Ansicht',123,'de');
INSERT INTO "term_i18n" VALUES ('Display note',123,'en');
INSERT INTO "term_i18n" VALUES ('Note d''affichage',123,'fr');
INSERT INTO "term_i18n" VALUES ('Nota sulla valutazione',123,'it');
INSERT INTO "term_i18n" VALUES ('Exibir nota',123,'pt');
INSERT INTO "term_i18n" VALUES ('Prikazana opomba',123,'sl');
INSERT INTO "term_i18n" VALUES ('Anmerkung des Archivars/der Archivarin',124,'de');
INSERT INTO "term_i18n" VALUES ('Archivist''s note',124,'en');
INSERT INTO "term_i18n" VALUES ('Note de l''archiviste',124,'fr');
INSERT INTO "term_i18n" VALUES ('Nota dell''archivista',124,'it');
INSERT INTO "term_i18n" VALUES ('Verantwoording',124,'nl');
INSERT INTO "term_i18n" VALUES ('Nota do arquivista',124,'pt');
INSERT INTO "term_i18n" VALUES ('Opombe arhivista',124,'sl');
INSERT INTO "term_i18n" VALUES ('Allgemeine Anmerkung',125,'de');
INSERT INTO "term_i18n" VALUES ('General note',125,'en');
INSERT INTO "term_i18n" VALUES ('Note générale',125,'fr');
INSERT INTO "term_i18n" VALUES ('Nota generale',125,'it');
INSERT INTO "term_i18n" VALUES ('Algemene aantekening',125,'nl');
INSERT INTO "term_i18n" VALUES ('Nota geral',125,'pt');
INSERT INTO "term_i18n" VALUES ('Splošne opombe',125,'sl');
INSERT INTO "term_i18n" VALUES ('Other Descriptive Data',126,'en');
INSERT INTO "term_i18n" VALUES ('Autres données descriptives',126,'fr');
INSERT INTO "term_i18n" VALUES ('Altre informazioni descrittive',126,'it');
INSERT INTO "term_i18n" VALUES ('Anmerkung zur Instandhaltung(?)',127,'de');
INSERT INTO "term_i18n" VALUES ('Maintenance note',127,'en');
INSERT INTO "term_i18n" VALUES ('Notes relatives à la mise à jour de la description',127,'fr');
INSERT INTO "term_i18n" VALUES ('Nota sulla manutenzione',127,'it');
INSERT INTO "term_i18n" VALUES ('Onderhoudsaantekening',127,'nl');
INSERT INTO "term_i18n" VALUES ('Nota de manutenção',127,'pt');
INSERT INTO "term_i18n" VALUES ('Opombe obdelave',127,'sl');
INSERT INTO "term_i18n" VALUES ('Archivgut',128,'de');
INSERT INTO "term_i18n" VALUES ('Archival material',128,'en');
INSERT INTO "term_i18n" VALUES ('Documents d''archives',128,'fr');
INSERT INTO "term_i18n" VALUES ('Materiale archivistico',128,'it');
INSERT INTO "term_i18n" VALUES ('Archivistisch materaal',128,'nl');
INSERT INTO "term_i18n" VALUES ('Acervo arquivístico',128,'pt');
INSERT INTO "term_i18n" VALUES ('Arhivsko gradivo',128,'sl');
INSERT INTO "term_i18n" VALUES ('Veröffentlichung',129,'de');
INSERT INTO "term_i18n" VALUES ('Published material',129,'en');
INSERT INTO "term_i18n" VALUES ('Documents publiés',129,'fr');
INSERT INTO "term_i18n" VALUES ('Materiale edito',129,'it');
INSERT INTO "term_i18n" VALUES ('Gepubliseerd materiaal',129,'nl');
INSERT INTO "term_i18n" VALUES ('Publicações',129,'pt');
INSERT INTO "term_i18n" VALUES ('Objavljeno gradivo',129,'sl');
INSERT INTO "term_i18n" VALUES ('Artefakt',130,'de');
INSERT INTO "term_i18n" VALUES ('Artefact material',130,'en');
INSERT INTO "term_i18n" VALUES ('Artefact',130,'fr');
INSERT INTO "term_i18n" VALUES ('Manufatto',130,'it');
INSERT INTO "term_i18n" VALUES ('Artefact materiaal',130,'nl');
INSERT INTO "term_i18n" VALUES ('Material tridimensional',130,'pt');
INSERT INTO "term_i18n" VALUES ('Artifakti',130,'sl');
INSERT INTO "term_i18n" VALUES ('Organisation',131,'de');
INSERT INTO "term_i18n" VALUES ('Corporate body',131,'en');
INSERT INTO "term_i18n" VALUES ('Entidade coletiva',131,'es');
INSERT INTO "term_i18n" VALUES ('Collectivité',131,'fr');
INSERT INTO "term_i18n" VALUES ('Ente',131,'it');
INSERT INTO "term_i18n" VALUES ('Instelling',131,'nl');
INSERT INTO "term_i18n" VALUES ('Entidade coletiva',131,'pt');
INSERT INTO "term_i18n" VALUES ('Korporacija',131,'sl');
INSERT INTO "term_i18n" VALUES ('Person',132,'de');
INSERT INTO "term_i18n" VALUES ('Person',132,'en');
INSERT INTO "term_i18n" VALUES ('Persona',132,'es');
INSERT INTO "term_i18n" VALUES ('Personne',132,'fr');
INSERT INTO "term_i18n" VALUES ('Persona',132,'it');
INSERT INTO "term_i18n" VALUES ('Persoon',132,'nl');
INSERT INTO "term_i18n" VALUES ('Pessoa',132,'pt');
INSERT INTO "term_i18n" VALUES ('Oseba',132,'sl');
INSERT INTO "term_i18n" VALUES ('Familie',133,'de');
INSERT INTO "term_i18n" VALUES ('Family',133,'en');
INSERT INTO "term_i18n" VALUES ('Família',133,'es');
INSERT INTO "term_i18n" VALUES ('Famille',133,'fr');
INSERT INTO "term_i18n" VALUES ('Famiglia',133,'it');
INSERT INTO "term_i18n" VALUES ('Familie',133,'nl');
INSERT INTO "term_i18n" VALUES ('Família',133,'pt');
INSERT INTO "term_i18n" VALUES ('Družina',133,'sl');
INSERT INTO "term_i18n" VALUES ('Audio/Ton-',135,'de');
INSERT INTO "term_i18n" VALUES ('Audio',135,'en');
INSERT INTO "term_i18n" VALUES ('Audio',135,'es');
INSERT INTO "term_i18n" VALUES ('Audio',135,'fr');
INSERT INTO "term_i18n" VALUES ('Audio',135,'it');
INSERT INTO "term_i18n" VALUES ('Audio',135,'nl');
INSERT INTO "term_i18n" VALUES ('Áudio',135,'pt');
INSERT INTO "term_i18n" VALUES ('Avdio',135,'sl');
INSERT INTO "term_i18n" VALUES ('Bild',136,'de');
INSERT INTO "term_i18n" VALUES ('Image',136,'en');
INSERT INTO "term_i18n" VALUES ('Image',136,'fr');
INSERT INTO "term_i18n" VALUES ('Immagine',136,'it');
INSERT INTO "term_i18n" VALUES ('Afbeelding',136,'nl');
INSERT INTO "term_i18n" VALUES ('Imagem',136,'pt');
INSERT INTO "term_i18n" VALUES ('Slike',136,'sl');
INSERT INTO "term_i18n" VALUES ('Text',137,'de');
INSERT INTO "term_i18n" VALUES ('Text',137,'en');
INSERT INTO "term_i18n" VALUES ('Texte',137,'fr');
INSERT INTO "term_i18n" VALUES ('Testo',137,'it');
INSERT INTO "term_i18n" VALUES ('Tekst',137,'nl');
INSERT INTO "term_i18n" VALUES ('Texto',137,'pt');
INSERT INTO "term_i18n" VALUES ('Besedilo',137,'sl');
INSERT INTO "term_i18n" VALUES ('Video',138,'de');
INSERT INTO "term_i18n" VALUES ('Video',138,'en');
INSERT INTO "term_i18n" VALUES ('Vidéo',138,'fr');
INSERT INTO "term_i18n" VALUES ('Video',138,'it');
INSERT INTO "term_i18n" VALUES ('Video',138,'nl');
INSERT INTO "term_i18n" VALUES ('Vídeo',138,'pt');
INSERT INTO "term_i18n" VALUES ('Video',138,'sl');
INSERT INTO "term_i18n" VALUES ('Anderes',139,'de');
INSERT INTO "term_i18n" VALUES ('Other',139,'en');
INSERT INTO "term_i18n" VALUES ('Autre',139,'fr');
INSERT INTO "term_i18n" VALUES ('Altro',139,'it');
INSERT INTO "term_i18n" VALUES ('Anders',139,'nl');
INSERT INTO "term_i18n" VALUES ('Outro',139,'pt');
INSERT INTO "term_i18n" VALUES ('Drugo',139,'sl');
INSERT INTO "term_i18n" VALUES ('Original',140,'de');
INSERT INTO "term_i18n" VALUES ('Master',140,'en');
INSERT INTO "term_i18n" VALUES ('Fichier maître',140,'fr');
INSERT INTO "term_i18n" VALUES ('Master',140,'it');
INSERT INTO "term_i18n" VALUES ('Master',140,'nl');
INSERT INTO "term_i18n" VALUES ('Master',140,'pt');
INSERT INTO "term_i18n" VALUES ('Izvorni',140,'sl');
INSERT INTO "term_i18n" VALUES ('Verweis',141,'de');
INSERT INTO "term_i18n" VALUES ('Reference',141,'en');
INSERT INTO "term_i18n" VALUES ('Référence',141,'fr');
INSERT INTO "term_i18n" VALUES ('Riferimento',141,'it');
INSERT INTO "term_i18n" VALUES ('Referentie',141,'nl');
INSERT INTO "term_i18n" VALUES ('Referência',141,'pt');
INSERT INTO "term_i18n" VALUES ('Referenca',141,'sl');
INSERT INTO "term_i18n" VALUES ('Thumbnail',142,'de');
INSERT INTO "term_i18n" VALUES ('Thumbnail',142,'en');
INSERT INTO "term_i18n" VALUES ('Vignette',142,'fr');
INSERT INTO "term_i18n" VALUES ('Anteprima',142,'it');
INSERT INTO "term_i18n" VALUES ('Thumbnail',142,'nl');
INSERT INTO "term_i18n" VALUES ('Visualização',142,'pt');
INSERT INTO "term_i18n" VALUES ('Ikona',142,'sl');
INSERT INTO "term_i18n" VALUES ('Compound',143,'en');
INSERT INTO "term_i18n" VALUES ('Ort',144,'de');
INSERT INTO "term_i18n" VALUES ('Location',144,'en');
INSERT INTO "term_i18n" VALUES ('Lieu',144,'fr');
INSERT INTO "term_i18n" VALUES ('Ubicazione',144,'it');
INSERT INTO "term_i18n" VALUES ('Lokatie',144,'nl');
INSERT INTO "term_i18n" VALUES ('Localização',144,'pt');
INSERT INTO "term_i18n" VALUES ('Lokacija',144,'sl');
INSERT INTO "term_i18n" VALUES ('Behältnis',145,'de');
INSERT INTO "term_i18n" VALUES ('Container',145,'en');
INSERT INTO "term_i18n" VALUES ('Contenedor',145,'es');
INSERT INTO "term_i18n" VALUES ('Contenant',145,'fr');
INSERT INTO "term_i18n" VALUES ('Contenitore',145,'it');
INSERT INTO "term_i18n" VALUES ('Verpakking',145,'nl');
INSERT INTO "term_i18n" VALUES ('Unidade de instalação física',145,'pt');
INSERT INTO "term_i18n" VALUES ('Vsebnik',145,'sl');
INSERT INTO "term_i18n" VALUES ('Gegenstand',146,'de');
INSERT INTO "term_i18n" VALUES ('Artefact',146,'en');
INSERT INTO "term_i18n" VALUES ('Artefact',146,'fr');
INSERT INTO "term_i18n" VALUES ('Manufatto',146,'it');
INSERT INTO "term_i18n" VALUES ('Artefact',146,'nl');
INSERT INTO "term_i18n" VALUES ('Objeto tridimensional',146,'pt');
INSERT INTO "term_i18n" VALUES ('Artefakt',146,'sl');
INSERT INTO "term_i18n" VALUES ('besitzt physisches Objekt (?)',147,'de');
INSERT INTO "term_i18n" VALUES ('has Physical Object',147,'en');
INSERT INTO "term_i18n" VALUES ('contient un objet physique',147,'fr');
INSERT INTO "term_i18n" VALUES ('contiene un oggetto fisico',147,'it');
INSERT INTO "term_i18n" VALUES ('heeft fysiek object',147,'nl');
INSERT INTO "term_i18n" VALUES ('possui objeto tridimensional',147,'pt');
INSERT INTO "term_i18n" VALUES ('ima fizi?ni objek',147,'sl');
INSERT INTO "term_i18n" VALUES ('Parallelansetzung',148,'de');
INSERT INTO "term_i18n" VALUES ('Parallel form',148,'en');
INSERT INTO "term_i18n" VALUES ('Forma paralela',148,'es');
INSERT INTO "term_i18n" VALUES ('Forme parallèle',148,'fr');
INSERT INTO "term_i18n" VALUES ('Forma parallela',148,'it');
INSERT INTO "term_i18n" VALUES ('Parallelle naam',148,'nl');
INSERT INTO "term_i18n" VALUES ('Forma paralela',148,'pt');
INSERT INTO "term_i18n" VALUES ('Vzporedna oblika',148,'sl');
INSERT INTO "term_i18n" VALUES ('Weiterer Name',149,'de');
INSERT INTO "term_i18n" VALUES ('Other form',149,'en');
INSERT INTO "term_i18n" VALUES ('Outra forma',149,'es');
INSERT INTO "term_i18n" VALUES ('Autre nom',149,'fr');
INSERT INTO "term_i18n" VALUES ('Altro nome',149,'it');
INSERT INTO "term_i18n" VALUES ('Andere naam',149,'nl');
INSERT INTO "term_i18n" VALUES ('Outra forma',149,'pt');
INSERT INTO "term_i18n" VALUES ('Drugo ime',149,'sl');
INSERT INTO "term_i18n" VALUES ('hierarchical',150,'en');
INSERT INTO "term_i18n" VALUES ('gerarchica',150,'it');
INSERT INTO "term_i18n" VALUES ('temporal',151,'en');
INSERT INTO "term_i18n" VALUES ('temporale',151,'it');
INSERT INTO "term_i18n" VALUES ('Familie',152,'de');
INSERT INTO "term_i18n" VALUES ('family',152,'en');
INSERT INTO "term_i18n" VALUES ('Família',152,'es');
INSERT INTO "term_i18n" VALUES ('Famille',152,'fr');
INSERT INTO "term_i18n" VALUES ('Famiglia',152,'it');
INSERT INTO "term_i18n" VALUES ('Familie',152,'nl');
INSERT INTO "term_i18n" VALUES ('Família',152,'pt');
INSERT INTO "term_i18n" VALUES ('Družina',152,'sl');
INSERT INTO "term_i18n" VALUES ('associative',153,'en');
INSERT INTO "term_i18n" VALUES ('associativa',153,'it');
INSERT INTO "term_i18n" VALUES ('description',154,'en');
INSERT INTO "term_i18n" VALUES ('descrizione',154,'it');
INSERT INTO "term_i18n" VALUES ('date display',155,'en');
INSERT INTO "term_i18n" VALUES ('data visualizzata',155,'it');
INSERT INTO "term_i18n" VALUES ('alternative label',156,'en');
INSERT INTO "term_i18n" VALUES ('associative',157,'en');
INSERT INTO "term_i18n" VALUES ('associativa',157,'it');
INSERT INTO "term_i18n" VALUES ('Veröffentlichung',158,'de');
INSERT INTO "term_i18n" VALUES ('publication',158,'en');
INSERT INTO "term_i18n" VALUES ('Publicação',158,'es');
INSERT INTO "term_i18n" VALUES ('Publication',158,'fr');
INSERT INTO "term_i18n" VALUES ('Pubblicazione',158,'it');
INSERT INTO "term_i18n" VALUES ('Publicatie',158,'nl');
INSERT INTO "term_i18n" VALUES ('Publicação',158,'pt');
INSERT INTO "term_i18n" VALUES ('Publikaciranje',158,'sl');
INSERT INTO "term_i18n" VALUES ('Entwurf',159,'de');
INSERT INTO "term_i18n" VALUES ('draft',159,'en');
INSERT INTO "term_i18n" VALUES ('Minuta',159,'es');
INSERT INTO "term_i18n" VALUES ('Ébauche',159,'fr');
INSERT INTO "term_i18n" VALUES ('Bozza',159,'it');
INSERT INTO "term_i18n" VALUES ('Klad',159,'nl');
INSERT INTO "term_i18n" VALUES ('Preliminar',159,'pt');
INSERT INTO "term_i18n" VALUES ('Osnutek',159,'sl');
INSERT INTO "term_i18n" VALUES ('published',160,'en');
INSERT INTO "term_i18n" VALUES ('pubblicato',160,'it');
INSERT INTO "term_i18n" VALUES ('Zugriffspunkt (Name)',161,'de');
INSERT INTO "term_i18n" VALUES ('name access points',161,'en');
INSERT INTO "term_i18n" VALUES ('nombre de los puntos de acceso',161,'es');
INSERT INTO "term_i18n" VALUES ('?????? ?? ???? ???',161,'fa');
INSERT INTO "term_i18n" VALUES ('points d''accès noms',161,'fr');
INSERT INTO "term_i18n" VALUES ('punti di accesso per nome',161,'it');
INSERT INTO "term_i18n" VALUES ('naam ontsluitingsterm',161,'nl');
INSERT INTO "term_i18n" VALUES ('ponto de acesso - nome',161,'pt');
INSERT INTO "term_i18n" VALUES ('ime vhodne to?ke',161,'sl');
INSERT INTO "term_i18n" VALUES ('hierarchical',162,'en');
INSERT INTO "term_i18n" VALUES ('gerarchica',162,'it');
INSERT INTO "term_i18n" VALUES ('temporal',163,'en');
INSERT INTO "term_i18n" VALUES ('temporale',163,'it');
INSERT INTO "term_i18n" VALUES ('associative',164,'en');
INSERT INTO "term_i18n" VALUES ('associativa',164,'it');
INSERT INTO "term_i18n" VALUES ('Standardansetzung',165,'de');
INSERT INTO "term_i18n" VALUES ('Standardized form',165,'en');
INSERT INTO "term_i18n" VALUES ('Forma normalizada',165,'es');
INSERT INTO "term_i18n" VALUES ('Forme normalisée',165,'fr');
INSERT INTO "term_i18n" VALUES ('Forma standardizzata',165,'it');
INSERT INTO "term_i18n" VALUES ('Geautoriseerde naam',165,'nl');
INSERT INTO "term_i18n" VALUES ('Forma normalizada',165,'pt');
INSERT INTO "term_i18n" VALUES ('Standardizirana oblika',165,'sl');
INSERT INTO "term_i18n" VALUES ('External URI',166,'en');
INSERT INTO "term_i18n" VALUES ('URI externo',166,'es');
INSERT INTO "term_i18n" VALUES ('Reproduction',167,'en');
INSERT INTO "term_i18n" VALUES ('Reproduction',167,'fr');
INSERT INTO "term_i18n" VALUES ('Riproduzione',167,'it');
INSERT INTO "term_i18n" VALUES ('Verbreitung',168,'de');
INSERT INTO "term_i18n" VALUES ('Distribution',168,'en');
INSERT INTO "term_i18n" VALUES ('Distribution',168,'fr');
INSERT INTO "term_i18n" VALUES ('Distribuzione',168,'it');
INSERT INTO "term_i18n" VALUES ('Distribuição',168,'pt');
INSERT INTO "term_i18n" VALUES ('Distribuiranje',168,'sl');
INSERT INTO "term_i18n" VALUES ('Sendung',169,'de');
INSERT INTO "term_i18n" VALUES ('Broadcasting',169,'en');
INSERT INTO "term_i18n" VALUES ('Diffusion',169,'fr');
INSERT INTO "term_i18n" VALUES ('Trasmissione',169,'it');
INSERT INTO "term_i18n" VALUES ('Radiodifusão',169,'pt');
INSERT INTO "term_i18n" VALUES ('Oddajanje (radio)',169,'sl');
INSERT INTO "term_i18n" VALUES ('Herstellung',170,'de');
INSERT INTO "term_i18n" VALUES ('Manufacturing',170,'en');
INSERT INTO "term_i18n" VALUES ('Fabrication',170,'fr');
INSERT INTO "term_i18n" VALUES ('Fabbricazione',170,'it');
INSERT INTO "term_i18n" VALUES ('Fabricação',170,'pt');
INSERT INTO "term_i18n" VALUES ('Proizvoden',170,'sl');
INSERT INTO "term_i18n" VALUES ('Schachtel',171,'de');
INSERT INTO "term_i18n" VALUES ('Box',171,'en');
INSERT INTO "term_i18n" VALUES ('Boîte',171,'fr');
INSERT INTO "term_i18n" VALUES ('Scatola',171,'it');
INSERT INTO "term_i18n" VALUES ('Doos',171,'nl');
INSERT INTO "term_i18n" VALUES ('Caixa',171,'pt');
INSERT INTO "term_i18n" VALUES ('Škatla',171,'sl');
INSERT INTO "term_i18n" VALUES ('Pappkarton',172,'de');
INSERT INTO "term_i18n" VALUES ('Cardboard box',172,'en');
INSERT INTO "term_i18n" VALUES ('Boîte en carton',172,'fr');
INSERT INTO "term_i18n" VALUES ('Scatola di cartone',172,'it');
INSERT INTO "term_i18n" VALUES ('Kaartenbak',172,'nl');
INSERT INTO "term_i18n" VALUES ('Caixa de papelão',172,'pt');
INSERT INTO "term_i18n" VALUES ('Škatla tip 1',172,'sl');
INSERT INTO "term_i18n" VALUES ('Hollinger box?',173,'de');
INSERT INTO "term_i18n" VALUES ('Hollinger box',173,'en');
INSERT INTO "term_i18n" VALUES ('Boîte Hollinger',173,'fr');
INSERT INTO "term_i18n" VALUES ('Scatola Hollinger',173,'it');
INSERT INTO "term_i18n" VALUES ('Ponskaartendoos',173,'nl');
INSERT INTO "term_i18n" VALUES ('Caixa Hollinger',173,'pt');
INSERT INTO "term_i18n" VALUES ('Škatla tip 2',173,'sl');
INSERT INTO "term_i18n" VALUES ('Umschlag/Mappe',174,'de');
INSERT INTO "term_i18n" VALUES ('Folder',174,'en');
INSERT INTO "term_i18n" VALUES ('Chemise',174,'fr');
INSERT INTO "term_i18n" VALUES ('Busta',174,'it');
INSERT INTO "term_i18n" VALUES ('Map',174,'nl');
INSERT INTO "term_i18n" VALUES ('Pasta',174,'pt');
INSERT INTO "term_i18n" VALUES ('Mapa',174,'sl');
INSERT INTO "term_i18n" VALUES ('Aktenschrank',175,'de');
INSERT INTO "term_i18n" VALUES ('Filing cabinet',175,'en');
INSERT INTO "term_i18n" VALUES ('Archivador',175,'es');
INSERT INTO "term_i18n" VALUES ('Classeur',175,'fr');
INSERT INTO "term_i18n" VALUES ('Classificatore',175,'it');
INSERT INTO "term_i18n" VALUES ('Dossierkast',175,'nl');
INSERT INTO "term_i18n" VALUES ('Armário',175,'pt');
INSERT INTO "term_i18n" VALUES ('Polica 1',175,'sl');
INSERT INTO "term_i18n" VALUES ('Planschrank',176,'de');
INSERT INTO "term_i18n" VALUES ('Map cabinet',176,'en');
INSERT INTO "term_i18n" VALUES ('Classeur pour cartes',176,'fr');
INSERT INTO "term_i18n" VALUES ('Armadio per mappe',176,'it');
INSERT INTO "term_i18n" VALUES ('Kaartenkast',176,'nl');
INSERT INTO "term_i18n" VALUES ('Mapoteca',176,'pt');
INSERT INTO "term_i18n" VALUES ('Polica 2',176,'sl');
INSERT INTO "term_i18n" VALUES ('Fach',177,'de');
INSERT INTO "term_i18n" VALUES ('Shelf',177,'en');
INSERT INTO "term_i18n" VALUES ('Anaquel',177,'es');
INSERT INTO "term_i18n" VALUES ('Tablette',177,'fr');
INSERT INTO "term_i18n" VALUES ('Scaffale',177,'it');
INSERT INTO "term_i18n" VALUES ('Plank',177,'nl');
INSERT INTO "term_i18n" VALUES ('Prateleira',177,'pt');
INSERT INTO "term_i18n" VALUES ('Poli?nica',177,'sl');
INSERT INTO "term_i18n" VALUES ('Final',178,'de');
INSERT INTO "term_i18n" VALUES ('Final',178,'en');
INSERT INTO "term_i18n" VALUES ('Final',178,'es');
INSERT INTO "term_i18n" VALUES ('Final',178,'fr');
INSERT INTO "term_i18n" VALUES ('Finale',178,'it');
INSERT INTO "term_i18n" VALUES ('Finale',178,'nl');
INSERT INTO "term_i18n" VALUES ('Final',178,'pt');
INSERT INTO "term_i18n" VALUES ('Zaklju?en',178,'sl');
INSERT INTO "term_i18n" VALUES ('Überarbeitet',179,'de');
INSERT INTO "term_i18n" VALUES ('Revised',179,'en');
INSERT INTO "term_i18n" VALUES ('Revisado',179,'es');
INSERT INTO "term_i18n" VALUES ('Révisé',179,'fr');
INSERT INTO "term_i18n" VALUES ('Rivista',179,'it');
INSERT INTO "term_i18n" VALUES ('Gereviseerd',179,'nl');
INSERT INTO "term_i18n" VALUES ('Revisado',179,'pt');
INSERT INTO "term_i18n" VALUES ('Ponovno pregledan',179,'sl');
INSERT INTO "term_i18n" VALUES ('Entwurf',180,'de');
INSERT INTO "term_i18n" VALUES ('Draft',180,'en');
INSERT INTO "term_i18n" VALUES ('Minuta',180,'es');
INSERT INTO "term_i18n" VALUES ('Ébauche',180,'fr');
INSERT INTO "term_i18n" VALUES ('Bozza',180,'it');
INSERT INTO "term_i18n" VALUES ('Klad',180,'nl');
INSERT INTO "term_i18n" VALUES ('Preliminar',180,'pt');
INSERT INTO "term_i18n" VALUES ('Osnutek',180,'sl');
INSERT INTO "term_i18n" VALUES ('Vollständig',181,'de');
INSERT INTO "term_i18n" VALUES ('Full',181,'en');
INSERT INTO "term_i18n" VALUES ('Completo',181,'es');
INSERT INTO "term_i18n" VALUES ('Complet',181,'fr');
INSERT INTO "term_i18n" VALUES ('Completa',181,'it');
INSERT INTO "term_i18n" VALUES ('Geheel',181,'nl');
INSERT INTO "term_i18n" VALUES ('Integral',181,'pt');
INSERT INTO "term_i18n" VALUES ('Popoln',181,'sl');
INSERT INTO "term_i18n" VALUES ('Teilweise',182,'de');
INSERT INTO "term_i18n" VALUES ('Partial',182,'en');
INSERT INTO "term_i18n" VALUES ('Parcial',182,'es');
INSERT INTO "term_i18n" VALUES ('Moyen',182,'fr');
INSERT INTO "term_i18n" VALUES ('Parziale',182,'it');
INSERT INTO "term_i18n" VALUES ('Gedeeltelijk',182,'nl');
INSERT INTO "term_i18n" VALUES ('Parcial',182,'pt');
INSERT INTO "term_i18n" VALUES ('Delni',182,'sl');
INSERT INTO "term_i18n" VALUES ('Minimal',183,'de');
INSERT INTO "term_i18n" VALUES ('Minimal',183,'en');
INSERT INTO "term_i18n" VALUES ('Mínimo',183,'es');
INSERT INTO "term_i18n" VALUES ('Élémentaire',183,'fr');
INSERT INTO "term_i18n" VALUES ('Minima',183,'it');
INSERT INTO "term_i18n" VALUES ('Minimaal',183,'nl');
INSERT INTO "term_i18n" VALUES ('Mínimo',183,'pt');
INSERT INTO "term_i18n" VALUES ('Minimalni',183,'sl');
INSERT INTO "term_i18n" VALUES ('Bestand',184,'de');
INSERT INTO "term_i18n" VALUES ('Fonds',184,'en');
INSERT INTO "term_i18n" VALUES ('Fondo',184,'es');
INSERT INTO "term_i18n" VALUES ('Fonds',184,'fr');
INSERT INTO "term_i18n" VALUES ('Fondo',184,'it');
INSERT INTO "term_i18n" VALUES ('Archief',184,'nl');
INSERT INTO "term_i18n" VALUES ('Fundo',184,'pt');
INSERT INTO "term_i18n" VALUES ('Fond/zbirka',184,'sl');
INSERT INTO "term_i18n" VALUES ('Teilbestand',185,'de');
INSERT INTO "term_i18n" VALUES ('Subfonds',185,'en');
INSERT INTO "term_i18n" VALUES ('Sub-fondo',185,'es');
INSERT INTO "term_i18n" VALUES ('Sous-fonds',185,'fr');
INSERT INTO "term_i18n" VALUES ('Sub-fondo',185,'it');
INSERT INTO "term_i18n" VALUES ('Deelarchief',185,'nl');
INSERT INTO "term_i18n" VALUES ('Seção/Subfundo',185,'pt');
INSERT INTO "term_i18n" VALUES ('Podfond',185,'sl');
INSERT INTO "term_i18n" VALUES ('Sammlung',186,'de');
INSERT INTO "term_i18n" VALUES ('Collection',186,'en');
INSERT INTO "term_i18n" VALUES ('Colección',186,'es');
INSERT INTO "term_i18n" VALUES ('Collection',186,'fr');
INSERT INTO "term_i18n" VALUES ('Collezione',186,'it');
INSERT INTO "term_i18n" VALUES ('Collectie',186,'nl');
INSERT INTO "term_i18n" VALUES ('Coleção',186,'pt');
INSERT INTO "term_i18n" VALUES ('Zbirka',186,'sl');
INSERT INTO "term_i18n" VALUES ('Serie',187,'de');
INSERT INTO "term_i18n" VALUES ('Series',187,'en');
INSERT INTO "term_i18n" VALUES ('Séries',187,'es');
INSERT INTO "term_i18n" VALUES ('Série organique',187,'fr');
INSERT INTO "term_i18n" VALUES ('Serie',187,'it');
INSERT INTO "term_i18n" VALUES ('Reeks',187,'nl');
INSERT INTO "term_i18n" VALUES ('Série',187,'pt');
INSERT INTO "term_i18n" VALUES ('Serija',187,'sl');
INSERT INTO "term_i18n" VALUES ('Teilserie',188,'de');
INSERT INTO "term_i18n" VALUES ('Subseries',188,'en');
INSERT INTO "term_i18n" VALUES ('Sub-séries',188,'es');
INSERT INTO "term_i18n" VALUES ('Sous-série organique',188,'fr');
INSERT INTO "term_i18n" VALUES ('Sottoserie',188,'it');
INSERT INTO "term_i18n" VALUES ('Deelreeks',188,'nl');
INSERT INTO "term_i18n" VALUES ('Subsérie',188,'pt');
INSERT INTO "term_i18n" VALUES ('Pod-serija',188,'sl');
INSERT INTO "term_i18n" VALUES ('Akt',189,'de');
INSERT INTO "term_i18n" VALUES ('File',189,'en');
INSERT INTO "term_i18n" VALUES ('Dossiê',189,'es');
INSERT INTO "term_i18n" VALUES ('Dossier',189,'fr');
INSERT INTO "term_i18n" VALUES ('Unità archivistica',189,'it');
INSERT INTO "term_i18n" VALUES ('Bestanddeel',189,'nl');
INSERT INTO "term_i18n" VALUES ('Dossiê/Processo',189,'pt');
INSERT INTO "term_i18n" VALUES ('Zadeva/dosje',189,'sl');
INSERT INTO "term_i18n" VALUES ('Einzelstück',190,'de');
INSERT INTO "term_i18n" VALUES ('Item',190,'en');
INSERT INTO "term_i18n" VALUES ('Item',190,'es');
INSERT INTO "term_i18n" VALUES ('Pièce',190,'fr');
INSERT INTO "term_i18n" VALUES ('Unità documentaria',190,'it');
INSERT INTO "term_i18n" VALUES ('Stuk',190,'nl');
INSERT INTO "term_i18n" VALUES ('Item',190,'pt');
INSERT INTO "term_i18n" VALUES ('Kos',190,'sl');
INSERT INTO "term_i18n" VALUES ('Information zum Objekt',191,'de');
INSERT INTO "term_i18n" VALUES ('Information object',191,'en');
INSERT INTO "term_i18n" VALUES ('Documents d''archives',191,'fr');
INSERT INTO "term_i18n" VALUES ('Oggetto informativo',191,'it');
INSERT INTO "term_i18n" VALUES ('Information object',191,'nl');
INSERT INTO "term_i18n" VALUES ('Objeto informacional',191,'pt');
INSERT INTO "term_i18n" VALUES ('Informacijski objekt',191,'sl');
INSERT INTO "term_i18n" VALUES ('Person/Einrichtung',192,'de');
INSERT INTO "term_i18n" VALUES ('Person/organization',192,'en');
INSERT INTO "term_i18n" VALUES ('Personne/organisme',192,'fr');
INSERT INTO "term_i18n" VALUES ('Persona/organizzazione',192,'it');
INSERT INTO "term_i18n" VALUES ('Persoon/organisatie',192,'nl');
INSERT INTO "term_i18n" VALUES ('Pessoa/organização',192,'pt');
INSERT INTO "term_i18n" VALUES ('Oseba/organizacija',192,'sl');
INSERT INTO "term_i18n" VALUES ('Bestandsbildner',193,'de');
INSERT INTO "term_i18n" VALUES ('Creator',193,'en');
INSERT INTO "term_i18n" VALUES ('Producteur d''archives',193,'fr');
INSERT INTO "term_i18n" VALUES ('Soggetto produttore',193,'it');
INSERT INTO "term_i18n" VALUES ('Archiefvormer',193,'nl');
INSERT INTO "term_i18n" VALUES ('Produtor',193,'pt');
INSERT INTO "term_i18n" VALUES ('Ustvarjalec',193,'sl');
INSERT INTO "term_i18n" VALUES ('Verwahrungsort',194,'de');
INSERT INTO "term_i18n" VALUES ('Repository',194,'en');
INSERT INTO "term_i18n" VALUES ('Institution de conservation',194,'fr');
INSERT INTO "term_i18n" VALUES ('Soggetto conservatore',194,'it');
INSERT INTO "term_i18n" VALUES ('Depot',194,'nl');
INSERT INTO "term_i18n" VALUES ('Entidade custodiadora',194,'pt');
INSERT INTO "term_i18n" VALUES ('Skladiš?e',194,'sl');
INSERT INTO "term_i18n" VALUES ('Begriff',195,'de');
INSERT INTO "term_i18n" VALUES ('Term',195,'en');
INSERT INTO "term_i18n" VALUES ('Descripteur',195,'fr');
INSERT INTO "term_i18n" VALUES ('Termine',195,'it');
INSERT INTO "term_i18n" VALUES ('Term',195,'nl');
INSERT INTO "term_i18n" VALUES ('Termo',195,'pt');
INSERT INTO "term_i18n" VALUES ('Izraz',195,'sl');
INSERT INTO "term_i18n" VALUES ('Gegenstand',196,'de');
INSERT INTO "term_i18n" VALUES ('Subject',196,'en');
INSERT INTO "term_i18n" VALUES ('Sujet',196,'fr');
INSERT INTO "term_i18n" VALUES ('Soggetto',196,'it');
INSERT INTO "term_i18n" VALUES ('Onderwerp',196,'nl');
INSERT INTO "term_i18n" VALUES ('Assunto',196,'pt');
INSERT INTO "term_i18n" VALUES ('Oseba',196,'sl');
INSERT INTO "term_i18n" VALUES ('Sammlung',197,'de');
INSERT INTO "term_i18n" VALUES ('Collection',197,'en');
INSERT INTO "term_i18n" VALUES ('Colección',197,'es');
INSERT INTO "term_i18n" VALUES ('Collection',197,'fr');
INSERT INTO "term_i18n" VALUES ('Collezione',197,'it');
INSERT INTO "term_i18n" VALUES ('Collectie',197,'nl');
INSERT INTO "term_i18n" VALUES ('Coleção',197,'pt');
INSERT INTO "term_i18n" VALUES ('Zbirka',197,'sl');
INSERT INTO "term_i18n" VALUES ('Bestände',198,'de');
INSERT INTO "term_i18n" VALUES ('Holdings',198,'en');
INSERT INTO "term_i18n" VALUES ('Collections',198,'fr');
INSERT INTO "term_i18n" VALUES ('Patrimoni',198,'it');
INSERT INTO "term_i18n" VALUES ('Collecties',198,'nl');
INSERT INTO "term_i18n" VALUES ('Acervo',198,'pt');
INSERT INTO "term_i18n" VALUES ('Fondi',198,'sl');
INSERT INTO "term_i18n" VALUES ('Archivische Beschreibung',199,'de');
INSERT INTO "term_i18n" VALUES ('Archival description',199,'en');
INSERT INTO "term_i18n" VALUES ('Description archivistique',199,'fr');
INSERT INTO "term_i18n" VALUES ('Descrizione archivistica',199,'it');
INSERT INTO "term_i18n" VALUES ('Archivistische beschrijving',199,'nl');
INSERT INTO "term_i18n" VALUES ('Descrição arquivística',199,'pt');
INSERT INTO "term_i18n" VALUES ('Arhivski opis',199,'sl');
INSERT INTO "term_i18n" VALUES ('Authority record',200,'en');
INSERT INTO "term_i18n" VALUES ('Fichier d''autorité',200,'fr');
INSERT INTO "term_i18n" VALUES ('Geautoriseerd bestand',200,'nl');
INSERT INTO "term_i18n" VALUES ('Registro de autoridade',200,'pt');
INSERT INTO "term_i18n" VALUES ('Bestand',201,'de');
INSERT INTO "term_i18n" VALUES ('Fonds',201,'en');
INSERT INTO "term_i18n" VALUES ('Fondo',201,'es');
INSERT INTO "term_i18n" VALUES ('Fonds',201,'fr');
INSERT INTO "term_i18n" VALUES ('Fondo',201,'it');
INSERT INTO "term_i18n" VALUES ('Archief',201,'nl');
INSERT INTO "term_i18n" VALUES ('Fundo',201,'pt');
INSERT INTO "term_i18n" VALUES ('Fond/zbirka',201,'sl');
INSERT INTO "term_i18n" VALUES ('Archiv',202,'de');
INSERT INTO "term_i18n" VALUES ('Archival institution',202,'en');
INSERT INTO "term_i18n" VALUES ('Institution archivistique',202,'fr');
INSERT INTO "term_i18n" VALUES ('Istituzione archivistica',202,'it');
INSERT INTO "term_i18n" VALUES ('Archiefinstelling',202,'nl');
INSERT INTO "term_i18n" VALUES ('Instituição arquivística',202,'pt');
INSERT INTO "term_i18n" VALUES ('Arhivska ustanova',202,'sl');
INSERT INTO "term_i18n" VALUES ('International',203,'de');
INSERT INTO "term_i18n" VALUES ('International',203,'en');
INSERT INTO "term_i18n" VALUES ('Internacional',203,'es');
INSERT INTO "term_i18n" VALUES ('International',203,'fr');
INSERT INTO "term_i18n" VALUES ('Internazionale',203,'it');
INSERT INTO "term_i18n" VALUES ('Internationaal',203,'nl');
INSERT INTO "term_i18n" VALUES ('Internacional',203,'pt');
INSERT INTO "term_i18n" VALUES ('Mednarodni',203,'sl');
INSERT INTO "term_i18n" VALUES ('National',204,'de');
INSERT INTO "term_i18n" VALUES ('National',204,'en');
INSERT INTO "term_i18n" VALUES ('Nacional',204,'es');
INSERT INTO "term_i18n" VALUES ('National',204,'fr');
INSERT INTO "term_i18n" VALUES ('Nazionale',204,'it');
INSERT INTO "term_i18n" VALUES ('Nationaal',204,'nl');
INSERT INTO "term_i18n" VALUES ('Nacional',204,'pt');
INSERT INTO "term_i18n" VALUES ('Nacionalni',204,'sl');
INSERT INTO "term_i18n" VALUES ('Regional',205,'de');
INSERT INTO "term_i18n" VALUES ('Regional',205,'en');
INSERT INTO "term_i18n" VALUES ('Regional',205,'es');
INSERT INTO "term_i18n" VALUES ('Régional',205,'fr');
INSERT INTO "term_i18n" VALUES ('Regionale',205,'it');
INSERT INTO "term_i18n" VALUES ('Regionaal',205,'nl');
INSERT INTO "term_i18n" VALUES ('Regional',205,'pt');
INSERT INTO "term_i18n" VALUES ('Regionalni',205,'sl');
INSERT INTO "term_i18n" VALUES ('Bundesland/Kanton',206,'de');
INSERT INTO "term_i18n" VALUES ('Provincial/state',206,'en');
INSERT INTO "term_i18n" VALUES ('Provincial/estadual',206,'es');
INSERT INTO "term_i18n" VALUES ('Provincial/d''État',206,'fr');
INSERT INTO "term_i18n" VALUES ('Provinaciale/statale',206,'it');
INSERT INTO "term_i18n" VALUES ('Provinciaal',206,'nl');
INSERT INTO "term_i18n" VALUES ('Provincial/estadual',206,'pt');
INSERT INTO "term_i18n" VALUES ('Regionalni/državni',206,'sl');
INSERT INTO "term_i18n" VALUES ('Gemeinschaft',207,'de');
INSERT INTO "term_i18n" VALUES ('Community',207,'en');
INSERT INTO "term_i18n" VALUES ('Comunitário',207,'es');
INSERT INTO "term_i18n" VALUES ('Communautaire',207,'fr');
INSERT INTO "term_i18n" VALUES ('Comunitario',207,'it');
INSERT INTO "term_i18n" VALUES ('Gemeenschap',207,'nl');
INSERT INTO "term_i18n" VALUES ('Municipal',207,'pt');
INSERT INTO "term_i18n" VALUES ('Ob?inski',207,'sl');
INSERT INTO "term_i18n" VALUES ('Religion',208,'de');
INSERT INTO "term_i18n" VALUES ('Religious',208,'en');
INSERT INTO "term_i18n" VALUES ('Religioso',208,'es');
INSERT INTO "term_i18n" VALUES ('Religieux',208,'fr');
INSERT INTO "term_i18n" VALUES ('Religioso',208,'it');
INSERT INTO "term_i18n" VALUES ('Religie',208,'nl');
INSERT INTO "term_i18n" VALUES ('Religioso',208,'pt');
INSERT INTO "term_i18n" VALUES ('Verskih skupnosti',208,'sl');
INSERT INTO "term_i18n" VALUES ('Universität',209,'de');
INSERT INTO "term_i18n" VALUES ('University',209,'en');
INSERT INTO "term_i18n" VALUES ('Universitário',209,'es');
INSERT INTO "term_i18n" VALUES ('Universitaire',209,'fr');
INSERT INTO "term_i18n" VALUES ('Universitario',209,'it');
INSERT INTO "term_i18n" VALUES ('Universiteit',209,'nl');
INSERT INTO "term_i18n" VALUES ('Universitário',209,'pt');
INSERT INTO "term_i18n" VALUES ('Univerzitetni',209,'sl');
INSERT INTO "term_i18n" VALUES ('Gemeinde',210,'de');
INSERT INTO "term_i18n" VALUES ('Municipal',210,'en');
INSERT INTO "term_i18n" VALUES ('Municipal',210,'es');
INSERT INTO "term_i18n" VALUES ('Municipal',210,'fr');
INSERT INTO "term_i18n" VALUES ('Municipale',210,'it');
INSERT INTO "term_i18n" VALUES ('Gemeente',210,'nl');
INSERT INTO "term_i18n" VALUES ('Municipal',210,'pt');
INSERT INTO "term_i18n" VALUES ('Mestni',210,'sl');
INSERT INTO "term_i18n" VALUES ('Indigen (?)',211,'de');
INSERT INTO "term_i18n" VALUES ('Aboriginal',211,'en');
INSERT INTO "term_i18n" VALUES ('Autochtone',211,'fr');
INSERT INTO "term_i18n" VALUES ('Aborigeno',211,'it');
INSERT INTO "term_i18n" VALUES ('Indígena',211,'pt');
INSERT INTO "term_i18n" VALUES ('Prvobiten',211,'sl');
INSERT INTO "term_i18n" VALUES ('Erziehung',212,'de');
INSERT INTO "term_i18n" VALUES ('Educational',212,'en');
INSERT INTO "term_i18n" VALUES ('Educativo',212,'es');
INSERT INTO "term_i18n" VALUES ('Scolaire',212,'fr');
INSERT INTO "term_i18n" VALUES ('Educativo',212,'it');
INSERT INTO "term_i18n" VALUES ('Escolar',212,'pt');
INSERT INTO "term_i18n" VALUES ('Izbobraževalen',212,'sl');
INSERT INTO "term_i18n" VALUES ('medizinisch',213,'de');
INSERT INTO "term_i18n" VALUES ('Medical',213,'en');
INSERT INTO "term_i18n" VALUES ('Médico',213,'es');
INSERT INTO "term_i18n" VALUES ('Médical',213,'fr');
INSERT INTO "term_i18n" VALUES ('Medico',213,'it');
INSERT INTO "term_i18n" VALUES ('Medisch',213,'nl');
INSERT INTO "term_i18n" VALUES ('Médico',213,'pt');
INSERT INTO "term_i18n" VALUES ('Medecinski',213,'sl');
INSERT INTO "term_i18n" VALUES ('Militär',214,'de');
INSERT INTO "term_i18n" VALUES ('Military',214,'en');
INSERT INTO "term_i18n" VALUES ('Militar',214,'es');
INSERT INTO "term_i18n" VALUES ('Militaire',214,'fr');
INSERT INTO "term_i18n" VALUES ('Militare',214,'it');
INSERT INTO "term_i18n" VALUES ('Militair',214,'nl');
INSERT INTO "term_i18n" VALUES ('Militar',214,'pt');
INSERT INTO "term_i18n" VALUES ('Vojaški',214,'sl');
INSERT INTO "term_i18n" VALUES ('Privat',215,'de');
INSERT INTO "term_i18n" VALUES ('Private',215,'en');
INSERT INTO "term_i18n" VALUES ('Privé',215,'fr');
INSERT INTO "term_i18n" VALUES ('Privato',215,'it');
INSERT INTO "term_i18n" VALUES ('Privaat',215,'nl');
INSERT INTO "term_i18n" VALUES ('Privado',215,'pt');
INSERT INTO "term_i18n" VALUES ('Zasebni',215,'sl');
INSERT INTO "term_i18n" VALUES ('Ort',216,'de');
INSERT INTO "term_i18n" VALUES ('Place',216,'en');
INSERT INTO "term_i18n" VALUES ('Lieu',216,'fr');
INSERT INTO "term_i18n" VALUES ('Luogo',216,'it');
INSERT INTO "term_i18n" VALUES ('Plaats',216,'nl');
INSERT INTO "term_i18n" VALUES ('Local',216,'pt');
INSERT INTO "term_i18n" VALUES ('Kraj',216,'sl');
INSERT INTO "term_i18n" VALUES ('Name',217,'de');
INSERT INTO "term_i18n" VALUES ('Name',217,'en');
INSERT INTO "term_i18n" VALUES ('Nom',217,'fr');
INSERT INTO "term_i18n" VALUES ('Nome',217,'it');
INSERT INTO "term_i18n" VALUES ('Naam',217,'nl');
INSERT INTO "term_i18n" VALUES ('Nome',217,'pt');
INSERT INTO "term_i18n" VALUES ('Naziv',217,'sl');
INSERT INTO "term_i18n" VALUES ('Digitales Objekt',218,'de');
INSERT INTO "term_i18n" VALUES ('Digital object',218,'en');
INSERT INTO "term_i18n" VALUES ('Objet numérique',218,'fr');
INSERT INTO "term_i18n" VALUES ('Oggetto digitale',218,'it');
INSERT INTO "term_i18n" VALUES ('Digitaal object',218,'nl');
INSERT INTO "term_i18n" VALUES ('Objeto digital',218,'pt');
INSERT INTO "term_i18n" VALUES ('Digitalni objekt',218,'sl');
INSERT INTO "term_i18n" VALUES ('physisches Objekt',219,'de');
INSERT INTO "term_i18n" VALUES ('Physical object',219,'en');
INSERT INTO "term_i18n" VALUES ('Objet physique',219,'fr');
INSERT INTO "term_i18n" VALUES ('Oggetto fisico',219,'it');
INSERT INTO "term_i18n" VALUES ('fysiek object',219,'nl');
INSERT INTO "term_i18n" VALUES ('Objeto tridimensional',219,'pt');
INSERT INTO "term_i18n" VALUES ('Fizi?ni objekt',219,'sl');
INSERT INTO "term_i18n" VALUES ('Aufbewahrung',220,'de');
INSERT INTO "term_i18n" VALUES ('Physical storage',220,'en');
INSERT INTO "term_i18n" VALUES ('Conservation matérielle',220,'fr');
INSERT INTO "term_i18n" VALUES ('Deposito fisico',220,'it');
INSERT INTO "term_i18n" VALUES ('Fysieke opslag',220,'nl');
INSERT INTO "term_i18n" VALUES ('Depósito',220,'pt');
INSERT INTO "term_i18n" VALUES ('Fizi?no skladiš?e',220,'sl');
INSERT INTO "term_i18n" VALUES ('Medientyp',221,'de');
INSERT INTO "term_i18n" VALUES ('Media type',221,'en');
INSERT INTO "term_i18n" VALUES ('Type de support',221,'fr');
INSERT INTO "term_i18n" VALUES ('Tipo di media',221,'it');
INSERT INTO "term_i18n" VALUES ('Bestandsformaat',221,'nl');
INSERT INTO "term_i18n" VALUES ('Tipo de suporte',221,'pt');
INSERT INTO "term_i18n" VALUES ('Medij',221,'sl');
INSERT INTO "term_i18n" VALUES ('Werkzeug für das Open Information Management',222,'de');
INSERT INTO "term_i18n" VALUES ('Open Information Management Toolkit',222,'en');
INSERT INTO "term_i18n" VALUES ('Outil ouvert de gestion de l''information',222,'fr');
INSERT INTO "term_i18n" VALUES ('Strumento aperto di gestione delle informazioni Qubit',222,'it');
INSERT INTO "term_i18n" VALUES ('Open Information Management Toolkit',222,'nl');
INSERT INTO "term_i18n" VALUES ('Odprto informacijsko orodje za upravljanje',222,'sl');
INSERT INTO "term_i18n" VALUES ('Anmerkung zur Aufbewahrung',223,'de');
INSERT INTO "term_i18n" VALUES ('Conservation note',223,'en');
INSERT INTO "term_i18n" VALUES ('Note de conservation',223,'fr');
INSERT INTO "term_i18n" VALUES ('Nota sulla conservazione',223,'it');
INSERT INTO "term_i18n" VALUES ('Nota de conservação',223,'pt');
INSERT INTO "term_i18n" VALUES ('Opombe konservacije',223,'sl');
INSERT INTO "term_i18n" VALUES ('Architekturzeichnung',224,'de');
INSERT INTO "term_i18n" VALUES ('Architectural drawing',224,'en');
INSERT INTO "term_i18n" VALUES ('Dessin d''architecture',224,'fr');
INSERT INTO "term_i18n" VALUES ('Disegni architettonici',224,'it');
INSERT INTO "term_i18n" VALUES ('Desenho arquitetônico',224,'pt');
INSERT INTO "term_i18n" VALUES ('Arhitekturni na?rt',224,'sl');
INSERT INTO "term_i18n" VALUES ('Kartografisches Material',225,'de');
INSERT INTO "term_i18n" VALUES ('Cartographic material',225,'en');
INSERT INTO "term_i18n" VALUES ('Document cartographique',225,'fr');
INSERT INTO "term_i18n" VALUES ('Materiale cartografico',225,'it');
INSERT INTO "term_i18n" VALUES ('Material cartográfico',225,'pt');
INSERT INTO "term_i18n" VALUES ('Kartografsko gradivo',225,'sl');
INSERT INTO "term_i18n" VALUES ('Grafik(en)',226,'de');
INSERT INTO "term_i18n" VALUES ('Graphic material',226,'en');
INSERT INTO "term_i18n" VALUES ('Document graphique',226,'fr');
INSERT INTO "term_i18n" VALUES ('Materiale grafico',226,'it');
INSERT INTO "term_i18n" VALUES ('Material gráfico',226,'pt');
INSERT INTO "term_i18n" VALUES ('Grafi?ni material',226,'sl');
INSERT INTO "term_i18n" VALUES ('Bewegte Bilder (?)',227,'de');
INSERT INTO "term_i18n" VALUES ('Moving images',227,'en');
INSERT INTO "term_i18n" VALUES ('Images animées',227,'fr');
INSERT INTO "term_i18n" VALUES ('Immagini in movimento',227,'it');
INSERT INTO "term_i18n" VALUES ('Imagens em movimento',227,'pt');
INSERT INTO "term_i18n" VALUES ('Gibljive slike',227,'sl');
INSERT INTO "term_i18n" VALUES ('Multimedia',228,'de');
INSERT INTO "term_i18n" VALUES ('Multiple media',228,'en');
INSERT INTO "term_i18n" VALUES ('Multimédia',228,'fr');
INSERT INTO "term_i18n" VALUES ('Media molteplici',228,'it');
INSERT INTO "term_i18n" VALUES ('Mútiplos suportes',228,'pt');
INSERT INTO "term_i18n" VALUES ('Mnogovrstni medij',228,'sl');
INSERT INTO "term_i18n" VALUES ('Objekt',229,'de');
INSERT INTO "term_i18n" VALUES ('Object',229,'en');
INSERT INTO "term_i18n" VALUES ('Objet',229,'fr');
INSERT INTO "term_i18n" VALUES ('Oggetto',229,'it');
INSERT INTO "term_i18n" VALUES ('Objeto tridimensional',229,'pt');
INSERT INTO "term_i18n" VALUES ('Objekt',229,'sl');
INSERT INTO "term_i18n" VALUES ('Philatelistisches Objekt (Briefmarke?)',230,'de');
INSERT INTO "term_i18n" VALUES ('Philatelic record',230,'en');
INSERT INTO "term_i18n" VALUES ('Document philatélique',230,'fr');
INSERT INTO "term_i18n" VALUES ('Documentazione filiatelica',230,'it');
INSERT INTO "term_i18n" VALUES ('Documento filatélico',230,'pt');
INSERT INTO "term_i18n" VALUES ('Filatelisti?en zapis',230,'sl');
INSERT INTO "term_i18n" VALUES ('Tonaufnahme',231,'de');
INSERT INTO "term_i18n" VALUES ('Sound recording',231,'en');
INSERT INTO "term_i18n" VALUES ('Enregistrement sonore',231,'fr');
INSERT INTO "term_i18n" VALUES ('Registrazione sonora',231,'it');
INSERT INTO "term_i18n" VALUES ('Documento sonoro',231,'pt');
INSERT INTO "term_i18n" VALUES ('Zvo?ni zapis',231,'sl');
INSERT INTO "term_i18n" VALUES ('Technische Zeichnung',232,'de');
INSERT INTO "term_i18n" VALUES ('Technical drawing',232,'en');
INSERT INTO "term_i18n" VALUES ('Dessin technique',232,'fr');
INSERT INTO "term_i18n" VALUES ('Disegno tecnico',232,'it');
INSERT INTO "term_i18n" VALUES ('Desenho técnico',232,'pt');
INSERT INTO "term_i18n" VALUES ('Tehni?ni na?rt',232,'sl');
INSERT INTO "term_i18n" VALUES ('Text',233,'de');
INSERT INTO "term_i18n" VALUES ('Textual record',233,'en');
INSERT INTO "term_i18n" VALUES ('Document textuel',233,'fr');
INSERT INTO "term_i18n" VALUES ('Documentazione testuale',233,'it');
INSERT INTO "term_i18n" VALUES ('Documento textual',233,'pt');
INSERT INTO "term_i18n" VALUES ('Besedilni zapis',233,'sl');
INSERT INTO "term_i18n" VALUES ('Ausgabe',234,'de');
INSERT INTO "term_i18n" VALUES ('Edition',234,'en');
INSERT INTO "term_i18n" VALUES ('Edition',234,'fr');
INSERT INTO "term_i18n" VALUES ('Izdaja',234,'sl');
INSERT INTO "term_i18n" VALUES ('Physische Beschreibung',235,'de');
INSERT INTO "term_i18n" VALUES ('Physical description',235,'en');
INSERT INTO "term_i18n" VALUES ('Description physique',235,'fr');
INSERT INTO "term_i18n" VALUES ('Fizi?ni opis',235,'sl');
INSERT INTO "term_i18n" VALUES ('Erhaltung',236,'de');
INSERT INTO "term_i18n" VALUES ('Conservation',236,'en');
INSERT INTO "term_i18n" VALUES ('Conservation',236,'fr');
INSERT INTO "term_i18n" VALUES ('Konzervacija',236,'sl');
INSERT INTO "term_i18n" VALUES ('Begleitmaterial',237,'de');
INSERT INTO "term_i18n" VALUES ('Accompanying material',237,'en');
INSERT INTO "term_i18n" VALUES ('Document d''accompagnement',237,'fr');
INSERT INTO "term_i18n" VALUES ('Povezani material',237,'sl');
INSERT INTO "term_i18n" VALUES ('Herausgeberreihen(?)Reihenwerk(?)',238,'de');
INSERT INTO "term_i18n" VALUES ('Publisher''s series',238,'en');
INSERT INTO "term_i18n" VALUES ('Collection',238,'fr');
INSERT INTO "term_i18n" VALUES ('Izdajateljeve serije',238,'sl');
INSERT INTO "term_i18n" VALUES ('Alphanumerische Bezeichnungen',239,'de');
INSERT INTO "term_i18n" VALUES ('Alpha-numeric designations',239,'en');
INSERT INTO "term_i18n" VALUES ('Désignations alpha-numériques',239,'fr');
INSERT INTO "term_i18n" VALUES ('Alfanumeri?na oznaka',239,'sl');
INSERT INTO "term_i18n" VALUES ('Rechte',240,'de');
INSERT INTO "term_i18n" VALUES ('Rights',240,'en');
INSERT INTO "term_i18n" VALUES ('Droits',240,'fr');
INSERT INTO "term_i18n" VALUES ('Pravice',240,'sl');
INSERT INTO "term_i18n" VALUES ('Allgemeine Anmerkung',241,'de');
INSERT INTO "term_i18n" VALUES ('General note',241,'en');
INSERT INTO "term_i18n" VALUES ('Note générale',241,'fr');
INSERT INTO "term_i18n" VALUES ('Nota generale',241,'it');
INSERT INTO "term_i18n" VALUES ('Algemene aantekening',241,'nl');
INSERT INTO "term_i18n" VALUES ('Nota geral',241,'pt');
INSERT INTO "term_i18n" VALUES ('Splošne opombe',241,'sl');
INSERT INTO "term_i18n" VALUES ('Titelvarianten',242,'de');
INSERT INTO "term_i18n" VALUES ('Variations in title',242,'en');
INSERT INTO "term_i18n" VALUES ('Variations de titre',242,'fr');
INSERT INTO "term_i18n" VALUES ('Variacije naslova',242,'sl');
INSERT INTO "term_i18n" VALUES ('Quelle des genauen Titels',243,'de');
INSERT INTO "term_i18n" VALUES ('Source of title proper',243,'en');
INSERT INTO "term_i18n" VALUES ('Source du titre propre',243,'fr');
INSERT INTO "term_i18n" VALUES ('Vir pravilnega naslova',243,'sl');
INSERT INTO "term_i18n" VALUES ('Parallele Titel und andere Informationen zum Titel',244,'de');
INSERT INTO "term_i18n" VALUES ('Parallel titles and other title information',244,'en');
INSERT INTO "term_i18n" VALUES ('Informations sur les titres parallèles et autre titre',244,'fr');
INSERT INTO "term_i18n" VALUES ('Vzporedni naslov in druge informacije o naslovu',244,'sl');
INSERT INTO "term_i18n" VALUES ('Fortsetzung des Titels',245,'de');
INSERT INTO "term_i18n" VALUES ('Continuation of title',245,'en');
INSERT INTO "term_i18n" VALUES ('Complément de titre',245,'fr');
INSERT INTO "term_i18n" VALUES ('Kontinuiteta naslova',245,'sl');
INSERT INTO "term_i18n" VALUES ('Anmerkung zur Verantwortlichkeit',246,'de');
INSERT INTO "term_i18n" VALUES ('Statements of responsibility',246,'en');
INSERT INTO "term_i18n" VALUES ('Mentions de responsabilité',246,'fr');
INSERT INTO "term_i18n" VALUES ('Navedba odgovornosti',246,'sl');
INSERT INTO "term_i18n" VALUES ('Zuordnungen und Vermutungen',247,'de');
INSERT INTO "term_i18n" VALUES ('Attributions and conjectures',247,'en');
INSERT INTO "term_i18n" VALUES ('Attributions et conjectures',247,'fr');
INSERT INTO "term_i18n" VALUES ('Pripisovanja in domneve',247,'sl');
INSERT INTO "term_i18n" VALUES ('Text',248,'de');
INSERT INTO "term_i18n" VALUES ('text',248,'en');
INSERT INTO "term_i18n" VALUES ('Texte',248,'fr');
INSERT INTO "term_i18n" VALUES ('testo',248,'it');
INSERT INTO "term_i18n" VALUES ('Tekst',248,'nl');
INSERT INTO "term_i18n" VALUES ('Texto',248,'pt');
INSERT INTO "term_i18n" VALUES ('Besedilo',248,'sl');
INSERT INTO "term_i18n" VALUES ('cartographic',249,'en');
INSERT INTO "term_i18n" VALUES ('documents cartographiques',249,'fr');
INSERT INTO "term_i18n" VALUES ('cartografia',249,'it');
INSERT INTO "term_i18n" VALUES ('notated music',250,'en');
INSERT INTO "term_i18n" VALUES ('partitions musicales',250,'fr');
INSERT INTO "term_i18n" VALUES ('notazione musicale',250,'it');
INSERT INTO "term_i18n" VALUES ('Tonaufnahme',251,'de');
INSERT INTO "term_i18n" VALUES ('sound recording',251,'en');
INSERT INTO "term_i18n" VALUES ('Enregistrement sonore',251,'fr');
INSERT INTO "term_i18n" VALUES ('registrazione sonora',251,'it');
INSERT INTO "term_i18n" VALUES ('Documento sonoro',251,'pt');
INSERT INTO "term_i18n" VALUES ('Zvo?ni zapis',251,'sl');
INSERT INTO "term_i18n" VALUES ('sound recording - musical',252,'en');
INSERT INTO "term_i18n" VALUES ('enregistrements sonores - musicaux',252,'fr');
INSERT INTO "term_i18n" VALUES ('registrazione sonora - musicale',252,'it');
INSERT INTO "term_i18n" VALUES ('sound recording - nonmusical',253,'en');
INSERT INTO "term_i18n" VALUES ('enregistrements sonores - non musicaux',253,'fr');
INSERT INTO "term_i18n" VALUES ('registrazione sonora - non musicale',253,'it');
INSERT INTO "term_i18n" VALUES ('still image',254,'en');
INSERT INTO "term_i18n" VALUES ('images fixes',254,'fr');
INSERT INTO "term_i18n" VALUES ('immagine statica',254,'it');
INSERT INTO "term_i18n" VALUES ('moving image',255,'en');
INSERT INTO "term_i18n" VALUES ('images animées',255,'fr');
INSERT INTO "term_i18n" VALUES ('immagine immovimento',255,'it');
INSERT INTO "term_i18n" VALUES ('three dimensional object',256,'en');
INSERT INTO "term_i18n" VALUES ('objets tridimensionnels',256,'fr');
INSERT INTO "term_i18n" VALUES ('oggetto tridimensionale',256,'it');
INSERT INTO "term_i18n" VALUES ('software, multimedia',257,'en');
INSERT INTO "term_i18n" VALUES ('logiciels, multimedia',257,'fr');
INSERT INTO "term_i18n" VALUES ('software, multimedia',257,'it');
INSERT INTO "term_i18n" VALUES ('mixed material',258,'en');
INSERT INTO "term_i18n" VALUES ('documentation mixte',258,'fr');
INSERT INTO "term_i18n" VALUES ('materiale misto',258,'it');
INSERT INTO "term_i18n" VALUES ('Sammlung',259,'de');
INSERT INTO "term_i18n" VALUES ('collection',259,'en');
INSERT INTO "term_i18n" VALUES ('Colección',259,'es');
INSERT INTO "term_i18n" VALUES ('collection',259,'fr');
INSERT INTO "term_i18n" VALUES ('collezione',259,'it');
INSERT INTO "term_i18n" VALUES ('Collectie',259,'nl');
INSERT INTO "term_i18n" VALUES ('Coleção',259,'pt');
INSERT INTO "term_i18n" VALUES ('Zbirka',259,'sl');
INSERT INTO "term_i18n" VALUES ('dataset',260,'en');
INSERT INTO "term_i18n" VALUES ('ensemble de données',260,'fr');
INSERT INTO "term_i18n" VALUES ('dataset',260,'it');
INSERT INTO "term_i18n" VALUES ('event',261,'en');
INSERT INTO "term_i18n" VALUES ('événement',261,'fr');
INSERT INTO "term_i18n" VALUES ('evento',261,'it');
INSERT INTO "term_i18n" VALUES ('Bild',262,'de');
INSERT INTO "term_i18n" VALUES ('image',262,'en');
INSERT INTO "term_i18n" VALUES ('image',262,'fr');
INSERT INTO "term_i18n" VALUES ('immagine',262,'it');
INSERT INTO "term_i18n" VALUES ('Afbeelding',262,'nl');
INSERT INTO "term_i18n" VALUES ('Imagem',262,'pt');
INSERT INTO "term_i18n" VALUES ('Slike',262,'sl');
INSERT INTO "term_i18n" VALUES ('interactive resource',263,'en');
INSERT INTO "term_i18n" VALUES ('ressource interactive',263,'fr');
INSERT INTO "term_i18n" VALUES ('risorsa interattiva',263,'it');
INSERT INTO "term_i18n" VALUES ('moving image',264,'en');
INSERT INTO "term_i18n" VALUES ('images animées',264,'fr');
INSERT INTO "term_i18n" VALUES ('immagine immovimento',264,'it');
INSERT INTO "term_i18n" VALUES ('physisches Objekt',265,'de');
INSERT INTO "term_i18n" VALUES ('physical object',265,'en');
INSERT INTO "term_i18n" VALUES ('objet physique',265,'fr');
INSERT INTO "term_i18n" VALUES ('oggetto fisico',265,'it');
INSERT INTO "term_i18n" VALUES ('fysiek object',265,'nl');
INSERT INTO "term_i18n" VALUES ('Objeto tridimensional',265,'pt');
INSERT INTO "term_i18n" VALUES ('Fizi?ni objekt',265,'sl');
INSERT INTO "term_i18n" VALUES ('service',266,'en');
INSERT INTO "term_i18n" VALUES ('service',266,'fr');
INSERT INTO "term_i18n" VALUES ('sevizio',266,'it');
INSERT INTO "term_i18n" VALUES ('software',267,'en');
INSERT INTO "term_i18n" VALUES ('logiciel',267,'fr');
INSERT INTO "term_i18n" VALUES ('software',267,'it');
INSERT INTO "term_i18n" VALUES ('sound',268,'en');
INSERT INTO "term_i18n" VALUES ('enregistrement sonore',268,'fr');
INSERT INTO "term_i18n" VALUES ('suono',268,'it');
INSERT INTO "term_i18n" VALUES ('still image',269,'en');
INSERT INTO "term_i18n" VALUES ('images fixes',269,'fr');
INSERT INTO "term_i18n" VALUES ('immagine statica',269,'it');
INSERT INTO "term_i18n" VALUES ('Text',270,'de');
INSERT INTO "term_i18n" VALUES ('text',270,'en');
INSERT INTO "term_i18n" VALUES ('Texte',270,'fr');
INSERT INTO "term_i18n" VALUES ('testo',270,'it');
INSERT INTO "term_i18n" VALUES ('Tekst',270,'nl');
INSERT INTO "term_i18n" VALUES ('Texto',270,'pt');
INSERT INTO "term_i18n" VALUES ('Besedilo',270,'sl');
INSERT INTO "term_i18n" VALUES ('Funktion',271,'de');
INSERT INTO "term_i18n" VALUES ('Function',271,'en');
INSERT INTO "term_i18n" VALUES ('Funcion',271,'es');
INSERT INTO "term_i18n" VALUES ('Fonction',271,'fr');
INSERT INTO "term_i18n" VALUES ('Subfunction',272,'en');
INSERT INTO "term_i18n" VALUES ('Business process',273,'en');
INSERT INTO "term_i18n" VALUES ('Activity',274,'en');
INSERT INTO "term_i18n" VALUES ('Task',275,'en');
INSERT INTO "term_i18n" VALUES ('Transaction',276,'en');
CREATE TABLE "user" (
  "id" int(11) NOT NULL,
  "username" varchar(255) DEFAULT NULL,
  "email" varchar(255) DEFAULT NULL,
  "sha1_password" varchar(255) DEFAULT NULL,
  "salt" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "user_FK_1" FOREIGN KEY ("id") REFERENCES "actor" ("id") ON DELETE CASCADE
);
INSERT INTO "user" VALUES (278,'qubit','qubit@qubit.com','687a773b6aab941a03554beeed53a060cd8c33be','b7c4f9631cb888ac00c075ef216cb493');
CREATE INDEX "other_name_other_name_FI_1" ON "other_name" ("object_id");
CREATE INDEX "other_name_other_name_FI_2" ON "other_name" ("type_id");
CREATE INDEX "acl_user_group_acl_user_group_FI_1" ON "acl_user_group" ("user_id");
CREATE INDEX "acl_user_group_acl_user_group_FI_2" ON "acl_user_group" ("group_id");
CREATE INDEX "slug_slug_U_1" ON "slug" ("object_id");
CREATE INDEX "slug_slug_U_2" ON "slug" ("slug");
CREATE INDEX "digital_object_digital_object_FI_2" ON "digital_object" ("information_object_id");
CREATE INDEX "digital_object_digital_object_FI_3" ON "digital_object" ("usage_id");
CREATE INDEX "digital_object_digital_object_FI_4" ON "digital_object" ("media_type_id");
CREATE INDEX "digital_object_digital_object_FI_5" ON "digital_object" ("checksum_type_id");
CREATE INDEX "digital_object_digital_object_FI_6" ON "digital_object" ("parent_id");
CREATE INDEX "place_map_relation_place_map_relation_FI_2" ON "place_map_relation" ("place_id");
CREATE INDEX "place_map_relation_place_map_relation_FI_3" ON "place_map_relation" ("map_id");
CREATE INDEX "place_map_relation_place_map_relation_FI_4" ON "place_map_relation" ("map_icon_image_id");
CREATE INDEX "place_map_relation_place_map_relation_FI_5" ON "place_map_relation" ("type_id");
CREATE INDEX "repository_repository_FI_2" ON "repository" ("desc_status_id");
CREATE INDEX "repository_repository_FI_3" ON "repository" ("desc_detail_id");
CREATE INDEX "acl_group_acl_group_FI_1" ON "acl_group" ("parent_id");
CREATE INDEX "rights_term_relation_rights_term_relation_FI_1" ON "rights_term_relation" ("rights_id");
CREATE INDEX "rights_term_relation_rights_term_relation_FI_2" ON "rights_term_relation" ("term_id");
CREATE INDEX "rights_term_relation_rights_term_relation_FI_3" ON "rights_term_relation" ("type_id");
CREATE INDEX "object_term_relation_object_term_relation_FI_2" ON "object_term_relation" ("object_id");
CREATE INDEX "object_term_relation_object_term_relation_FI_3" ON "object_term_relation" ("term_id");
CREATE INDEX "relation_relation_FI_2" ON "relation" ("subject_id");
CREATE INDEX "relation_relation_FI_3" ON "relation" ("object_id");
CREATE INDEX "relation_relation_FI_4" ON "relation" ("type_id");
CREATE INDEX "system_event_system_event_FI_1" ON "system_event" ("type_id");
CREATE INDEX "system_event_system_event_FI_2" ON "system_event" ("user_id");
CREATE INDEX "information_object_information_object_U_1" ON "information_object" ("oai_local_identifier");
CREATE INDEX "information_object_information_object_FI_2" ON "information_object" ("level_of_description_id");
CREATE INDEX "information_object_information_object_FI_3" ON "information_object" ("collection_type_id");
CREATE INDEX "information_object_information_object_FI_4" ON "information_object" ("repository_id");
CREATE INDEX "information_object_information_object_FI_5" ON "information_object" ("parent_id");
CREATE INDEX "information_object_information_object_FI_6" ON "information_object" ("description_status_id");
CREATE INDEX "information_object_information_object_FI_7" ON "information_object" ("description_detail_id");
CREATE INDEX "historical_event_historical_event_FI_2" ON "historical_event" ("type_id");
CREATE INDEX "rights_rights_FI_1" ON "rights" ("object_id");
CREATE INDEX "rights_rights_FI_2" ON "rights" ("permission_id");
CREATE INDEX "acl_permission_acl_permission_FI_1" ON "acl_permission" ("user_id");
CREATE INDEX "acl_permission_acl_permission_FI_2" ON "acl_permission" ("group_id");
CREATE INDEX "acl_permission_acl_permission_FI_3" ON "acl_permission" ("object_id");
CREATE INDEX "menu_menu_FI_1" ON "menu" ("parent_id");
CREATE INDEX "taxonomy_taxonomy_FI_2" ON "taxonomy" ("parent_id");
CREATE INDEX "note_note_FI_1" ON "note" ("object_id");
CREATE INDEX "note_note_FI_2" ON "note" ("type_id");
CREATE INDEX "note_note_FI_3" ON "note" ("user_id");
CREATE INDEX "note_note_FI_4" ON "note" ("parent_id");
CREATE INDEX "event_event_FI_2" ON "event" ("type_id");
CREATE INDEX "event_event_FI_3" ON "event" ("information_object_id");
CREATE INDEX "event_event_FI_4" ON "event" ("actor_id");
CREATE INDEX "property_property_FI_1" ON "property" ("object_id");
CREATE INDEX "physical_object_physical_object_FI_2" ON "physical_object" ("type_id");
CREATE INDEX "physical_object_physical_object_FI_3" ON "physical_object" ("parent_id");
CREATE INDEX "term_term_FI_2" ON "term" ("taxonomy_id");
CREATE INDEX "term_term_FI_3" ON "term" ("parent_id");
CREATE INDEX "status_status_FI_1" ON "status" ("object_id");
CREATE INDEX "status_status_FI_2" ON "status" ("type_id");
CREATE INDEX "status_status_FI_3" ON "status" ("status_id");
CREATE INDEX "oai_harvest_oai_harvest_FI_1" ON "oai_harvest" ("oai_repository_id");
CREATE INDEX "rights_actor_relation_rights_actor_relation_FI_2" ON "rights_actor_relation" ("rights_id");
CREATE INDEX "rights_actor_relation_rights_actor_relation_FI_3" ON "rights_actor_relation" ("actor_id");
CREATE INDEX "rights_actor_relation_rights_actor_relation_FI_4" ON "rights_actor_relation" ("type_id");
CREATE INDEX "place_place_FI_2" ON "place" ("country_id");
CREATE INDEX "place_place_FI_3" ON "place" ("type_id");
CREATE INDEX "function_function_FI_2" ON "function" ("type_id");
CREATE INDEX "function_function_FI_3" ON "function" ("parent_id");
CREATE INDEX "function_function_FI_4" ON "function" ("description_status_id");
CREATE INDEX "function_function_FI_5" ON "function" ("description_detail_id");
CREATE INDEX "contact_information_contact_information_FI_1" ON "contact_information" ("actor_id");
CREATE INDEX "actor_actor_FI_2" ON "actor" ("entity_type_id");
CREATE INDEX "actor_actor_FI_3" ON "actor" ("description_status_id");
CREATE INDEX "actor_actor_FI_4" ON "actor" ("description_detail_id");
CREATE INDEX "actor_actor_FI_5" ON "actor" ("parent_id");
END TRANSACTION;
