*** Settings ***
Resource    ../../resources.robot
Resource    ../../Common/Utils.robot
Resource    ../Utils/APICommonKeywords.robot

Library    Collections
Library    String

Suite Setup    Init Suite Setup
 
Suite Teardown    Init Suite Teardown

Test Teardown    Init Test Teardown 


*** Variables ***
# Assign this variable = ON to create test cycle & add to ticket
# else it will run test only
${TEST_CYCLE_RUNNER}=    ON

${TEST_CYCLE_NAME}=    [SC-158: Update Sale Channel] QC Check
${ISSUE_KEY}=    SC-158


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
${RESPONSE_CHANNEL_TYPE}=    type
${RESPONSE_CHANNEL_SELLER_ID}=    seller_id
${RESPONSE_CHANNEL_IS_ACTIVE}=    is_active
${RESPONSE_CHANNEL_RESULT}=    result

${MAX_LENGTH}    255


*** Keywords ***
Init Suite Setup
    Run Keyword If    "${TEST_CYCLE_RUNNER}" == "${CYCLE_ON}"     Init Result List      
    
Init Suite Teardown  
    Run Keyword If    "${TEST_CYCLE_RUNNER}" == "${CYCLE_ON}"    Update Test Status         

Init Test Teardown  
    Run Keyword If    "${TEST_CYCLE_RUNNER}" == "${CYCLE_ON}"    Get Test Result Of Each Test Case 
        

Init Result List
    Create Jira Session
    ${TEST_RESULT_LIST}=    Create List
    Set Suite Variable    ${TEST_RESULT_LIST}
    
    ${TEST_CASE_LIST}=    Get All Test Cases From Folder As Dictionary    ${FOLDER_UPDATE_SALE_CHANNEL}    
    Set Suite Variable    ${TEST_CASE_LIST}

Get Test Result Of Each Test Case    
    Collect Test Result    ${TEST_CASE_LIST}    ${TEST_RESULT_LIST}    
    
Update Test Status    
    Create Test Run    ${TEST_CYCLE_NAME}    ${ISSUE_KEY}    ${TEST_RESULT_LIST}    
    

Send Request To Create Channel    
    [Arguments]    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}    
    ${body} =    Create Dictionary    ${RESPONSE_CHANNEL_NAME}=${channelName}    ${RESPONSE_CHANNEL_CODE}=${channelCode}    ${RESPONSE_CHANNEL_TYPE}=${channelType}    
    ...    ${RESPONSE_CHANNEL_SELLER_ID}=${sellerId}    ${RESPONSE_CHANNEL_IS_ACTIVE}=${isActive}    
    
    ${response}=    Send Post Request    ${body}    ${URI_PATH_ADD_SALE_CHANNEL}
    [Return]    ${response}
 
    
Send Request To Update Channel    
    [Arguments]    ${requestBody}    ${channelId}    
    ${response}=    Send Put Request    ${requestBody}    ${URI_PATH_UPDATE_SALE_CHANNEL}/${channelId}
    [Return]    ${response}
    
Create Sale Channel
    ${channelName}=    Generate Random String With Time    Sale Channel 
    ${channelCode}=    Generate Random String With Time    CODE
    ${channelType}=    Evaluate    random.choice($CHANNEL_TYPE_LIST)    random    
    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random    
    ${isActive}=    Convert To Integer    ${isActive}    

    ${response}=    Send Request To Create Channel    ${channelName}    ${channelCode}    ${channelType}    ${sellerId}    ${isActive}    
    Result Should Be Success    ${response}
    ${responseDictionary}    Set Variable    ${response.json()}
    ${channelDictionary}=    Get From Dictionary    ${responseDictionary}    ${RESPONSE_CHANNEL_RESULT}
    # Sleep    5s    
    [Return]    ${channelDictionary}    
    
Update Channel Value
    [Arguments]    ${channelDictionary}    ${keyToUpdate}    ${valueToUpdate}
    Set To Dictionary    ${channelDictionary}    ${keyToUpdate}    ${valueToUpdate}
    Remove From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}    
    [Return]    ${channelDictionary}

    
*** Test Cases ***
TC01_Update A Valid Sale Channel Name    
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName}=    Generate Random String With Time    Kênh bán updated 
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Success    ${response}

TC02_Sale Channel Name = null
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    # ${channelName}=    Generate Random String With Time    Kênh bán updated 
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${null}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}

TC03_Sale Channel Name = empty
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    # ${channelName}=    Generate Random String With Time    Kênh bán updated 
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${EMPTY}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}

