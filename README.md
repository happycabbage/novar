
# novar

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/happycabbage/novar.svg?branch=master)](https://travis-ci.com/happycabbage/novar)
[![Codecov test coverage](https://codecov.io/gh/happycabbage/novar/branch/master/graph/badge.svg)](https://codecov.io/gh/happycabbage/novar?branch=master)
<!-- badges: end -->

## Description

API Endpoints for webhook integrations that leverage hca proprietary data analytics to faciliate real-time triggers for insights driven actions.

## Example using R and httr

``` r
library(httr)

url <- "https://cabbage.pub/v1/novar/{end_point}"

resp <- POST(url, body = list( {data}, apikey = {partner issued apikey} ))

stop_for_status(resp)

content(resp, "text")

```
