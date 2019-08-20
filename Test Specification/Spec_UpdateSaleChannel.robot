*** Settings ***
Documentation    Test Seller Center REST API
Resource    ../resources.robot
Resource    ../Common/Utils.robot

Test Setup    Init Test Step List
Suite Setup    Suite Setup    ${FOLDER_UPDATE_SALE_CHANNEL}    ${TEST_CASE_FOLDER}


*** Test Cases ***  

Delete Old Test Case
    Check And Delete All Test Cases From Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
  
TC01_Update A Valid Sale Channel Name
    Add Test Step    Put a valid sale channel name     Sale channel name is added   
    Add Test Step    Put a valid sale channel code     Sale channel code is added
    Add Test Step    Put a valid sale channel type     Sale channel type is added
    Add Test Step    Put a valid sale channel seller     Sale channel seller is added
    Add Test Step    Put a valid sale channel status     Sale channel status is added
    Add Test Step    Commit the request                A new sale channel is created successfully
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}   
 
TC02_Sale Channel Name = null    
    Add Test Step    Put sale channel name = null     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL} 
    
TC03_Sale Channel Name = empty   
    Add Test Step    Put request without filling name value     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}

TC04_Sale Channel Name Containing Space Only
    Add Test Step    Put sale channel name containing space only     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
        
TC05_Sale Channel Name Containing Reduntdant Space: Leading, Following
    Add Test Step    Put sale channel name containing some redundant spaces     The sale channel is added, the reduntdant spaces are cut out
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL} 
    
TC06_Sale Channel Name With Max Length    
    Add Test Step    Put sale channel name containing 255 character     The sale channel is updated successfully
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC07_Sale Channel Name Over Max Length
    Add Test Step    Put sale channel name containing 256 character     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC08_Dupicated Sale Channel Name    
    Add Test Step    Put sale channel name duplicated with an existed one     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC09_Dupicated Sale Channel Name - Uppercase - Lowercase    
    Add Test Step    Put sale channel name duplicated with an existed one, one in uppercase, one in lower case     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC10_Dupicated Sale Channel Name - Vietnamse With Accent - Without Accent    
    Add Test Step    Put sale channel name duplicated with an existed one, one With Accent, one Without Accent     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC11_Sale Channel Name Containing Special Characters    
    Add Test Step    Put sale channel name containing special characters     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
TC12_Sale Channel Code = null    
    Add Test Step    Put sale channel code = null     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL} 
    
TC13_Sale Channel Code = empty   
    Add Test Step    Put request without filling name value     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}

TC14_Sale Channel Code Containing Space Only
    Add Test Step    Put sale channel code containing space only     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC15_Sale Channel Change Code Should Be Not Allowed
    Add Test Step    Put a valid sale channel code     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}        
# TC15_Sale Channel Code Containing Reduntdant Space: Leading, Following
    # Add Test Step    Put sale channel code containing some redundant spaces     The sale channel is added, the reduntdant spaces are cut out
    # Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL} 
    
# TC16_Sale Channel Code With Max Length    
    # Add Test Step    Put sale channel code containing 255 character     The sale channel is updated successfully
    # Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
# TC17_Sale Channel Code Over Max Length
    # Add Test Step    Put sale channel code containing 256 character     The sale channel is failed to update
    # Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
# TC18_Dupicated Sale Channel Code    
    # Add Test Step    Put sale channel code duplicated with an existed one     The sale channel is failed to update
    # Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
# TC19_Dupicated Sale Channel Code - Uppercase - Lowercase    
    # Add Test Step    Put sale channel code duplicated with an existed one, one in uppercase, one in lower case     The sale channel is failed to update
    # Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
# TC20_Dupicated Sale Channel Code - Vietnamse With Accent - Without Accent    
    # Add Test Step    Put sale channel code duplicated with an existed one, one With Accent, one Without Accent     The sale channel is failed to update
    # Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
# TC21_Sale Channel Code Containing Special Characters        
    # Add Test Step    Put sale channel code containing special characters     The sale channel is updated successfully
    # Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC22_Sale Channel Type = null    
    Add Test Step    Put sale channel code = null     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL} 
    
TC23_Sale Channel Type = empty   
    Add Test Step    Put request without filling name value     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}

TC24_Sale Channel Type Containing Space Only
    Add Test Step    Put sale channel code containing space only     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}    
  
# TC25_Sale Channel Type Max Length    
    # Add Test Step    Put sale channel code containing 255 character     The sale channel is updated successfully
    # Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC26_Sale Channel Type Over Max Length
    Add Test Step    Put sale channel type containing 256 character     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC27_Sale Channel Type Not Exist In Database
    Add Test Step    Put sale channel type which not exist in database    The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC28_Sale Channel Seller = null    
    Add Test Step    Put sale channel seller = null     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL} 
    
TC29_Sale Channel Seller = empty   
    Add Test Step    Put request without filling name value     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}

    
TC30_Sale Channel Seller Inactive
    Add Test Step    Put sale channel seller with inactive status     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}    
    
TC31_Sale Channel Seller Not Exist In Database
    Add Test Step    Put sale channel seller which does not exist     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC32_Sale Channel Seller Is String
    Add Test Step    Put sale channel seller as string value     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}    
    
TC33_Sale Channel Status Is String
    Add Test Step    Put sale channel status as string value     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}   
    
TC34_Sale Channel Status Is Active
    Add Test Step    Put sale channel status as Active     The sale channel is updated successfully
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}     
    
TC35_Sale Channel Status Is Inactive
    Add Test Step    Put sale channel status as Inactive     The sale channel is updated successfully
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}
    
TC36_Sale Channel Status Not Exist
    Add Test Step    Put sale channel status not 0 nor 1     The sale channel is failed to update
    Complete Test Case And Add To Folder    ${FOLDER_UPDATE_SALE_CHANNEL}    
    

