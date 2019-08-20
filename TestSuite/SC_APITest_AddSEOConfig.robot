*** Settings ***
Resource    ../resources.robot
Documentation      Test Seller Center REST API
...                Test API To Add A New SEO Config To Attribute Set
...                UI Step: Go to List of Attribute Set -> Select an attribute set -> Select Config SEO -> Add A New Config Line -> Save

    
Library            RequestsLibrary
 
*** Variables ***
${set_id}    null
${URL_PATH}    /attribute_sets/${set_id}/config

*** Keywords ***

 
*** Test Cases ***    
# Add A New SEO Config
    
    # ${config_default_id} =    Create Dictionary
    # ${step1}=    Create Dictionary    description=-Description From Robot<br/> -Description From Robot line 2<br/> -Description From Robot line3    expectedResult=Expected Result From Robot
    # ${step2}=    Create Dictionary    description=Description From Robot 2    expectedResult=Expected Result From Robot 2
    # ${step}=    Create List    ${step1}    ${step2}

    # ${testScript}=    Create Dictionary    type=STEP_BY_STEP    steps=${step}

    # ${body}=    create dictionary    projectKey=SC    name=New TestCase By Robot Framework    testScript=${testScript}
    
    # # Create session    alias=Get_Jira_Request    url=${JIRA_URL}    auth=${AUTH}
    # # ${response}=    Post Request    Get_Jira_Request    /rest/atm/1.0/testcase    data=${body}    headers=${header}    
    # ${code}=    convert to string    ${response.status_code} 
    # Log To Console    "Body:" + ${body}
    # Log To Console    "Status code:" + ${response.status_code}
    # Log To Console    ${response.content}
    # Should Be Equal    ${code}    201    

    
