#include <Rcpp.h>
#include <iostream>

#include "cpp-semver.h"

using namespace Rcpp;

bool one_is_valid(std::string v) {

  try {
    return(semver::intersects(v));
  } catch(...) {
    return(FALSE);
  }

}

//' Test if semantic version strings are valid
//'
//' @param v character verctor of version strings
//' @export
// [[Rcpp::export]]
std::vector < bool > is_valid(std::vector < std::string > v) {

  std::vector < bool > ret(v.size());

  for (unsigned int i = 0; i < v.size(); i++) {
    ret[i] = one_is_valid(v[i]);
  }

  return(ret);

}
