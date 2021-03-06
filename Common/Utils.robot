*** Settings ***
Documentation    Test Seller Center REST API
Resource    ../resources.robot

Library    RequestsLibrary
Library    Collections    

*** Variables ***
${GET_SUCCESS_CODE}    200
${POST_SUCCESS_CODE}    201
${DELETE_SUCCESS_CODE}    204

${NOT_FOUND}    404

${REQUEST_INVALID_OR_NOT_FOUND_CODE}    400

${TEST_CASE_FOLDER}    TEST_CASE

${TEST_STEP_LIST}    ${EMPTY}

${TEST_CASE_KEY}    key
${TEST_CASE_NAME}    name


*** Keywords ***
Suite Setup
    [Arguments]    ${folderPath}    ${folderType}
    Create Jira Session
    Check And Create Folder    ${folderPath}    ${folderType}


Init Test Step List
    ${TEST_STEP_LIST}=   Create List
    Set Test Variable      ${TEST_STEP_LIST}
    
Add Test Step
    [Arguments]    ${stepDescription}    ${stepExpect}
    ${step}=    Create Dictionary    description=${stepDescription}        expectedResult=${stepExpect}
    Append To List    ${TEST_STEP_LIST}     ${step} 

Complete Test Case
    [Arguments]    ${folder}    ${issueLinks}
    Run Keyword If    "${issueLinks}"!="${null}"    Add Test Case To Folder And Ticket    ${folder}    ${issueLinks}
    ...                  ELSE                            Add Test Case To Folder    ${folder}        
       

Add Test Case To Folder And Ticket
    [Arguments]    ${folder}    ${issueLinks}
    Create Test Case With Ticket    ${TEST_STEP_LIST}    ${folder}        ${TEST_NAME}    ${issueLinks}  

Add Test Case To Folder
    [Arguments]    ${folder} 
    Create Test Case    ${TEST_STEP_LIST}    ${folder}        ${TEST_NAME}


Create Test Case With Ticket
    [Arguments]    ${testSteps}    ${folder}    ${testcaseName}    ${issueKeys}      
    ${testScript}=    Create Dictionary    type=STEP_BY_STEP    steps=${testSteps} 
    
    ${issueLinks}=     Create List    ${issueKeys} 
    
    ${body}=    Create Dictionary    projectKey=${JIRA_PROJECT_KEY}     folder=${folder}    status=Approved      name=${testcaseName}    testScript=${testScript}    issueLinks=${issueLinks}    
    # Create Session    alias=Get_Jira_Request    url=${JIRA_URL}    auth=${JIRA_AUTH}    verify=True 
    ${response}=    Post Request    Get_Jira_Request    ${URI_CREATE_TESTCASE}       data=${body}    headers=${JIRA_HEADER}   
    
    Should Be Equal As Strings    ${response.status_code}    ${POST_SUCCESS_CODE}    
    
Create Test Case
    [Arguments]    ${testSteps}    ${folder}    ${testcaseName}     
    ${testScript}=    Create Dictionary    type=STEP_BY_STEP    steps=${testSteps} 
        
    ${body}=    Create Dictionary    projectKey=${JIRA_PROJECT_KEY}     folder=${folder}    status=Approved      name=${testcaseName}    testScript=${testScript}  
    # Create Session    alias=Get_Jira_Request    url=${JIRA_URL}    auth=${JIRA_AUTH}    verify=True 
    ${response}=    Post Request    Get_Jira_Request    ${URI_CREATE_TESTCASE}       data=${body}    headers=${JIRA_HEADER}   
    
    Should Be Equal As Strings    ${response.status_code}    ${POST_SUCCESS_CODE}    

Create Jira Session
    Create Session    alias=Get_Jira_Request    url=${JIRA_URL}    auth=${JIRA_AUTH}    verify=True


