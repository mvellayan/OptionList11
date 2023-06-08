DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_net`(
    in p_op_ol_id int,
    in p_cl_ol_id int,
    out r_net double(9,4),
    out r_op_days int,
    out r_cl_days int)
BEGIN
	declare l_op_sq_bid, l_op_sq_ask, l_op_oq_bid, l_op_oq_ask, l_cl_sq_bid, l_cl_sq_ask, l_cl_oq_bid, l_cl_oq_ask double(9,4);

	select datediff(ol.expiry, oq.quote_date) AS date_difference,
		sq.bid_avg, sq.ask_avg, oq.bid_avg, oq.ask_avg
	into r_op_days, 
        l_op_sq_bid, l_op_sq_ask, l_op_oq_bid, l_op_oq_ask
	from stock_quote sq, option_quote oq, option_list ol
	where oq.con_id = ol.con_id 
	and oq.quote_date = sq.quote_date
	and oq.id = p_op_ol_id;
    
    select datediff(ol.expiry, oq.quote_date) AS date_difference,
		sq.bid_avg, sq.ask_avg, oq.bid_avg, oq.ask_avg
	into r_cl_days, 
        l_cl_sq_bid, l_cl_sq_ask, l_cl_oq_bid, l_cl_oq_ask
	from stock_quote sq, option_quote oq, option_list ol
	where oq.con_id = ol.con_id 
	and oq.quote_date = sq.quote_date
	and oq.id = p_cl_ol_id;
    
    set r_net = (- l_op_sq_ask + l_op_oq_bid + l_cl_sq_bid - l_cl_oq_ask);
    
END$$
DELIMITER ;
