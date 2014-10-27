context("Timestamp handlers")

test_that("mw_strptime handles character timestamps appropriately", {
  
  #Example mediawiki timestamp
  example_ts <- "20010116200833"
  
  #Test resulting values
  expect_that(mw_strptime(example_ts), equals(as.POSIXlt("2001-01-16 20:08:33 UTC", tz = "UTC")))
  
})

test_that("mw_strptime handles numeric timestamps appropriately", {
  
  #Example mediawiki timestamp
  example_ts <- 20010116200833
  
  #Test resulting values
  expect_that(mw_strptime(example_ts), equals(as.POSIXlt("2001-01-16 20:08:33 UTC", tz = "UTC")))
  
})

test_that("mw_strptime handles too-long timestamps appropriately", {
  
  #Example mediawiki timestamp
  example_ts <- 20010116200832342423423233233
  
  #Test resulting values
  expect_that(is.na(mw_strptime(example_ts)), equals(TRUE))
  
})

test_that("log_strptime handles character timestamps appropriately", {
  
  #Example log timestamp
  example_ts <- "2014-10-20T22:00:00"
  
  #Test resulting values
  expect_that(log_strptime(example_ts), equals(as.POSIXlt("2014-10-20 22:00:00 UTC", tz = "UTC")))
  
})

test_that("log_strptime handles too-long timestamps appropriately", {
  
  #Example log timestamp
  example_ts <- "2014-10-20wefwregdfgdfgfdgdfT22:00:00"
  
  #Test resulting values
  expect_that(is.na(log_strptime(example_ts)), equals(TRUE))
  
})

test_that("to_mw converts appropriately", {
  
  #Example log timestamp
  example_ts <- as.POSIXlt("2014-10-20 22:00:00 UTC", tz = "UTC")
  
  #Test resulting values
  expect_that(to_mw(example_ts), equals("20141020220000"))
  
})

test_that("to_log converts appropriately", {
  
  #Example log timestamp
  example_ts <- as.POSIXlt("2014-10-20 22:00:00 UTC", tz = "UTC")
  
  #Test resulting values
  expect_that(to_log(example_ts), equals("2014-10-20T22:00:00"))
  
})