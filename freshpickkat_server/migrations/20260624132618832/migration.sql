BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "customer_order" ADD COLUMN "deliveryVerificationMethod" text DEFAULT 'otp'::text;
ALTER TABLE "customer_order" ADD COLUMN "deliveryProofImageUrl" text;
ALTER TABLE "customer_order" ADD COLUMN "deliveryProofLatitude" double precision;
ALTER TABLE "customer_order" ADD COLUMN "deliveryProofLongitude" double precision;
ALTER TABLE "customer_order" ADD COLUMN "deliveryProofTimestamp" timestamp without time zone;
ALTER TABLE "customer_order" ADD COLUMN "deliveryProofDistanceMeters" double precision;
ALTER TABLE "customer_order" ADD COLUMN "deliveryProofGpsAccuracy" double precision;
ALTER TABLE "customer_order" ADD COLUMN "deliveredByUserId" text;
ALTER TABLE "customer_order" ADD COLUMN "deliveredByName" text;
ALTER TABLE "customer_order" ADD COLUMN "deliveredByRole" text DEFAULT 'admin'::text;
ALTER TABLE "customer_order" ADD COLUMN "deliveryCompletedAt" timestamp without time zone;
ALTER TABLE "customer_order" ADD COLUMN "deliveryOtpVerifiedAt" timestamp without time zone;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "delivery_settings" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "defaultVerificationMethod" text NOT NULL DEFAULT 'otp'::text,
    "cameraOnlyCapture" boolean NOT NULL DEFAULT true,
    "gpsRequired" boolean NOT NULL DEFAULT true,
    "strictDistanceValidation" boolean NOT NULL DEFAULT true,
    "maxAllowedRadiusMeters" bigint NOT NULL DEFAULT 200,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260624132618832', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260624132618832', "timestamp" = now();

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
