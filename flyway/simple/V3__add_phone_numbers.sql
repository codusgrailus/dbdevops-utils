ALTER TABLE allservices02_central.user_info
    ADD COLUMN IF NOT EXISTS phone_number  VARCHAR(20),
    ADD COLUMN IF NOT EXISTS phone_number2 VARCHAR(20),
    ADD COLUMN IF NOT EXISTS phone_number3 VARCHAR(20);
