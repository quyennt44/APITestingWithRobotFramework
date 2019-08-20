*** Settings ***
Documentation    Test Seller Center REST API
Resource    ../resources.robot
Resource    ../Common/File.robot
    
*** Variables ***
${TEST_SUITE_FOLDER}    ${CURDIR}

*** Test Cases ***
Gerate File    
    Generate Test Case Name List    ${FOLDER_UPDATE_SALE_CHANNEL}    ${TEST_SUITE_FOLDER}/UpdateSaleChannel    Test
    
    
