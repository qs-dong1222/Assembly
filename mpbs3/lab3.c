#include "stdio.h"

extern char ddmmyy[]="30/12/2012";
extern int countweeks(char * date);
int main()
{
    printf(" number of weeks = %d\n", countweeks( ddmmyy ));
    return 0;
}
