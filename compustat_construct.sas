
proc sql;
create table compg.returnall as
select m.datadate, 
m.gvkey,
m.iid,
m.returnusd,
m.issuemvusd,
case when idhist.itemvalue is not null then 1 else 0 end as ismajorsecurity,
case when sh1.itemvalue is null then s.sedol else sh1.itemvalue end as sedol,
case when sh2.itemvalue is null then s.isin else sh2.itemvalue end as isin

from compg.weeklyreturn m
inner join compg.compustat_selected s
on(m.gvkey=s.gvkey
and m.iid=s.iid)
left join compg.idhist sh1 on 
(s.gvkey=sh1.gvkey
and s.iid=sh1.iid

and m.datadate between sh1.effdate and sh1.thrudate
and  sh1.item='SEDOL'
)
left join compg.idhist sh2 on
(s.gvkey=sh2.gvkey
and s.iid=sh2.iid
and m.datadate between sh2.effdate and sh2.thrudate
and sh2.item='ISIN'
)
left join compg.idhist idhist on
(
idhist.item in ('PRIHISTCAN','PRIHISTUSA','PRIHISTROW')
and m.datadate between idhist.effdate and case when idhist.thrudate is not null then idhist.thrudate else input('01/01/3000',mmddyy10.) end
and s.gvkey=idhist.gvkey
and s.iid=idhist.iid);
quit;
/*LL BRAZIL LISTED STOCKS*/
proc sql;
create table brazil as
select a.riusd,a.issuemvusd,a.gvkey,a.iid,a.datadate
from compg.returnd a, compg.security b 
where a.gvkey=b.gvkey and a.iid=b.iid
and b.excntry='BRA'
order by a.gvkey,a.iid,datadate;
quit;

proc sql;
create table peru as
select a.riusd,a.issuemvusd,a.gvkey,a.iid,a.datadate
from compg.returnd a, compg.security b 
where a.gvkey=b.gvkey and a.iid=b.iid
and b.excntry='PER'
and year(datadate) in (1991,1992)
order by a.gvkey,a.iid,datadate;
quit;

proc sql;
create table canada as
select gvkey,iid
from compg.compustat_Selected
where loc='CAN';
quit;


proc sql;
select count(*)
from compg.returnd a, compg.security b 
where a.gvkey=b.gvkey and a.iid=b.iid
and b.excntry='PER';
quit;

proc sql;
create table test as
select * from brazil
where year(datadate) =1988;
quit;

proc sql;
create table test as 
select * from compg.returnd
where gvkey='185208' and iid='01C'
order by datadate;
quit;

proc sql;
create table test as 
select * from compg.weeklyreturn
where gvkey='202022' and iid='01W'
order by datadate;
quit;

proc sql;
select * from compg.compustat_selected
where gvkey='185208' and iid='01C';

proc sql;
create table test as 
select * from 
compg.security
where gvkey='030581'
and iid='01W';
quit;
