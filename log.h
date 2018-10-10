#ifndef LOG_H_INCLUDED
#define LOG_H_INCLUDED

#include <stdio.h>

#define log(format, ...) \
  fprintf(stderr, "%s:%d: ", __FILE__, __LINE__);\
  fprintf(stderr, format, ##__VA_ARGS__);\
  fprintf(stderr, "\n");

#endif // LOG_H_INCLUDED
