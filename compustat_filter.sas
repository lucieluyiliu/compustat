%let wrds=wrds-cloud.wharton.upenn.edu 4016;
options comamid=TCP remote=wrds;
signon username=_prompt_;
/*filter compustat securities*/


libname compg 'F:\compustatglobal';

rsubmit;

data namefilter;
infile '/home/mcgill/yiliulu/namefilter.csv' delimiter = ','
          missover DSD  lrecl = 32767
          firstobs = 2;
informat keyword $32.;
format keyword $32.;
INPUT 
keyword$;
run;
endrsubmit;
rsubmit;
data exchangemap;
infile '/home/mcgill/yiliulu/exchangemap.csv' delimiter = ','
          missover DSD  lrecl = 32767
          firstobs = 2;
informat exchgcd best32.;
informat iso $2.;
informat excntry $3.;

informat exchgdesc $40.;
informat ismajor best12.;

format exchgcd best12.;
format iso$2.;
format excntry $3.;
format exchgdesc $40.;
format ismajor best12.;

INPUT 
exchgcd$
iso$
excntry$
exchgdesc$ 
ismajor;

run;
endrsubmit;


rsubmit;
proc sql;
create table compustat_selected as 
select a.gvkey,a.iid,d.sic,d.fic,d.loc,a.sedol,a.isin,a.dsci,conm, a.excntry,
case when  a.dsci contains b.keyword then 1 else 0 end as namefilter
from (select *  
from compd.g_security a1 union select * from compd.security a2) a, 
namefilter b,
exchangemap c,
(select d1.gvkey,d1.sic,d1.loc,d1.fic,conm from compd.company d1 union select d2.gvkey,d2.sic,d2.loc,d2.fic,d2.conm from compd.g_company d2) d
where  a.exchg=c.exchgcd 
and c.ismajor =1
and tpci='0'
and a.gvkey=d.gvkey
and (input(sic,16.) >6999 or input(sic,16.) <6000);  /*exclude financial*/
quit;
endrsubmit;

rsubmit;
proc sql;
create table tmp as select 
gvkey,iid,sic,fic,loc,sedol,isin,dsci,conm, excntry,
sum(namefilter) as namesum
from compustat_selected
group by gvkey,iid,sic,fic,loc,sedol,isin,dsci,conm, excntry
having calculated namesum =0;
quit;
endrsubmit;
rsubmit;
proc sql;
create table compustat_selected as 
select gvkey,iid,sic,fic,loc,sedol,isin,dsci,conm, excntry,
case when loc=excntry then 1 else 0 as islocal

from tmp;
proc sort data=compustat_selected nodupkeys; by gvkey iid; run;

endrsubmit;

proc contents data=compg.compustat_selected;run;
RSUBMIT;
proc contents data=compustat_selected;run;
ENDRSUBMIT;


rsubmit;
proc sql;
create table majorexchange as 
select count(*) as nstocks, exchg,excntry
from
(
select distinct gvkey,iid, exchg,excntry from compustat_selected)
group by  excntry,exchg
order by excntry,calculated nstocks desc;
endrsubmit;


/*construct total return*/
/*last cshoi of na stocks*/
rsubmit;
proc sql;
create table cshoi as
select a.gvkey, a.iid,a.datadate, b.cshoi, b.datadate as choidate
from compd.secd a,compd.sec_afnd b,
(select c.gvkey,c.iid,c.datadate,  max(d.datadate) as maxdate from compd.secd c, compd.sec_afnd d
where c.datadate >d.datadate and c.iid=d.iid and c.gvkey=d.gvkey  group by c.gvkey,c.iid,c.datadate) m 
where a.gvkey=b.gvkey 
and a.iid=b.iid 
and b.datadate=m.maxdate 
and a.datadate=m.datadate
and a.iid=m.iid 
and a.gvkey=m.gvkey
;
endrsubmit;
rsubmit;
proc sql;
create table totalreturnd as 
select a.gvkey,
a.iid,
a.datadate,
a.curcdd,
a.prccd/a.ajexdi*trfd/b.exratd*c.exratd as riusd,
a.prccd*d.cshoi/b.exratd*c.exratd as issuemvusd
from compd.secd a, compd.exrt_dly b, compd.exrt_dly c,cshoi d

