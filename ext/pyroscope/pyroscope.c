#include <stdlib.h>
#include <ruby.h>

static VALUE rb_Pyroscope;
static VALUE rb_cGreeting;

#include <stdio.h>
#include <string.h>

int Start(char*, int, char*, char*);

static VALUE
pyroscope_start(VALUE self, VALUE appName, VALUE pid, VALUE spyName, VALUE serverAddress) {
  VALUE r_appName = StringValue(appName);
  char *c_appName = RSTRING_PTR(r_appName);

  int c_pid = FIX2INT(pid);

  int res = Start(c_appName, c_pid, "rbspy", "http://localhost:4040");

  return INT2FIX(res);
}

void
Init_pyroscope_c() {
  rb_Pyroscope = rb_define_module("Pyroscope");
  rb_define_module_function(rb_Pyroscope, "start", pyroscope_start, 4);
}
