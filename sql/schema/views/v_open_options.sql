use ol7;
drop view if exists open_options;
create view open_options(
    op_date, op_sq_id, op_oq_id,
    op_sq_trade_average, op_sq_bid_average, op_sq_ask_average, op_sq_trade_average_delta_30, op_sq_barcount_sum_30,
    op_oq_trade_average, op_oq_bid_average, op_oq_ask_average, op_oq_trade_average_delta_30, op_oq_barcount_sum_30,
    op_iv, op_tv, op_dur,
    con_id, expiry, strike, local_symbol) as
select sq.quote_date op_date, sq.id op_sq_id,  oq.id op_oq_id,
       sq.trade_average op_sq_trade_average, sq.bid_avg , sq.ask_avg, format(sq.trade_average_delta_30,3) op_sq_trade_average_delta_30,
       sq.barcount_sum_30 op_sq_barcount_sum_30,

       oq.trade_average op_oq_trade_average, oq.bid_avg , oq.ask_avg, format(oq.trade_average_delta_30,3) op_oq_trade_average_delta_30,
       oq.barcount_sum_30 op_oq_barcount_sum_30,

       oq.iv op_iv, oq.open_tv op_tv, get_exp_mins(sq.quote_date, ol.expiry) op_dur,
       ol.con_id ol_con_id,  ol.expiry ol_expiry, ol.strike ol_strike,  ol.local_symbol ol_local_symbol
from  option_list ol, option_quote oq, stock_quote sq
where sq.quote_date = oq.quote_date
and oq.con_id = ol.con_id
and ol.option_type = 'C'

order by oq.con_id, sq.quote_date;