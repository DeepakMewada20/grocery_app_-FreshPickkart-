BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "support_issue" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "issueType" text NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "screenshotUrl" text,
    "appVersion" text NOT NULL,
    "buildNumber" text NOT NULL,
    "deviceInfo" text NOT NULL,
    "status" text NOT NULL DEFAULT 'Pending'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "support_issue_user_created_idx" ON "support_issue" USING btree ("userId", "createdAt");
CREATE INDEX "support_issue_status_created_idx" ON "support_issue" USING btree ("status", "createdAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "support_issue"
    ADD CONSTRAINT "support_issue_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260515040246559', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260515040246559', "timestamp" = now();

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
