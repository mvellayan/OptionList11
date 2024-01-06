DELIMITER $$
drop function if exists get_tv$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_tv`(
	sq_trade_average double(9,3), 
	strike double(9,3),
    oq_bid_avg double(9,4),
    oq_ask_avg double(9,4),
	option_type varchar(1),
    transaction_type varchar(10)) RETURNS double(9,4)
    DETERMINISTIC
BEGIN
  declare iv, tv double(9,3);
  set iv = greatest(0.0, get_iv(sq_trade_average, strike, option_type));
  # https://www.ig.com/en/trading-strategies/option-pricing--the-intrinsic-and-time-values-of-options-explain-220111
  # TV = premium - IV
  if transaction_type = 'OPEN' then 
     set tv = oq_bid_avg - iv;
  elseif transaction_type = 'CLOSE' then
	 set tv = oq_ask_avg - iv;
  else
	set tv = 1/0;
  end if;
  RETURN round(tv,3);
END$$
DELIMITER ;
