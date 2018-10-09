#ifndef UTIL_H_INCLUDED
#define UTIL_H_INCLUDED
#define PRECISION_DEFAULT 0.00000001

int len_double (double num, double precision) {
    int i = num;
    int len = 0;
    int part = 0;
    int grandeza = 1;

    while (i) {
        part += (i % 10) * grandeza;
        grandeza *= 10;

        len++;
        i = i / 10;
    }

    num -= part;

    short vp = 2;

    while (num < -precision || num > precision) {
        vp = 1;
        int dig = num * 10;
        num = num * 10 - dig;
        len++;
    }

    return len + vp;
}

#endif // UTIL_H_INCLUDED