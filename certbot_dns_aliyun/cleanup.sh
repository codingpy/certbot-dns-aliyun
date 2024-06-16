#!/bin/bash
#
# Deletes the DNS TXT record which would have been created.

# Hook '--manual-auth-hook' ran with output:
# {
#   "RequestId": "536E9CAD-DB30-4647-AC87-AA5CC38C5382",
#   "RecordId": "9999985"
# }
record_id="$(grep -Po '"RecordId": "\K[^"]*' <<< "${CERTBOT_AUTH_OUTPUT}")"

aliyun alidns DeleteDomainRecord --RecordId "${record_id}"
