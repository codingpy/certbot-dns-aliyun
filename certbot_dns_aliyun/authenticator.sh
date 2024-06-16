#!/bin/bash
#
# Performs a dns-01 challenge by creating a DNS TXT record.

# When using the `dns` challenge, `certbot` will ask you to place a TXT DNS record with specific
# contents under the domain name consisting of the hostname for which you want a certificate
# issued, prepended by `_acme-challenge`.

validation_domain_name="_acme-challenge.${CERTBOT_DOMAIN}"

for n in {1..21}; do
  # One of these will probably be the domain name known to the DNS provider.
  domain_name_guess=($(sed "s/\./ /$n" <<< "${validation_domain_name}"))

  rr="${domain_name_guess[0]}"
  domain_name="${domain_name_guess[1]}"

  aliyun alidns DescribeDomainInfo --DomainName "${domain_name}" &>/dev/null \
    && break
done

# Create TXT record
aliyun alidns AddDomainRecord \
  --DomainName "${domain_name}" \
  --RR "${rr}" \
  --Type TXT \
  --Value "${CERTBOT_VALIDATION}"

# Sleep to make sure the change has time to propagate over to DNS
sleep 25
