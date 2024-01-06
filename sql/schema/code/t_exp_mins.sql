

select get_exp_mins(STR_TO_DATE('20221228 09:30', '%Y%m%d %H:%i'), STR_TO_DATE('20221229', '%Y%m%d')) = 780;
select get_exp_mins(STR_TO_DATE('20221228 10:00', '%Y%m%d %H:%i'), STR_TO_DATE('20221229', '%Y%m%d')) = 750;
select get_exp_mins(STR_TO_DATE('20221228 11:00', '%Y%m%d %H:%i'), STR_TO_DATE('20221229', '%Y%m%d')) = 690;
select get_exp_mins(STR_TO_DATE('20221228 15:00', '%Y%m%d %H:%i'), STR_TO_DATE('20221229', '%Y%m%d')) = 450;

select get_exp_mins(STR_TO_DATE('20221228 16:00', '%Y%m%d %H:%i'), STR_TO_DATE('20221229', '%Y%m%d')) = 390;
select get_exp_mins(STR_TO_DATE('20221229 09:30', '%Y%m%d %H:%i'), STR_TO_DATE('20221229', '%Y%m%d')) = 390;

select * from logs;
truncate logs;
select STR_TO_DATE('20230105 09:30', '%Y%m%d %H:%i');
select date_format(STR_TO_DATE('20230105 09:30', '%Y%m%d %H:%i'), '%Y%m%d %H:%i:00');
select date_format(STR_TO_DATE('20230104', '%Y%m%d'),'%i') ;