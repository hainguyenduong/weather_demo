#!/bin/bash
curl --location --request POST 'https://xray.cloud.xpand-it.com/api/v1/graphql' \
--header 'Authorization: Bearer {{TOKEN}}' \
--header 'Content-Type: application/json' \
--data-raw '{"query":"mutation {\n    updateTestRunStatus( \n            id: \"{{TEST_RUN_ID}}\",\n            status: \"{{TEST_RUN_STATUS}}\"\n        ) \n}","variables":{}}'