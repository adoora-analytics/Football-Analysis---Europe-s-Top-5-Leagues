-- performance score
-- midfielders
with mf_stats90 as(
				select rk, player,
					round(
						(2 * (ifnull(Gls, 0)  + ifnull(ast, 0) * 90 / ifnull(min, 1))) +
						(1.5 * ifnull(xA, 0) * 90 / ifnull(min, 1)) +
						(1 * ifnull(Prgp, 0) * 90 / ifnull(min, 1)) +
						(1 * ifnull(SCA, 0)  * 90 / ifnull(min, 1)) +
						(2 * ifnull(`Tkl+Int`, 0) * 90 / ifnull(min, 1)) +
						(1 * ifnull(kp, 0) * 90 / ifnull(min, 1)) +
						(0.5 * ifnull(CPA, 0) * 90 / ifnull(min, 1)) +
						(0.1 * ifnull(ppa, 0) * 90 / ifnull(min, 1)),
					2) as raw_rating
				from players_data
				where pos in ('mf','mf,df', 'df,mf') and min >= 600),
scaled as (
	select *,
			min(raw_rating) over () as min_rating,
            max(raw_rating) over () as max_rating
	from mf_stats90
)
select rk, player, raw_rating,
	round(
		case when max_rating = min_rating then 5 -- avoid divide by zero
        else 10.0 * (raw_rating - min_rating) / (max_rating - min_rating)
        end, 2) as mf_rating_scaled
from scaled
order by mf_rating_scaled desc; 


-- attackers
select rk, player,
	round(
		(4 * ifnull(Gls, 0)  * 90 / ifnull(min, 1)) +
		(2 * ifnull(ast, 0) * 90 / ifnull(min, 1)) +
		(0.1 * ifnull(xA, 0) * 90 / ifnull(min, 1)) +
		(0.8 * ifnull(sh, 0) * 90 / ifnull(min, 1)) +
		(0.2 * ifnull(kp, 0) * 90 / ifnull(min, 1)) +
		(0.1 * ifnull(xG, 0) * 90 / ifnull(min, 1)),
	2) as fw_rating
from players_data
where pos in ('fw', 'mf,fw', 'fw,mf') and min >= 900
order by fw_rating desc;


-- defenders
with def_stats90 as(
				select rk, player,
					round(
						(1 * ifnull(`tkl+int`, 0)  * 90 / ifnull(min, 1)) +
                        (1 * ifnull(xg, 0)  * 90 / ifnull(min, 1)) +
						(0.5 * ifnull(tklw, 0) * 90 / ifnull(min, 1)) +
						(-0.1 * ifnull(err, 0) * 90 / ifnull(min, 1)) +
						(2 * ifnull(clr, 0) * 90 / ifnull(min, 1)) +
						(1.5 * ifnull(blocks, 0) * 90 / ifnull(min, 1)) +
						(1.0 * ifnull(ppa, 0) * 90 / ifnull(min, 1)) +
						(1.0 * ifnull(Prgp, 0) * 90 / ifnull(min, 1)),
					2) as raw_rating
				from players_data
				where pos in ('df', 'df,mf', 'fw, df', 'df,fw') and min >= 2000),
scaled as (
	select *,
			min(raw_rating) over () as min_rating,
            max(raw_rating) over () as max_rating
	from def_stats90
)
select rk, player, raw_rating,
	round(
		case when max_rating = min_rating then 5 -- avoid divide by zero
        else 10.0 * (raw_rating - min_rating) / (max_rating - min_rating)
        end, 2) as def_rating_scaled
from scaled
order by def_rating_scaled desc; 

-- goalkeepers
select rk, player,
	round(
		(2.0 * ifnull(`save%`, 0)  * 90 / ifnull(min, 1)) +
        (1.5 * ifnull(cs, 0) * 90 / ifnull(min, 1)) +
        (-0.1 * ifnull(err, 0) * 90 / ifnull(min, 1)) +
        (2 * ifnull(`PSxG+/-`, 0) * 90 / ifnull(min, 1)) +
		(1.5 * ifnull(`launch%`, 0) * 90 / ifnull(min, 1)) +
		(1.0 * ifnull(crspa, 0) * 90 / ifnull(min, 1)),
	2) as gk_rating
from players_data
where pos in ('gk') and min >= 3000
order by gk_rating desc;