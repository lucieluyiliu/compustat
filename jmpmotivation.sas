rsubmit;
proc contents data=work._all_;run;
endrsubmit;
%let wrds=wrds-cloud.wharton.upenn.edu 4016;
options comamid=TCP remote=wrds;
signon username=_prompt_;

rsubmit;
libname home '/scratch/mcgill/yiliulu';
endrsubmit;


rsubmit;
proc download data=home.entityctrynumber out=compg.entityctrynumber;run;
endrsubmit;


rsubmit;
proc download data=home.entityctrynumrank out=compg.entityctrynumrank;run;
endrsubmit;

proc sql;
create table test as 
select * from compg.entityctrynumrank
where int(quarter/100)=2001;

proc sql;
create table tests as 
select * from compg.entityctrynumrank 
where factset_entity_id='05FW7Z-E';

proc sql;
create table test2 as 
select distinct sec_country 
from compg.v1_entityholding a,
fslocal.ctry b
where factset_entity_id='05FW7Z-E';

and a.sec_sountry=b.iso
and int(quarter/100)=2001;
rsubmit;
proc download data=home.globalentity out=compg.globalentity;run;
endrsubmit;

proc sort data= compg.globalentity; by quarter;run;
rsubmit;
proc download data=home.globalentityaum out=compg.globalentityaum;run;
endrsubmit;


rsubmit;
proc download data=home.globalentitynum out=compg.globalentitynum;run;
endrsubmit;

rsubmit;
proc download data=home.allentityaum out=compg.allentityaum;run;
endrsubmit;

rsubmit;
proc download data=home.globalentitynum out=compg.globalentitynum;run;
endrsubmit;



proc sql;
create table compg.globalentity_annual as 
select *,
int(quarter/100) as year, max(quarter) as maxqtr 
from compg.globalentityaum
group by calculated year
having quarter=calculated maxqtr;



proc sql;
create table compg.globalentitynum_annual as 
select *,
int(quarter/100) as year, max(quarter) as maxqtr 
from compg.globalentitynum
group by year
having quarter=calculated maxqtr;

proc sql;
create table compg.allentityaum_annual as 
select allaum,globalaum,
int(quarter/100) as year,
quarter, 
max(quarter) as maxqtr 
from compg.allentityaum
group by calculated year
having quarter=calculated maxqtr;






proc sql;
create table compg.entityctrynumber_annual as 
select *,
mean(nctry) as avgnctry,
int(quarter/100) as year, max(quarter) as maxqtr 
from compg.entityctrynumber
group by calculated year
having quarter=calculated maxqtr;

proc sql;
create table compg.allentityaum_annual as 
select *,
int(quarter/100) as year, max(quarter) as maxqtr 
from copg.allentityaum
having quarter=calculated maxqtr;

proc sql;
select max(nctry) from compg.entityctrynumber;

signoff;

proc sql;
create table test as select count (distinct sec_country) as nctry
from compg.v1_entityholding a,
fslocal.edm_Standard_entity b 

where a.factset_entity_id=b.factset_entity_id
group by a.factset_entity_id,quarter
order by quarter,calculated nctry;

proc sql;
 select distinct ctry from compg.instsummary 
order by ctry;
quit;
proc sql;
create table test as 
 select distinct * from compg.instsummary
 where ctry='Taiwan'
order by datadate;
quit;

proc sql;
create table test as 
select *
from compg.instsummary
where ctry='Luxembourg'; 
/*and datadate=input('01/05/2000',mmddyy10.);*/
proc sql;
select count(*) from (select distinct gvkey,iid from test1);


proc sql;
create table test as select * from compg.holdings_by_security_final a,
compg.ctry b
where a.sec_country=b.iso
and ctry='Luxembourg';
quit;

