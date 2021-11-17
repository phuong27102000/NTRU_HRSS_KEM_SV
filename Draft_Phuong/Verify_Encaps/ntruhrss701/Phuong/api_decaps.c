#include "../Ref/api.h"
#include "../Ref/params.h"
#include "stdio.h"
#include "stdint.h"
#include "string.h"

int main() {
    int i;
    uint8_t sk[NTRU_SECRETKEYBYTES];
    uint8_t c[NTRU_CIPHERTEXTBYTES];
    uint8_t k2[NTRU_SHAREDKEYBYTES];
    unsigned int a;
    char buffer[100];
    char hex[2];
    char name[64];
    printf("---------------------------------ntruhrss701---------------------------------\n");
    printf("Decapsulating ...\n");

    FILE* fp = fopen("../report/secret_key.txt","r");
    if (fp==NULL)
    {
        printf("Catching errors with secret_key.txt\n");
        return(-1);
    }

    while(feof(fp) == 0)
    { /*read some data, lets process it.*/
        /*extract individual values from the buffer*/
        fgets(buffer, 100, fp);
        sscanf(buffer, "%s", name);
        if (strcmp(name, "Secret_key:") == 0) {
            for (i = 0; i < NTRU_SECRETKEYBYTES; i++) {
                fgets(hex, 3, fp);
                sscanf(hex, "%02X", &a);
                sk[i] = (uint8_t)a;
            }
            break;
        }
    }

    fclose(fp);

    FILE* ct_file_en = fopen("../report/SV_encaps.txt","r");
    // FILE* ct_file_en = fopen("../report/ciphertext_after_encaps.txt","r");

    if (ct_file_en==NULL)
    {
        printf("Catching errors with SV_encaps.txt\n");
        return(-1);
    }

    while(feof(ct_file_en) == 0)
    { /*read some data, lets process it.*/
        /*extract individual values from the buffer*/
        fgets(buffer, 101, ct_file_en);
        sscanf(buffer, "%s", name);
        if (strcmp(name, "Ciphertext:") == 0) {
            for (i = 0; i<NTRU_CIPHERTEXTBYTES; i++) {
                fgets(hex, 3, fp);
                sscanf(hex, "%02X", &a);
                c[i] = (uint8_t)a;
            }
            break;
        }
    }

    fclose(ct_file_en);

    PQCLEAN_NTRUHRSS701_CLEAN_crypto_kem_dec(k2, c, sk);

    FILE *ct_file_de = fopen("../report/ciphertext_before_decaps.txt", "w");
    fprintf(ct_file_de,"Secret_key:\n");
    for (i = 0; i < NTRU_SECRETKEYBYTES; i++) {
        fprintf(ct_file_de,"%02X", sk[i]);
    }
    fprintf(ct_file_de,"\n______________________________________________________________________________________________________________________________________________________________________________________________\n\n");
    fprintf(ct_file_de,"Ciphertext:\n");
    for (i = 0; i < NTRU_CIPHERTEXTBYTES; i++) {
        fprintf(ct_file_de,"%02X", c[i]);
    }

    fclose(ct_file_de);

    FILE *shk_file = fopen("../report/shared_key_after_decaps.txt", "w");
    fprintf(shk_file,"Shared_key:\n");
    for (i = 0; i < NTRU_SHAREDKEYBYTES;i++) {
        fprintf(shk_file,"%02X", k2[i]);
    }
    fprintf(shk_file,"\n");

    fclose(shk_file);

    printf("Done.\n");

}
