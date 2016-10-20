#!/usr/bin/env bash

#!/usr/bin/env bash

CONTENT_SNAPSHOT_VERSION=$1
DATASOURCE_SNAPSHOT_VERSION=$2
PROCESSING_SNAPSHOT_VERSION=$3
HNAM_SOURCE=$4
HNAM_PARTITIONS=$5
CONTENT_JIRA=$6
REFRECORD_JIRA=$7
JOB_PRIORITY=$8
EMAIL_ADDRESSES=$9
JIRA_PASSWORD=$10
CONTENT_SECRET=$11
HNAM_SECRET=$12


. /usr/local/rvm/scripts/rvm
mkdir -p /home/WHQ_NT_DOMAIN/svcrecord-admin/refrecord/functional-testing
cd /home/WHQ_NT_DOMAIN/svcrecord-admin/refrecord/functional-testing

rm -rf *
wget http://github.cerner.com/phrecorddev/record-dev-ecosystem/raw/master/functional-testing/functional_test.rb
chmod 700 functional_test.rb

export HADOOP_OPTS="-Xmx2048m -Xms2048m -XX:MaxPermSize=1024m -Dhttps.protocols=TLSv1"
echo $HADOOP_OPTS

if [[ -n "$DATASOURCE_SNAPSHOT_VERSION" ]] && [[ -z "$PROCESSING_SNAPSHOT_VERSION" ]]
then
  echo "ERROR: Invalid value for parameter [PROCESSING_SNAPSHOT_VERSION] specified."
  exit 1

elif [[ -n "$PROCESSING_SNAPSHOT_VERSION" ]] && [[ -z "$DATASOURCE_SNAPSHOT_VERSION" ]]
then
  echo "ERROR: Invalid value for parameter [DATASOURCE_SNAPSHOT_VERSION] specified."
  exit 1

elif [[ -n "$PROCESSING_SNAPSHOT_VERSION" ]] && [[ -n "$DATASOURCE_SNAPSHOT_VERSION" ]]
then
	if [ -z "$REFRECORD_JIRA"  -a -z "$CONTENT_JIRA" ]
	then
	exec ruby /home/WHQ_NT_DOMAIN/svcrecord-admin/refrecord/functional-testing/functional_test.rb $CONTENT_SNAPSHOT_VERSION --da_version $DATASOURCE_SNAPSHOT_VERSION --processing_version $PROCESSING_SNAPSHOT_VERSION  --level $JOB_PRIORITY --contentsecret $CONTENT_SECRET --hnamsecret $HNAM_SECRET --hnamsource $HNAM_SOURCE --hnampartitions $HNAM_PARTITIONS
	else
	exec ruby /home/WHQ_NT_DOMAIN/svcrecord-admin/refrecord/functional-testing/functional_test.rb $CONTENT_SNAPSHOT_VERSION  --da_version $DATASOURCE_SNAPSHOT_VERSION --processing_version $PROCESSING_SNAPSHOT_VERSION  --level $JOB_PRIORITY --contentsecret $CONTENT_SECRET --hnamsecret $HNAM_SECRET --hnamsource $HNAM_SOURCE --hnampartitions $HNAM_PARTITIONS --content_jira $CONTENT_JIRA --record_jira $REFRECORD_JIRA
	fi
else
	if [ -z "$REFRECORD_JIRA" -a -z "$CONTENT_JIRA" ]
	then
	exec ruby /home/WHQ_NT_DOMAIN/svcrecord-admin/refrecord/functional-testing/functional_test.rb $CONTENT_SNAPSHOT_VERSION --level $JOB_PRIORITY --contentsecret $CONTENT_SECRET --hnamsecret $HNAM_SECRET --hnamsource $HNAM_SOURCE --hnampartitions $HNAM_PARTITIONS
	else
	exec ruby /home/WHQ_NT_DOMAIN/svcrecord-admin/refrecord/functional-testing/functional_test.rb $CONTENT_SNAPSHOT_VERSION --level $JOB_PRIORITY --contentsecret $CONTENT_SECRET --hnamsecret $HNAM_SECRET --hnamsource $HNAM_SOURCE --hnampartitions $HNAM_PARTITIONS --content_jira $CONTENT_JIRA
	fi
fi

 if [ "$?" -ne 0 ]; then
    exit 1
 fi