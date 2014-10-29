context("Session functions")

test_that("session_length handles 1-intertime sessions correctly", {
  
  #Example event(s)
  events <- 12
  
  #Test resulting values
  expect_that(session_length(events), equals(442))
  
})

test_that("session_length handles 2-intertime sessions correctly", {
  
  #Example event(s)
  events <- c(12,30)
  
  #Test resulting values
  expect_that(session_length(events), equals(472))
  
})

test_that("session_length handles 1-intertime sessions where the value is > threshold", {
  
  #Example event(s)
  events <- c(100000)
  
  #Test resulting values
  expect_that(session_length(events), equals(c(430,430)))
  
})

test_that("session_length handles 2-intertime sessions where one value is > threshold", {
  
  #Example event(s)
  events <- c(12,30,3900)
  
  #Test resulting values
  expect_that(session_length(events), equals(c(472,430)))
  
})

test_that("session_length handles multi-intertime sessions where multiple values are > threshold", {
  
  #Example event(s)
  events <- c(12,30,4000,12,3900)
  
  #Test resulting values
  expect_that(session_length(events), equals(c(472,442,430)))
  
})

test_that("session_length handles multi-intertime sessions where multiple /sequential/ values are > threshold", {
  
  #Example event(s)
  events <- c(12,30,4000,3900)
  
  #Test resulting values
  expect_that(session_length(events), equals(c(472,430,430)))
  
})

test_that("session_count handles 1-intertime events correctly", {
  
  #Example event(s)
  events <- 12
  
  #Test resulting values
  expect_that(session_count(events), equals(1))
  
})

test_that("session_count handles 2-intertime events correctly", {
  
  #Example event(s)
  events <- c(12,30)
  
  #Test resulting values
  expect_that(session_count(events), equals(1))
  
})

test_that("session_count handles multiple sessions correctly", {
  
  #Example event(s)
  events <- c(12,30,4000,1)
  
  #Test resulting values
  expect_that(session_count(events), equals(2))
  
})

test_that("session_pages handles 1-intertime vectors correctly", {
  
  #Example event(s)
  events <- c(12)
  
  #Test resulting values
  expect_that(session_pages(events), equals(2))
  
})

test_that("session_pages handles 2-intertime vectors correctly", {
  
  #Example event(s)
  events <- c(12,14)
  
  #Test resulting values
  expect_that(session_pages(events), equals(3))
  
})

test_that("session_pages handles multi-session vectors correctly", {
  
  #Example event(s)
  events <- c(12,3900,4)
  
  #Test resulting values
  expect_that(session_pages(events), equals(c(2,2)))
  
})

test_that("session_pages handles multi-session vectors with sequentially above-threshold values correctly", {
  
  #Example event(s)
  events <- c(12,3900,3900)
  
  #Test resulting values
  expect_that(session_pages(events), equals(c(2,1,1)))
  
})
