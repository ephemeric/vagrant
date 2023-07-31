# Vagrant

## Test

## `curl`

This seems to be a transient, networking error, seemingly corrected by the following command:

```
pipes: curl: (35) error:0A0000D9:SSL routines::unsolicited extension
```

```
curl --write-out '%{http_code}' --output api_response --fail --location --connect-timeout 60 --retry-connrefused --retry 3 --retry-delay 5 --retry-max-time 60 --silent --show-error https://httpstat.us/200 >http_code
```
