BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "banner" ADD COLUMN "screenPlacements" text NOT NULL DEFAULT ''::text;
ALTER TABLE "banner" ADD COLUMN "linkedProductIds" text;

-- Migrate existing placement data
UPDATE "banner" b
SET "screenPlacements" = (
  SELECT string_agg(bp."placementKey", ',' ORDER BY bp."createdAt")
  FROM "banner_placement" bp
  WHERE bp."bannerId" = b.id
);

-- Migrate existing linked product data
UPDATE "banner" b
SET "linkedProductIds" = (
  SELECT string_agg(blp."productId"::text, ',' ORDER BY blp."sortOrder")
  FROM "banner_linked_product" blp
  WHERE blp."bannerId" = b.id
);

--
-- ACTION DROP TABLE
--
DROP TABLE "banner_placement" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "banner_linked_product" CASCADE;

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260612175252826-consolidate-banner-data', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260612175252826-consolidate-banner-data', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
