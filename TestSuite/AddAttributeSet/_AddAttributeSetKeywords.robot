*** Settings ***
Resource    ../../resources.robot


Library  DateTime
Library    Collections
Library    RequestsLibrary

*** Variables ***
${URI_PATH}    /attribute_sets


${ERROR_STATUS}    error
${SUCCESS_STATUS}    success
${SUCCESS_CODE}    200
${BAD_REQUEST_CODE}    400


*** Keywords ***
Send Post Request
    [Arguments]    ${attributeSetName}
    ${body} =  Create Dictionary    name=${attributeSetName}   
        
    ${header}=    Create Dictionary   Content-Type=application/json     Authorization=${APPLICATION_API_TOKEN}    
        
    Create Session    ConnectToApplicationURL    ${APPLICATION_API_URL}    verify=True 
    ${response}=    Post Request    ConnectToApplicationURL    ${URI_PATH}    data=${body}    headers=${header}      
    [Return]     ${response}
    
Generate Random Attribute Name
    ${CurrentDate}=  Get Current Date  result_format=%Y%m%d %H%M%S%f
    ${name}	    Set Variable    Bộ thuộc tính ${CurrentDate}  
    [Return]     ${name}
    
Result Should Be Success
    [Arguments]    ${requestResponse}
    ${responseCode}=     convert to string    ${requestResponse.status_code} 
    ${dict}    Set Variable    ${requestResponse.json()}
    Dictionary Should Contain Value    ${dict}    ${SUCCESS_STATUS}  
    Should Be Equal    ${responseCode}    ${SUCCESS_CODE}      
    
Result Should Be Error
    [Arguments]    ${requestResponse}
    ${responseCode}=     convert to string    ${requestResponse.status_code} 
    ${dict}    Set Variable    ${requestResponse.json()}
    Dictionary Should Contain Value    ${dict}    ${ERROR_STATUS}
    Should Be Equal    ${responseCode}    ${SUCCESS_CODE}
 
Result Should Be Bad Request
    [Arguments]    ${requestResponse}
    ${responseCode}=     convert to string    ${requestResponse.status_code} 
    # ${dict}    Set Variable    ${requestResponse.json()}    
    Should Be Equal    ${responseCode}    ${BAD_REQUEST_CODE}
    
 
  
    


    

