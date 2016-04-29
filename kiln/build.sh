#!/bin/bash

# regular -Xmx value is 1024m, but use at least 5000m for Solr indexing - can do in batches of 200 with that allocation

export ANT_OPTS='-Xmx1024m -Dinfo.aduna.platform.appdata.basedir=./webapps/openrdf-sesame/app_dir/ -Dorg.eclipse.jetty.LEVEL=WARN'

sw/ant/bin/ant -S -f local.build.xml $*