where prcstd in (3,10,4)
and a.datadate=b.datadate
and a.curcdd=b.tocurd
and a.datadate=c.datadate
and c.tocurd='USD'
and a.datadate=d.datadate 
and a.gvkey=d.gvkey 
and a.iid=d.iid

/*market capitalization do not divide by ajexdi!*/
union all
select a1.gvkey,
a1.iid,
a1.datadate,
a1.curcdd,
a1.prccd/a1.ajexdi*a1.trfd/b1.exratd*c1.exratd/a1.qunit as riusd,
a1.prccd*a1.cshoc/b1.exratd*c1.exratd/a1.qunit as issuemvusd
from compd.g_secd a1, compd.exrt_dly b1, compd.exrt_dly c1


where prcstd in (3,10)
and a1.datadate=b1.datadate
and a1.curcdd=b1.tocurd
and a1.datadate=c1.datadate
and c1.tocurd='USD';
quit;
endrsubmit;
rsubmit;
proc sql;
create table security
as select * from compd.security 
union all 
select * from compd.g_security;
quit;

endrsubmit;

rsubmit;
proc sql;
create table sec_history as
select * from compd.sec_history 
union all
select * from compd.g_sec_history;

endrsubmit;

rsubmit;
proc sql;
create table returnd_selected as
select a.gvkey,a.iid,
datadate, 
riusd,
issuemvusd
from totalreturnd a, compustat_selected b 
where a.gvkey=b.gvkey
and a.iid=b.iid;
endrsubmit;

/*daily return*/
rsubmit;
proc sort data=returnd_selected;
by gvkey iid datadate;
run;

data returnd_selected;
set returnd_selected;
by gvkey iid;
rank+1;
if first.gvkey or first.iid then rank=1;
run;
endrsubmit;
rsubmit;
proc sql;
create table returnd as 
(select b.gvkey,b.iid,riusd, issuemvusd,datadate from returnd_selected b left join security c 
on(b.gvkey=c.gvkey and b.iid=c.iid and dlrsni in ('02','03') and b.datadate=c.dldtei)
where c.gvkey is null)
union 
(select a.gvkey,a.iid,b.riusd*0.7 as riusd,a.issuemvusd,a.datadate 
from returnd_selected  a, returnd_selected b, security c 
where a.gvkey=b.gvkey
and a.iid=b.iid
and b.gvkey=c.gvkey
and b.iid=c.iid
and a.datadate=c.dldtei
and c.dlrsni in ('02','03')
and b.rank=a.rank-1);
endrsubmit;


/*only 133 adjustments made*/

rsubmit;
proc download data=returnd out=compg.returnd;run;
endrsubmit;


/*copute weekly return*/
rsubmit;
proc sql;
create table compg.totalreturnw as 
select riusd,issuemvusd,gvkey,iid,
datadate
from compg.returnd
where weekday(datadate)eq 4
order by datadate;
quit;
proc contents data=compg.returnd_selected;run;
proc sql;
create table compg.weeklyreturn as 
select 
a.gvkey,
a.iid,
log(a.riusd)-log(b.riusd) as returnusd,a.issuemvusd,
a.datadate
from compg.totalreturnw a, compg.totalreturnw b
where a.datadate=b.datadate+7
and a.gvkey=b.gvkey
and a.iid=b.iid;
quit;
endrsubmit;
rsubmit;
proc download data=weeklyreturn out=compg.weeklyreturn;
endrsubmit;

/*calculate 3-day return*/
proc sql;
create table return3d as 
select a.gvkey,a.iid,
log(a.riusd)-log(b.riusd) as returnusd, issuemvusd
from returnusd a,returnusd b
where a.gvkey=b.gvkey and a.iid=b.iid
and a.datadsate=b.datadate+3;
quit;
endrsubmit;
rsubmit;
proc download data=return3d out=compg.return3d;run;
proc sql;
create table sedolhist as
select 
gvkey,iid,sedol,
input(max(datadate),num8.) as thrudate,
input(min(datadate),num8.) as effdate
from compd.g_secd
group by gvkey,iid,sedol;
endrsubmit;
proc sql;
create table isinhist as
select 
gvkey,iid, isin,
max(datadate) as thrudate,
min(datadate) as effdate
from compd.g_secd
group by gvkey,iid,isin;
quit;
endrsubmit;
rsubmit;
proc sql;
create table cusiphist as 
select gvkey,iid,cusip,
inpurt(max(datadate),num8.)as thrudate,
min(datadate) as effdate
from compd.secd
group by gvkey,iid,cusip;
endrsubmit;



