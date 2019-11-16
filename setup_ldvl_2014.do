/*
Author: Mr NguyÔn Ngäc B×nh
Email: nguyenngocbinhNEU@yahoo.com
First : 11/08/2014
update 27/10/2015 Unicode
*/
clear
set more off
global data "D:\GoogleDrive\Data\Ldvl"
global temp "E:\Dropbox\temp\ldvl"

use "$data\lfs_2014.dta", clear

* Bæ sung thªm sè giê lµm viÖc bq/ tuÇn 1-9, 10-19 ... 60+
* Bs lý do kh«ng tham gia ho¹t ®éng kinh tÕ
*Lo¹i h×nh kinh tÕ, nªn nhãm nhãm 1, 2 vµo lµm 1
* VÏ biÓu ®å viÖc lµm, thÊt nghiÖp theo nhãm tuæi
* ChØ tiªu di c­ néi ®Þa
* Tû lÖ ng­êi di c­ tham gia ho¹t ®éng kinh tÕ
/* Trong b¸o c¸o ph©n tÝch nµy, di c­ bao gåm nh÷ng ng­êi 15 tuæi trë lªn chuyÓn tõ x·/ph­êng/thÞ trÊn kh¸c 
®Õn n¬i ë hiÖn t¹i trong vßng 12 th¸ng tr­íc thêi ®iÓm ®iÒu tra. Do vËy ng­êi di c­ ®Ò cËp ë ®©y chñ yÕu lµ di c­ néi ®Þa.
*/
// T¹o biÕn vïng kinh tÕ
do "E:\Dropbox\dofile\labels\region6.do"

// Giíi tÝnh
gen gender = c3
label define gender 1"Nam" 2 "N÷" 99"Missing"

gen age = c5
do "E:\Dropbox\dofile\labels\agegroup5.do"

// T×nh tr¹ng h«n nh©n 
gen marital_status = c8
#delimit;
label define marital_status
1 " Ch­a cã vî/ chång"
2 " §· cã vî/ chång"
3 " Gãa"
4 " Ly h«n/ ly th©n"
99 "Mising";
#delimit cr


// B»ng cÊp cao nhÊt
gen highest_degree = c15
#delimit;
label define highest_degree 
0	"Ch­a ®i häc"
1	"D­íi tiÓu häc"
2	"TiÓu häc"
3	"THCS"
4	"S¬ cÊp nghÒ"
5	"THPT"
6	"Trung cÊp nghÒ"
7	"Trung cÊp CN"
8	"Cao ®¼ng nghÒ"
9	"Cao ®¼ng"
10	"§h trë lªn"
99	"Missing" ;
#delimit cr
gen tdvh =highest_degree 
recode tdvh 4 =3 5/10 =4 .=0 if age >=15
#delimit;
label define tdvh
0 "Kh«ng biÕt ®äc biÕt viÕt"
1 "Ch­a tèt nghiÖp tiÓu häc"
2 "TN tiÓu häc"
3 "TN THCS"
4 "TN THPT";
#delimit cr
// Do n¨m 2009 kh«ng cã biÕn highest_degree nªn t¹o biÕn train
gen train = .
replace train = 1 if highest_degree >= 0 & highest_degree <= 3 | highest_degree == 5

replace train = 3 if highest_degree == 4
replace train = 4 if highest_degree == 6
replace train = 5 if highest_degree == 7
replace train = 6 if highest_degree == 8
replace train = 7 if highest_degree == 9
replace train = 8 if highest_degree == 10
recode train (.=1) if age >=15
#delimit;
label define train 
1	"Kh«ng cã CMKT"

3	"S¬ cÊp nghÒ"
4	"Trung cÊp nghÒ"
5	"THCN"
6	"Cao ®¼ng nghÒ"
7	"Cao ®¼ng"
8	"§H trë lªn"
99	"Missing" ;
#delimit cr

