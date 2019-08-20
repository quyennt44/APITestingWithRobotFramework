*** Settings ***
Documentation                 Test our very first REST API
# Library                       HttpLibrary.HTTP
Library                         RequestsLibrary
 
*** Variables ***
${BASE_URL}               https://catalog-dev.phongvu.vn/
${product_id}    0 

${jira_url}    https://jira.teko.vn
${jira_user}	dung.bv
${jira_password}    123456a@
${jira_project_key}    SC

# ${headers}          Content-Type=application/json  Authorization=Basic ZHVuZy5idjoxMjM0NTZhQA==
 
*** Test Cases ***
# Put an invalid product id
  # Create session    Get_Product_Request    ${BASE_URL}
  
  # ${response}=    Get Request   Get_Product_Request    products/0/bundled_items
  # ${code}=    convert to string    ${response.status_code}    
  # Should Be Equal    ${code}    400  
  # Log To Console    "Status code:" + ${response.status_code}
  # Log To Console    ${response.content}
  
# Put a bundle id which contains no product
  # Create session    Get_Product_Request    ${BASE_URL}
  
  # ${response}=    Get Request   Get_Product_Request    products/900400/bundled_items
  

  # ${code}=    convert to string    ${response.status_code}    
  # Should Be Equal    ${code}    200  
  # Log To Console    "Status code:" + ${response.status_code}
  # Log To Console    ${response.content}
  
Get All Testcase Of SC Project
    # https://jira.teko.vn/rest/atm/1.0/testcase/search?query=projectKey%20=%20%22SC%22    
	# &{data}=    Create Dictionary   email=any.body@yourcorp.com 
    # &{auth}=    Create Dictionary   ${jira_user}      ${jira_password}
    # &{headers}=     Create Dictionary    Content-Type=application/json
	# Create Session    mysession    ${jira_url}  auth=${auth)  verify=${CERTDIR}/cacert.pem	debut=4
	# ${resp}=  Post Request  mysession  / 	headers=${headers}	data=${data} 	
	# Should Be Equal As Strings  ${resp.status_code}  200
	
     ${auth}=    Create List   ${jira_user}      ${jira_password}     
       
    Create session    alias=Get_Jira_Request        url=${jira_url}  auth=${auth}
  ${response}=    Get Request   Get_Jira_Request    /rest/atm/1.0/testcase/search?query=projectKey%20=%20%22SC%22    
  ${code}=    convert to string    ${response.status_code} 
  
  Log To Console    "Status code:" + ${response.status_code}
  Log To Console    ${response.content}
  Should Be Equal    ${code}    200  
  
