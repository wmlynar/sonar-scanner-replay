# sonar-scanner-replay

usage:

1. prepare a file named sonar-project.properties that is specific to your project. for an example please take a look at the file included in this repository
2. edit the file sonar-replay.sh that is included in this repository to point to the right places
3. execute sonar-replay.sh

your sonar repository will be populated with historical data

please notice that sonar will not accept results dated earlier than already existing in its database. in such case - delete the whole project in sonar and execute the script
