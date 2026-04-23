--liquibase formatted sql

--changeset dbdevopsuser01:0
--comment: Create the database if it does not exist
CREATE DATABASE IF NOT EXISTS demo_versioned_sql;
