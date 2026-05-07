BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_tracking" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" uuid NOT NULL,
    "trackingEnabled" boolean NOT NULL DEFAULT false,
    "userLatitude" double precision,
    "userLongitude" double precision,
    "userAddress" text,
    "userLocationType" text,
    "riderLatitude" double precision,
    "riderLongitude" double precision,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "order_tracking_order_idx" ON "order_tracking" USING btree ("orderId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order_tracking"
    ADD CONSTRAINT "order_tracking_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260507134004042', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260507134004042', "timestamp" = now();

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
