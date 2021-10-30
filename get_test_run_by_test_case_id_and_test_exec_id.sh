#!/bin/bash
curl --location --request GET 'https://xray.cloud.xpand-it.com/api/v1/graphql' \
--header 'Authorization: Bearer {{TOKEN}}' \
--header 'Content-Type: application/json' \
--data-raw '{"query":"{\n    getTestRun( testIssueId: \"{{TEST_CASE_ID}}\", testExecIssueId: \"{{TEST_EXECUTION_ID}}\") {\n        id\n        status {\n            name\n            color\n            description\n        }\n    }\n}","variables":{}}'