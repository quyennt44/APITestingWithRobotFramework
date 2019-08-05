*** Settings ***



*** Variables ***
${APPLICATION_API_URL}    https://catalog-dev.phongvu.vn
${APPLICATION_API_TOKEN}    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTksInR5cGUiOiJ1c2VyIiwiZW1haWwiOiJxdXllbi5udEB0ZWtvLnZuIiwiaWF0IjoxNTY0Mzk2NjQwLCJleHAiOjE1NjQ0ODMwNDA5OX0.R-YCMBNF1hVKvSi3B7mPkiTypirr--Dkol-PNuv_Y6A

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


${JIRA_PROJECT_KEY}    SC









