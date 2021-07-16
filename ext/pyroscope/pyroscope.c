#include <stdlib.h>
#include <ruby.h>

static VALUE rb_Pyroscope;

#include <stdio.h>
#include <string.h>

int Start(char*, int, char*, char*);
int Stop(int);
int ChangeName(char*);

static VALUE
pyroscope_start(VALUE self, VALUE appName, VALUE pid, VALUE serverAddress) {
  VALUE r_appName = StringValue(appName);
  char *c_appName = RSTRING_PTR(r_appName);

  int c_pid = FIX2INT(pid);

  VALUE r_serverAddress = StringValue(serverAddress);
  char *c_serverAddress = RSTRING_PTR(r_serverAddress);

  int res = Start(c_appName, c_pid, "rbspy", c_serverAddress);

  return INT2FIX(res);
}

static VALUE
pyroscope_stop(VALUE self, VALUE pid) {
  int c_pid = FIX2INT(pid);
  int res = Stop(c_pid);
  return INT2FIX(res);
}

static VALUE
pyroscope_change_name(VALUE self, VALUE appName) {
  VALUE r_appName = StringValue(appName);
  char *c_appName = RSTRING_PTR(r_appName);
  int res = ChangeName(c_appName);
  return INT2FIX(res);
}

void
Init_pyroscope_c() {
  rb_Pyroscope = rb_define_module("Pyroscope");
  rb_define_module_function(rb_Pyroscope, "_start", pyroscope_start, 3);
  rb_define_module_function(rb_Pyroscope, "_stop", pyroscope_stop, 1);
  rb_define_module_function(rb_Pyroscope, "_change_name", pyroscope_change_name, 1);
}
