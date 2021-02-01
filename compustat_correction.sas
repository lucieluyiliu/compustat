/*compustat data correction per CLS*/

proc sql;
update  compg.returnd 
set issuemvusd=issuemvusd/10
where gvkey='205247'
and iid='01W'
and datadate <input('01/01/1992',mmddyy10.);
quit;
proc sql;
update  compg.weeklyreturn
set lagissuemvusd=lagissuemvusd/10
where gvkey='205247'
and iid='01W'
and datadate <input('01/01/1992',mmddyy10.);
quit;

proc sql;
update compg.returnd
set issuemvusd=.
where gvkey='029178'
and iid='01W'
and datadate <input('10/01/1990',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set lagissuemvusd=.
where gvkey='029178'
and iid='01W'
and datadate <input('10/01/1990',mmddyy10.);
quit;





/*brazil 1989 currency change*/
proc sql;
update compg.returnd a
set riusd=riusd/1000 
where curcdd='BRE'
and a.datadate=input('01/16/1989',mmddyy10.);
quit;
/*effective day is sunday, no data*/

proc sql;
update compg.weeklyreturn a
set returnusd=(1+returnusd)/1000-1
where curcdd='BRE'
and a.datadate=input('01/18/1989',mmddyy10.);
quit;
/*chinese stocks 1993 abnormal*/

proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='208194' and iid='02W' 
and datadate= input('03/24/1993',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='203187' and iid='01W' and datadate= input('03/24/1993',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='229956' and iid='02W' and datadate= input('03/24/1993',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='208200' and iid='01W' and datadate= input('03/24/1993',mmddyy10.);
quit;
/*not major excluded no correction*/
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='203462' and iid='01W' and datadate= input('03/24/1993',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='203682' and iid='01W' and datadate= input('03/24/1993',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='208603' and iid='01W' and datadate= input('03/24/1993',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='208366' and iid='01W' and datadate= input('03/24/1993',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='209409' and iid='01W' and datadate= input('03/24/1993',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='2103255' and iid='01W' and datadate= input('01/06/1999',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='210759' and iid='01W' and datadate= input('01/06/1999',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='240641' and iid='01W' and datadate= input('01/06/1999',mmddyy10.);
quit;


proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='200503' and iid='01W' and datadate= input('12/02/1992',mmddyy10.);
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='206463' and iid='03W';
quit;
proc sql;
update compg.weeklyreturn
set returnusd=.
where gvkey='202022' and iid='01W' and datadate= input('11/17/2004',mmddyy10.);
quit;






proc sql;
select * from
compg.compustat_selected
where gvkey='208536' 
and iid='01W';
