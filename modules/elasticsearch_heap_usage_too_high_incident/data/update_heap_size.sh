

#!/bin/bash



# Set the new heap size in MB

NEW_HEAP_SIZE=${NEW_HEAP_SIZE_IN_MB}



# Set the path to the Elasticsearch configuration file

ELASTICSEARCH_CONFIG=${PATH_TO_ELASTICSEARCH_CONFIG_FILE}



# Modify the Elasticsearch configuration file to update the heap size

sed -i "s/-Xmx[0-9]*m/-Xmx${NEW_HEAP_SIZE}m/g" ${ELASTICSEARCH_CONFIG}



# Restart Elasticsearch to apply the new heap size

systemctl restart elasticsearch