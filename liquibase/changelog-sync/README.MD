# Changelog Sync - prepare-db.sql

## Run via kubectl

Note: Do NOT use `-it` when piping a file — it conflicts with stdin redirection and the SQL will not execute.

```bash
kubectl run mysql-client --image=mysql:8.0 --rm -i --restart=Never -- \
  mysql -h xxxxxxxxxx.cluster-ctsyoy2uexi7.ap-south-1.rds.amazonaws.com \
  -P 3306 -u auroramysqladmin -pxxxxxxxx \
  < /Users/abc/dbdevops-utils/liquibase/changelog-sync/prepare-db.sql
```

## Harness Pipeline: generate-changelog + changelog-sync

```yaml
pipeline:
  name: generate-changelog-and-sync
  identifier: generatechangelogandsync
  stages:
    - stage:
        name: s2
        identifier: s2
        type: Custom
        spec:
          execution:
            steps:
              - stepGroup:
                  name: stepgroup_hmi
                  identifier: stepgroup_hmi
                  steps:
                    - step:
                        type: LiquibaseCommand
                        name: LiquibaseCommand_1
                        identifier: LiquibaseCommand_1
                        spec:
                          connectorRef: account.harnessImage
                          command: generate-changelog
                          settings:
                            changeLogFile: generated-changelog.yml
                          dbSchema: may21schema01
                          dbInstance: may21inst005
                          excludeChangeLogFile: true
                        timeout: 10m
                    - step:
                        type: LiquibaseCommand
                        name: LiquibaseCommand_2
                        identifier: LiquibaseCommand_2
                        spec:
                          connectorRef: account.harnessImage
                          command: changelog-sync
                          settings:
                            changeLogFile: generated-changelog.yml
                          dbSchema: may21schema01
                          dbInstance: may21inst005
                          excludeChangeLogFile: true
                        timeout: 10m
                  stepGroupInfra:
                    type: KubernetesDirect
                    spec:
                      connectorRef: <+input>
```
