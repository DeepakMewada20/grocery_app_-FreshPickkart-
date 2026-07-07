BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "coupon" ALTER COLUMN "couponCategory" SET DEFAULT 'General'::text;

--
-- DATA MIGRATION: Convert existing coupons to new category + type scheme
--
-- PRODUCT_BASED → category='Product Based', type='FLAT_DISCOUNT'
UPDATE "coupon"
SET "couponCategory" = 'Product Based', "couponType" = 'FLAT_DISCOUNT'
WHERE "couponType" = 'PRODUCT_BASED';

-- LOYALTY → category='Loyalty', type='FLAT_DISCOUNT'
UPDATE "coupon"
SET "couponCategory" = 'Loyalty', "couponType" = 'FLAT_DISCOUNT'
WHERE "couponType" = 'LOYALTY';

-- FIRST_ORDER → category='General', type='FLAT_DISCOUNT'
UPDATE "coupon"
SET "couponCategory" = 'General', "couponType" = 'FLAT_DISCOUNT'
WHERE "couponType" = 'FIRST_ORDER';

-- LIMITED_TIME → category='Seasonal', type='FLAT_DISCOUNT'
UPDATE "coupon"
SET "couponCategory" = 'Seasonal', "couponType" = 'FLAT_DISCOUNT'
WHERE "couponType" = 'LIMITED_TIME';

-- PERCENTAGE_DISCOUNT → category='General'
UPDATE "coupon"
SET "couponCategory" = 'General'
WHERE "couponType" = 'PERCENTAGE_DISCOUNT' AND "couponCategory" = 'All';

-- FLAT_DISCOUNT → category='General'
UPDATE "coupon"
SET "couponCategory" = 'General'
WHERE "couponType" = 'FLAT_DISCOUNT' AND "couponCategory" = 'All';

-- Remaining 'All' categories → 'General' fallback
UPDATE "coupon"
SET "couponCategory" = 'General'
WHERE "couponCategory" = 'All';

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260706112014566', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260706112014566', "timestamp" = now();

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
