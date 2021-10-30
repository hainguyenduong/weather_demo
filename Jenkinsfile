//use JsonSlurperClassic because it produces HashMap that could be serialized by pipeline
import groovy.json.JsonSlurperClassic;
node() {

    def repoURL = env.repoURL


    stage("Prepare Workspace") {
        echo "==========================================Prepare Workspace=========================================="
        cleanWs()
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
        bat(script: """bash perf_script.sh ${jmeter_test_path}""", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
    }
    stage('Save the Artifacts') {
        echo "==========================================Save the Artifacts=========================================="
        archiveArtifacts artifacts: "tests/summary-report.csv", followSymlinks: false
        archiveArtifacts artifacts: "tests/result.jtl", followSymlinks: false
    }
    stage('JIRA Xray authentication') {
        echo "JIRA Xray authentication"
        env.token = bat(script: "bash authentication.sh", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        echo "token is :"  + env.token    
    }
    stage('Create JIRA Xray test Execution') {
        echo "==========================================Create JIRA Xray test Execution=========================================="
        def text = readFile "create_xray_test_execution.sh"
        text = text.replace("{{TOKEN}}", env.token )
        text = text.replace("{{PROJECT_KEY}}",env.PROJECT_KEY )
        writeFile file: "create_xray_test_execution.sh", text: text
        def response_string = bat(script: "bash create_xray_test_execution.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
        echo "response_string is:  " + response_string
        def jsonObj = readJSON text: response_string
        echo "jsonObj is:  " + jsonObj
        
        // env.TEST_EXECUTION_KEY = bat(script: "echo ${jsonObj.key}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        // echo "TEST_EXECUTION_KEY is:  " + env.TEST_EXECUTION_KEY
        env.TEST_EXECUTION_ID = bat(script: "echo ${jsonObj.data.createTestExecution.testExecution.issueId}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
        echo "TEST_EXECUTION_ID is:  " + env.TEST_EXECUTION_ID
    }
    stage('Attach report to new created JIRA execution'){
        echo "==========================================Attach report to new created JIRA execution=========================================="
        def attachment1 = jiraUploadAttachment idOrKey: env.TEST_EXECUTION_ID, file: './tests/summary-report.csv', site: 'nguyenduonghai'
        def attachment2 = jiraUploadAttachment idOrKey: env.TEST_EXECUTION_ID, file: './tests/result.jtl', site: 'nguyenduonghai'
        echo "=========Attachment 1: " + attachment1.data.toString()
        echo "=========Attachment 2: " + attachment2.data.toString()
    }

    stage('Analyze summary report and Add Test case to execution'){
        echo "==========================================Analyze summary report and Add Test case to execution=========================================="

        def data  = readFile "tests/summary-report.csv"
        def lines = data.readLines()
        for (line in lines) {
            echo "******line is: " + line
            def parts = line.split(",")
            if(parts[2].contains(env.PROJECT_KEY)){               
                def jiraKey = parts[2]
                echo "JIRA key is: " + jiraKey
                echo "**************Get Test case ID by issue key************"
                def text = readFile "get_test_case_id_by_issue_key.sh"
                text = text.replace("{{TOKEN}}", env.token )
                text = text.replace("{{TEST_KEY}}", jiraKey )
                writeFile file: "get_test_case_id_by_issue_key_execute.sh", text: text
                def response_string = bat(script: "bash get_test_case_id_by_issue_key_execute.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
                def jsonObj = readJSON text: response_string
                def test_id = bat(script: "echo ${jsonObj.data.getTests.results[0].issueId}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
                echo "TEST_ID is:  " + test_id
                echo "**************End Get Test case ID by issue key************"

                echo "**************Add test case to a test Execution************"
                text = readFile "add_test_to_a_test_execution.sh"
                text = text.replace("{{TOKEN}}", env.token )
                text = text.replace("{{TEST_CASE_ID}}", test_id )
                text = text.replace("{{TEST_EXECUTION_ID}}", env.TEST_EXECUTION_ID )
                writeFile file: "add_test_to_a_test_execution_execute.sh", text: text
                response_string = bat(script: "bash add_test_to_a_test_execution_execute.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
                jsonObj = readJSON text: response_string
                //def test_id = bat(script: "echo ${jsonObj.data.getTests.results[0].issueId}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
                echo "jsonObj is:  " + jsonObj

                echo "**************End add test case to a test Execution************"



                echo "**************Get test run ID************"
                text = readFile "get_test_run_by_test_case_id_and_test_exec_id.sh"
                text = text.replace("{{TOKEN}}", env.token )
                text = text.replace("{{TEST_CASE_ID}}", test_id )
                text = text.replace("{{TEST_EXECUTION_ID}}", env.TEST_EXECUTION_ID )

                writeFile file: "get_test_run_by_test_case_id_and_test_exec_id_execute.sh", text: text
                
                response_string = bat(script: "bash get_test_run_by_test_case_id_and_test_exec_id_execute.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
                echo "response_string is:  " + response_string
                jsonObj = readJSON text: response_string
                
                def test_run_id = bat(script: "echo ${jsonObj.data.getTestRun.id}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
                echo "TEST_RUN_ID is:  " + test_run_id
                echo "**************End Get test run ID************"

                echo "**************update_test_run_status**************"

                echo "parts[5]:  " + parts[5]
                echo "parts[6]:  " + parts[6]
                echo "parts[7]:  " + parts[7]
                echo "parts[8]:  " + parts[8]

                def test_run_status = "PASSED"
                if(parts[7] == "FALSE"){
                    test_run_status = "FAILED"
                }
                
                echo "test_run_status is:  " + test_run_status
                echo "**************end update_test_run_status**************"

                echo "**************update_test_run_by_id**************"
                text = readFile "update_test_run_by_id.sh"
                text = text.replace("{{TOKEN}}", env.token )
                text = text.replace("{{TEST_RUN_ID}}", test_run_id )
                text = text.replace("{{TEST_RUN_STATUS}}", test_run_status ) // for the sake of the demo
                writeFile file: "update_test_run_by_id_execute.sh", text: text
                
                response_string = bat(script: "bash update_test_run_by_id_execute.sh", returnStdout: true).trim().readLines().drop(1).join(" ")
                echo "response_string is:  " + response_string
                jsonObj = readJSON text: response_string
                
                env.updateTestRunStatus = bat(script: "echo ${jsonObj.data.updateTestRunStatus}", returnStdout: true).trim().replace('"','').readLines().drop(1).join(" ")
                echo "updateTestRunStatus is:  " + env.updateTestRunStatus
                echo "**************end update_test_run_by_id**************"

            }
        }
    }
    
}