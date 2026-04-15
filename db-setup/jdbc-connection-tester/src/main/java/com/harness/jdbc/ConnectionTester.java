package com.harness.jdbc;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ConnectionTester {

    private static String requireEnv(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            System.err.printf("[ERROR] Required environment variable '%s' is not set.%n", name);
            System.exit(1);
        }
        return value;
    }

    public static void main(String[] args) {
        String host           = requireEnv("DB_HOST");
        String port           = System.getenv().getOrDefault("DB_PORT", "3306");
        String user           = requireEnv("DB_USER");
        String password       = requireEnv("DB_PASSWORD");
        String jdbcDriver     = requireEnv("DB_JDBC_DRIVER");   // e.g. jdbc:mysql
        String extraJdbcArgs  = System.getenv().getOrDefault("EXTRA_JDBC_ARGS", "");

        String jdbcUrl = String.format("%s://%s:%s/%s", jdbcDriver, host, port, extraJdbcArgs);

        System.out.println("=================================================");
        System.out.println("  JDBC Connection Tester — Aurora MySQL 8");
        System.out.println("=================================================");
        System.out.printf("  Host : %s%n", host);
        System.out.printf("  Port : %s%n", port);
        System.out.printf("  User : %s%n", user);
        System.out.println("-------------------------------------------------");

        try (Connection conn = DriverManager.getConnection(jdbcUrl, user, password)) {

            System.out.println("[OK] Connection established successfully!");
            System.out.println();

            DatabaseMetaData meta = conn.getMetaData();
            System.out.printf("  DB Product  : %s%n", meta.getDatabaseProductName());
            System.out.printf("  DB Version  : %s%n", meta.getDatabaseProductVersion());
            System.out.printf("  Driver      : %s %s%n",
                meta.getDriverName(), meta.getDriverVersion());
            System.out.println();

            String newDbName = System.getenv("NEW_DB_NAME");
            if (newDbName != null && !newDbName.isBlank()) {
                createDatabase(conn, newDbName);
            }

            showDatabases(conn);

        } catch (SQLException e) {
            System.err.println("[FAILED] Could not connect to the database.");
            System.err.printf("  SQLState : %s%n", e.getSQLState());
            System.err.printf("  ErrorCode: %d%n", e.getErrorCode());
            System.err.printf("  Message  : %s%n", e.getMessage());
            System.exit(1);
        }

        System.out.println("=================================================");
        System.out.println("  Test PASSED");
        System.out.println("=================================================");
    }

    private static void createDatabase(Connection conn, String dbName) throws SQLException {
        System.out.printf("Creating database '%s'...%n", dbName);
        try (Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS `" + dbName + "`");
            System.out.printf("[OK] Database '%s' created (or already exists).%n%n", dbName);
        }
    }

    private static void showDatabases(Connection conn) throws SQLException {
        System.out.println("Available Databases:");
        System.out.println("-------------------------------------------------");
        try (Statement stmt = conn.createStatement();
             ResultSet rs   = stmt.executeQuery("SHOW DATABASES")) {
            int count = 0;
            while (rs.next()) {
                System.out.printf("  - %s%n", rs.getString(1));
                count++;
            }
            System.out.println("-------------------------------------------------");
            System.out.printf("  Total: %d database(s)%n", count);
        }
    }
}
