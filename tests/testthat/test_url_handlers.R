context("URL handlers")

test_that("host_handler detects HTTP", {
  
  expect_that(host_handler("http://foo.bar.org/"), equals("foo.bar.org"))
  
})

test_that("host_handler detects HTTPS", {
  
  expect_that(host_handler("https://foo.bar.org/"), equals("foo.bar.org"))
  
})

test_that("host_handler detects invalid URLs", {
  
  expect_that(host_handler("I'm seeing stars, watch me fall apart"), equals("Unknown"))
  
})

test_that("host_handler handles caps lock appropriately", {
  
  expect_that(host_handler("HTTP://FOO.BAR.ORG/"), equals("foo.bar.org"))
  
})

test_that("host_handler handles root URLs correctly", {
  
  expect_that(host_handler("http://foo.bar.org"), equals("foo.bar.org"))
  
})

test_that("project_extractor handles root URLs correctly", {
  
  expect_that(project_extractor("http://foo.bar.org"), equals("foo.bar"))
  
})

test_that("project_extractor handles mobile, zero and legacy URLs correctly", {
  
  expect_that(project_extractor("http://foo.mobile.bar.org"), equals("foo.bar"))
  expect_that(project_extractor("http://foo.m.bar.org"), equals("foo.bar"))
  expect_that(project_extractor("http://foo.zero.bar.org"), equals("foo.bar"))
  expect_that(project_extractor("http://foo.wap.bar.org"), equals("foo.bar"))
  
})
