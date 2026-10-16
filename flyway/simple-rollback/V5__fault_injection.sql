-- If rollback_trigger table exists, intentionally fail by inserting into a non-existent column
SET @trigger_exists = (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'y1' AND TABLE_NAME = 'rollback_trigger');

SET @s = IF(@trigger_exists > 0,
    'INSERT INTO allservices02_central.user_info (username, email, password_hash, full_name, non_existent_column) VALUES (''faultuser'', ''fault@example.com'', ''$2a$10$faultinjectedhashvalue'', ''Fault User'', ''bad_value'')',
    'SELECT 1'
);
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;
