*** Settings ***
Resource    ../../resources.robot
Resource    ../../Common/Utils.robot
Resource    ../Utils/APICommonKeywords.robot
Resource    ../Utils/ConnectDatabase.robot

Library    Collections
Library    String

Suite Setup    Init Suite Setup
 
Suite Teardown    Init Suite Teardown

Test Teardown    Init Test Teardown 


*** Variables ***
# Assign this variable = ON to create test cycle & add to ticket
# else it will run test only
${TEST_CYCLE_RUNNER}=    ON

${TEST_CYCLE_NAME}=    [SC-155: Add Sale Channel] QC Check
${ISSUE_KEY}=    SC-155


${TEST_RESULT_LIST}=    ${EMPTY}
${TEST_SUITE_RESULT_LIST}=    ${EMPTY}
${TEST_CASE_LIST}=    ${EMPTY}

${CHANNEL_TYPE_NOT_EXIST}=    notExist
@{CHANNEL_TYPE_LIST}=    agent    online    showroom

@{CHANNEL_SELLER_ID_ACTIVE_LIST}=    1    2
@{CHANNEL_SELLER_ID_INACTIVE_LIST}=    3
${CHANNEL_SELLER_ID_NOT_EXIST}=    999

@{CHANNEL_STATUS_LIST}=    0    1
${CHANNEL_STATUS_ACTIVE}=    1
${CHANNEL_STATUS_INACTIVE}=    0
${CHANNEL_STATUS_NOT_EXIST}=    404

${RESPONSE_CHANNEL_NAME}=    name
${RESPONSE_CHANNEL_CODE}=    code
${RESPONSE_CHANNEL_ID}=    id
${RESPONSE_CHANNEL_ACTIVE}=    is_active
${RESPONSE_CHANNEL_RESULT}=    result

${MAX_LENGTH}    255
${COMPARE_STRING}=    0
${COMPARE_INT}=    1


*** Keywords ***
Init Suite Setup
    Run Keyword If    "${TEST_CYCLE_RUNNER}" == "${CYCLE_ON}"     Init Result List    
    Connect To The DataBase  
    
Init Suite Teardown  
    Run Keyword If    "${TEST_CYCLE_RUNNER}" == "${CYCLE_ON}"    Update Test Status    
    Close Database     

Init Test Teardown  
    Run Keyword If    "${TEST_CYCLE_RUNNER}" == "${CYCLE_ON}"    Get Test Result Of Each Test Case 

Init Result List
    Create Jira Session
    ${TEST_RESULT_LIST}=    Create List
    Set Suite Variable    ${TEST_RESULT_LIST}
    
    ${TEST_CASE_LIST}=    Get All Test Cases From Folder As Dictionary    ${FOLDER_ADD_SALE_CHANNEL}    
    Set Suite Variable    ${TEST_CASE_LIST}

Get Test Result Of Each Test Case    
    Collect Test Result    ${TEST_CASE_LIST}    ${TEST_RESULT_LIST}    
    
Update Test Status    
    Create Test Run    ${TEST_CYCLE_NAME}    ${ISSUE_KEY}    ${TEST_RESULT_LIST}    
    

Send Request    
    [Arguments]    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}    
    ${body} =    Create Dictionary    name=${channelName}    code=${channelCode}    type=${channelType}    seller_id=${sellerId}    is_active=${isActive}    
    
    ${response}=    Send Post Request    ${body}    ${URI_PATH_ADD_SALE_CHANNEL}
    [Return]    ${response}
    
Result Should Contain Equal Value
    [Arguments]    ${response}    ${key}    ${valueToCompate}    ${compareType}         
    ${dict}    Set Variable    ${response.json()}    
    ${responsResultDict}=    Get From Dictionary    ${dict}    ${RESPONSE_CHANNEL_RESULT}
    ${responseValue}=    Get From Dictionary    ${responsResultDict}    ${key}
    Run Keyword If    ${compareType}== ${COMPARE_STRING}    Should Be Equal As Strings    ${valueToCompate}    ${responseValue}            
    Run Keyword If    ${compareType}== ${COMPARE_INT}    Should Be Equal As Integers    ${valueToCompate}    ${responseValue} 
    
Get Value From Key
    [Arguments]    ${response}    ${key}            
    ${dict}    Set Variable    ${response.json()}    
    ${responsResultDict}=    Get From Dictionary    ${dict}    ${RESPONSE_CHANNEL_RESULT}
    ${responseValue}=    Get From Dictionary    ${responsResultDict}    ${key}
    
    [Return]    ${responseValue}
    