Get All Test Cases From Folder As Dictionary
    [Arguments]        ${folder}
    ${testCaseItemDictionary}=    Set Variable    ${EMPTY}
    ${response}=    Get Request    Get_Jira_Request    ${URI_SEARCH_TESTCASE}?query=projectKey = "${JIRA_PROJECT_KEY}" AND folder = "${folder}"      
    Should Be Equal As Strings    ${response.status_code}    ${GET_SUCCESS_CODE}    
    
    #Process the returned result
     ${returnList}    Set Variable    ${response.json()}       
     
    ${testCaseDict}=    Create Dictionary    
     :FOR    ${item}    IN    @{returnList} 
     \    ${key}=    Get From Dictionary    ${item}    ${TEST_CASE_KEY}
     \    ${name}=    Get From Dictionary    ${item}    ${TEST_CASE_NAME}
     \    Set To Dictionary    ${testCaseDict}    ${name}=${key}
    
    [Return]    ${testCaseDict}
    

Get All Test Cases From Folder As List
    [Arguments]        ${folder}    ${contentType}
    ${testCaseItemDictionary}=    Set Variable    ${EMPTY}
    ${response}=    Get Request    Get_Jira_Request    ${URI_SEARCH_TESTCASE}?query=projectKey = "${JIRA_PROJECT_KEY}" AND folder = "${folder}"      
    Should Be Equal As Strings    ${response.status_code}    ${GET_SUCCESS_CODE}    
    
    #Process the returned result
     ${returnList}    Set Variable    ${response.json()}     
        
    ${testCaseList}=    Create List   
     :FOR    ${item}    IN    @{returnList} 
     \    ${addedItem}=    Get From Dictionary    ${item}    ${contentType}
     \    Append To List    ${testCaseList}    ${addedItem}      
    
    [Return]    ${testCaseList}
    

Check If Folder Existed
    [Arguments]        ${folder}
     
    ${response}=    Get Request    Get_Jira_Request    ${URI_SEARCH_TESTCASE}?query=projectKey = "${JIRA_PROJECT_KEY}" AND folder = "${folder}"      
    
    ${statusCode}=    Convert To Integer    ${response.status_code}    
    
    ${existed}=     Set Variable If     ${statusCode} == ${GET_SUCCESS_CODE}      ${True}      ${False}
     
    [Return]    ${existed}

    
Check And Delete All Test Cases From Folder 
    [Arguments]        ${folder}    
    ${testCaseKeyList}=     Get All Test Cases From Folder As List     ${folder}    ${TEST_CASE_KEY}  
     
     :FOR    ${testCaseKey}    IN    @{testCaseKeyList}     
    \    ${response}=    Delete Request    Get_Jira_Request    ${URI_DELETE_TESTCASE}/${testCaseKey}     
    \    Should Be Equal As Strings    ${response.status_code}    ${DELETE_SUCCESS_CODE} 

Create Test Run      
    [Arguments]    ${cycleName}    ${issueKey}    ${testResult}  
           
    ${body}=    Create Dictionary    projectKey=${JIRA_PROJECT_KEY}    name=${cycleName}    issueKey=${issueKey}    items=${testResult}
        
    ${response}=    Post Request    Get_Jira_Request    ${URI_CREATE_TESTRUN}       data=${body}    headers=${JIRA_HEADER}    

    Should Be Equal As Strings    ${response.status_code}    ${POST_SUCCESS_CODE} 
    [Return]   Get From Dictionary     ${response.json()}    key  
    
Collect Test Result
    [Arguments]    ${testCaseList}    ${testResultList}       
    ${testCaseKey}=    Get From Dictionary    ${testCaseList}     ${TEST NAME.strip()}  
    ${testResultDictionary}=    Create Dictionary    testCaseKey=${testCaseKey}    status=${TEST STATUS.title()}
    Append To List    ${testResultList}    ${testResultDictionary}   
          
   

Check And Create Folder
    [Arguments]    ${folderPath}    ${folderType}   
    ${folderFound}=    Check If Folder Existed    ${folderPath}
    Run Keyword If    ${folderFound}!= ${True}    Create Folder    ${folderPath}    ${folderType}      
     
 
Create Folder
   [Arguments]    ${folderPath}    ${folderType}      
     
    ${body}=    Create Dictionary    projectKey=${JIRA_PROJECT_KEY}     name=${folderPath}    type=${folderType}
     
    ${response}=    Post Request    Get_Jira_Request    ${URI_CREATE_TESTFOLDER}       data=${body}    headers=${JIRA_HEADER}   

    Should Be Equal As Strings    ${response.status_code}    ${POST_SUCCESS_CODE}    

         

     

