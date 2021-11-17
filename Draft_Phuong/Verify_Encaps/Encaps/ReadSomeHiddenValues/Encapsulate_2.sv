// `include "ControlUnit.sv"
// `include "inc.sv"
//
// `include "ternary.sv"
// `include "mod3_i8_o2.sv"
//
// `include "pack_s3.sv"
// `include "trit5_to_bit8.sv"
// `include "ppa_sk.sv"
// `include "mux.sv"
//
// `include "sha3_256.sv"
// `include "bytes_to_bits.sv"
//
// `include "unpack_rq0.sv"
//
// `include "Add_in_Rq.sv"
// `include "Arith_poly.sv"
// `include "polynomialmultiplication.sv"
//
// `include "ter_arith.sv"
// `include "poly_lift.sv"
//
// `include "pack_Rq0.sv"
//
// `include "LFSR.sv"
`timescale 1ns / 1ps
// (lsfr_rst, ovr_rst1, clk, h_in, c, k)
module encapsulate;
	parameter RANDOM_BITS = 16, HASH_BITS = 1088, SHA3_256_BITS = 1600;
	parameter R_BITS = 1400, TER_BITS = 20, PUBLIC_KEY_BITS = 9113;
	parameter CIPHERTEXT_BITS = 9104;

	reg lsfr_rst, ovr_rst1, clk;
	reg [CIPHERTEXT_BITS:1] h_in;
	wire [CIPHERTEXT_BITS:1] c;
	wire [256:1] k;

	wire[1088:1] p_reg;
    	wire [1402:1] m1, m2, z;
//------------------------------------------------------------------------------
//  LFSR
	wire [RANDOM_BITS:1] bits;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  UNPACK_RQ0
	wire ovr_rst2, sipo_u_clk, up_rq0_done;
	wire [PUBLIC_KEY_BITS:1] h;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  TERNARY
	wire sipo_t1_clk, sipo_t2_clk;
	wire [R_BITS+TER_BITS : 1] rm;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  PACK_S3
	wire p3_rst, sipo_p_clk, sipo_p_stop;
	wire [1:0] p3_count;
	wire [HASH_BITS:1] prm;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// SHA3_256
	wire hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk;
	wire hash_fin;
	wire [SHA3_256_BITS:1] s_next;
	reg [256:1] k_in;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  POLY_MUL_IN_RQ
	wire [1:0] poly_r;
	wire [PUBLIC_KEY_BITS:1] v;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  LIFT
	wire [3:0] poly_m;
	wire lift_en;
	wire [PUBLIC_KEY_BITS:1] m0;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  ADD_IN_RQ
	wire [PUBLIC_KEY_BITS:1] c_before_pack;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  Structural Design Area
	Control_Unit CU (ovr_rst1, ovr_rst2, clk, halt_n, sipo_u_clk, sipo_t1_clk,
	sipo_t2_clk, up_rq0_done, sipo_p_clk, sipo_p_stop, p3_rst, p3_count,
	hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin,
	enc_rst, lift_en);

	LFSR LFSR ( .clk(clk), .rst(lsfr_rst), .coins(bits));

	unpack_rq0 UP_RQ0 ( .rst( ovr_rst1 ), .clk( sipo_u_clk ),
	.done( up_rq0_done ), .h_in( h_in ), .h( h ) );

	ternary TER ( .rst( ovr_rst1 ), .clk1( sipo_t1_clk ), .clk2( sipo_t2_clk ),
	.bits( bits ), .rm( rm ) );

	pack_s3 PS3 ( .ovr_rst( ovr_rst2 ), .rst( p3_rst ), .clk1( sipo_t1_clk ),
	.clk2( sipo_p_clk ), .stop( sipo_p_stop ), .count( p3_count ),
	.rm( rm[R_BITS+TER_BITS : R_BITS+1] ), .prm( prm ) );

	sha3_256 HASH ( .ovr_rst( ovr_rst1 ), .rst1( hash_rst1 ), .rst2( hash_rst2 ),
	.sample( hash_sp ), .answer( hash_ans ), .keccak_sp( hash_keccak ),
	.keccak_clk( hash_clk ), .finish( hash_fin ), .prm( prm ), .out( s_next ) );

	assign #0.2 poly_r = sipo_t2_clk ? rm[2:1] : rm[4:3];
	assign poly_m = rm[R_BITS+TER_BITS : R_BITS+TER_BITS-3];

	polynomialmultiplication MUL ( .clk(sipo_t1_clk), .en(enc_rst), .rin(poly_r), 
	.h(h), .e_1(v) );

	poly_lift LIFT ( .clk(sipo_t1_clk), .rst(enc_rst), .en(lift_en), .m_in(poly_m), 
	.m0(m0) );

	Add_in_Rq ADD_IN_RQ ( .v(v), .m1(m0), .c(c_before_pack) );

	pack_Rq0 PACK_RQ0 ( .c( c_before_pack ), .cnew( c ) );

	bits_to_bytes_k B2B ( .k_in(k_in), .k(k) );
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Behavioral Design Area
	always @ ( posedge clk ) begin
		if (halt_n) begin
			k_in <= 0;
		end else begin
			k_in <= s_next[256:1];
		end
	end
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  testbench
	integer f_read, f_write;
	wire [1400:1] r,m;

	map_r R_CHECK ( .rst(enc_rst), .r_clk(clk), .r_bits(poly_r), .r(r) );

	map_m M_CHECK ( .rst(enc_rst), .m_clk(clk), .m_bits(poly_m), .m(m) );

	initial begin
		f_read = $fopen("../report/SV_public_key.txt","r");
		while (! $feof(f_read)) begin
			$fscanf(f_read,"Public_key: %h",h_in);
		end
		$fclose(f_read);
		$display("h: %h",h_in);
		// h_in = 9104'h0B17B0D52AF21AC50DA92FB0411916BDAA151C0B9F5B056C75BB9744E8CDDC8BF2C5C07CF2946C8F3BC4E78CB29FBD40F647A6BCA511FAB9D575FC3C946DDFFAAD3071A04FCF3F9CFAC132678768D4D3312FBE327D0B7CA520E8CBE7E7C46D6948E52768ADE594D6D876EA6CE7D4C658BFAAE817A23B7D201A4629C1DFBEBA2512784A950A19786A7303E4C1533FDD1A1CC2837D97F4F8CFAF9FEC98240E86415E81328DFBE32623AF0FF7116F643A0ED8DD748E83377BDCA5A32216E07D1B38FE418182C174637363B4FCB5D7D8C5ED30DAA4A98AA1BD83ABF735DDCF41EBFEE7BF41FEA1AA7D1D4E448CF60B78AECDB7E91C31F23A55453B16C0F133451A3B9E1842950E2B4341D4221EE82638B755F76FAA995BBAC22B0963FD16134F25C4585092736E8B4E41F9C85FC7D44D02A7878354D3163F00B173F53D355F92F9B362321CE005B117487619A13991FFB88571695971687065DCAC5FA787DBDF58297ECBEF10B3343B07A6F123919E1DD107296F5E68F7A085A5F1BA0C8A6E80AB092E1C5ED79C7113CAD5FD72A0022B049C8FC4995D3B4C9C46F84DA30518B0564EB53C5935F66FD963C9169351138A89B8713DB6BEE149392A5F5C29AD26E27F5C5EF91C31619BCE52CD2179FCDAE52F8407680895981B0A926234104BD09DC2E2E8ABC9D1E63A4796AADFD6B11CD3EE69B88E32AB3DFBEF077987B3DDFAE84D48EF00CA89D0B854DEAFED299D20AEF5A20E2C0CB4475C54813E2AED01AEE3D3C005C89FC416FD5277D5B076BA5F63D20D6D4CE4B255639BD96D9863E03F71C156C5F85654F286BFF85006D04C1D021F63EE100176B10C5A5F208FA20B0773C777BC6644333EF339655F73BF6DAC8B37193C9B868345513B3D46FF93435B9BC52B966237BEA141A83419E812CFCF37BD363126A862B28033C65AC28B855D28D32795C56DB6F53EEF7809ECF45061FE2A882F0C9977721816087CB5C55CB5FFBC06BCDD33AC9DB83F0178C87796BF5E543CB16569E861997CF400389793D340088DDAE9827848DE26F929D86E029112A9E8BC686265CCE3487E65DF452482A4860AF05ACC7567855D63D9E194D146DE6293BCB585C821DC05910C7BBF7E1A859203685E2AEA7F5798BBD4AEEA5C623742AE862C46CE05540975C0A20127E164E71ECF23C3EBC14272A832CFBF907CD21E62B252AC7AC1C67A1BCC761731D557C4AA922EE4BFF1004F8D50BA330A186EC398662AC0B12F759676A795722EEE0CD4B90C8D18938BA05EAA89DE2AFCB5AE0D3043B9920E792FF7C643A5117BDD883C1654527CEFF70484917CD648B4D2353712AF4B4D01FB899DBABAFA919BA8C71888D79ECB131D64EDE9D6A00F1F8FC14C5B24B8DBDBBAE02F11792373421CCEADE0EE072868CF3FC6766C8BEC3AF506B4C7E96A41F7ABBA1F6FB5A41D2FAF9A93CC8A856B87155EB0B1BC21766F762AE6298A1095C2F991B64EDF1A962A86DB3467126212C5689F37AE19D9C9BD2D4D4F7E2D2263A2D9991C57907CB8336407326F10ED98E0600C1AFB19B44F781087555A7EF7F596C5C2CFB5B1C71C2BFF1FF548E93DFA5E2AC35C9AD05E662DC520B5CBA40B;
	end
	initial begin
		clk = 1;
		forever begin
			#0.5 clk = ~clk;
		end
	end

	initial begin
		lsfr_rst = 1;
		#1.2 lsfr_rst = 0;
	end

	initial begin
		ovr_rst1 = 0;
		#50.2;
		ovr_rst1 = 1;
		#1;
		ovr_rst1 = 0;
		#2000;
	    f_write = $fopen("../report/SV_encaps.txt","w");
		$fwrite(f_write,"Shared_key:\n%H\n",k);
		$fwrite(f_write,"Ciphertext:\n%H\n",c);
		$fclose(f_write);
		$finish;
	end
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end
//------------------------------------------------------------------------------
endmodule
