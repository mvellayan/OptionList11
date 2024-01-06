DELIMITER $$
DROP PROCEDURE IF EXISTS `model_open`;DROP PROCEDURE IF EXISTS `model_open`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `model_open`(in p_model_id int)
BEGIN
     declare l_sample_per_hr int;

     declare op cursor for 
        select DATE_FORMAT(sq.quote_date,'%Y-%m-%d %H'), me.run_id, count(oq.id), SUBSTRING(group_concat(oq.id order by rand()), 1, 10*m.sample_per_hr)
        from option_quote oq, option_list ol, stock_quote sq, model_exp me, model m
        where m.model_id = me.model_id 
        and oq.con_id = ol.con_id 
        and ol.expiry=me.expiry
        and oq.id not in (select oq.id from model_exp_run r where r.run_id = me.run_id)
        and oq.quote_date = sq.quote_date
        and option_type = 'C'
        and oq.open_tv >= ifnull(m.op_tv, oq.open_tv)
        and oq.iv >= ifnull(m.op_iv, oq.iv)
        and m.model_id = p_model_id
        group by DATE_FORMAT(sq.quote_date,'%Y-%m-%d %H'), me.run_id
        order by DATE_FORMAT(sq.quote_date,'%Y-%m-%d %H');
        

    select sample_per_hr into l_sample_per_hr from model where model_id = p_model_id;

    truncate table logs;    
    open op;
    begin
        declare exit_flag int default 0;
        declare l_quote_hr date;
        declare l_me_run_id int;
        declare l_quote_hr_count int;
        declare l_open_ids varchar(2048);
        declare l_loop_ctr INT default 0;

        DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET exit_flag = 1;
        opLoop: LOOP
        FETCH op INTO l_quote_hr, l_me_run_id, l_quote_hr_count, l_open_ids;
            IF exit_flag THEN LEAVE opLoop; 
            END IF;
              insert into logs (log) values ( CONCAT_WS(" ", l_quote_hr, l_quote_hr_count, l_open_ids));
              
              SET l_loop_ctr = 1;
              WHILE l_loop_ctr <= l_sample_per_hr DO
                INSERT IGNORE INTO model_exp_run (run_id, op_oq_id) VALUES (l_me_run_id, 
                        SUBSTRING_INDEX(SUBSTRING_INDEX(l_open_ids, ',',l_loop_ctr),',',-1));
                SET l_loop_ctr = l_loop_ctr + 1;
              END WHILE;
            
        end loop;
    end;
    close op;
END$$
DELIMITER ;
