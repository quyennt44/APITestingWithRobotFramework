*** Settings ***
Resource    ../../resources.robot
Resource    AddAttributeSetKeywords.robot
Resource    ../../Common/Utils.robot

Library     Collections

Suite Setup    Init Result List
 
Suite Teardown    Update Test Status

Test Teardown   Get Test Result Of Each Test Case 


*** Variables ***
${TEST_RESULT_LIST}=    ${EMPTY}
${TEST_SUITE_RESULT_LIST}=   ${EMPTY}
${TEST_CASE_LIST}=   ${EMPTY}

${folder}     /API Test/Add Attribute Set

${TEST_RUN_NAME}=    Test
${ISSUE_KEY}=    SC-137


*** Keywords ***
Init Result List
    Create Jira Session
    ${TEST_RESULT_LIST}=   Create List
    Set Suite Variable      ${TEST_RESULT_LIST}
    
    ${TEST_CASE_LIST}= 	Get All Test Cases From Folder    ${folder}    
    Set Suite Variable      ${TEST_CASE_LIST}

Get Test Result Of Each Test Case    
    Collect Test Result    ${TEST_CASE_LIST}    ${TEST_RESULT_LIST}  
    
Update Test Status    
    Create Test Run    ${TEST_RUN_NAME}    ${ISSUE_KEY}    ${TEST_RESULT_LIST}    

*** Test Cases ***
TC01_Add A Valid Attribute Set     
    ${attributeSetName}=    Generate Random Attribute Name    
    ${response}=     Send Request    ${attributeSetName}
    Result Should Be Success    ${response}
      
    
TC02_Attribute Set Name = null    
    ${response}=     Send Request    ${null}
    Result Should Be Bad Request    ${response} 
    
    
TC03_Attribute Set Name = empty    
   ${response}=     Send Request      ${EMPTY} 
   Result Should Be Bad Request    ${response} 
   
TC04_Attribute Set Name Containing Space Only              
    ${response}=     Send Request    ${SPACE * 4}
    Result Should Be Error    ${response}
    
TC05_Attribute Set Name Containing Reduntdant Space: Leading, Following, Between  
    ${attributeSetName}=    Generate Random Attribute Name    
    ${response}=     Send Request    ${SPACE * 4}${attributeSetName}${SPACE * 4}
    Result Should Be Success    ${response}       
    # Attribute Set Name should be trim()
    ${dict}    Set Variable    ${response.json()}      
    ${responseName}=    Get From Dictionary    ${dict}    name
    Should Be Equal As Strings    ${attributeSetName}    ${responseName}
    
   

    


