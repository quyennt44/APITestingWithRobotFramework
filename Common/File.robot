*** Settings ***
Documentation    Test Seller Center REST API
Resource    ../resources.robot
Resource    Utils.robot
Library    OperatingSystem    


*** Keywords ***
Generate Test Case Name List
    [Arguments]    ${inputFolder}    ${outputFolder}    ${fileName}
    Create Jira Session
    ${testCaseNameList}=    Get All Test Cases From Folder As List    ${inputfolder}    ${TEST_CASE_NAME}    
    Create File    ${outputFolder}/${fileName}.robot
    :FOR    ${testCaseName}    IN    @{testCaseNameList}    
    \    Append To File    ${outputFolder}/${fileName}.robot    ${testCaseName}\n\n\n    
        
 
    
    
