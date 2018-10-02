#ifndef STR_H_INCLUDED
#define STR_H_INCLUDED

#include <string.h>
#include <stdlib.h>
#define MAX(x, y) (((x) > (y)) ? (x) : (y))
#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#define INIT_LENGTH_ALLOCATED 10

typedef struct st_string {
    char* c_str;
    int lenght;
    int __length_allocated;
} String;

String* new_str(const char* s) {
    String* str = (String*) malloc(sizeof(String));
    str->lenght = strlen(s);
    str->__length_allocated = MIN(10, str->lenght * 2);
    str->c_str = (char*) malloc(sizeof(char) * str->__length_allocated);
    strcpy(str->c_str, s);
    return str;
}

void set_str(String* str, const char* s) {
    int len_s = strlen(s);
    int flag = 0;

    while (str->__length_allocated <= len_s) {
        str->__length_allocated *= 2;
        flag = 1;
    }

    if (flag)
        str->c_str = (char*) realloc(str->c_str, sizeof(char) * str->__length_allocated);

    strcpy(str->c_str, s);
}

void cat_str(String* str, const char* s) {
    int len_s = strlen(s);
    char ns[len_s + str->lenght + 1];
    strcpy(ns, "");
    strcpy(ns, str->c_str);
    strcat(ns, s);
    set_str(str, ns);
}

void eraser_str(String* str) {
    str->__length_allocated = 0;
    str->lenght = 0;
    free(str->c_str);
    free(str);
}

#endif // STR_H_INCLUDED