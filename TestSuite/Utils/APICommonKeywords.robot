*** Settings ***
Resource    ../../resources.robot
Library  DateTime
Library    Collections
Library    RequestsLibrary

*** Variables ***
${ERROR_STATUS}    ERROR
${SUCCESS_STATUS}    SUCCESS
${SUCCESS_CODE}    200
${BAD_REQUEST_CODE}    400

${RETURN_CODE}    code


*** Keywords ***
Generate Random String With Time
    [Arguments]    ${string}
    ${CurrentDate}=    Get Current Date    result_format=%Y%m%d %H%M%S%f
    ${name}    Set Variable    ${string} ${CurrentDate}    
    [Return]    ${name}

Send Post Request
    [Arguments]    ${body}     ${uriPath}    
        
    ${header}=    Create Dictionary   Content-Type=application/json     Authorization=${APPLICATION_API_TOKEN}    
        
    Create Session    ConnectToApplicationURL    ${APPLICATION_API_URL}    verify=True 
    ${response}=    Post Request    ConnectToApplicationURL    ${uriPath}    data=${body}    headers=${header}      
    [Return]     ${response}
    
Send Put Request
    [Arguments]    ${body}     ${uriPath}    
        
    ${header}=    Create Dictionary   Content-Type=application/json     Authorization=${APPLICATION_API_TOKEN}    
        
    Create Session    ConnectToApplicationURL    ${APPLICATION_API_URL}    verify=True 
    ${response}=    Put Request    ConnectToApplicationURL    ${uriPath}    data=${body}    headers=${header}      
    [Return]     ${response}
    
Result Should Be Success
    [Arguments]    ${requestResponse}
    ${responseCode}=     convert to string    ${requestResponse.status_code} 
    ${dict}    Set Variable    ${requestResponse.json()}
    Dictionary Should Contain Value    ${dict}    ${SUCCESS_STATUS}    ignore_case=True    
    Should Be Equal    ${responseCode}    ${SUCCESS_CODE}      
    
Result Should Be Error
    [Arguments]    ${requestResponse}
    ${responseCode}=     convert to string    ${requestResponse.status_code} 
    ${dict}    Set Variable    ${requestResponse.json()}
    Dictionary Should Contain Value    ${dict}    ${ERROR_STATUS}    ignore_case=True      
    Should Be Equal    ${responseCode}    ${SUCCESS_CODE}
 
Result Should Be Bad Request
    [Arguments]    ${requestResponse}
    ${responseCode}=     convert to string    ${requestResponse.status_code} 
    # ${dict}    Set Variable    ${requestResponse.json()}    
    Should Be Equal    ${responseCode}    ${BAD_REQUEST_CODE}

            

 
  
    


    

