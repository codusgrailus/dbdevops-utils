package db_sql

policies := [
    {
        "error_message": "Dropping the 'values_check' database is not allowed.",
        "rules": [
            {
                "types": [
                    "jdbc:sqlserver","jdbc:mysql","jdbc:postgresql","jdbc:oracle:thin"
                ],
                "regex": [
                    "drop\\s+database.*values_check"
                ]
            }
        ]
    },
    {
        "error_message": "Dropping the 'values_check_table' table is not allowed.",
        "rules": [
            {
                "types": [
                    "jdbc:sqlserver","jdbc:mysql","jdbc:postgresql","jdbc:oracle:thin"
                ],
                "regex": [
                    "drop\\s+table.*values_check"
                ]
            }
        ]
    },
    {
        "error_message": "Dropping any database is not allowed.",
        "rules": [
            {
                "types": [
                    "jdbc:sqlserver","jdbc:mysql","jdbc:postgresql","jdbc:oracle:thin"
                ],
                "regex": [
                    "drop\\s+database"
                ]
            }
        ]
    },
    {
        "error_message": "Dropping any table is not allowed.",
        "rules": [
            {
                "types": [
                    "jdbc:sqlserver","jdbc:mysql","jdbc:postgresql","jdbc:oracle:thin"
                ],
                "regex": [
                    "drop\\s+table"
                ]
            }
        ]
    }
]

deny[msg] {
    some i,j,k,l
    policy := policies[i]
    type := input.dbInstance.type
    rule := policy.rules[j]
    type = rule.types[_]
    regex.match(lower(concat("", [".*", rule.regex[k], ".*"])), lower(input.sqlStatements[l]))
    msg := concat("", [
        "Policy violation:\n The following sql statement:\n",
        input.sqlStatements[l],
        "\n\n Matches the following regex: \n",
        rule.regex[k],
        "\n\n Error: ",
        policy.error_message
    ])
}
