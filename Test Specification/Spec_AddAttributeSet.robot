*** Settings ***
Documentation    Test Seller Center REST API
Resource    ../resources.robot
Resource    ../Common/Utils.robot

Test Setup    Init Test Step List
Suite Setup    Suite Setup    ${folder}    ${TEST_CASE_FOLDER}


*** Variables ***
${folder}     /API Test/Add Attribute Set

*** Test Cases ***  

Delete Old Test Case
    Check And Delete All Test Cases From Folder    ${folder}
  
TC01_Add A Valid Attribute Set  
    Add Test Step    Put a valid attribute set name     New attribute set is added successfully   
    Complete Test Case And Add To Folder    ${folder}   
 
TC02_Attribute Set Name = null    
    Add Test Step    Put attribute set name = null     The attribute set is failed to add
    Complete Test Case And Add To Folder    ${folder} 
    
TC03_Attribute Set Name = empty   
    Add Test Step    Put request without filling name value     The attribute set is failed to add
    Complete Test Case And Add To Folder    ${folder}

TC04_Attribute Set Name Containing Space Only
    Add Test Step    Put attribute set name containing space only     The attribute set is failed to add
    Complete Test Case And Add To Folder    ${folder}
        
TC05_Attribute Set Name Containing Reduntdant Space: Leading, Following, Between  
    Add Test Step    Put attribute set name containing some redundant spaces     The attribute set is added, the reduntdant spaces are cut out
    Complete Test Case And Add To Folder    ${folder} 
    
TC06_Attribute Set Name 255 Characters    
    Add Test Step    Put attribute set name containing 255 character     The attribute set is added successfully
    Complete Test Case And Add To Folder    ${folder}
    
TC07_Attribute Set Name 256 Characters
    Add Test Step    Put attribute set name containing 256 character     The attribute set is failed to add
    Complete Test Case And Add To Folder    ${folder}
    
TC08_Dupicated Attribute Set    
    Add Test Step    Put attribute set name duplicated with an existed one     The attribute set is failed to add
    Complete Test Case And Add To Folder    ${folder}
    
TC09_Dupicated Attribute Set - Uppercase - Lowercase    
    Add Test Step    Put attribute set name duplicated with an existed one, one in uppercase, one in lower case     The attribute set is failed to add
    Complete Test Case And Add To Folder    ${folder}
    
TC10_Dupicated Attribute Set - Vietnamse With Accent - Without Accent    
    Add Test Step    Put attribute set name duplicated with an existed one, one With Accent, one Without Accent     The attribute set is failed to add
    Complete Test Case And Add To Folder    ${folder}
    
TC11_Attribute Set Containing Special Characters    
    Add Test Step    Put attribute set name containing special characters     The attribute set is failed to add
    Complete Test Case And Add To Folder    ${folder}


    

