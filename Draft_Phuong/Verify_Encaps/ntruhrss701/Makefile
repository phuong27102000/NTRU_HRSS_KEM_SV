# This Makefile can be used with GNU Make or BSD Make
OBJ_DIR = Ref
MY_DIR = Phuong

HEADERS = $(OBJ_DIR)/api.h $(OBJ_DIR)/cmov.h $(OBJ_DIR)/owcpa.h \
          $(OBJ_DIR)/params.h $(OBJ_DIR)/poly.h $(OBJ_DIR)/sample.h \
		  $(OBJ_DIR)/randombytes.h $(OBJ_DIR)/fips202.h
OBJECTS = $(OBJ_DIR)/cmov.o $(OBJ_DIR)/kem.o $(OBJ_DIR)/owcpa.o \
          $(OBJ_DIR)/pack3.o $(OBJ_DIR)/packq.o $(OBJ_DIR)/poly.o \
		  $(OBJ_DIR)/poly_lift.o $(OBJ_DIR)/poly_mod.o \
		  $(OBJ_DIR)/poly_r2_inv.o $(OBJ_DIR)/poly_rq_mul.o \
		  $(OBJ_DIR)/poly_s3_inv.o $(OBJ_DIR)/sample.o $(OBJ_DIR)/sample_iid.o \
		  $(OBJ_DIR)/randombytes.o $(OBJ_DIR)/fips202.o
CFLAGS = -g -Wall -std=gnu99
EX_CFLAGS = -no-pie

ENCAPS_OBJ = $(MY_DIR)/api_encaps.o
DECAPS_OBJ = $(MY_DIR)/api_decaps.o
KEYGEN_OBJ = $(MY_DIR)/api_keygen.o
VERIFY_OBJ = $(MY_DIR)/verify.o

ENCAPS = encaps
DECAPS = decaps
KEYGEN = keygen
VERIFY = verify

all: encaps decaps keygen verify

encaps: $(ENCAPS)

$(ENCAPS): $(OBJECTS) $(ENCAPS_OBJ)
	$(CC) $(CFLAGS) $(EX_CFLAGS) -o $@ $^

decaps: $(DECAPS)

$(DECAPS): $(OBJECTS) $(DECAPS_OBJ)
	$(CC) $(CFLAGS) $(EX_CFLAGS) -o $@ $^

keygen: $(KEYGEN)

$(KEYGEN): $(OBJECTS) $(KEYGEN_OBJ)
	$(CC) $(CFLAGS) $(EX_CFLAGS) -o $@ $^

verify: $(VERIFY)

$(VERIFY): $(OBJECTS) $(VERIFY_OBJ)
	$(CC) $(CFLAGS) $(EX_CFLAGS) -o $@ $^

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	$(RM) $(OBJECTS) $(ENCAPS_OBJ) $(DECAPS_OBJ) $(KEYGEN_OBJ) $(VERIFY_OBJ)
