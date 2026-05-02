BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_user" ADD COLUMN "fcmToken" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_cart_item" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "productId" text NOT NULL,
    "variantId" text,
    "quantity" bigint NOT NULL,
    "bogoFreeProductId" text,
    "comboId" text,
    "comboName" text,
    "comboDiscountType" text,
    "comboDiscountValue" double precision,
    "comboItemQuantity" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "user_cart_item_user_id_idx" ON "user_cart_item" USING btree ("userId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_cart_item"
    ADD CONSTRAINT "user_cart_item_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260429122222987', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260429122222987', "timestamp" = now();

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