gen train1 = train 
replace train1  = 2 if train1 ==3 
replace train1  = 3 if train1 ==4 | train1 ==5
replace train1  = 4 if train1 ==6 | train1 ==7
replace train1  = 5 if train1 ==8
#delimit;
label define train1 
1	"Kh«ng cã CMKT"
2	"S¬ cÊp nghÒ"
3	"Trung cÊp"
4	"Cao ®¼ng"
5	"§H trë lªn"
99	"Missing" ;
#delimit cr

gen train2 = train
recode train2 3/4=2 6=2 5=3 7/8=4 .=1 if age >=15
#delimit;
label define train2
1 " Kh«ng cã CMKT"
2 "Lao ®éng qua ®µo t¹o nghÒ"
3 "THCN"
4 "C§, §H trë lªn";
#delimit cr

// T¹o nh·n biÕn thµnh thÞ n«ng th«n
capture label drop ttnt
label define ttnt 1"Thµnh thÞ" 2 "N«ng th«n" 99" Missing"
/*
gen hdkt = 1 if c16 ==1 | c17 ==1 | c18 ==1 | c19 ==1 | c21 ==1
recode hdkt (.=2) if c68 ==1 & c71 ==1 
gen temp = c70
recode temp 4/9 = 999
recode hdkt (.=2) if c71 ==1 & temp ==999 
*/
gen employment = 1 if hdkt ==1
gen unemployment = 1 if hdkt == 2
gen weekhour = c64 // Tæng sè giê lµm viªc/ 1 tuÇn
gen underemployment = 1 if c64 <35 & c64 >0 & c65==1 & c66==1
recode underemployment (.=2) if employment ==1
label define hdkt 1"Cã viÖc lµm" 2"ThÊt nghiÖp" 99"Ngoµi lùc l­îng lao ®éng", modify
label define employment 1"Cã viÖc lµm" 2"Kh«ng" 99"missing"
label define unemployment 1"ThÊt nghiÖp" 2"Kh«ng" 99"missing"
label define underemployment 1"ThiÕu viÖc lµm" 2"Kh«ng" 99"missing"

***** Tinh luu luong lao dong
* 1. Tinh luc luong lao dong  
gen labour_force=employment					
replace labour_force=unemployment if unemployment==1	// Cong them so nguoi that nghiep vao so nguoi co viec lam
label define labour_force 1"Lùc l­îng lao ®éng " 2"Kh«ng" 99"Missing"
****** Tinh ty le that nghiep
* 1. Tinh 
/* 	a. Cho ty le that nghiep = luu luong lao dong
	b. Replace ty le that nghiep = so nguoi that nghiep
	c. Ap dung lenh sum cho bien ty le tn
*/

gen unemployment_rate=0 if labour_force==1		
replace unemployment_rate=100 if unemployment==1
// Tû lÖ thiÕu viÖc lµm
gen under_emp_rate = .
recode under_emp_rate (.=0) if employment ==1
replace under_emp_rate = 100 if underemployment ==1
// Tû lÖ tham gia LLLD: Labour force participation rate
gen lfp_rate = 100 if labour_force ==1 
recode lfp_rate (.=0) if age >=15

// Lo¹i h×nh kinh tÕ nhµ n­íc cã phÇn chia thµnh 3 lo¹i nh­ng trong phÇn nµy gép chung vµo
gen economic_sector = c23
recode economic_sector (6=5)
recode economic_sector (7=5)
recode economic_sector (8=6)
recode economic_sector (0=.)
recode economic_sector  -1=99  9 =99 // Change
#delimit;
label define economic_sector
1	"Hé c¸ nh©n"
2	"Hé kinh doanh c¸ thÓ"
3	"TËp thÓ"
4	"T­ nh©n"
5	"Nhµ n­íc"
6	"Vèn ®Çu t­ n­íc ngoµi"
99	"Missing" , modify ;
#delimit cr

