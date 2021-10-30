//use JsonSlurperClassic because it produces HashMap that could be serialized by pipeline
import groovy.json.JsonSlurperClassic
node() {

    def repoURL = env.repoURL
    def jiraKey= env.jiraKey  // Test case you want to run test


    stage("Prepare Workspace") {
        echo "==========================================Prepare Workspace=========================================="
        if (env.jmeter_test_path== '') { // and/or whatever condition you want
                currentBuild.result = 'ABORTED'
                error('You have to input the test you want to run')
        }
        env.WORKSPACE_LOCAL = bat(returnStdout: true, script: 'cd').trim().readLines().drop(1).join(" ")
        env.BUILD_TIME = bat(returnStdout: true, script: 'date /t').trim().readLines().drop(1).join(" ")
        echo "Workspace set to:"  + env.WORKSPACE_LOCAL
        echo "Build time:"  + env.BUILD_TIME
        env.PATH = "C:/Program Files/Git/usr/bin;D:/Working/Tools/apache-jmeter-5.4.1/bin;${env.PATH}"
    }
    stage('Checkout Self') {
        echo "==========================================Checkout Self=========================================="
        git branch: 'main', credentialsId: '', url: repoURL
    }
    stage('JMeter run Tests') {
        echo "==========================================JMeter run Tests=========================================="
        def jmeter_test_path = env.jmeter_test_path // example: tests/weather_demo.jmx
        echo "jmeter_test_path is :"  + env.jmeter_test_path 
        bat"""bash perf_script.sh"""
    }
    stage('Save the Artifacts') {
        echo "==========================================Save the Artifacts=========================================="
        archiveArtifacts artifacts: "reports/summary-report.csv", followSymlinks: false
        archiveArtifacts artifacts: "results.jtl", followSymlinks: false
    }
    stage('Create JIRA Xray test Execution') {
        echo "Create JIRA Xray test Execution"
        def text = readFile "create_xray_test_execution.sh"
        text = text.replace("{{TOKEN}}", env.token )
        text = text.replace("{{TEST}}", env.jiraKey )
        text = text.replace("{{BUILD_TIME}}",env.BUILD_TIME )
        writeFile file: "create_xray_test_execution.sh", text: text
        def response_string = bat(script: "bash create_xray_test_execution.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
        def jsonObj = readJSON text: response_string
        
        env.TEST_EXECUTION_KEY = bat(script: "echo ${jsonObj.key}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        echo "TEST_EXECUTION_KEY is:  " + env.TEST_EXECUTION_KEY
        env.TEST_EXECUTION_ID = bat(script: "echo ${jsonObj.id}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        echo "TEST_EXECUTION_ID is:  " + env.TEST_EXECUTION_ID
    }







    stage('Attach report to JIRA'){
        echo "==========================================Attach report to JIRA=========================================="
        def attachment1 = jiraUploadAttachment idOrKey: jiraKey, file: './tests/summary-report.csv', site: 'nguyenduonghai'
        def attachment2 = jiraUploadAttachment idOrKey: jiraKey, file: 'results.jt', site: 'nguyenduonghai'
        echo "=========Attachment 1: " + attachment1.data.toString()
        echo "=========Attachment 2: " + attachment2.data.toString()
    }
    stage('JIRA Xray authentication') {
        echo "JIRA Xray authentication"
        env.token = bat(script: "bash authentication.sh", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        echo "token is :"  + env.token    
    }
    stage('Get Test case ID by issue key') {
        echo "Get Test case ID by issue key"
        
        def text = readFile "get_test_case_id_by_issue_key.sh"
        text = text.replace("{{TOKEN}}", env.token )
        text = text.replace("{{TEST_KEY}}", env.jiraKey )
        writeFile file: "get_test_case_id_by_issue_key.sh", text: text
        def response_string = bat(script: "bash get_test_case_id_by_issue_key.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
        def jsonObj = readJSON text: response_string

        env.TEST_ID = bat(script: "echo ${jsonObj.data.getTests.results[0].issueId}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        echo "TEST_ID is:  " + env.TEST_ID 
    }
    

    stage('Get test run ID') {
        echo "Get test run ID"
        def text = readFile "get_test_run_by_test_case_id_and_test_exec_id.sh"
        text = text.replace("{{TOKEN}}", env.token )
        text = text.replace("{{TEST_CASE_ID}}", env.TEST_ID )
        text = text.replace("{{TEST_EXECUTION_ID}}", env.TEST_EXECUTION_ID )
        text = text.replace("{{BUILD_TIME}}",env.BUILD_TIME )
        writeFile file: "get_test_run_by_test_case_id_and_test_exec_id.sh", text: text
        
        def response_string = bat(script: "bash get_test_run_by_test_case_id_and_test_exec_id.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
        echo "response_string is:  " + response_string
        def jsonObj = readJSON text: response_string
        
        env.TEST_RUN_ID = bat(script: "echo ${jsonObj.data.getTestRun.id}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        echo "TEST_RUN_ID is:  " + env.TEST_RUN_ID

    }
    stage('Update test run ID') {
        echo "update_test_run_by_id"
        def test_run_status = bat(script: "bash get_status_evaluation_criteria.sh reports/result4_1.csv", returnStdout: true).trim().readLines().drop(1).join(" ")
        echo "test_run_status is:  " + test_run_status


        def text = readFile "update_test_run_by_id.sh"
        text = text.replace("{{TOKEN}}", env.token )
        text = text.replace("{{TEST_RUN_ID}}", env.TEST_RUN_ID )
        text = text.replace("{{TEST_RUN_STATUS}}", test_run_status ) // for the sake of the demo
        writeFile file: "update_test_run_by_id.sh", text: text
        
        def response_string = bat(script: "bash update_test_run_by_id.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
        echo "response_string is:  " + response_string
        def jsonObj = readJSON text: response_string
        
        env.updateTestRunStatus = bat(script: "echo ${jsonObj.data.updateTestRunStatus}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        echo "updateTestRunStatus is:  " + env.updateTestRunStatus

    }
    
}