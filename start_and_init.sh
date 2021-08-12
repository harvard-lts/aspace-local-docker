#!/bin/bash

if [ "$RUN_PLUGIN_INIT" = true ] ; then
    /archivesspace/scripts/initialize-plugin.sh aspace-ead-xform
    /archivesspace/scripts/initialize-plugin.sh aspace-hvd-pui
    # /archivesspace/scripts/initialize-plugin.sh aspace-omniauth-cas
fi

/archivesspace/archivesspace.sh
