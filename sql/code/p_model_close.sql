DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `model_close`(in p_model_id int)
BEGIN
     declare l_con_id_list varchar(2048);
	 declare l_op_tv, l_op_iv, l_cl_tv, l_cl_iv double;
	 declare l_con_id int;
     select con_id_list, op_iv, op_tv, cl_iv, cl_tv into l_con_id_list, l_op_iv, l_op_tv, l_cl_iv,  l_cl_tv from model where model_id = p_model_id;
     truncate table logs;
    
    BLOCK1: begin 
		declare cl_p1_flag int default 0;
        declare l_op_oq_id int;
        declare l_op_oq_date datetime;
	    declare cl_p1 cursor for 
			select r.op_oq_id, oq.quote_date, oq.con_id
			from model_run r, option_quote oq
			where r.model_id = p_model_id
			and oq.id = r.op_oq_id
			and r.cl_oq_id is null;
 		-- DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET cl_p1_flag = 1;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET cl_p1_flag = TRUE;
        open cl_p1;
		cl_p1_loop: LOOP
        FETCH cl_p1 INTO l_op_oq_id, l_op_oq_date, l_con_id;
            IF cl_p1_flag THEN 
                close cl_p1;
				LEAVE cl_p1_loop; 
            END IF;
            
            -- BLOCK2 ----------------------------------------
			BLOCK2: BEGIN
				declare cl_p2_flag int default 0;
				declare l_cl_oq_id, l_op_days, l_cl_days int;
                declare l_net double(9,4);
				declare cl_p2 cursor for 
						select oq.id
							-- sq.quote_date, ol.expiry, datediff(ol.expiry, oq.quote_date) AS date_difference,
							-- sq.trade_average stock_quote, ol.strike, oq.trade_average option_quote, oq.iv, oq.open_tv, oq.close_tv 
						from stock_quote sq, option_quote oq, option_list ol
						where oq.con_id = ol.con_id 
						and oq.quote_date = sq.quote_date
						and oq.quote_date > l_op_oq_date
                        and oq.con_id = l_con_id
						-- criteria
						and oq.close_tv <= ifnull(l_cl_tv, oq.close_tv)
						and oq.iv <= ifnull(l_cl_iv, oq.iv)
						order by sq.quote_date;
				declare continue handler for not found set cl_p2_flag = true;
				open cl_p2; 
                -- insert into logs (log) values (CONCAT_WS(' ', 'l_con_id:', l_con_id, ' l_op_oq_date:', l_op_oq_date, ' l_cl_tv:', l_cl_tv, ' l_cl_iv:', l_cl_iv));
				cl_p2_loop: LOOP
				fetch from cl_p2 INTO l_cl_oq_id;
					if cl_p2_flag THEN
                      update model_run set cl_oq_id =0, reason="Expired" where model_id = p_model_id and op_oq_id = l_op_oq_id;
					  close cl_p2;
					  leave cl_p2_loop;
					end if;
                    call get_net(l_op_oq_id, l_cl_oq_id, l_net, l_op_days, l_cl_days);
                    update model_run 
                       set cl_oq_id=l_cl_oq_id, net = l_net, op_days = l_op_days, cl_days = l_cl_days, reason="Found Exit"
					where model_id = p_model_id and op_oq_id = l_op_oq_id;
                    close cl_p2;
					leave cl_p2_loop;
				end loop cl_p2_loop;
			END BLOCK2;
			-- BLOCK2----------------------------------------
        end loop cl_p1_loop;
    end BLOCK1;
END$$
DELIMITER ;
