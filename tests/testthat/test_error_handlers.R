context("Test various error handlers.")

test_that("NAs without rm_na are correctly detected", {
  
  expect_that(cryptohash(NA,"md5"),
              throws_error(regexp = "x contained NA values and cannot be hashed. Remove the invalid elements, or set na_rm to TRUE",
                           fixed = TRUE))
  
})

test_that("Vectors consisting entirely of NA values are detected", {
  
  expect_that(cryptohash(NA,"md5", na_rm = TRUE),
              throws_error(regexp = "After removing NA values, no values were left", fixed = TRUE))
  
})

test_that("non-character vectors are detected, converted and warn", {
  
  expect_that(cryptohash(4,"md5"),
              gives_warning(regexp = "x is not a character vector. Attempting to convert it into one.", fixed = TRUE))
  
})

test_that("non-character vectors are successfully converted", {
  
  expect_that(cryptohash(4,"md5"), equals("a87ff679a2f3e71d9181a67b7542122c"))
  
})

test_that("Empty vectors throw an appropriate error", {
  
  expect_that(cryptohash(character(),"md5"), throws_error("The vector you have provided is empty", fixed = TRUE))
  
})

test_that("non-existent algorithms throw an appropriate error", {
  
  expect_that(cryptohash(4,"turnips are a fruit"), throws_error("You did not provide a valid algorithm", fixed = TRUE))
  
})
