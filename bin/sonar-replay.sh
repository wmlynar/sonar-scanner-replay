#!/bin/bash

SONAR_HOST=http://localhost:9000
SONAR_SCANNER=/opt/sonar-scanner-3.0.3.778-linux/bin/sonar-scanner
CONFIGURATION_FILE=/home/woj/tmp/sonar-project.properties
PROJECT_REPO=https://repo.inovatica.com/automatyczne-wozki-widlowe/canboxros.git
TMP_FOLDER=~/tmp/sonar-replay-tmp
BUILD_COMMAND='mvn clean install'
BRANCH=master
NUM_DAYS=100

rm -rf $TMP_FOLDER
mkdir -p $TMP_FOLDER
git clone $PROJECT_REPO $TMP_FOLDER
cd $TMP_FOLDER

git checkout ${BRANCH}
git pull

commit_log=( $(git log --date=short | grep -e "Date:" | sed -E 's/Date:[ ]+//' | uniq | tac | head -n ${NUM_DAYS} ) )

for ((i=0; i<${#commit_log[*]}; i++)); do

	commit_date=${commit_log[$i]}
	echo "Date: ${commit_date}"

	git checkout --force `git rev-list -n 1 --before="${commit_date}" ${BRANCH}`
	$BUILD_COMMAND

	cp --force ${CONFIGURATION_FILE} .

	${SONAR_SCANNER} \
		-Dsonar.host.url="${SONAR_HOST}" \
		-Dsonar.projectDate="${commit_date}"

done

