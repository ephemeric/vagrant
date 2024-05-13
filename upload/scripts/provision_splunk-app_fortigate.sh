#!/usr/bin/env bash

set -euo pipefail

cd /vagrant/splunk/etc/apps/

mkdir -p fortigate/{default,samples}

cd fortigate/default

cat >indexes.conf <<'EOF'
[fortigate]
coldPath = $SPLUNK_DB/fortigate/colddb
enableDataIntegrityControl = 0
enableTsidxReduction = 0
homePath = $SPLUNK_DB/fortigate/db
maxTotalDataSizeMB = 512000
thawedPath = $SPLUNK_DB/fortigate/thaweddb
EOF

cat >inputs.conf <<'EOF'
[monitor:///vagrant/splunk/etc/apps/fortigate/samples/fortigate-traffic.log]
disabled = false
host = fortigate.ephemeric.lan
index = fortigate
sourcetype = fortigate
EOF

cat >props.conf <<'EOF'
[fortigate]
DATETIME_CONFIG = 
LINE_BREAKER = ([\r\n]+)
MAX_TIMESTAMP_LOOKAHEAD = 10
NO_BINARY_CHECK = true
TIME_FORMAT = %s
TIME_PREFIX = eventtime=
TZ = GMT
category = Network & Security
description = FortiGate Syslog
disabled = false
pulldown_type = true
EOF

# Secure user and restricted role. Run in container or commands.
#cat >>/opt/splunk/etc/system/local/authorize.conf <<'EOF'
#[role_user-slob]
#cumulativeRTSrchJobsQuota = 0
#cumulativeSrchJobsQuota = 0
#rtSrchJobsQuota = 0
#srchDiskQuota = 0
#srchIndexesAllowed = *;fortigate
#srchIndexesDefault = fortigate;main
#srchJobsQuota = 0
#srchMaxTime = 0
#EOF
#
#cat >>/opt/splunk/etc/apps/user-prefs/local/user-prefs.conf <<'EOF'
#[role_user-slob]
#default_namespace = search
#EOF
#
#cat >>/opt/splunk/etc/passwd <<'EOF'
#:slob:$6$nbBL4gvWPDlIASzh$es6p8zV4vtFvI7XkZrJf5WKKXbcrkgiWDgoqVYRtudYekm54jEcMbD/5XAD/OCzjX3HS5bgDB4BTKkfdQJDHk1::Slob User:user;user-slob:slob@ephemeric.lan:::19489
#EOF

exit 0
