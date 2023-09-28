

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