TC04_Sale Channel Name Containing Space Only    
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName}=    Catenate    ${SPACE*3}    ${SPACE*4} 
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}

TC05_Sale Channel Name Containing Reduntdant Space: Leading, Following
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName1}=    Generate Random String With Time    Sale Channel 
    ${channelName2}=    Catenate    ${SPACE*3}    ${channelName1}    ${SPACE*5}    
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName2}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Success    ${response}
    
    ${dict}    Set Variable    ${response.json()}    
    ${responsResultDict}=    Get From Dictionary    ${dict}    ${RESPONSE_CHANNEL_RESULT}
    ${responseName}=    Get From Dictionary    ${responsResultDict}    ${RESPONSE_CHANNEL_NAME}
    
    # Channel Name should be trim()
    Should Be Equal As Strings    ${channelName1}    ${responseName}

TC06_Sale Channel Name With Max Length
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName}=    Generate Random String With Time    Sale Channel 
    ${channelNameLength}=    Get Length    ${channelName}
    ${extraNameLength}=    Evaluate    ${MAX_LENGTH} - ${channelNameLength}
    ${extraName}=    Generate Random String    ${extraNameLength}    LETTERS    
    
    ${channelName}=    Catenate    SEPARATOR=    ${channelName}    ${extraName}    
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    
    
    Result Should Be Success    ${response}

TC07_Sale Channel Name Over Max Length
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName}=    Generate Random String With Time    Sale Channel 
    ${channelNameLength}=    Get Length    ${channelName}
    ${extraNameLength}=    Evaluate    ${MAX_LENGTH} - ${channelNameLength} + 1
    ${extraName}=    Generate Random String    ${extraNameLength}    LETTERS    
    
    ${channelName}=    Catenate    SEPARATOR=    ${channelName}    ${extraName}    
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    
    
    Result Should Be Bad Request    ${response}

TC08_Dupicated Sale Channel Name
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName}=    Generate Random String With Time    Kênh bán updated 
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Success    ${response}
    
    # Send request again
    ${channelDictionary2}=    Create Sale Channel
    ${channelId2}=    Get From Dictionary    ${channelDictionary2}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary2}=    Update Channel Value    ${channelDictionary2}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response2}=    Send Request To Update Channel    ${channelDictionary2}    ${channelId2}    
    Result Should Be Bad Request    ${response2}


TC09_Dupicated Sale Channel Name - Uppercase - Lowercase
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName}=    Generate Random String With Time    Sale Channel updated 
    ${channelName}=    Convert To Uppercase    ${channelName}
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Success    ${response}
    
    # Send request again
    ${channelDictionary2}=    Create Sale Channel
    ${channelId2}=    Get From Dictionary    ${channelDictionary2}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelName2}=    Convert To Lowercase    ${channelName} 
    ${channelDictionary2}=    Update Channel Value    ${channelDictionary2}    ${RESPONSE_CHANNEL_NAME}    ${channelName2}
    
    ${response2}=    Send Request To Update Channel    ${channelDictionary2}    ${channelId2}    
    Result Should Be Bad Request    ${response2}
    

TC10_Dupicated Sale Channel Name - Vietnamse With Accent - Without Accent    
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${tmpString}=    Generate Random String With Time    ABC 
    
    ${channelName}=    Catenate    Kênh bán updated    ${tmpString} 
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Success    ${response}    
    

    #Create a sale channel
    ${channelDictionary2}=    Create Sale Channel
    ${channelId2}=    Get From Dictionary    ${channelDictionary2}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName2}=    Catenate    Kenh ban updated    ${tmpString}
    
    ${channelDictionary2}=    Update Channel Value    ${channelDictionary2}    ${RESPONSE_CHANNEL_NAME}    ${channelName2}
    
    ${response2}=    Send Request To Update Channel    ${channelDictionary2}    ${channelId2}    
    Result Should Be Bad Request    ${response2}    


TC11_Sale Channel Name Containing Special Characters
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelName}=    Generate Random String With Time    ~!!#@###%$#^#^&*()_+    
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelName}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Success    ${response}
    
TC12_Sale Channel Code = null
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${null}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Bad Request    ${response}

TC13_Sale Channel Code = empty
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${EMPTY}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Bad Request    ${response}

TC14_Sale Channel Code Containing Space Only    
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelCode}=    Catenate    ${SPACE*3}    ${SPACE*4} 
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${channelCode}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Bad Request    ${response}

TC15_Sale Channel Change Code Should Be Not Allowed
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelCode}=    Generate Random String With Time    Code updated
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${channelCode}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Bad Request    ${response}    

