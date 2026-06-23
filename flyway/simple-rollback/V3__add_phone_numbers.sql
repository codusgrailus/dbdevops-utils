SET @s = (SELECT IF(COUNT(*) = 0, 'ALTER TABLE allservices02_central.user_info ADD COLUMN phone_number VARCHAR(20)', 'SELECT 1') FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'allservices02_central' AND TABLE_NAME = 'user_info' AND COLUMN_NAME = 'phone_number');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @s = (SELECT IF(COUNT(*) = 0, 'ALTER TABLE allservices02_central.user_info ADD COLUMN phone_number2 VARCHAR(20)', 'SELECT 1') FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'allservices02_central' AND TABLE_NAME = 'user_info' AND COLUMN_NAME = 'phone_number2');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @s = (SELECT IF(COUNT(*) = 0, 'ALTER TABLE allservices02_central.user_info ADD COLUMN phone_number3 VARCHAR(20)', 'SELECT 1') FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'allservices02_central' AND TABLE_NAME = 'user_info' AND COLUMN_NAME = 'phone_number3');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;