gen economic_sector2 = c23
recode economic_sector2  -1=99  9 =99		// Change
#delimit;
label define economic_sector2
1	"Hé c¸ nh©n"
2	"Hé kinh doanh c¸ thÓ"
3	"TËp thÓ"
4	"T­ nh©n"
5	"C¬ quan tæ chøc NN"
6	"§¬n vi sù nghiÖp NN"
7   " Doanh nghiÖp NN"
8   " Doanh nghiÖp vèn ®Çu t­ n­íc ngoµi"
99	"Missing" ;
#delimit cr

// T¹o c¸c biÕn ngµnh kinh tÕ  c«ng viÖc chiÕm nhiÒu thêi gian nhÊt
// Ngµnh cÊp 2
gen indus2 = int(c25/100)
replace indus2 = 100 if indus2 ==.
// Ngµnh cÊp 1
gen indus1 =.
do "E:\Dropbox\dofile\labels\indus1.do"

// VÞ thÕ viÖc lµm cña c«ng viÖc chiÕm nhiÒu thêi gian nhÊt
gen employment_status = c28
#delimit;
label define employment_status
1 " Chñ c¬ së"
2 " Tù lµm"
3 " Lao ®éng gia ®×nh"
4 " Lµm c«ng ¨n l­¬ng"
5 " X· viªn hîp t¸c x·"
99 " Missing";
#delimit cr

gen occup2 = int(c22/100)
do "E:\Dropbox\dofile\labels\occup1.do"

gen train3 = train
recode train3 (1=0) if occup1 <1 | occup1 >8
recode train3 8 =7
#delimit;
label define train3
0 "Kh«ng cã CMKT"
1 " L§ qua ®µo t¹o kh«ng b»ng cÊp"
3	"S¬ cÊp nghÒ"
4	"Trung cÊp nghÒ"
5	"THCN"
6	"Cao ®¼ng nghÒ"
7 "C§, §H trë lªn"
99	"Missing" ;
#delimit cr

// TiÒn l­¬ng thu nhËp

replace c38 = 0 if c38 <0
replace c40 = 0 if c40 <0
gen wage = c38
recode wage(0=.)

egen income = rsum( c38 c40)
recode income (0=.)
// gen income = thunhap
// recode income(.=0)
gen dantoc = c6a 
label define dantoc 1"Kinh" 2 "Kh¸c" 99 "Missing"
// B¶o hiÓm x· héi c«ng viÖc chiÕm nhiÒu thêi gian nhÊt
gen bhxh = c32c
label define bhxh 1"cã" 2 "Kh«ng" 99 "Missing"
gen bhyt = c32b
label define bhyt 1"cã" 2 "Kh«ng" 99 "Missing"

// Thêi gian thÊt nghiÖp
gen time_tn = c74 
#delimit;
label define time_tn
1 "D­íi 3 th¸ng"
2 " Tõ 3- 6 th¸ng"
3 " Tõ 6- 9 th¸ng"
4 " Tõ 9- 12 th¸ng"
5 " Trªn 12 th¸ng"
99 " Missing" ;
#delimit cr

gen hdld = c29
#delimit;
label define hdld
1 "H§L§ kh«ng thêi h¹n"
2 " H§L§ tõ 1-3 n¨m"
3 " H§L§ d­íi 1 n¨m"
4 "D­íi 3 th¸ng "						// B¾t ®Çu tõ n¨m 2014 cã thªm ph©n tæ nµy
5 " Tháa thuËn miÖng"
6 " Kh«ng cã H§L§"
99 " Missing" ;
#delimit cr

do "E:\Dropbox\dofile\ldvl\support_ldvl2014.do"

gen hoatdong = labour_force
recode hoatdong .=2 if c75 == 1 
recode hoatdong .=3 if c75 != 1
#delimit;
label define hoatdong
1 "Tham gia LLL§"
2 "Sinh viªn/ häc sinh"
3 " Kh¸c"
99 " Missing" ;
#delimit cr

gen lydokolv = c75 
recode lydokolv(5=4)
recode lydokolv (.=4) 
recode lydokolv (1/4=.) if labour_force ==1 
#delimit;
label define lydokolv 
1 "Sinh viªn/ häc sinh"
2 " Néi trî"
3 " MÊt kh¶ n¨ng lao ®éng"
4 " Kh¸c"
99 " Missing" ;
#delimit cr

