#ifndef UTIL_H_INCLUDED
#define UTIL_H_INCLUDED
#define PRECISION_DEFAULT 0.00000001

int len_double (double num, double precision) {
    short vp = 2;

    if (num < 0)
        vp++;

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

    while (num < -precision || num > precision) {
        vp--;
        int dig = num * 10;
        num = num * 10 - dig;
        len++;
    }

    return len + vp;
}

#endif // UTIL_H_INCLUDED