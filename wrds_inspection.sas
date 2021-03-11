rsubmit;
proc contents data=work._all_;run;
endrsubmit;

signoff;
proc sql;
select count(*) from compg.security;


proc sql;
create table diff as 
select * from compg.socklistall a,
left join compg.compustat_selected b
on(a.gkey=b.gvkey and a.iid=b.iid)
where b.gvkey is null;

