---
title: Introduction to Gonkey -- testing automation tool
date: 2022-11-13
draft: false
tags:
  - golang
  - gonkey
  - testing
---

Gonkey is a testing automation tool that can test your service API without a single line of code. Here is a quick example:

````yaml
# File cases/post.yaml
- name: "POST response must contain same data as in request"  
  method: POST  
  path: /post  
  headers:  
    Content-Type: application/json  
  
  request: >  
    {"phrase": "Hello Gonkey!"}  
  
  response:  
    200: >  
      {"json": {"phrase": "Hello Gonkey!"}}
````

Given a file with this test, Gonkey will send a POST request to \<host\>/post endpoint with Content-Type header and body `{"phrase": "Hello Gonkey!"}`. Upon receiving a response, it will check that HTTP code is 200 and response contains field `json` with expected data.
\>💡 Pro tip: Setup [Gonkey JSON-schema](https://github.com/lamoda/gonkey#json-schema) in your editor to add syntax highlight to your favourite IDE and write Gonkey tests more easily.

### Give it a try ⌨️

1. Install Gonkey

````bash
go install github.com/lamoda/gonkey@latest
````

2. Create folder with a test from example above

````bash
mkdir -p cases
touch example.yaml
# insert test case from above to example.yaml
````

3. Run test

````bash
gonkey -tests=./cases -host=https://httpbin.org/
````

Output should be:

````
success 1, failed 0, skipped 0, broken 0, total 1
````

### What if test fails

Let's change expected response to:

````yaml
# File cases/post.yaml
...
response:  
  200: >  
    {"json": {"phrase": "Goodbye Gonkey!"}}
````

Run the test again and see the following output:

````bash
gonkey -tests=cases -host=https://httpbin.org/

       Name: POST response must contain same data as in request
       File: cases/post.yaml

Request:
     Method: POST
       Path: /post
      Query: 
    Headers:
      Content-Type: application/json
       Body:
{"phrase": "Hello Gonkey!"}


Response:
     Status: 200 OK
       Body:
{
  "args": {}, 
  "data": "{\"phrase\": \"Hello Gonkey!\"}\n", 
  "files": {}, 
  "form": {}, 
  "headers": {
    "Accept-Encoding": "gzip", 
    "Content-Length": "28", 
    "Content-Type": "application/json", 
    "Host": "httpbin.org", 
    "User-Agent": "Go-http-client/1.1", 
    "X-Amzn-Trace-Id": "Root=1-6370c698-2123abec37f32ecd1556d7e5"
  }, 
  "json": {
    "phrase": "Hello Gonkey!"
  }, 
  "origin": "xxx.xxx.xxx.xxx", 
  "url": "https://httpbin.org/post"
}

     Result: ERRORS!

Errors:

1) at path $.json.phrase values do not match:
     expected: Goodbye Gonkey!
       actual: Hello Gonkey!



success 0, failed 1, skipped 0, broken 0, total 1
````

As you can see, the test failed. (What a twist!) When a test is failed, its name, path, request and actual response is printed, so you can easily debug what's happened.

 > 
 > Well, it's all nice and dandy, but life is far more complicated than writing tests to echo servers. What else can it do?

I'm glad you asked 😃

Gonkey also can:

* Apply fixtures to database (PostgreSQL, MySQL, Aerospike, Redis)
* Generate Allure reports
* Test service API for compliance with OpenAPI-specs
* Mock external HTTP endpoints\*

\*when used as library

That was just the tip of the iceberg. I'll dive deeply on how you can integrate Gonkey with your Go service and `go test` suit to test more complex scenarios in next article\*.

\*This article is not yet written.
