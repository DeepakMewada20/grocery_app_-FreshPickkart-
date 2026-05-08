--
-- MIGRATION 20260508075352215
--
-- BEGIN
BEGIN;

--
-- ACTION DROP COLUMN
--
ALTER TABLE "bogo_offer_reward" DROP COLUMN "quantity";
ALTER TABLE "bogo_offer_reward" DROP COLUMN "quantity_label";

--
-- ACTION ADD COLUMN
--
ALTER TABLE "bogo_offer_reward" ADD COLUMN "reward_variant_id" uuid;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE "bogo_offer_reward"
  ADD CONSTRAINT "bogo_offer_reward_fk_2"
  FOREIGN KEY ("reward_variant_id")
  REFERENCES "product_variant"("id")
  ON DELETE RESTRICT;


COMMIT;
-- END
