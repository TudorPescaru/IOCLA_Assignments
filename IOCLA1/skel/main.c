#include <stdio.h>
#include <stdlib.h>

#include "tema1.h"

int main() {
    printf("%d\n\t%d\n\t\t%u\n", 2147483647, -2147483648, 4294967295);
    iocla_printf("%d\n\t%d\n\t\t%u\n", 2147483647, -2147483648, 4294967295);
    return 0;
}

