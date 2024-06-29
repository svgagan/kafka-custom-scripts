#!/bin/bash

# Usage: bash delete-empty-consumer-group.sh "TopicNameToBeCheckedAgainst"

BOOTSTRAP_SERVER=localhost:9092
TOPIC_NAME=$1
STATE=Empty
CONSUMER_GROUPS=$(bin/kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVER --list)
for group in $CONSUMER_GROUPS
do
        GROUP_STATE=$(bin/kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVER --describe --group $group --state)
        GROUP_DESCRIBE=$(bin/kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVER --describe --group $group)

        echo "Verifying Group: $group"
        if (echo $GROUP_DESCRIBE | grep -iq $TOPIC_NAME); then
                echo "-------- Found $group group which belongs to topic $TOPIC_NAME --------"
                        if (echo $GROUP_STATE | grep -iq $STATE); then
                                DELETE_GROUP=$(bin/kafka-consumer-groups.sh --bootstrap-server $BOOTSTRAP_SERVER --delete --group $group)
                                echo "-------- Identified $group group is in $STATE state and it has to be deleted --------"
                                echo $DELETE_GROUP
                        else
                                echo "Ignoring deletion since it's not in $STATE state"
                        fi
        fi
done