rsubmit;
proc sql;
alter table sedolhist 
add  item char(80);
update sedolhist
set item='SEDOL';
alter  table isinhist 
add item char(80);
update isinhist 
set item='ISIN';
alter table cusiphist 
add item char(80);
update cusiphist 
set item='CUSIP';
endrsubmit;
rsubmit;
proc sql;
create table idhist as 
select * from sec_history 
union all select a.gvkey,a.iid, a.item,a.cusip as itemvalue,a.EFFDATE,a.THRUDATE from cusiphist a
union all select b.gvkey,b.iid,b.item,b.sedol as itemvalue,b.effdate,b.thrudate from sedolhist b
union all select c.gvkey,c.iid, c.item,c.isin as itemvalue,c.effdate,c.thrudate from isinhist c;
endrsubmit;



rsubmit;
proc contents data=idhist;run;
endrsubmit;


proc sql;
select count(*) from 
totalreturnd a, list b 
where a.gvkey=b.gvkey and a.iid=b.iid;
endrsubmit;



rsubmit;
proc sql;
create table return as
select a.datadate, 
riusd,
issuemvusd,
case when idhist.itemvalue is not null then 1 else 0 end as ismajorsecurity,
case when sh1.itemvalue is null then s.sedol else sh1.itemvalue end as sedol,
case when sh2.itemvalue is null then s.isin else sh2.itemvalue end as isin

from totalreturnd a
inner join compustat_selected s
on(a.gvkey=s.gvkey
and a.iid=s.iid)
left join idhist sh1 on 
(s.gvkey=sh1.gvkey
and s.iid=sh1.iid

and a.datadate between sh1.effdate and sh1.thrudate
and  sh1.item='SEDOL'
)
left join idhist sh2 on
(s.gvkey=sh2.gvkey
and s.iid=sh2.iid
and a.datadate between sh2.effdate and sh2.thrudate
and sh2.item='ISIN'
)
left join idhist on
(
idhist.item in ('PRIHISTCAN','PRIHISTUSA','PRIHISTROW')

and a.datadate between idhist.effdate and max(idhist.thrudate,input('01/01/3000',mmddyy10.))
and s.gvkey=idhist.gvkey
and s.iid=idhist.gvkey);
quit;
endrsubmit;

rsubmit;
proc contents 
data=sec_history;run;
endrsubmit;

rsubmit;
proc download data=idhist out=compg.idhist;run;
endrsubmit;

rsubmit;
proc download data=returnd_selected out=compg.returnd_selected;run;
endrsubmit;

proc sql;
select distinct item from compg.idhist;
quit;








rsubmit;
proc download data=majorexchange out=compg.majorexchange;run;
endrsubmit;
rsubmit;
proc download data=compustat_selected out=compg.compustat_Selected;run;
endrsubmit;

proc sql; 
select distinct excntry from compg.compustat_selected;
quit;
signoff;

proc sql;
create table exchangemap as 
select a.exchgcd,a.iso,b.excntry,
a.exchgdesc,
case when b.nstocks eq nmax then 1 else 0 end as ismajor
from compg.comp_exchanges a, (select *, max(nstocks) as nmax from compg.majorexchange group by excntry)  b 
where a.exchgcd=b.exchg;
quit;
proc sql;
select * from compg.majorexchange where excntry='CAN';
quit;

proc sql;
create table test as 
select * from compg.compustat_Selected where exchg=340;
quit;

/*exchange info*/
rsubmit;
proc download data=comp.r_ex_codes out=compg.exchange;run;
endrsubmit;

proc sql;
select count(*) from compg.compustat_selected;
quit;

rsubmit;
proc sql;
select count(*) from compustat_selected;
quit;
endrsubmit;
rsubmit;
proc sql;
select count(*) from 
(select distinct gvkey,iid from compustat_selected);
quit;

endrsubmit;

rsubmit;
proc download data=compustat_selected out=compg.compustat_selected;
endrsubmit;




;
