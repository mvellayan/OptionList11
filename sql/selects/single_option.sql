select * from project_all
where op_oq_id = 3920311
and DATE_FORMAT(op_date,'%H') between 10 and 14
and abs(op_iv) <= 5
and con_id = 444905767;
