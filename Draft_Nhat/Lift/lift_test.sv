module lift_test;
parameter NUMS_OF_A_TER=700*2; parameter NUMS_OF_A_SQ=700*13;
logic clk;
logic en;
logic [NUMS_OF_A_TER:1] m;
logic [NUMS_OF_A_SQ+13:1] b;
logic [NUMS_OF_A_SQ:1] m_sq;
lift lift (.clk(clk),.en(en),.m(m),.b(b),.m_sq(m_sq));
always begin
	clk=0;
	forever #20 clk=~clk;
	end
initial begin
en=1; 
m=1400'd5348781957263701820311526337382083045908442384806069698511068414607085671528498313075590681518625920548145312491763101886640487460530913203329294545438391458024591194778533438404073579896179565548831300796310152025777671122464183737290759870916276084770419529312040186625877526958233137686459731508531847755451630842122875146097408090672203665760256929123737251807199498668925417278898272143061939195014862493132476217281;
//b=9113'd288082966776529302498489725090956947536456927369576469225048025461762808608625066192610966281156982873919013337323022064310930456349984231794977193296205229536006644524854185392968790675371330938947003078225448801789161604608576024643280315989675466760289088165153382250920252090126735235561179494201526614514922145426630275076155308019390655980868836448308146300068719913330298496946535968734792890920758796058081534122164190582594481652639814306186665371357404327052390472425632223383013109930733675632225826176646909222623654920957025666111717044288822574390253535690356320856169863400996352527511270493893250531689800053226709977637123093951623972651429713844660357635913769916376706891208939349647701568371904957723055108639654276351800385463508829228885301537191271922329083877181935426802760307002077244071777508389472954600106636611882344098096643487031783695241023698115311856653665395611435773869139655659403042830597178975970419266643236851122016579539498811173293059703533877581295524376647387722283326303641877098779197888052775551561986368336831992720671239747667910018117922433534881577257225160875319588015308797342710793026609925484352405850616139895133906210696647054230635754591869670784341297474559359686519791311394825668537378961437543526608632932311890304428805120371686054272144564626619795743253084616454021220606932667375577713623057350846720721214460125302504930944056497478830009646569553154947938104299158452359730081491682401180603000174967300085350179459162985915597729886284831328717812482653922983146859816851518220337326252925509969686572656304911492000282995012826219999660452750935602910227467368336940852087740892973317114337251074223016712399632634684306147841955066654798138227444269342032007447502060321697285962982214498933099604652477409237614944013764600008162774954505691324342554500739848401308021919762011882801179892842525048286527123643207842582693838503991285479522056716692538168571139158801354740288335847511240715348058700833137103248149650589822283126722776527419100851557373213681685391962598615861045936462893565795342011212135928982834442939550145881164590868209732939947815836668466267656491929517042426779925103701946783365983544581381938990524486429597619903088764576537704000881617719011106204361781271168670526727507473567171884036686142269312573263539448165117582298107570664928284840997031668092909100608909919541943534085916951415202606578552825837688733547349171583900258136351564775178282747506772844775999843547500021993966797952161434740801804126302961600054236265374750859449013639384145348395514403225413031072122849954895283870035700604656537518118290009153249993086176188780552768886200627483927745802787699569227567159265231960398344101173422295781308417733296129;
#30 en=0;
end
endmodule