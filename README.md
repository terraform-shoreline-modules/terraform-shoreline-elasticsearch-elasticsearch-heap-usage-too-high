
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Elasticsearch Heap Usage Too High Incident
---

An Elasticsearch Heap Usage Too High Incident is an issue where the Elasticsearch instance experiences high heap usage, which can lead to performance degradation or system failure. This incident is triggered when the heap usage crosses a predefined threshold, usually set at 80% of the allocated heap size. The incident requires immediate attention from the responsible team to investigate and resolve the root cause of the issue, which could be related to memory leaks, indexing issues, or insufficient heap size allocation.

### Parameters
```shell
export ELASTICSEARCH_INSTANCE_URL="PLACEHOLDER"

export ELASTICSEARCH_HOST="PLACEHOLDER"

export ELASTICSEARCH_PORT="PLACEHOLDER"

export EXPECTED_HEAP_SIZE="PLACEHOLDER"

export NEW_HEAP_SIZE_IN_MB="PLACEHOLDER"

export PATH_TO_ELASTICSEARCH_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Check Elasticsearch service status
```shell
systemctl status elasticsearch
```

### Check Elasticsearch logs for any errors
```shell
journalctl -u elasticsearch | tail
```

### Check Elasticsearch heap usage
```shell
curl -X GET "localhost:9200/_nodes/stats/jvm?pretty"
```

### Check Elasticsearch cluster health
```shell
curl -X GET "localhost:9200/_cluster/health?pretty"
```

### Check system memory usage
```shell
free -m
```

### Check disk usage
```shell
df -h
```

### Check CPU usage
```shell
top
```

### Large volume of data being indexed at a high rate causing heap memory usage to increase beyond the limit.
```shell


#!/bin/bash



# Set the Elasticsearch instance URL

ELASTICSEARCH_URL=${ELASTICSEARCH_INSTANCE_URL}



# Get the heap usage percentage from Elasticsearch

HEAP_USAGE=$(curl -s "${ELASTICSEARCH_URL}/_cat/nodes?h=heap.percent")



# Check if the heap usage is above the limit (80%)

if (( $(echo "${HEAP_USAGE} > 80" | bc -l) )); then

  echo "Heap usage is above the limit. Checking indexing rate..."



  # Get the indexing rate from Elasticsearch

  INDEXING_RATE=$(curl -s "${ELASTICSEARCH_URL}/_cat/indices?h=i,ss,si&bytes=b")



  # Check if the indexing rate is high

  if (( $(echo "${INDEXING_RATE}" | awk '{ sum += $3 } END { print sum }') )); then

    echo "Indexing rate is high. It could be causing the high heap usage."

  else

    echo "Indexing rate is normal. The high heap usage could be due to other reasons."

  fi

else

  echo "Heap usage is normal. No action necessary."

fi


```

### Misconfigured Elasticsearch JVM heap size, leading to insufficient memory allocation.
```shell


#!/bin/bash



# Set the Elasticsearch instance details

ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST}

ELASTICSEARCH_PORT=${ELASTICSEARCH_PORT}



# Set the expected heap size in GB

EXPECTED_HEAP_SIZE=${EXPECTED_HEAP_SIZE}



# Get the current heap size of the Elasticsearch instance

CURRENT_HEAP_SIZE=$(curl -s -XGET "http://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/_nodes/_local/stats/jvm" | jq -r '.nodes[].jvm.mem.heap_max_in_bytes')



# Convert the heap size to GB

CURRENT_HEAP_SIZE_GB=$(echo "scale=2; $CURRENT_HEAP_SIZE/1024/1024/1024" | bc)



# Check if the current heap size is less than the expected heap size

if (( $(echo "$CURRENT_HEAP_SIZE_GB < $EXPECTED_HEAP_SIZE" | bc -l) )); then

    echo "Elasticsearch JVM heap size is misconfigured. Current heap size is $CURRENT_HEAP_SIZE_GB GB, but the expected heap size is $EXPECTED_HEAP_SIZE GB."

    # Add any additional diagnostic steps here

else

    echo "Elasticsearch JVM heap size is configured correctly. Current heap size is $CURRENT_HEAP_SIZE_GB GB."

fi


```

## Repair

### Increase the heap size of Elasticsearch to accommodate the increased usage.
```shell


#!/bin/bash



# Set the new heap size in MB

NEW_HEAP_SIZE=${NEW_HEAP_SIZE_IN_MB}



# Set the path to the Elasticsearch configuration file

ELASTICSEARCH_CONFIG=${PATH_TO_ELASTICSEARCH_CONFIG_FILE}



# Modify the Elasticsearch configuration file to update the heap size

sed -i "s/-Xmx[0-9]*m/-Xmx${NEW_HEAP_SIZE}m/g" ${ELASTICSEARCH_CONFIG}



# Restart Elasticsearch to apply the new heap size

systemctl restart elasticsearch


```