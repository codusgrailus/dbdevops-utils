# Changelog Sync - prepare-db.sql

## Run via kubectl

Note: Do NOT use `-it` when piping a file — it conflicts with stdin redirection and the SQL will not execute.

```bash
kubectl delete pod liquibase-client --ignore-not-found && \
kubectl run liquibase-client \
  --image=liquibase/liquibase:4.33.0 \
  --rm -i \
  --restart=Never \
  --overrides='{"spec":{"hostNetwork":true}}' \
  -- sh -c "
    curl -sL \
      https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar \
      -o /tmp/mysql-connector-j.jar && \
    liquibase \
      --driver=com.mysql.cj.jdbc.Driver \
      --classpath=/tmp/mysql-connector-j.jar \
      --url='jdbc:mysql://xxxxxxxxxxx.ap-south-1.rds.amazonaws.com:3306/inventory_central' \
      --username=auroramysqladmin \
      --password=xxxxxxx \
      --changeLogFile=/tmp/generated-changelog.yml \
      generate-changelog && \
    cat /tmp/generated-changelog.yml
  "
```