Delete A Channel By Id
    [Arguments]    ${response}     
    ${id}=    Get Value From Key    ${response}    ${RESPONSE_CHANNEL_ID}
    Delete A Record From Database By Id    ${TABLE_SALE_CHANNELS}    ${id}
    
    
*** Test Cases ***
TC01_Add A Valid Sale Channel Name    
    ${channelName}=    Generate Random String With Time    Kênh bán 
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    Result Should Be Success    ${response}
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_NAME}    ${channelName}    ${COMPARE_STRING}
    Delete A Channel By Id    ${response}
    
TC02_Sale Channel Name = null
    # ${channelName}=    ${null}
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${null}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    Result Should Be Bad Request    ${response}

TC03_Sale Channel Name = empty
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${EMPTY}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    Result Should Be Bad Request    ${response}

TC04_Sale Channel Name Containing Space Only    
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${SPACE * 4}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    Result Should Be Bad Request    ${response}

TC05_Sale Channel Name Containing Reduntdant Space: Leading, Following
    ${channelName}=    Generate Random String With Time    Kênh bán    
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${SPACE * 4}${channelName}${SPACE * 4}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    Result Should Be Success    ${response}
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_NAME}    ${channelName}    ${COMPARE_STRING}
    Delete A Channel By Id    ${response}

TC06_Sale Channel Name With Max Length
    ${channelName}=    Generate Random String With Time    Sale Channel 
    ${channelNameLength}=    Get Length    ${channelName}
    ${extraNameLength}=    Evaluate    ${MAX_LENGTH} - ${channelNameLength}
    ${extraName}=    Generate Random String    ${extraNameLength}    LETTERS    
    
    ${channelName}=    Catenate    SEPARATOR=    ${channelName}    ${extraName}    
    
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    
    Result Should Be Success    ${response}
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_NAME}    ${channelName}    ${COMPARE_STRING}
    Delete A Channel By Id    ${response}

TC07_Sale Channel Name Over Max Length
    ${channelName}=    Generate Random String With Time    Sale Channel 
    ${channelNameLength}=    Get Length    ${channelName}
    ${extraNameLength}=    Evaluate    ${MAX_LENGTH} - ${channelNameLength} + 1
    ${extraName}=    Generate Random String    ${extraNameLength}    LETTERS    
    
    ${channelName}=    Catenate    SEPARATOR=    ${channelName}    ${extraName}   
    
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    
    Result Should Be Bad Request    ${response}

TC08_Dupicated Sale Channel Name
    ${channelName}=    Generate Random String With Time    Kênh bán    
    ${channelCode1}=    Generate Random String With Time    CODE
    ${channelCode2}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response1}=    Send Request    ${channelName}    ${channelCode1}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response1}    
    
    # Send request again
    ${response2}=    Send Request    ${channelName}    ${channelCode2}    ${channelType}    ${sellerId}    ${isActive}    
    Result Should Be Bad Request    ${response2}
    
    Delete A Channel By Id    ${response1}


TC09_Dupicated Sale Channel Name - Uppercase - Lowercase
    ${channelName}=    Generate Random String With Time    Kênh bán    
    ${channelCode1}=    Generate Random String With Time    CODE
    ${channelCode2}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${channelName}=    Convert To Uppercase    ${channelName}
    ${response1}=    Send Request    ${channelName}    ${channelCode1}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response1}    
    
    # Send request with lower case
    ${channelName}=    Convert To Lowercase    ${channelName}
    ${response2}=    Send Request    ${channelName}    ${channelCode2}    ${channelType}    ${sellerId}    ${isActive}    
    Result Should Be Bad Request    ${response2}
    
    Delete A Channel By Id    ${response1}
    

TC10_Dupicated Sale Channel Name - Vietnamse With Accent - Without Accent
    ${tmpString}=    Generate Random String With Time    A    
    ${channelName1}=    Catenate    Kênh bán    ${tmpString}
    
    ${channelName2}=    Catenate    Kenh ban    ${tmpString}
    
    ${channelCode1}=    Generate Random String With Time    CODE
    ${channelCode2}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response1}=    Send Request    ${channelName1}    ${channelCode1}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response1}    
    
    ${response2}=    Send Request    ${channelName2}    ${channelCode2}    ${channelType}    ${sellerId}    ${isActive}    
    Result Should Be Bad Request    ${response2} 
    
    Delete A Channel By Id    ${response1}