# TC15_Sale Channel Code Containing Reduntdant Space: Leading, Following
    # #Create a sale channel
    # ${channelDictionary}=    Create Sale Channel
    # ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    # #Update
    # ${channelCode1}=    Generate Random String With Time    Code updated 
    # ${channelCode2}=    Catenate    ${SPACE*3}    ${channelCode1}    ${SPACE*5}    
    
    # ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${channelCode2}
    
    # ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    # Result Should Be Success    ${response}
    
    # ${dict}    Set Variable    ${response.json()}    
    # ${responsResultDict}=    Get From Dictionary    ${dict}    ${RESPONSE_CHANNEL_RESULT}
    # ${responseCode}=    Get From Dictionary    ${responsResultDict}    ${RESPONSE_CHANNEL_Code}
    
    # # Channel Code should be trim()
    # Should Be Equal As Strings    ${channelCode1}    ${responseCode}

# TC16_Sale Channel Code With Max Length
    # #Create a sale channel
    # ${channelDictionary}=    Create Sale Channel
    # ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    # #Update
    # ${channelCode}=    Generate Random String With Time    Code updated 
    # ${channelCodeLength}=    Get Length    ${channelCode}
    # ${extraCodeLength}=    Evaluate    ${MAX_LENGTH} - ${channelCodeLength}
    # ${extraCode}=    Generate Random String    ${extraCodeLength}    LETTERS    
    
    # ${channelCode}=    Catenate    SEPARATOR=    ${channelCode}    ${extraCode}    
    
    # ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${channelCode}
    
    # ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}        
    
    # Result Should Be Success    ${response}

# TC17_Sale Channel Code Over Max Length
    # #Create a sale channel
    # ${channelDictionary}=    Create Sale Channel
    # ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    # #Update
    # ${channelCode}=    Generate Random String With Time    Code updated 
    # ${channelCodeLength}=    Get Length    ${channelCode}
    # ${extraCodeLength}=    Evaluate    ${MAX_LENGTH} - ${channelCodeLength} + 1
    # ${extraCode}=    Generate Random String    ${extraCodeLength}    LETTERS    
    
    # ${channelCode}=    Catenate    SEPARATOR=    ${channelCode}    ${extraCode}    
    
    # ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_NAME}    ${channelCode}
    
    # ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    
    
    # Result Should Be Bad Request    ${response}

# TC18_Dupicated Sale Channel Code
    # #Create a sale channel
    # ${channelDictionary}=    Create Sale Channel
    # ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    # #Update
    # ${channeCode}=    Generate Random String With Time    Code updated 
    
    # ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${channeCode}
    
    # ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    # Result Should Be Success    ${response}
    
    # # Send request again
    # ${channelDictionary2}=    Create Sale Channel
    # ${channelId2}=    Get From Dictionary    ${channelDictionary2}    ${RESPONSE_CHANNEL_ID}
    
    # #Update    
    # ${channelDictionary2}=    Update Channel Value    ${channelDictionary2}    ${RESPONSE_CHANNEL_CODE}    ${channeCode}
    
    # ${response2}=    Send Request To Update Channel    ${channelDictionary2}    ${channelId2}    
    # Result Should Be Bad Request    ${response2}

# TC19_Dupicated Sale Channel Code - Uppercase - Lowercase
    # #Create a sale channel
    # ${channelDictionary}=    Create Sale Channel
    # ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    # #Update
    # ${channelCode}=    Generate Random String With Time    Code updated 
    # ${channelCode}=    Convert To Uppercase    ${channelCode}
    
    # ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${channelCode}
    
    # ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    # Result Should Be Success    ${response}
    
    # # Send request again
    # ${channelDictionary2}=    Create Sale Channel
    # ${channelId2}=    Get From Dictionary    ${channelDictionary2}    ${RESPONSE_CHANNEL_ID}
    
    # #Update    
    # ${channelCode2}=    Convert To Lowercase    ${channelCode} 
    # ${channelDictionary2}=    Update Channel Value    ${channelDictionary2}    ${RESPONSE_CHANNEL_CODE}    ${channelCode2}
    
    # ${response2}=    Send Request To Update Channel    ${channelDictionary2}    ${channelId2}    
    # Result Should Be Bad Request    ${response2}
    
    

