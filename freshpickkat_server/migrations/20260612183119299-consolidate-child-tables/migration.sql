BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "category_offer" ADD COLUMN "scopeProductIds" text;
ALTER TABLE "category_offer" ADD COLUMN "excludeProductIds" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "coupon" ADD COLUMN "productIds" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" ADD COLUMN "subCategoryIds" text;

-- Backfill product subCategoryIds from existing product_sub_category rows
UPDATE "product" p
SET "subCategoryIds" = (
  SELECT string_agg(psc."subCategoryId"::text, ',' ORDER BY sc.name)
  FROM "product_sub_category" psc
  JOIN "sub_category" sc ON sc.id = psc."subCategoryId"
  WHERE psc."productId" = p.id
);

-- Backfill coupon productIds
UPDATE "coupon" c
SET "productIds" = (
  SELECT string_agg(cps."productId"::text, ',' ORDER BY cps."createdAt")
  FROM "coupon_product_scope" cps
  WHERE cps."couponId" = c.id
);

-- Backfill category_offer scopeProductIds
UPDATE "category_offer" co
SET "scopeProductIds" = (
  SELECT string_agg(cops."productId"::text, ',' ORDER BY cops."createdAt")
  FROM "category_offer_product_scope" cops
  WHERE cops."categoryOfferId" = co.id
);

-- Backfill category_offer excludeProductIds
UPDATE "category_offer" co
SET "excludeProductIds" = (
  SELECT string_agg(coep."productId"::text, ',' ORDER BY coep."createdAt")
  FROM "category_offer_product_exclusion" coep
  WHERE coep."categoryOfferId" = co.id
);

--
-- ACTION DROP TABLE
--
DROP TABLE "product_sub_category" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "coupon_product_scope" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "category_offer_product_scope" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "category_offer_product_exclusion" CASCADE;

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260612183119299-consolidate-child-tables', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260612183119299-consolidate-child-tables', "timestamp" = now();

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