egen extra_hours = rsum(c61 c63)
replace extra_hours = . if extra_hours <=0

gen migration = c9 if age >=5 
recode migration 1/2 =1 3/4=0 .=0 if age >=5
label define migration 1 "Di c­" 0 "Kh«ng di c­"

gen migration_reasons = c12 
recode migration_reasons (6=8)  if migration ==1 
recode migration_reasons (.=9) if migration ==1 

#delimit;
label define migration_reasons 
1 "T×m viÖc"
2 "B¾t ®Çu c«ng viÖc míi"
3 "MÊt viÖc/ kh«ng t×m ®­îc viÖc"
4 "Theo gia ®×nh/ nghØ h­u"
5 "Kªt h«n"
8 "§i häc"
9 "Kh¸c",modify ;
#delimit cr

gen provinces_migration = c11
gen reg_migration=6  
replace reg_migration=5 if provinces_migration >=70 & provinces_migration<=79 
replace reg_migration=4 if provinces_migration >=62 & provinces_migration<=68  
replace reg_migration=3 if provinces_migration >=38 &provinces_migration<=60   
replace reg_migration=2 if provinces_migration >=2 & provinces_migration<=20  
replace reg_migration=2 if provinces_migration ==24
replace reg_migration=2 if provinces_migration ==25
replace reg_migration=1 if provinces_migration >=26 & provinces_migration <=37
replace reg_migration=1 if provinces_migration ==22
replace reg_migration=1 if provinces_migration ==1

#delimit;
label define reg_migration 
		1 "§ång b¾ng s«ng Hång" 
		2 "Trung du miªn nói phÝa b¾c" 
		3 "B¾c Trung bé vµ Duyªn h¶i miÒn trung" 
		4 "T©y Nguyªn"
		5 "§«ng Nam bé"
		6 "§ång b¾ng s«ng Cöu Long"
		99 "Missing";
#delimit cr

gen doituong = c7

// Lao dong phi chinh thuc
do "E:\Dropbox\dofile\ldvl\informal_2014.do"

// Recode gi¸ trÞ missing b»ng 99 vµ g¸n nh·n cho biÕn
local namelist dantoc bhxh region6 regHN_HCM agegroup5 marital_status gender highest_degree train train2 train3 employment  ///
unemployment underemployment economic_sector economic_sector2 indus1 indus2 occup1 labour_force employment_status ttnt nganh_N_C_D  tdvh    hdkt ///
time_tn prev_indus1  prev_nganh_N_C_D  prev_employment_status  prev_economic_sector prev_occup1 hinhthuctimviec ///
lydokolv hoatdong hdld trongtuoi migration migration_reasons reg_migration  informal prod_uni

foreach name in `namelist' {
recode `name' (.=99) if age >=15
label values `name' `name'
}

		
		gen weight = w_p

order `namelist' age weight tinh unemployment_rate under_emp_rate wage  weekhour  lfp_rate extra_hours
compress
label var marital_status "T×nh tr¹ng h«n nh©n"
label var highest_degree "Tr×nh ®é häc vÊn cao nhÊt"
label var tdvh "Tr×nh ®é häc vÊn cao nhÊt"
label var train "Tr×nh ®é chuyªn m«n kü thuËt"
label var train2 "Tr×nh ®é chuyªn m«n kü thuËt"
label var agegroup5 "Nhãm tuæi"
label var economic_sector "H×nh thøc së h÷u"
label var indus1 "Nhãm ngµnh kinh tÕ cÊp 1"
label var occup1 "Nhãm nghÒ cÊp 1"
label var  nganh_N_C_D "3 ngµnh lín"
label var region6 "Vïng kinh tÕ"
label var gender "Giíi tÝnh"
label var dantoc "D©n téc"
label var ttnt "Khu vùc"

save "$temp\ldvl_2014.dta", replace
