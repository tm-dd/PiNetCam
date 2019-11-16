#!/bin/bash
#
# Copyright (C) 2019 Thomas Mueller <developer@mueller-dresden.de>
#
# This code is free software. You can use, redistribute and/or
# modify it under the terms of the GNU General Public Licence
# version 2, as published by the Free Software Foundation.
# This program is distributed without any warranty.
# See the GNU General Public Licence for more details.
#

# read settings from the config file
source /usr/local/pinetcam/config.cfg

# optional wait some seconds
(set -x; sleep 120)

# send the email
/usr/local/pinetcam/systeminformation.sh 2>&1 | swaks --to $MAILTO --from $MAILFROM --server $MAILSMTPSERVER --auth LOGIN --auth-user $MAILLOGIN --auth-password "$MAILPASSWORD" -tls --port 587 --header "Subject: $MAILSUBJECT" --body -

exit 0
