proc sql;
create table compg.ctry
(ctry char(32),
 iso char(2),
 iso3 char(3),
region char(32),
isem char(2));
quit;

proc sql;
insert into compg.ctry
values('Australia','AU','AUS','Other DM','DM')
values('Austria','AT','AUT','EU','DM')
values('Belgium','BE','BEL','EU','DM')
values('Brazil','BR','BRA','Latin America','EM')
values('Canada','CA','CAN','North America','DM')
values('Chile','CL','CHL','Latin America','EM')
values('China','CN','CHN','Emerging Asia','EM')
values('Colombia','CO','COL','Latin America','EM')
values('Czech Republic','CZ','CZE','EMEA','EM')
values('Denmark','DK',,'DNK','EU','DM')
values('Egypt','EG','EGY','EMEA','EM')
values('Finland','FI','FIN','EU','DM')
values('France','FR','FRA','EU','DM')
values('Germany','DE','DEU','EU','DM')
values('Greece','GR','GRC','EMEA','EM')
values('Hong Kong','HK','HKG','Developed Pacific','DM')
values('Hungary','HU','HUN','EMEA','EM')
values('India','IN','IND','Emerging Asia','EM')
values('Indonesia','ID','IDN','Emerging Asia','EM')
values('Ireland','IE','IRL','EU','DM')
values('Israel','IL','ISR','Other DM','DM')
values('Italy','IT','ITA','EU','DM')
values('Japan','JP','JPN','Developed Pacific','DM')
values('South Korea','KR','KOR','Emerging Asia','EM')
values('Luxembourg','LU','LUX','EU','DM')
values('Malaysia','MY','MYS','Emerging Asia','EM')
values('Mexico','MX','MEX','Latin America','EM')
values('Morocco','MA','MAR','EMEA','EM')
values('Netherlands','NL','NLD','EU','DM')
values('New Zealand','NZ','NZL','Developed Pacific','DM')
values('Norway','NO','NOR','EU','DM')
values('Peru','PE','PER','Latin America','EM')
values('Philippines','PH','PHL','Emerging Asia','EM')
values('Poland','PL','POL','EMEA','EM')
values('Portugal','PT','PRT','EU','DM')
values('Russia','RU','RUS','EMEA','EM')
values('Singapore','SG','SGP','Other EU','DM')
values('South Africa','ZA','ZAF','EMEA','EM')
values('Spain','ES','ESP','Developed Euro','DM')
values('Sweden','SE','SWE','Developed Euro','DM')
values('Switzerland','CH','CHE','Developed other Europe','DM')
values('Taiwan','TW','TWN','Emerging Asia','EM')
values('Thailand','TH','THA','Emerging Asia','EM')
values('Turkey','TR','TUR','EMEA','EM')
values('UK','GB','GBR','Developed other Europe','DM')
values('US','US','USA','North America','DM')
;
quit;
