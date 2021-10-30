#!/bin/bash
curl --location --request GET 'https://xray.cloud.xpand-it.com/api/v1/graphql' \
--header 'Authorization: Bearer {{TOKEN}}' \
--header 'Content-Type: application/json' \
--data-raw '{"query":"{\n  getTests(jql: \"key={{TEST_KEY}}\", limit: 50) {\n    results {\n      issueId\n    }\n  }\n}","variables":{}}'