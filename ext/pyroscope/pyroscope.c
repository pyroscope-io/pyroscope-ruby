#include <stdlib.h>
#include <ruby.h>

static VALUE rb_Pyroscope;

#include <stdio.h>
#include <string.h>

int pyroscope_log(int level, char* msg);
int Start(int, char*, char*, char*, char*, int, int, char*);
int Stop(int);
int ChangeName(int, char*);
int SetTag(int, char*, char*);
int TestLogger();
int SetLoggerLevel(int);
char* BuildSummary();

static VALUE
pyroscope_start(VALUE self, VALUE pid, VALUE appName, VALUE serverAddress, VALUE authToken, VALUE sampleRate, VALUE withSubprocesses, VALUE logLevel) {
  VALUE r_appName = StringValue(appName);
  char *c_appName = RSTRING_PTR(r_appName);

  int c_pid = FIX2INT(pid);
  int c_sampleRate = FIX2INT(sampleRate);
  int c_withSubprocesses = FIX2INT(withSubprocesses);

  VALUE r_serverAddress = StringValue(serverAddress);
  char *c_serverAddress = RSTRING_PTR(r_serverAddress);

  VALUE r_authToken = StringValue(authToken);
  char *c_authToken = RSTRING_PTR(r_authToken);

  VALUE r_logLevel = StringValue(logLevel);
  char *c_logLevel = RSTRING_PTR(r_logLevel);

  int res = Start(c_pid, c_appName, "rbspy", c_serverAddress, c_authToken, c_sampleRate, c_withSubprocesses, c_logLevel);

  return INT2FIX(res);
}

static VALUE
pyroscope_stop(VALUE self, VALUE pid) {
  int c_pid = FIX2INT(pid);
  int res = Stop(c_pid);
  return INT2FIX(res);
}

static VALUE
pyroscope_change_name(VALUE self, VALUE pid, VALUE appName) {
  VALUE r_appName = StringValue(appName);
  char *c_appName = RSTRING_PTR(r_appName);
  int c_pid = FIX2INT(pid);

  int res = ChangeName(c_pid, c_appName);
  return INT2FIX(res);
}

static VALUE
pyroscope_set_tag(VALUE self, VALUE pid, VALUE key, VALUE val) {
  VALUE r_key = StringValue(key);
  char *c_key = RSTRING_PTR(r_key);
  VALUE r_val = StringValue(val);
  char *c_val = RSTRING_PTR(r_val);
  int c_pid = FIX2INT(pid);

  int res = SetTag(c_pid, c_key, c_val);
  return INT2FIX(res);
}

static VALUE
pyroscope_test_logger(VALUE self) {
  int res = TestLogger();
  return INT2FIX(res);
}

static VALUE
pyroscope_set_logger_level(VALUE self, VALUE level) {
  int res = SetLoggerLevel(FIX2INT(level));
  return INT2FIX(res);
}

static VALUE
pyroscope_build_summary(VALUE self) {
  char *c_summary = BuildSummary();
  VALUE r_summary = rb_str_new_cstr(c_summary);
  free(c_summary);
  return r_summary;
}

void
Init_pyroscope_c() {
  rb_Pyroscope = rb_define_module("Pyroscope");
  rb_define_module_function(rb_Pyroscope, "_start", pyroscope_start, 7);
  rb_define_module_function(rb_Pyroscope, "_stop", pyroscope_stop, 1);
  rb_define_module_function(rb_Pyroscope, "_change_name", pyroscope_change_name, 2);
  rb_define_module_function(rb_Pyroscope, "_set_tag", pyroscope_set_tag, 3);
  rb_define_module_function(rb_Pyroscope, "_test_logger", pyroscope_test_logger, 0);
  rb_define_module_function(rb_Pyroscope, "_set_logger_level", pyroscope_set_logger_level, 1);
  rb_define_module_function(rb_Pyroscope, "_build_summary", pyroscope_build_summary, 0);
}
