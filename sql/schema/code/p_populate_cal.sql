DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `populate_cal`(start_date date, max_days int)
BEGIN
	declare x int default 0;
    declare new_date date;
	while (x < max_days) do
		set new_date = date_add(start_date, INTERVAL x DAY);
        if dayname(new_date) not in ('Saturday', 'Sunday') then
			insert ignore into cal (trade_date) values (new_date);
        end if;
		set x = x + 1;
    end while;
    
    
	delete from cal where trade_date = date("20220117"); ##Martin Luther King, Jr. Day	January 17, 2022	Closed
	delete from cal where trade_date = date("20220221"); ##Presidents Day	February 21, 2022	Closed
	delete from cal where trade_date = date("20220415"); ##Good Friday	April 15, 2022	Closed
	delete from cal where trade_date = date("20220530"); ##Memorial Day	May 30, 2022	Closed
	delete from cal where trade_date = date("20220620"); ##Juneteenth Holiday	June 20, 2022	Closed
	delete from cal where trade_date = date("20220704"); ##Independence Day	July 4, 2022	Closed
	delete from cal where trade_date = date("20220905"); ##Labor Day	September 5, 2022	Closed
	delete from cal where trade_date = date("20221124"); ##Thanksgiving Day	November 24, 2022	Closed
	delete from cal where trade_date = date("20221225"); ##Christmas Holiday	December 26, 2022	Closed


    delete from cal where trade_date = date("20230101"); ## New Year’s Day: Monday, Jan. 2 (observed)
	delete from cal where trade_date = date("20230116"); ##Martin Luther King Jr. Day: Monday, Jan. 16
	delete from cal where trade_date = date("20230220"); ##Washington’s Birthday: Monday, Feb. 20
	delete from cal where trade_date = date("20230407"); ##Good Friday: Friday, April 7
	delete from cal where trade_date = date("20230529"); ##Memorial Day: Monday, May 29
	delete from cal where trade_date = date("20230619"); ##Juneteenth National Independence Day: Monday, June 19
	delete from cal where trade_date = date("20230704"); ##Independence Day: Tuesday, July 4
	delete from cal where trade_date = date("20230904"); ##Labor Day: Monday, Sept. 4
	delete from cal where trade_date = date("20231123"); ##Thanksgiving: Thursday, Nov. 23
	delete from cal where trade_date = date("20231225"); ##Christmas: Monday, Dec. 25
    
    
	delete from cal where trade_date = date("20240101"); ##New Year's Day	January 1	Closed
	delete from cal where trade_date = date("20240115"); ##MLK, Jr. Day	January 15	Closed
	delete from cal where trade_date = date("20240219"); ##Presidents Day	February 19	Closed
	delete from cal where trade_date = date("20240329"); ##Good Friday	March 29	Closed
	delete from cal where trade_date = date("20240527"); ##Memorial Day	May 27	Closed
	delete from cal where trade_date = date("20240619"); ##Juneteenth	June 19	Closed
	delete from cal where trade_date = date("20240704"); ##Independence Day	July 4	Closed
	delete from cal where trade_date = date("20240902"); ##Labor Day	September 2	Closed
	delete from cal where trade_date = date("20241128"); ##Thanksgiving Day	November 28	Closed
	delete from cal where trade_date = date("20241225"); ##Christmas Day	December 25	Closed

END$$
DELIMITER ;
