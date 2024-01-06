use ol7;
drop view if exists project_all;
create view project_all as
select
     op_date,
     op_sq_id,
     op_oq_id,
     op_sq_trade_average,
     op_sq_trade_average_delta_30,
     op_sq_barcount_sum_30,
     op_oq_trade_average,
     op_oq_trade_average_delta_30,
     op_oq_barcount_sum_30,
     op_iv,
     op_tv,
     op_dur,

  sq.quote_date cl_date,
  sq.id cl_sq_id,
  oq.id cl_oq_id,
  sq.trade_average  cl_sq_trade_average,
  format(sq.trade_average_delta_30,3) cl_sq_trade_average_delta_30,
  sq.barcount_sum_30 cl_sq_barcount_sum_30,

  oq.trade_average cl_oq_trade_average,
  format(oq.trade_average_delta_30,3) cl_oq_trade_average_delta_30,
  oq.barcount_sum_30 cl_oq_barcount_sum_30,

  oq.iv cl_iv,
  oq.close_tv cl_tv,
  get_exp_mins(sq.quote_date, expiry) cl_dur,

  /* Position Summary */
  /* get_min_diff(oo.op_date, sq.quote_date) pos_dur, */
  round(TIME_TO_SEC(TIMEDIFF(sq.quote_date, oo.op_date))/60,0) pos_dur,
  get_net(op_sq_bid_average, op_sq_ask_average,
      op_oq_bid_average, op_oq_ask_average,
      sq.bid_avg , sq.ask_avg,
      oq.bid_avg , oq.ask_avg, 'OPT') net_opt,
  get_net(op_sq_bid_average, op_sq_ask_average,
      op_oq_bid_average, op_oq_ask_average,
      sq.bid_avg , sq.ask_avg,
      oq.bid_avg , oq.ask_avg, 'STK') net_stk,
  get_net(op_sq_bid_average, op_sq_ask_average,
      op_oq_bid_average, op_oq_ask_average,
      sq.bid_avg , sq.ask_avg,
      oq.bid_avg , oq.ask_avg, 'NET') net_tot,

  /* Option List */
     oo.con_id,
     expiry,
     strike,
     local_symbol

from  option_quote oq, stock_quote sq, open_options oo
where sq.quote_date = oq.quote_date
and oo.con_id = oq.con_id
and oo.op_date < sq.quote_date
and op_oq_id = 3920311
and date(oo.op_date) = date(sq.quote_date)
order by sq.quote_date;
