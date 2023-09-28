

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