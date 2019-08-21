*** Settings ***
Documentation    Test Seller Center REST API
Resource    ../../resources.robot

Library           DatabaseLibrary


*** Keywords ***

Connect To The DataBase
    Connect To Database    ${DatabaseType}    ${DatabaseName}    ${Username}    ${Password}    ${DatabaseHost}    ${Port}

Delete A Record From Database By Id
    [Arguments]    ${tableName}    ${id}
    Execute Sql String  Delete from ${tableName} where id = ${id};
    
Close Database
    Disconnect From Database
    


         
     

