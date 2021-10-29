module Vector_mul_tb;
parameter NUMS_OF_A = 700*13;
parameter NUMS_PARALLEL = NUMS_OF_A/100;
parameter NUMS_PARALLEL_2=(NUMS_OF_A+13-13*3)/2;
logic clk;
logic en;
logic [NUMS_OF_A:1] v;
logic [NUMS_OF_A+13:1]b_temp,b_temp_3,b_out,b_out_2;
logic [NUMS_PARALLEL:1]b_temp_2;
logic [NUMS_OF_A:1] a_S3_out_mod,a_S3_out_mod_1,a_S3_out_mod_2,a_S3_out;
logic [NUMS_OF_A+13:1] a,m,n,a_temp,a_S3_temp,a_temp_2;
logic [NUMS_PARALLEL:1]a1,a2,a3,a4,a6,a7,a9;
logic [13:1]t1,t2,t3,t4,t5,t6,t7,t8,t9;
logic [NUMS_PARALLEL_2+13*3:1] k1,k2,k3;
vector_mul vector_mul (.a_temp_2(a_temp_2),.b_out_2(b_out_2),.b_out(b_out),.b_temp_3(b_temp_3),.b_temp(b_temp),.b_temp_2(b_temp_2),.a_S3_out_mod(a_S3_out_mod),.a_S3_temp(a_S3_temp),.a_S3_out(a_S3_out),.a_S3_out_mod_2(a_S3_out_mod_2),.a_S3_out_mod_1(a_S3_out_mod_1),.a_temp(a_temp),.clk(clk),.en(en),.v(v),.a(a),.a1(a1),.a2(a2),.a3(a3),.a4(a4),.a6(a6),.a7(a7),.a9(a9),.t1(t1),.t2(t2),.t3(t3),.t4(t4),.t5(t5),.t6(t6),.t7(t7),.t8(t8),.t9(t9),.k1(k1),.k2(k2),.k3(k3),.m(m),.n(n));
always begin
	clk=0;
	forever #20 clk=~clk;
	end
//11=1111111111111
//01=0000000000001
//00=0000000000000
initial begin
en=1;v=9100'd35179257140617138036326250072352617768945028329907336018861829174665119035545944010612586303470680347291001690573171579344898323003387046419424032333905359159712487989195204067958504516948962620610461474903139960834251691001790740961439801786883101676103865242799123305519294719795142743573285519438961195517397431417034048432147599423141456779025738360628798955775141003497949271699665732394137861429736819187375378161188643403672180120157530214468610146768165679410439440857479631728943490786279136800150716557960599843367792299602907806317021834184949032137848278949416565077172914569662674367319776907536446163950192228785084535507866797211683386271006894818891174594414123586776426609526573045792056589382175314739960510506615064789815471185104706588520973141083500591823345352365793102407869082020561359762594876708312314007217202547974898409544522083442443382329297709789910314161774953278879371511169589181184223950531025388309758306305868613648235813105076331043278462149160440257498889525540728175739135928305970348539389811426260824840694588082312350817025964152607515885543445993733611035658951725750520546996004351681176029435015361486561422818905590210796080472853447973623253613654035634242164328676046057910492912722067933250579712117628059898346897980869246855851836693222746301463194900203572968636768700782065255566239262392824361764518135642370146856798355175305464676399884411457340123455875270974361603883665840009074341856158929864351678879153054281817074797821348711302348100950248219760285371510460890085282971808006886480083932551404101669301748857194200406457704762101904171389152662469408144549512440428516508779997670332191544302321878506179419019324304894686168775847131369205353594337886214170894200238006775617401797303737785110216535435403698955244979341960990386026690727332216311297826674481106211201540088632704531921489220999627275438154142693182863270922578337424246682902872380655055261295100190646029926558286359058830785539045933954314190988831867202174081019438909588750470243705272374452241761507015853460680382268328975147294077165759003823506106825342926288416921193350350587897989241012247414534142191701320815001249470957788342531851364740710542254731674994080227297815205648837547750372269349203809550744735671862479494143619203186470190932244193551053849480583037812135443030214966433197893212744142153388895458488292407411584368162302515272260382907289558222475213875877265993842631696394430924026221641747959557311089704832829999748430121676044676642335605033915965424722349887278293572017896227634967013567466863154199067821570169691627318159632710689933891629732785505682520111831937877530394457741225579951985891891523792935675441235668382403685773003044809703439419303100686337;
#40 en=0;
end
endmodule