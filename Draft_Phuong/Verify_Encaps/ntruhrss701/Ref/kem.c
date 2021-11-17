#include "api.h"
#include "cmov.h"
#include "fips202.h"
#include "owcpa.h"
#include "params.h"
#include "randombytes.h"
#include "sample.h"
#include <stdio.h>

// API FUNCTIONS
int PQCLEAN_NTRUHRSS701_CLEAN_crypto_kem_keypair(uint8_t *pk, uint8_t *sk) {
    uint8_t seed[NTRU_SAMPLE_FG_BYTES];

    randombytes(seed, NTRU_SAMPLE_FG_BYTES);
    PQCLEAN_NTRUHRSS701_CLEAN_owcpa_keypair(pk, sk, seed);

    randombytes(sk + NTRU_OWCPA_SECRETKEYBYTES, NTRU_PRFKEYBYTES);
/*
// ADD TO PRINT THE SEED
    int i;
    printf("Seed:\n");
    for (i = 0; i < NTRU_SAMPLE_FG_BYTES; i++) {
        printf("%02X ", seed[i]);
        if ((i & 63) == 63) { printf("\n"); }
    }
    for (i = 0; i < NTRU_PRFKEYBYTES; i++) {
        printf("%02X ", sk[i + NTRU_OWCPA_SECRETKEYBYTES]);
        if (((i + NTRU_SAMPLE_FG_BYTES) & 63) == 63) { printf("\n"); }
    }
    printf("\n______________________________________________________________________________________________________________________________________________________________________________________________\n\n");
// --------------------
*/
    return 0;
}

int PQCLEAN_NTRUHRSS701_CLEAN_crypto_kem_enc(uint8_t *c, uint8_t *k, const uint8_t *pk) {
    poly r, m;
    uint8_t rm[NTRU_OWCPA_MSGBYTES];
    uint8_t rm_seed[NTRU_SAMPLE_RM_BYTES];

    randombytes(rm_seed, NTRU_SAMPLE_RM_BYTES);

    PQCLEAN_NTRUHRSS701_CLEAN_sample_rm(&r, &m, rm_seed);

    PQCLEAN_NTRUHRSS701_CLEAN_poly_S3_tobytes(rm, &r);
    PQCLEAN_NTRUHRSS701_CLEAN_poly_S3_tobytes(rm + NTRU_PACK_TRINARY_BYTES, &m);


    sha3_256(k, rm, NTRU_OWCPA_MSGBYTES);

    PQCLEAN_NTRUHRSS701_CLEAN_poly_Z3_to_Zq(&r);
    PQCLEAN_NTRUHRSS701_CLEAN_owcpa_enc(c, &r, &m, pk);

/*
// ADD TO PRINT COINS AND RM
    int i;
    printf("Coins:\n");
    for (i = 0; i < NTRU_SAMPLE_RM_BYTES;i++) {
        printf("%02X ", rm_seed[i]);
        if ((i & 63) == 63) { printf("\n"); }
    }
    printf("\n______________________________________________________________________________________________________________________________________________________________________________________________\n\n");
    printf("rm:\n");
    for (i = 0; i < NTRU_OWCPA_MSGBYTES; i++) {
        printf("%02X ", rm[i]);
        if ((i & 63) == 63) { printf("\n"); }
    }
    printf("\n______________________________________________________________________________________________________________________________________________________________________________________________\n\n");
// ------------------------
*/

    return 0;
}

int PQCLEAN_NTRUHRSS701_CLEAN_crypto_kem_dec(uint8_t *k, const uint8_t *c, const uint8_t *sk) {
    int i, fail;
    uint8_t rm[NTRU_OWCPA_MSGBYTES];
    uint8_t buf[NTRU_PRFKEYBYTES + NTRU_CIPHERTEXTBYTES];

    fail = PQCLEAN_NTRUHRSS701_CLEAN_owcpa_dec(rm, c, sk);
    /* If fail = 0 then c = Enc(h, rm). There is no need to re-encapsulate. */
    /* See comment in PQCLEAN_NTRUHRSS701_CLEAN_owcpa_dec for details.                                */

    sha3_256(k, rm, NTRU_OWCPA_MSGBYTES);

    /* shake(secret PRF key || input ciphertext) */
    for (i = 0; i < NTRU_PRFKEYBYTES; i++) {
        buf[i] = sk[i + NTRU_OWCPA_SECRETKEYBYTES];
    }
    for (i = 0; i < NTRU_CIPHERTEXTBYTES; i++) {
        buf[NTRU_PRFKEYBYTES + i] = c[i];
    }
    sha3_256(rm, buf, NTRU_PRFKEYBYTES + NTRU_CIPHERTEXTBYTES);

    PQCLEAN_NTRUHRSS701_CLEAN_cmov(k, rm, NTRU_SHAREDKEYBYTES, (unsigned char) fail);

    return 0;
}
