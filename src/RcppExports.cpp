// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// cpp_intertimes
NumericVector cpp_intertimes(NumericVector timestamps);
RcppExport SEXP WMUtils_cpp_intertimes(SEXP timestampsSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< NumericVector >::type timestamps(timestampsSEXP );
        NumericVector __result = cpp_intertimes(timestamps);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// session_count
int session_count(NumericVector x, int local_minimum = 3600);
RcppExport SEXP WMUtils_session_count(SEXP xSEXP, SEXP local_minimumSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP );
        Rcpp::traits::input_parameter< int >::type local_minimum(local_minimumSEXP );
        int __result = session_count(x, local_minimum);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
