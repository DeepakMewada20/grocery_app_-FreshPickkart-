BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "complaint" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" uuid NOT NULL,
    "orderId" uuid NOT NULL,
    "orderItemId" uuid NOT NULL,
    "issueType" text NOT NULL,
    "description" text NOT NULL,
    "imageUrls" json NOT NULL,
    "status" text NOT NULL DEFAULT 'Pending'::text,
    "adminReply" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "complaint_order_item_idx" ON "complaint" USING btree ("orderItemId");
CREATE INDEX "complaint_user_created_idx" ON "complaint" USING btree ("userId", "createdAt", "id");
CREATE INDEX "complaint_status_created_idx" ON "complaint" USING btree ("status", "createdAt", "id");
CREATE INDEX "complaint_order_idx" ON "complaint" USING btree ("orderId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "complaint"
    ADD CONSTRAINT "complaint_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "complaint"
    ADD CONSTRAINT "complaint_fk_1"
    FOREIGN KEY("orderId")
    REFERENCES "customer_order"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "complaint"
    ADD CONSTRAINT "complaint_fk_2"
    FOREIGN KEY("orderItemId")
    REFERENCES "order_item"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260515075712073', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260515075712073', "timestamp" = now();

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
