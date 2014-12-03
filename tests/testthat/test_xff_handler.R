context("Test various error handlers.")

test_that("xff_handler does not truncate single IPs", {
  
  expect_that(xff_handler("77.84.7.88"), equals("77.84.7.88"))
  
})

test_that("xff_handler extracts final IPs from doubles", {
  
  expect_that(xff_handler("10.35.39.42, 10.35.8.51"), equals("10.35.8.51"))
              
})

test_that("xff_handler extracts final IPs from triples", {
  
  expect_that(xff_handler("5.134.171.121, 10.215.120.29, 10.215.157.47"), equals("10.215.157.47"))
              
})