# TC20_Dupicated Sale Channel Code - Vietnamse With Accent - Without Accent
    # #Create a sale channel
    # ${channelDictionary}=    Create Sale Channel
    # ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    # #Update
    # ${tmpString}=    Generate Random String With Time    ABC 
    
    # ${channelCode}=    Catenate    Mã kênh updated    ${tmpString} 
    
    # ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${channelCode}
    
    # ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    # Result Should Be Success    ${response}    
    

    # #Create a sale channel
    # ${channelDictionary2}=    Create Sale Channel
    # ${channelId2}=    Get From Dictionary    ${channelDictionary2}    ${RESPONSE_CHANNEL_ID}
    
    # #Update
    # ${channelCode2}=    Catenate    Ma kenh updated    ${tmpString}
    
    # ${channelDictionary2}=    Update Channel Value    ${channelDictionary2}    ${RESPONSE_CHANNEL_CODE}    ${channelCode2}
    
    # ${response2}=    Send Request To Update Channel    ${channelDictionary2}    ${channelId2}    
    # Result Should Be Bad Request    ${response2}    


# TC21_Sale Channel Code Containing Special Characters
    # #Create a sale channel
    # ${channelDictionary}=    Create Sale Channel
    # ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    # #Update
    # ${channelCode}=    Generate Random String With Time    ~!!#@###%$#^#^&*()_+    
    
    # ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_CODE}    ${channelCode}
    
    # ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    # Result Should Be Success    ${response}


TC22_Sale Channel Type = null
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_TYPE}    ${null}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Bad Request    ${response}    

TC23_Sale Channel Type = empty
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_TYPE}    ${EMPTY}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Bad Request    ${response}

TC24_Sale Channel Type Containing Space Only
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelType}=    Catenate    ${SPACE*3}    ${SPACE*4} 
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_TYPE}    ${channelType}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Bad Request    ${response}


TC26_Sale Channel Type Over Max Length
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update
    ${channelType}=    Generate Random String With Time    Sale Channel 
    ${channelTypeLength}=    Get Length    ${channelType}
    ${extraTypeLength}=    Evaluate    ${MAX_LENGTH} - ${channelTypeLength} + 1
    ${extraType}=    Generate Random String    ${extraTypeLength}    LETTERS    
    
    ${channelType}=    Catenate    SEPARATOR=    ${channelType}    ${extraType}    
    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_TYPE}    ${channelType}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    
    
    Result Should Be Bad Request    ${response}

TC27_Sale Channel Type Not Exist In Database
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_TYPE}    ${CHANNEL_TYPE_NOT_EXIST}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    
    Result Should Be Bad Request    ${response}

TC28_Sale Channel Seller = null
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_SELLER_ID}    ${null}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}

TC29_Sale Channel Seller = empty
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_SELLER_ID}    ${EMPTY}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}

TC30_Sale Channel Seller Inactive
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_INACTIVE_LIST)    random 
    ${sellerId}=    Convert To Integer    ${sellerId}
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_SELLER_ID}    ${sellerId}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}    
    
TC31_Sale Channel Seller Not Exist In Database
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_SELLER_ID}    ${CHANNEL_SELLER_ID_NOT_EXIST}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}    
    
TC32_Sale Channel Seller Is String
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${sellerId}=    Evaluate    random.choice($CHANNEL_SELLER_ID_ACTIVE_LIST)    random 
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_SELLER_ID}    ${sellerId}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}    
    
TC33_Sale Channel Status Is String
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${isActive}=    Evaluate    random.choice($CHANNEL_STATUS_LIST)    random   
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_IS_ACTIVE}    ${isActive}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Bad Request    ${response}    
    

TC34_Sale Channel Status Is Active
    #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${isActive}=    Convert To Integer    ${CHANNEL_STATUS_ACTIVE}
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_IS_ACTIVE}    ${isActive}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Success    ${response}    

TC35_Sale Channel Status Is Inactive
   #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
     ${isActive}=    Convert To Integer    ${CHANNEL_STATUS_INACTIVE}
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_IS_ACTIVE}    ${isActive}
    
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId} 
    Result Should Be Success    ${response}      

TC36_Sale Channel Status Not Exist
   #Create a sale channel
    ${channelDictionary}=    Create Sale Channel
    ${channelId}=    Get From Dictionary    ${channelDictionary}    ${RESPONSE_CHANNEL_ID}
    
    #Update    
    ${channelDictionary}=    Update Channel Value    ${channelDictionary}    ${RESPONSE_CHANNEL_IS_ACTIVE}    ${CHANNEL_STATUS_NOT_EXIST}
    
    ${response}=    Send Request To Update Channel    ${channelDictionary}    ${channelId}    
    Result Should Be Bad Request    ${response}    



