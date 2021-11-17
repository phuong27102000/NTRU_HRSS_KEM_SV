COMPILER = vcs
EXECUTE = ./simv
DESIGN =
FILE_LIST = benlist.lf
# testbench Add_in_Rq.sv Arith_poly.sv bytes_to_bits.sv ControlUnit.sv Encapsulate.sv inc.sv LFSR.sv mod3_i8_o2.sv mux.sv pack_Rq0.sv pack_s3.sv poly_lift.sv polynomialmultiplication.sv ppa_sk.sv sha3_256.sv ter_arith.sv ternary.sv trit5_to_bit8.sv unpack_rq0.sv
FLAGS = -sverilog -f
TOP_FLAG = -top
VCS_FILE = simv.daidir/.vcs.timestamp
WF_FILE = dump.vcd 
TOP_MODULE = testbench

DELAY ?= 10
PARAMS := -pvalue+testbench.DELAY=
LFSR_DELAY := $(strip $(PARAMS))$(strip $(DELAY))

compile:
	$(COMPILER) $(FLAGS) $(FILE_LIST) $(TOP_FLAG) $(TOP_MODULE) $(LFSR_DELAY)

exe: $(WF_FILE)

reset:
	rm -f $(VCS_FILE) $(DESIGN) $(WF_FILE)

$(WF_FILE): compile
	$(EXECUTE)

