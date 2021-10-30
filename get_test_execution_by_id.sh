#!/bin/bash
curl --location --request GET 'https://xray.cloud.xpand-it.com/api/v1/graphql' \
--header 'Authorization: Bearer {{TOKEN}}' \
--header 'Content-Type: application/json' \
--data-raw '{"query":"{\n    getTestExecution(issueId: \"{{TEST_EXECUTION_ID}}\") {\n        issueId\n        jira(fields: [\"key\"])\n    }\n}","variables":{}}'