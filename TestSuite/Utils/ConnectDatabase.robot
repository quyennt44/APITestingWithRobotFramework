*** Settings ***
Documentation    Test Seller Center REST API
Resource    ../../resources.robot

Library           DatabaseLibrary


*** Keywords ***

Connect to the DataBase
    Connect to Database    ${DatabaseType}    ${DatabaseName}    ${Username}    ${Password}    ${DatabaseHost}    ${Port}

Delete A Record
    [Arguments]    ${tableName}    ${condition}
    @{S}  Execute Sql String  Delete from ${tableName} where ${condition};


         
     

