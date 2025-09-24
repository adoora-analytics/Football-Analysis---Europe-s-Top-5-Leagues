select *
from players_data;


-- data cleaning

select count(nation)
from players_data
where comp = 'Premier League';

select avg(gls)
from players_data
where comp = 'bundesliga';

-- trim nation and comp columns 

update players_data
set nation = trim(substring_index(nation, ' ', -1))
where nation like '% %';

update players_data
set comp = trim(substring_index(comp, ' ', -2))
where comp like '% %'
;

update players_data
set comp = 'Bundesliga'
where comp = 'de Bundesliga';


-- data modelling
-- lists creation
-- basic player info

select rk, player, Nation, Pos, Squad, Comp, born, age,
		case
		when age <= 19 then 'Under 20'
		when age <= 24 then '20-24'
		when age <= 29 then '25-29'
        when age >= 30 then '30+'
		else 'unknown'
	end as 'age bracket'
from players_data
;

-- playing time & apps
select rk, Starts, Min, 90s
from players_data
;

-- attacking stats
select rk, gls, Ast, `G+A`, xG, xAG, xA, npxG, `G-PK`
from players_data
;

-- defensive stats
select rk, Tkl, tklw, Recov, `int`, `tkl+int`, clr, err, def
from players_data;

-- passing & creativity stats
select rk, KP, prgp, prgc, PrgDist, Cmp, `Cmp%`, Ast_stats_passing, xAG, PPA, sca, gca, cpa
from players_data;

-- players at their peak football age grouped by key passes
select Player, KP, Ast, Gls, xg, xa
from players_data
where age <= '27'
order by kp desc;

-- goalkeeping stats
select rk, ga, Saves, `Save%`, CS, `cs%`, PKA, PKcon, PKsv, `Launch%`, `Stp%`, `avgdist`, `Att (GK)`
from players_data
where pos = 'gk';

-- possession & ball control
select rk, rec, Touches, Carries, PrgR, mis, dis
from players_data;

-- misc stats
select rk, CrdY, Crdr, PKwon, pkcon, sot, `SoT%`, `sh/90`, kp, CrsPA, sw, tb, Off, fls, fld, onG, onGA, `Def 3rd`,`Mid 3rd`, `att 3rd`, att pen, ppm
from players_data;

-- bin list for grouping players based on age
select player, age,
	case
		when age <= 19 then 'Under 20'
		when age <= 24 then '20-24'
		when age <= 29 then '25-29'
        when age >= 30 then '30+'
		else 'unknown'
	end as 'age bracket'
from players_data
;

select distinct age,
	case
		when age <= 19 then 'Under 20'
		when age between 20 and 24 then '20-24'
		when age between 25 and 29 then '25-29'
        when age >= 30 then '30+'
		else 'unknown'
	end as 'age bracket'
from players_data
order by age;

-- most represented nationalities  by league
select 
		comp, 
		nation,
        count(*) as player_count
from players_data
group by comp, nation
order by comp, player_count desc;

select distinct count(nation) as nation_count,
		comp
from players_data
group by comp
order by comp, nation_count desc;

select count(distinct nation) as NationCount,
Comp
from players_data
group by Comp
order by NationCount desc ;

-- top nationality per league

select comp, nation, max_nation_count
from
		(select 
			comp, 
			nation,
			count(*) as max_nation_count,
			rank() over (partition by comp order by count(*) desc) as rnk
		from players_data
		group by comp, nation) as subquery
where rnk = 1
order by max_nation_count desc;

-- players represented by leagues
select comp, count(player) as player_count
from players_data
group by comp
order by player_count desc;

-- most represented countries by club
select 
		squad,
        nation,
        count(*) as player_count
from players_data
group by squad, nation
order by squad, player_count desc;

-- top nationality per squad
select squad, nation, max_nation_count
from
		(select 
			squad, 
			nation,
			count(*) as max_nation_count,
			rank() over (partition by squad order by count(*) desc) as rnk
		from players_data
		group by squad, nation) as subquery
