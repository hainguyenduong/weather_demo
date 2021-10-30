curl --location --request POST 'https://xray.cloud.xpand-it.com/api/v1/import/execution' \
--header 'Authorization: Bearer {{TOKEN}}' \
--header 'Content-Type: application/json' \
--data-raw '{
    "info" : {
        "summary" : "API test execution, build time {{BUILD_TIME}}",
        "description" : "This execution is automatically created when run in jenkin job"
    }
}'