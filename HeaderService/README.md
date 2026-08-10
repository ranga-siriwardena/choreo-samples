Rest API to return incoming headers
[//]: # (above is the package summary)

# Package Overview
Test the API

curl -i http://localhost:9090/headers/echo \
  -H "X-Custom-Header: test123" \
  -H "Authorization: Basic test"

curl -i -X POST http://localhost:9090/headers/echo \
  -H "Content-Type: application/json" \
  -H "X-Custom-Header: test123" \
  -d '{"foo": "bar"}'
