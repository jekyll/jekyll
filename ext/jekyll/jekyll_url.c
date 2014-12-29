// ext/faye_websocket/faye_websocket.c

#include <ruby.h>

// Allocate two VALUE variables to hold the modules we'll create. Ruby values
// are all of type VALUE. Qnil is the C representation of Ruby's nil.
VALUE Jekyll = Qnil;
VALUE JekyllUrl = Qnil;
// Declare a couple of functions. The first is initialization code that runs
// when this file is loaded, and the second is the actual business logic we're
// implementing.
void Init_jekyll();
VALUE method_jekyll_url_generate_url(VALUE self, VALUE placeholders, VALUE template);

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
  JekyllUrl = rb_define_module_under(Jekyll, "URL");
  rb_define_singleton_method(JekyllUrl, "generate_url", method_jekyll_url_generate_url, 2);
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
VALUE method_jekyll_url_generate_url(VALUE self, VALUE placeholders, VALUE template) {
  return template;
}
