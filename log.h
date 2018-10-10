#ifndef LOG_H_INCLUDED
#define LOG_H_INCLUDED

#include <stdio.h>

#ifdef __DEBUG__
#define log(format, ...) \
  fprintf(stderr, "%s:%d   ", __FILE__, __LINE__);\
  fprintf(stderr, format, ##__VA_ARGS__);\
  fprintf(stderr, "\n");
#else
#define log(format, ...)
#endif

#define error(format, ...) \
  fprintf(stderr, "%s:%d [ERROR] ", __FILE__, __LINE__);\
  fprintf(stderr, format, ##__VA_ARGS__);\
  fprintf(stderr, "\n");

#endif // LOG_H_INCLUDED
