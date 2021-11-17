#include "../Ref/api.h"
#include "../Ref/params.h"
#include "stdio.h"
#include "stdint.h"
#include "string.h"

int main() {
    int i;
    uint8_t pk[NTRU_PUBLICKEYBYTES];
    uint8_t c[NTRU_CIPHERTEXTBYTES];
    uint8_t k1[NTRU_SHAREDKEYBYTES];
    unsigned int a;
    char buffer[100];
    char hex[2];
    char name[64];
    printf("---------------------------------ntruhrss701---------------------------------\n");
    printf("Encapsulating ...\n");

    FILE* fp = fopen("../report/public_key.txt","r");
    if (fp==NULL)
    {
        printf("Catching errors with public_key.txt\n");
        return(-1);
    }

    while(feof(fp) == 0)
    { /*read some data, lets process it.*/
        /*extract individual values from the buffer*/
        fgets(buffer, 100, fp);
        sscanf(buffer, "%s", name);
        if (strcmp(name, "Public_key:") == 0) {
            for (i = 0; i < NTRU_PUBLICKEYBYTES; i++) {
                fgets(hex, 3, fp);
                sscanf(hex, "%02X", &a);
                pk[i] = (uint8_t)a;
            }
            break;
        }
    }

    fclose(fp);

    PQCLEAN_NTRUHRSS701_CLEAN_crypto_kem_enc(c, k1, pk);

    FILE *ct_file = fopen("../report/ciphertext_after_encaps.txt", "w");
    fprintf(ct_file,"Public_key:\n");
    for (i = 0; i < NTRU_PUBLICKEYBYTES; i++) {
        fprintf(ct_file,"%02X", pk[i]);
    }
    fprintf(ct_file,"\n______________________________________________________________________________________________________________________________________________________________________________________________\n\n");
    fprintf(ct_file,"Ciphertext:\n");
    for (i = 0; i < NTRU_CIPHERTEXTBYTES; i++) {
        fprintf(ct_file,"%02X", c[i]);
    }

    fclose(ct_file);

    FILE *shk_file = fopen("../report/shared_key_after_encaps.txt", "w");
    fprintf(shk_file,"Shared_key:\n");
    for (i = 0; i < NTRU_SHAREDKEYBYTES;i++) {
        fprintf(shk_file,"%02X", k1[i]);
    }
    fprintf(shk_file,"\n");

    fclose(shk_file);

    printf("Done.\n");
}
