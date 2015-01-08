// ext/jekyll/jekyll_url.c

#include <stdio.h>
#include <ruby.h>
#include <ruby/encoding.h>

// Allocate two VALUE variables to hold the modules we'll create. Ruby values
// are all of type VALUE. Qnil is the C representation of Ruby's nil.
VALUE Jekyll = Qnil;
VALUE JekyllUrl = Qnil;
// Declare a couple of functions. The first is initialization code that runs
// when this file is loaded, and the second is the actual business logic we're
// implementing.
void Init_jekyll();
VALUE method_jekyll_url_sanitize_url(VALUE self, VALUE url);

// Initial setup function, takes no arguments and returns nothing. Some API
// notes:
//
// * rb_define_module() creates and returns a top-level module by name
//
// * rb_define_module_under() takes a module and a name, and creates a new
//   module within the given one
//
// * rb_define_singleton_method() take a module, the method name, a reference to
//   a C function, and the method's arity, and exposes the C function as a
//   single method on the given module
//
void Init_jekyll() {
  Jekyll = rb_define_module("Jekyll");
  JekyllUrl = rb_define_class_under(Jekyll, "URL", rb_cObject);
  rb_define_singleton_method(JekyllUrl, "sanitize_url", method_jekyll_url_sanitize_url, 1);
}

int array_include_char(char values[], char questionable) {
  for(int i = 0; i < strlen(values); i++) {
    if (questionable == values[i]) {
      return 1;
    }
  }
  return 0;
}

// The business logic -- this is the function we're exposing to Ruby. It returns
// a Ruby VALUE, and takes three VALUE arguments: the receiver object, and the
// method parameters. Notes on APIs used here:
//
// * RARRAY_LEN(VALUE) returns the length of a Ruby array object
// * rb_ary_new2(int) creates a new Ruby array with the given length
// * rb_ary_entry(VALUE, int) returns the nth element of a Ruby array
// * NUM2INT converts a Ruby Fixnum object to a C int
// * INT2NUM converts a C int to a Ruby Fixnum object
// * rb_ary_store(VALUE, int, VALUE) sets the nth element of a Ruby array
//
VALUE method_jekyll_url_sanitize_url(VALUE self, VALUE url) {
  char* cUrl = rb_string_value_cstr(&url);

  int n = strlen(cUrl);

  // Helpful variables for string manipulation.
  int searching;
  int theIndex;
  int offset;
  char naughtyForDots[] = {'.', '/'};
  char naughtyForSlashes[] = {'/'};
  char* result;

  // Remove all dot segments
  while((result = strstr(cUrl, "/..")) != NULL || (result = strstr(cUrl, "../")) != NULL) {
    theIndex = (int)(result - cUrl);
    if(result[0] == '/') {
      theIndex += 1;
    }
    offset = 0;
    searching = 1;
    for(int c = theIndex + offset ; c < n; c++) {
      if(array_include_char(naughtyForDots, cUrl[c]) && searching > 0) {
        offset++;
        continue;
      } else {
        cUrl[c-offset] = cUrl[c];
        if (searching > 0) {
          searching = 0;
          continue;
        }
      }
    }
    n -= offset;
    cUrl[n] = '\0';
  }

  // Remove all double slashes
  while((result = strstr(cUrl, "//")) != NULL) {
    offset = 0;
    searching = 1;
    theIndex = (int)(result - cUrl);
    for(int c = theIndex + 1; c < n; c++) {
      if(n - 1 == theIndex) {
        n--;
        break;
      }
      if(array_include_char(naughtyForSlashes, cUrl[c]) && searching > 0) {
        offset++;
        continue;
      } else {
        cUrl[c-offset] = cUrl[c];
        if (searching > 0) {
          searching = 0;
          continue;
        }
      }
    }
    n -= offset;
    cUrl[n] = '\0';
  }

  // Ensure there's a leading slash.
  if(cUrl[0] != '/') {
    n++;
    for (int c = n-1; c >= 0; c--) {
      cUrl[c+1] = cUrl[c];
    }
    cUrl[0] = '/';
  }

  // Chomp the string at the end.
  cUrl[n] = '\0';

  return rb_utf8_str_new_cstr(cUrl);
}
