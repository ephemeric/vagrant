#!/usr/bin/env bash

set -euo pipefail

cd /vagrant/splunk/apps/

mkdir -p hec/default

cd hec/default

cat >indexes.conf <<'EOF'
[hec_events]
coldPath = $SPLUNK_DB/hec_events/colddb
enableDataIntegrityControl = 0
enableTsidxReduction = 0
homePath = $SPLUNK_DB/hec_events/db
maxTotalDataSizeMB = 512000
thawedPath = $SPLUNK_DB/hec_events/thaweddb

[hec_metrics]
coldPath = $SPLUNK_DB/hec_metrics/colddb
datatype = metric
enableDataIntegrityControl = 0
enableTsidxReduction = 0
homePath = $SPLUNK_DB/hec_metrics/db
maxTotalDataSizeMB = 512000
thawedPath = $SPLUNK_DB/hec_metrics/thaweddb
EOF

cat >inputs.conf <<'EOF'
[http://hec_events]
disabled = 0
host = aa9aa88978a2
index = hec_events
indexes = hec_events
token = 05c0cde0-ecf0-4576-bd93-819d33529697

[http://hec_metrics]
disabled = 0
host = aa9aa88978a2
index = hec_metrics
indexes = hec_metrics
token = cc042214-f4c2-4ed2-a24d-ea988e844158
EOF

exit 0
