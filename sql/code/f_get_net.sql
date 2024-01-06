DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_net`(
	l_op_sq_bid double(9,3), l_op_sq_ask double(9,3), l_op_oq_bid double(9,3), l_op_oq_ask double(9,3),
    l_cl_sq_bid double(9,3), l_cl_sq_ask double(9,3), l_cl_oq_bid double(9,3), l_cl_oq_ask double(9,3),
    net_type varchar(10)) RETURNS double(9,3)
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE r_net double(9,3);
  # https://www.ig.com/en/trading-strategies/option-pricing--the-intrinsic-and-time-values-of-options-explain-220111

  if net_type = 'NET' then
     set r_net = (- l_op_sq_ask + l_op_oq_bid + l_cl_sq_bid - l_cl_oq_ask);
  elseif net_type = 'STK' then
     set r_net = (- l_op_sq_ask + l_cl_sq_bid );
  elseif net_type = 'OPT' then
     set r_net = (l_op_oq_bid - l_cl_oq_ask);
  else
	set r_net = null;
  end if;
  RETURN round(r_net,3);
END$$
DELIMITER ;