where rnk = 1
order by nation, squad, max_nation_count desc;

select distinct pos
from players_data;

-- versatile young players
select player, pos
from players_data
where pos in  ('df,fw', 'fw,df', 'mf,fw', 'fw,mf', 'fw,df', 'df,fw') and Age <= 20
order by player;

-- MIDFIELDERS
-- Controller midfielder (possession & distribution)
-- no 8
select 	player, (touches * 90.0 / min) as touches_per_90, (cmp * 90.0 / min) as cmp_per_90, prgr, PrgC, (PrgDist * 90.0 / min) as prgDist_per_90
from players_data
where pos in ('mf', 'df,mf', 'mf,df', 'mf,fw', 'fw,mf');

select *
from players_data
limit 5;

-- defensive midfielder 
-- no 4 or 6

select player, 
			(tkl * 90.0 / min) as tkl_per_90, 
            (`int` * 90.0 / min) as int_per_90, 
            Recov, prgp, err, Blocks, dis
from players_data
where pos in ('mf', 'df,mf', 'mf,df');

-- attacking midfielders
-- no 10
select player, kp, xA, SCA, `G+A`, xG, prgp, prgr
from players_data
where pos in ('mf', 'df,mf', 'mf,df', 'mf,fw', 'fw,mf')
order by `G+A` desc;
;

-- rank based on prgp
select player, sum(prgp) as total_prgrp, sum(kp) total_key_passes,
rank() over (order by sum(prgp) desc) as ranking
from players_data
where pos in  ('mf', 'df,mf', 'mf,df', 'mf,fw', 'fw,mf')
group by player;

-- comparison btw mainoo, stiller, ugarte, caicedo and wharton
select player, (total_prgp * 90.0 / min) as prgp_90, (total_kp * 90.0 / min) as kp_90, (`int` * 90.0 / min) as int_90, ranking
from
		(select player, sum(prgp) as total_prgp, sum(kp) as total_kp, `Int`,min,
		rank() over (order by sum(prgp) desc) as ranking
		from players_data
		where pos in  ('mf', 'df,mf', 'mf,df', 'mf,fw', 'fw,mf')
		group by player, `int`, min) as subq
where player like '%ugarte%' or player like '%stiller%' or player like '%caicedo%' or player like '%wharton%' or player like '%mainoo%'
;

-- gk
select
	rk, 
	player,
	(
		(0.3 * `Save%` + 
		0.25 * CS + 
        0.2 * `PSxG+/-` + 
        0.1 * CrsPA + 
        0.1 * `Launch%` + 
        -0.1 * Err) / nullif(min, 0) * 90
	) as gk_rating
from players_data
where pos = 'gk'
order by gk_rating desc;

-- df
select player, squad, comp,
	(
		(0.35 * Tkl +
        0.3 * `Int` +
        0.15 * clr +
        0.1 * blocks +
        0.1 * err) / nullif(min, 0) * 90
	) as def_rating
from players_data
where pos in ('df') 
order by def_rating desc
;

-- mf
select player, squad, comp,
	(
		(0.25 * PrgP +
        0.2 * Ast +
        0.2 * xA +
        0.15 * kp +
        0.1 * tkl +
        0.1 * `int` +
        0.1 * Cmp) / nullif(min, 0) * 90
	) as mf_rating
from players_data
where pos = 'mf' 
order by mf_rating desc;

select player, squad, comp,
		rank() over(order by mf_rating desc) as mf_ranking
from
		(select player, squad, comp,
			(
				(0.25 * PrgP +
				0.2 * Ast +
				0.2 * xA +
				0.15 * kp +
				0.1 * tkl +
				0.1 * `int` +
				0.1 * Cmp) / nullif(min, 0) * 90
			) as mf_rating
		from players_data
		where pos = 'mf' 
		order by mf_rating desc) as subq
        ;
        
-- avg xG by league
select comp, avg(`xg+/-90` ) as avg_comp_xg
from
	(select player, comp, `xg+/-90` 
	from players_data
	) as avg
group by comp
;