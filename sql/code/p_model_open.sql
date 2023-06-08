DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `model_open`(in p_model_id int)
BEGIN
     declare l_con_id_list varchar(2048);
	 declare l_op_tv double;
	 declare l_op_iv double;
	 declare l_cl_tv double;
	 declare l_cl_iv double;


     declare op cursor for 
		select oq.id
		from option_quote oq, option_list ol, stock_quote sq 
		where oq.con_id = ol.con_id 
		and FIND_IN_SET(ol.con_id,l_con_id_list) > 0
        and oq.id not in (select oq.id from model_run r where r.model_id = 1 and FIND_IN_SET(oq.id,@l_con_id_list) > 0)
		and oq.quote_date = sq.quote_date
		and option_type = 'C'
        and oq.open_tv >= ifnull(l_op_tv, oq.open_tv)
        and oq.iv >= ifnull(l_op_iv, oq.iv)
		order by sq.quote_date;

    select con_id_list, op_iv, op_tv, cl_iv, cl_tv into l_con_id_list, l_op_iv, l_op_tv, l_cl_iv,  l_cl_tv from model where model_id = p_model_id;

    truncate table logs;
    insert into logs (log) values ( CONCAT_WS(" ", l_con_id_list, l_op_iv, l_op_tv, l_cl_iv,  l_cl_tv));
    
    open op;
    begin
		declare exit_flag int default 0;
        declare l_oq_id int;
		DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET exit_flag = 1;
		opLoop: LOOP
        FETCH op INTO l_oq_id;
            IF exit_flag THEN LEAVE opLoop; 
            END IF;
            insert into logs (log) values (l_oq_id);
            INSERT INTO model_run (model_id, op_oq_id) VALUES (p_model_id, l_oq_id);
        end loop;
    end;
    close op;
END$$
DELIMITER ;