TC11_Sale Channel Name Containing Special Characters
    ${channelName}=    Generate Random String With Time    ~!!#@###%$#^#^&*()_+    
    
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response}    
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_NAME}    ${channelName}    ${COMPARE_STRING}
    Delete A Channel By Id    ${response}
    
TC12_Sale Channel Code = null
    ${channelName}=    Generate Random String With Time    Kênh bán 
    # ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${null}    ${channelType}    ${sellerId}    ${isActive} 
    Result Should Be Bad Request    ${response}

TC13_Sale Channel Code = empty
    ${channelName}=    Generate Random String With Time    Kênh bán 
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${EMPTY}    ${channelType}    ${sellerId}    ${isActive} 
    Result Should Be Bad Request    ${response}

TC14_Sale Channel Code Containing Space Only    
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${SPACE * 4}    ${channelType}    ${sellerId}    ${isActive} 
    Result Should Be Bad Request    ${response}

TC15_Sale Channel Code Containing Reduntdant Space: Leading, Following
    ${channelName}=    Generate Random String With Time    Kênh bán    
    ${channelCode1}=    Generate Random String With Time    CODE
    ${channelCode2}=    Catenate    ${SPACE * 4}    ${channelCode1}    ${SPACE * 4}
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${channelCode2}    ${channelType}    ${sellerId}    ${isActive} 
    ${dict}    Set Variable    ${response.json()}    
    
    ${responsResultDict}=    Get From Dictionary    ${dict}    ${RESPONSE_CHANNEL_RESULT}
    
    Result Should Be Success    ${response}
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_CODE}    ${channelCode1}    ${COMPARE_STRING}
    Delete A Channel By Id    ${response}
    

TC16_Sale Channel Code With Max Length
    ${channelName}=    Generate Random String With Time    Kênh bán 
    
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelCodeLength}=    Get Length    ${channelCode}
    ${extraCodeLength}=    Evaluate    ${MAX_LENGTH} - ${channelCodeLength}
    ${extraCode}=    Generate Random String    ${extraCodeLength}    LETTERS    
    
    ${channelCode}=    Catenate    SEPARATOR=    ${channelCode}    ${extraCode}    
    
    
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    
    Result Should Be Success    ${response}
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_CODE}    ${channelCode}    ${COMPARE_STRING}
    Delete A Channel By Id    ${response}

TC17_Sale Channel Code Over Max Length
    ${channelName}=    Generate Random String With Time    Kênh bán 

    ${channelCode}=    Generate Random String With Time    CODE
    ${channelCodeLength}=    Get Length    ${channelCode}
    ${extraCodeLength}=    Evaluate    ${MAX_LENGTH} - ${channelCodeLength} + 1
    ${extraCode}=    Generate Random String    ${extraCodeLength}    LETTERS    
    
    ${channelCode}=    Catenate    SEPARATOR=    ${channelCode}    ${extraCode}   
    
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    
    Result Should Be Bad Request    ${response}

TC18_Dupicated Sale Channel Code
    ${channelName1}=    Generate Random String With Time    Kênh bán
    ${channelName2}=    Generate Random String With Time    Kênh bán    
    
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response1}=    Send Request    ${channelName1}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response1}    
    
    # Send request again
    ${response2}=    Send Request    ${channelName2}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}    
    Result Should Be Bad Request    ${response2}
    Delete A Channel By Id    ${response1}


TC19_Dupicated Sale Channel Code - Uppercase - Lowercase
    ${channelName1}=    Generate Random String With Time    Kênh bán    
    ${channelName2}=    Generate Random String With Time    Kênh bán    
    
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${channelName}=    Convert To Uppercase    ${channelCode}
    ${response1}=    Send Request    ${channelName1}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response1}    
    
    # Send request with lower case
    ${channelName}=    Convert To Lowercase    ${channelCode}
    ${response2}=    Send Request    ${channelName2}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}    
    Result Should Be Bad Request    ${response2}
    
    Delete A Channel By Id    ${response1}

TC20_Dupicated Sale Channel Code - Vietnamse With Accent - Without Accent
    ${tmpString}=    Generate Random String With Time    C
    
    ${channelName1}=    Generate Random String With Time    Kênh bán
    ${channelName2}=    Generate Random String With Time    Kênh bán
    
    ${channelCode1}=    Catenate    Mã Kênh    ${tmpString}
    ${channelCode2}=    Catenate    Ma Kenh    ${tmpString}
    
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response1}=    Send Request    ${channelName1}    ${channelCode1}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response1}    
    
    ${response2}=    Send Request    ${channelName2}    ${channelCode2}    ${channelType}    ${sellerId}    ${isActive}    
    Result Should Be Bad Request    ${response2}
     
    Delete A Channel By Id    ${response1}

