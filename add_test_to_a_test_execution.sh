curl --location --request POST 'https://xray.cloud.xpand-it.com/api/v1/graphql' \
--header 'Authorization: Bearer {{TOKEN}}' \
--header 'Content-Type: application/json' \
--data-raw '{"query":"mutation {\n    addTestsToTestExecution(\n        issueId: \"{{TEST_EXECUTION_ID}}\",\n        testIssueIds: [\"{{TEST_CASE_ID}}\"]\n    ) {\n        addedTests\n        warning\n    }\n}","variables":{}}'