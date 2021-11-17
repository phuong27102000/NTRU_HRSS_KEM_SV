#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "../Ref/params.h"

int main() {
    char buffer[100];
    char hex[2];
    char name[64];
    unsigned int a;
    uint8_t fail = 0;
    uint8_t impl_shk[NTRU_SHAREDKEYBYTES];
    uint8_t ref_shk[NTRU_SHAREDKEYBYTES];
    int i;

    FILE* impl = fopen("../report/SV_encaps.txt","r");
    if (impl==NULL)
    {
        printf("Catching errors with SV_encaps.txt\n");
        return(-1);
    }

    while(feof(impl) == 0)
    { /*read some data, lets process it.*/
        /*extract individual values from the buffer*/
        fgets(buffer, 101, impl);
        sscanf(buffer, "%s", name);
        if (strcmp(name, "Shared_key:") == 0) {
            for (i = 0; i < NTRU_SHAREDKEYBYTES; i++) {
                fgets(hex, 3, impl);
                sscanf(hex, "%02X", &a);
                impl_shk[i] = (uint8_t)a;
            }
            break;
        }
    }

    FILE* ref = fopen("../report/shared_key_after_decaps.txt","r");
    if (ref==NULL)
    {
        printf("Catching errors with shared_key_after_decaps.txt\n");
        return(-1);
    }

    while(feof(ref) == 0)
    { /*read some data, lets process it.*/
        /*extract individual values from the buffer*/
        fgets(buffer, 100, ref);
        sscanf(buffer, "%s", name);
        if (strcmp(name, "Shared_key:") == 0) {
            for (i = 0; i < NTRU_SHAREDKEYBYTES; i++) {
                fgets(hex, 3, ref);
                sscanf(hex, "%02X", &a);
                ref_shk[i] = (uint8_t)a;
            }
            break;
        }
    }
    // Check whether the implement shared key was identical to the reference
    // shared key.
    for (i = 0; i < NTRU_SHAREDKEYBYTES; i++) {
        if (impl_shk[i] != ref_shk[i]) {
            fail = 1;
        }
    }

    // Print the report.
    printf("\n\tShared key that was returned by the reference code is:\n");
    for (i = 0; i < NTRU_SHAREDKEYBYTES;i++) {
        printf("%02X ", ref_shk[i]);
    }
    printf("\n");

    printf("\n\tShared key that was returned by the our implement is:\n");
    for (i = 0; i < NTRU_SHAREDKEYBYTES;i++) {
        printf("%02X ", impl_shk[i]);
    }
    printf("\n");
    printf("\n\tHence, it is my honor to announce that...\n");
    if (fail) {
	printf("\033[0;31m");
        printf("\t\tVERIFICATION FAILED.\n");
	printf("\033[0m");
    }
    else {
	printf("\033[0;32m");
        printf("\t\tVERIFICATION SUCCEEDED.\n");
	printf("\033[0m");
    }

    return 0;
}