TC21_Sale Channel Code Containing Special Characters
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    ~!!#@###%$#^#^&*()_+    
    
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response}  
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_CODE}    ${channelCode}    ${COMPARE_STRING}
    Delete A Channel By Id    ${response}

TC22_Sale Channel Type = null
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE    
    
    # ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${null}    ${sellerId}    ${isActive}
    Result Should Be Bad Request    ${response}    

TC23_Sale Channel Type = empty
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE    
    
    # ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${EMPTY}    ${sellerId}    ${isActive}
    Result Should Be Bad Request    ${response}    

TC24_Sale Channel Type Containing Space Only
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE    
    
    # ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${SPACE*5}    ${sellerId}    ${isActive}
    Result Should Be Bad Request    ${response}    

# TC25_Sale Channel Type Max Length
    # ${channelName}=    Generate Random String With Time    Kênh bán 

    # ${channelCode}=    Generate Random String With Time    CODE
    
    # ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    # ${channelTypeLength}=    Get Length    ${channelType}
    # ${extraTypeLength}=    Evaluate    ${MAX_LENGTH} - ${channelTypeLength}
    # ${extraType}=    Generate Random String    ${extraTypeLength}    LETTERS    
    
    # ${channelType}=    Catenate    SEPARATOR=    ${channelType}    ${extraType}    
    
    
    
    # ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    # ${sellerId}=    Convert To Integer    ${sellerId}
    
    # ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    # ${isActive}=    Convert To Integer    ${isActive}    

    # ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    
    # Result Should Be Success    ${response}

TC26_Sale Channel Type Over Max Length
    ${channelName}=    Generate Random String With Time    Kênh bán 

    ${channelCode}=    Generate Random String With Time    CODE
    
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    ${channelTypeLength}=    Get Length    ${channelType}
    ${extraTypeLength}=    Evaluate    ${MAX_LENGTH} - ${channelTypeLength}
    ${extraType}=    Generate Random String    ${extraTypeLength}    LETTERS    
    
    ${channelType}=    Catenate    SEPARATOR=    ${channelType}    ${extraType}       
    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive} 
    
    Result Should Be Bad Request    ${response}

TC27_Sale Channel Type Not Exist In Database
    ${channelName}=    Generate Random String With Time    Kênh bán 

    ${channelCode}=    Generate Random String With Time    CODE   
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request    ${channelName}    ${channelCode}    ${CHANNEL_TYPE_NOT_EXIST}    ${sellerId}    ${isActive} 
    
    Result Should Be Bad Request    ${response}

TC28_Sale Channel Seller = null
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    # ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    # ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${null}    ${isActive}
    Result Should Be Bad Request    ${response}    

TC29_Sale Channel Seller = empty
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    # ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    # ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${EMPTY}    ${isActive}
    Result Should Be Bad Request    ${response}    

TC30_Sale Channel Seller Inactive
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_INACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Bad Request    ${response}    

TC31_Sale Channel Seller Not Exist In Database
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
         
    ${sellerId}=    Convert To Integer    ${CHANNEL_SELLER_ID_NOT_EXIST}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Bad Request    ${response}    


TC32_Sale Channel Seller Is String
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
        
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Bad Request    ${response}  
    
TC33_Sale Channel Status Is String
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
        
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    # ${isActive}=    Convert To Integer    ${isActive}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Bad Request    ${response}  

TC34_Sale Channel Status Is Active
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
            
    ${isActive}=    Convert To Integer    ${CHANNEL_STATUS_ACTIVE}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response}  
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_ACTIVE}    ${isActive}    ${COMPARE_INT}
    Delete A Channel By Id    ${response}

TC35_Sale Channel Status Is Inactive
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
        
    ${isActive}=    Convert To Integer    ${CHANNEL_STATUS_INACTIVE}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Success    ${response}  
    Result Should Contain Equal Value    ${response}    ${RESPONSE_CHANNEL_ACTIVE}    ${isActive}    ${COMPARE_INT}
    Delete A Channel By Id    ${response}

TC36_Sale Channel Status Not Exist
    ${channelName}=    Generate Random String With Time    Kênh bán
    ${channelCode}=    Generate Random String With Time    CODE       
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId} 
    
    ${isActive}=    Convert To Integer    ${CHANNEL_STATUS_NOT_EXIST}    
    
    ${response}=    Send Request    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}
    Result Should Be Bad Request    ${response}  


