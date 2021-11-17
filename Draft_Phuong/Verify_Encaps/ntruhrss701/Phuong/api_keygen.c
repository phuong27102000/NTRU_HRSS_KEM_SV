#include "../Ref/api.h"
#include "../Ref/params.h"
#include "stdio.h"
#include "stdint.h"

int main() {
    int i;
    uint8_t pk[NTRU_PUBLICKEYBYTES];
    uint8_t sk[NTRU_SECRETKEYBYTES];
    printf("---------------------------------ntruhrss701---------------------------------\n");
    printf("Generating key ...\n");

    PQCLEAN_NTRUHRSS701_CLEAN_crypto_kem_keypair(pk, sk);

    FILE *pk_file = fopen("../report/public_key.txt", "w");
    fprintf(pk_file,"Public_key:\n");
    for (i = 0; i < NTRU_PUBLICKEYBYTES; i++) {
        fprintf(pk_file,"%02X", pk[i]);
    }
    fclose(pk_file);

    pk_file = fopen("../report/SV_public_key.txt", "w");
    fprintf(pk_file,"Public_key: ");
    for (i = 0; i < NTRU_PUBLICKEYBYTES; i++) {
        fprintf(pk_file,"%02X", pk[i]);
    }
    fclose(pk_file);

    FILE *sk_file = fopen("../report/secret_key.txt", "w"); // write only
    fprintf(sk_file,"Secret_key:\n");
    for (i = 0; i < NTRU_SECRETKEYBYTES; i++) {
        fprintf(sk_file,"%02X", sk[i]);
    }
    fclose(sk_file);

    sk_file = fopen("../report/SV_secret_key.txt", "w"); // write only
    fprintf(sk_file,"Secret_key: ");
    for (i = 0; i < NTRU_SECRETKEYBYTES; i++) {
        fprintf(sk_file,"%02X", sk[i]);
    }
    fclose(sk_file);

    printf("Done.\n");
}
