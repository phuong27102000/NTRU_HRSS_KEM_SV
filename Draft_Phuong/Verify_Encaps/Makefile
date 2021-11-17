ATTEMPT ?= 1
IMPL_DIR = Encaps
REF_DIR = ntruhrss701
REPORT = report
RP_FILES = ciphertext_after_encaps.txt ciphertext_before_decaps.txt public_key.txt secret_key.txt shared_key_after_decaps.txt shared_key_after_encaps.txt SV_encaps.txt

DELAY ?= 10
DELAY_CMD := DELAY=

all: 
	delay=$(DELAY) ; \
	number=1 ; \
	while [[ $$number -le $(ATTEMPT) ]] ; do \
		make verify $(DELAY_CMD)$$delay; \
		((number = number + 1)) ; \
		((delay = delay + 1)) ;\
	done
new_attempt: keygen encaps decaps

keygen:
	cd $(REF_DIR) && ./keygen

encaps:
	cd $(IMPL_DIR) && make reset exe $(DELAY_CMD)$(DELAY)

decaps:
	cd $(REF_DIR) && ./decaps

verify: new_attempt
	cd $(REF_DIR) && ./verify

clean:
	cd $(IMPL_DIR) && make reset
	cd $(REPORT) && rm -f RP_FILES
