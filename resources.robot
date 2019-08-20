*** Settings ***



*** Variables ***
#Database
${Port}           3306
${Username}       cuong-dev
${DatabaseHost}    14.225.2.95
${Password}       secret
${DatabaseName}    catalog_dev
${DatabaseType}    pymysql



${APPLICATION_API_URL}    https://catalog-dev.phongvu.vn
${APPLICATION_API_TOKEN}    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTksInR5cGUiOiJ1c2VyIiwiZW1haWwiOiJxdXllbi5udEB0ZWtvLnZuIiwiaWF0IjoxNTY0Mzk2NjQwLCJleHAiOjE1NjQ0ODMwNDA5OX0.R-YCMBNF1hVKvSi3B7mPkiTypirr--Dkol-PNuv_Y6A

${URI_PATH_ADD_ATTRIBUTE_SET}    /attribute_sets
${URI_PATH_ADD_SALE_CHANNEL}    /sale_channels
${URI_PATH_UPDATE_SALE_CHANNEL}    /sale_channels


${URI_CREATE_TESTCASE}    /rest/atm/1.0/testcase
${URI_SEARCH_TESTCASE}    /rest/atm/1.0/testcase/search    

${URI_DELETE_TESTCASE}    /rest/atm/1.0/testcase
${URI_CREATE_TESTRUN}    /rest/atm/1.0/testrun

${URI_CREATE_TESTFOLDER}    /rest/atm/1.0/folder


${JIRA_URL}    https://jira.teko.vn
${JIRA_USER}    quyen.nt
${JIRA_PASSWORD}    teko@123

@{JIRA_AUTH}    ${JIRA_USER}    ${JIRA_PASSWORD}
&{JIRA_HEADER}       Content-Type=application/json

${CYCLE_ON}=    ON

${JIRA_PROJECT_KEY}    SC

${FOLDER_ADD_SALE_CHANNEL}    /API Test/Add Sale Chanel Demo
${FOLDER_UPDATE_SALE_CHANNEL}    /API Test/Update Sale Chanel
${FOLDER_ADD_ATTRIBUTE_SET}    /API Test/Add Attribute Set











