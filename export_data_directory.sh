#!/bin/bash

rm -rf /Users/boushey/ucsfDataShare/tomcat/webapps/xtf/data
cd /Users/boushey/ucsfDataShare/tomcat/webapps/xtf
python parseFeed.py https://merritt-stage.cdlib.org/object/recent.atom?collection=ark:/13030/m57p9070 ucsf_datashare_submitter
cd /Users/boushey/ucsfDataShare
./tomcat/bin/shutdown.sh   
./textIndexer -clean -index default
./tomcat/bin/startup.sh