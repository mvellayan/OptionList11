CREATE TABLE `hibernate_sequence` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `logs` (
  `idlogs` int NOT NULL AUTO_INCREMENT,
  `log` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idlogs`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `model` (
  `model_id` int NOT NULL AUTO_INCREMENT,
  `con_id_list` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `op_tv` double DEFAULT NULL,
  `op_iv` double DEFAULT NULL,
  `cl_tv` double DEFAULT NULL,
  `cl_iv` double DEFAULT NULL,
  PRIMARY KEY (`model_id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `model_run` (
  `model_id` int NOT NULL,
  `op_oq_id` int NOT NULL,
  `cl_oq_id` int DEFAULT NULL,
  `op_days` int DEFAULT NULL,
  `cl_days` int DEFAULT NULL,
  `net` double(9,3) DEFAULT NULL,
  `reason` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`model_id`,`op_oq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `option_list` (
  `con_id` int NOT NULL,
  `symbol` varchar(15) NOT NULL,
  `expiry` date NOT NULL,
  `strike` double(9,2) NOT NULL,
  `option_type` varchar(1) NOT NULL,
  `multiplier` int NOT NULL,
  `exchange` varchar(10) NOT NULL,
  `local_symbol` varchar(20) NOT NULL,
  PRIMARY KEY (`con_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `option_quote` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quote_date` datetime NOT NULL,
  `con_id` int NOT NULL,
  `trade_low` double(9,3) NOT NULL,
  `trade_average` double(9,3) NOT NULL,
  `trade_average_delta_30` double(9,3) DEFAULT NULL,
  `trade_average_delta_60` double(9,3) DEFAULT NULL,
  `trade_high` double(9,3) NOT NULL,
  `trade_volume` double(9,3) NOT NULL,
  `trade_barcount` int NOT NULL,
  `barcount_sum_30` int DEFAULT NULL,
  `barcount_sum_60` int DEFAULT NULL,
  `bid_min` double(9,3) DEFAULT NULL,
  `bid_avg` double(9,3) DEFAULT NULL,
  `ask_avg` double(9,3) DEFAULT NULL,
  `ask_max` double(9,3) DEFAULT NULL,
  `iv` double(9,3) DEFAULT NULL,
  `open_tv` double(9,3) DEFAULT NULL,
  `close_tv` double(9,3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `oq_conid_date` (`con_id`,`quote_date`),
  UNIQUE KEY `oq_date_conid` (`quote_date`,`con_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10192454 DEFAULT CHARSET=latin1;

CREATE TABLE `stock_list` (
  `con_id` int NOT NULL,
  `symbol` varchar(15) NOT NULL,
  `exchange` varchar(10) NOT NULL,
  PRIMARY KEY (`con_id`),
  UNIQUE KEY `symbol_UNIQUE` (`symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `stock_quote` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quote_date` datetime NOT NULL,
  `con_id` int NOT NULL,
  `trade_low` double NOT NULL,
  `trade_average` double NOT NULL,
  `trade_average_delta_30` double DEFAULT NULL,
  `trade_average_delta_60` double DEFAULT NULL,
  `trade_high` double NOT NULL,
  `trade_volume` double NOT NULL,
  `trade_barcount` int NOT NULL,
  `barcount_sum_30` int DEFAULT NULL,
  `barcount_sum_60` varchar(45) DEFAULT NULL,
  `bid_min` double DEFAULT NULL,
  `bid_avg` double DEFAULT NULL,
  `ask_avg` double DEFAULT NULL,
  `ask_max` double DEFAULT NULL,
  `vix` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sq_date_conid` (`quote_date`,`con_id`),
  UNIQUE KEY `sq_con_iddate` (`con_id`,`quote_date`)
) ENGINE=InnoDB AUTO_INCREMENT=121379 DEFAULT CHARSET=latin1;

CREATE TABLE `task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pull_date` date NOT NULL,
  `con_id` bigint NOT NULL,
  `symbol` varchar(15) NOT NULL,
  `expiry` date NOT NULL,
  `strike` double NOT NULL,
  `right` varchar(1) NOT NULL,
  `multiplier` int NOT NULL,
  `exchange` text NOT NULL,
  `secType` text NOT NULL,
  `status` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pull_date_con_id_UNIQUE` (`con_id`,`pull_date`)
) ENGINE=InnoDB AUTO_INCREMENT=38545 DEFAULT CHARSET=latin1;
