DELIMITER $$
DROP PROCEDURE IF EXISTS `model_close`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `model_close`(in p_model_id int)
BEGIN
	 declare l_op_tv, l_op_iv, l_cl_tv, l_cl_iv double;
	 declare l_con_id, l_run_id int;
     select op_iv, op_tv, cl_iv, cl_tv into l_op_iv, l_op_tv, l_cl_iv,  l_cl_tv from model where model_id = p_model_id;
     truncate table logs;
    
    BLOCK1: begin 
		declare cl_p1_flag int default 0;
        declare l_op_oq_id int;
        declare l_op_oq_date datetime;
	    declare cl_p1 cursor for 
			select mr.op_oq_id, oq.quote_date, oq.con_id, mr.run_id
			from model_exp_run mr, model_exp me, option_quote oq
			where me.model_id = p_model_id
            and mr.run_id = me.run_id
			and oq.id = mr.op_oq_id
			and mr.cl_oq_id is null;
 		DECLARE CONTINUE HANDLER FOR NOT FOUND SET cl_p1_flag = TRUE;
        open cl_p1;
		cl_p1_loop: LOOP
        FETCH cl_p1 INTO l_op_oq_id, l_op_oq_date, l_con_id, l_run_id;
            IF cl_p1_flag THEN 
                close cl_p1;
				LEAVE cl_p1_loop; 
            END IF;
            
            -- BLOCK2 ----------------------------------------
			BLOCK2: BEGIN
				declare cl_p2_flag int default 0;
				declare l_cl_oq_id, l_op_days, l_cl_days int default 0;
                declare l_net double(9,4);
				declare cl_p2 cursor for 
						select oq.id
						from stock_quote sq, option_quote oq, model m
						where oq.quote_date = sq.quote_date
						and m.model_id = p_model_id
						and oq.quote_date > l_op_oq_date
						and oq.con_id = l_con_id
						and oq.close_tv <= ifnull(m.cl_tv, oq.close_tv)
						and oq.iv <= ifnull(m.cl_iv, oq.iv)
						order by sq.quote_date;
				declare continue handler for not found set cl_p2_flag = true;
				open cl_p2; 
                -- insert into logs (log) values (CONCAT_WS(' ', 'l_con_id:', l_con_id, ' l_op_oq_date:', l_op_oq_date, ' l_cl_tv:', l_cl_tv, ' l_cl_iv:', l_cl_iv));
				cl_p2_loop: LOOP
				fetch from cl_p2 INTO l_cl_oq_id;
					if cl_p2_flag THEN
                      select id into l_cl_oq_id from option_quote oq where con_id in (
							select con_id from option_quote oq where id = l_op_oq_id)
					  order by quote_date desc limit 1;                      
					  call get_net(l_op_oq_id, l_cl_oq_id, l_net, l_op_days, l_cl_days);
					  update model_exp_run 
						   set cl_oq_id=l_cl_oq_id, net = l_net, op_days = l_op_days, cl_days = l_cl_days, reason="Expired."
					  where run_id = l_run_id and op_oq_id = l_op_oq_id;
					  close cl_p2;
					  leave cl_p2_loop;
					end if;
                    
                    call get_net(l_op_oq_id, l_cl_oq_id, l_net, l_op_days, l_cl_days);
                    update model_exp_run 
                       set cl_oq_id=l_cl_oq_id, net = l_net, op_days = l_op_days, cl_days = l_cl_days, reason="Found Exit"
					where run_id = l_run_id and op_oq_id = l_op_oq_id;
                    close cl_p2;
					leave cl_p2_loop;
				end loop cl_p2_loop;
			END BLOCK2;
			-- BLOCK2----------------------------------------
        end loop cl_p1_loop;
    end BLOCK1;
END$$
DELIMITER ;
