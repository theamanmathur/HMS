-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 04, 2017 at 02:52 PM
-- Server version: 5.7.14
-- PHP Version: 5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hotel2`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `after_checkout_ops` (IN `cid` VARCHAR(30), IN `cout` DATE, IN `days` INT(20), IN `amt` INT(30), IN `med` VARCHAR(30))  NO SQL
BEGIN
INSERT INTO cd_old(cust_id,name,phone,address,check_in,room_no) SELECT * FROM cust_details where cust_id=cid;
UPDATE cd_old SET check_out=cout WHERE cust_id=cid;
UPDATE room SET room_status='available' WHERE room_no = (SELECT room_no from cust_details WHERE cust_id=cid);
DELETE from cust_details WHERE cust_id=cid;
insert into rent_history values(cid,cout,days,amt,med);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `adv_payment`
--

CREATE TABLE `adv_payment` (
  `cust_id` varchar(20) NOT NULL,
  `paid` int(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `adv_payment`
--

INSERT INTO `adv_payment` (`cust_id`, `paid`) VALUES
('13', 1400),
('14', 900),
('29', 900),
('78', 1050),
('9', 800);

-- --------------------------------------------------------

--
-- Table structure for table `cd_old`
--

CREATE TABLE `cd_old` (
  `cust_id` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `phone` int(50) NOT NULL,
  `address` varchar(30) NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date DEFAULT NULL,
  `room_no` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cd_old`
--

INSERT INTO `cd_old` (`cust_id`, `name`, `phone`, `address`, `check_in`, `check_out`, `room_no`) VALUES
('1', 'Rohit ', 267345, 'allahabad', '2017-09-11', '2017-09-22', 6),
('10', 'Ankit', 458632, 'Wasseypur', '2017-06-16', '2017-06-21', 18),
('18', 'anthony', 225687, 'cunnigham road', '2017-11-03', '2017-11-08', 4),
('19', 'akbar', 789453, 'jamal road', '2017-11-03', '2017-11-04', 1),
('2', 'Shaahid', 684636, 'mumbai', '2016-12-03', '2016-12-14', 9),
('23', 'Santosh', 563857, 'bangalore', '2016-10-23', '2016-11-01', 5),
('24', 'aman', 591758, 'porbandar', '2017-10-29', '2017-10-30', 8),
('3', 'Raj', 684852, 'chennai', '2017-04-06', '2017-04-12', 2),
('33', 'Amritesh', 554862, 'faridabad', '2017-11-18', '2017-11-22', 3),
('39', 'Kamal', 454545, 'tamilnadu', '2017-11-10', '2017-11-14', 17),
('43', 'Karun', 5746982, 'jalahalli', '2017-11-18', '2017-12-01', 5),
('45', 'Sanjay', 4569875, 'chikkabanwara', '2017-11-18', '2017-11-29', 2),
('48', 'Allaudin', 558733, 'udaipur', '2017-11-27', '2017-11-30', 1),
('51', 'Ramesh', 123456789, 'mathikere', '2017-11-09', '2017-11-11', 2),
('52', 'Mithilesh', 267894, 'mumbai', '2017-11-07', '2017-11-10', 3),
('53', 'Subham', 675488, 'AGB layout', '2017-11-10', '2017-11-10', 6),
('65', 'Farukh', 657345, 'mannat', '2017-11-04', '2017-11-06', 2),
('8', 'Ahmed', 32557, 'abcdefg', '2017-11-27', '2017-12-04', 18);

-- --------------------------------------------------------

--
-- Table structure for table `cust_details`
--

CREATE TABLE `cust_details` (
  `cust_id` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `phone` bigint(70) NOT NULL,
  `address` varchar(30) NOT NULL,
  `check_in` date NOT NULL,
  `room_no` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cust_details`
--

INSERT INTO `cust_details` (`cust_id`, `name`, `phone`, `address`, `check_in`, `room_no`) VALUES
('13', 'Zed', 8778878787, 'jallahali', '2017-11-28', 4),
('14', 'Aarav', 7899102061, 'Bangalore', '2017-12-04', 5),
('29', 'Tom', 34532453, 'Koramangla', '2017-11-29', 3),
('49', 'ADAM', 56555, 'Mumbai', '2017-11-27', 17),
('78', 'Amarjeet', 678994, 'nelamangla', '2017-12-04', 19),
('9', 'Ram', 228564, 'malleswaram', '2017-11-20', 9);

--
-- Triggers `cust_details`
--
DELIMITER $$
CREATE TRIGGER `custid_validity` BEFORE INSERT ON `cust_details` FOR EACH ROW begin
	
   	declare msg1 varchar(128);
    declare msg2 varchar(128);
	set msg1 = concat('Trigger3:customer with this cust_id already EXISTS ', cast(new.cust_id as char));
    set msg2 = concat('Trigger3:Please enter a positive customer id ', cast(new.cust_id as char));
    if new.cust_id IN (SELECT cust_id FROM cust_details) OR new.cust_id IN (SELECT cust_id FROM cd_old) THEN
	signal sqlstate '45000' set message_text = msg1;
    end if;
    if (new.cust_id<=0) THEN
    signal sqlstate '45001' set message_text = msg2;
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `userid` varchar(30) COLLATE latin1_general_cs NOT NULL,
  `password` varchar(30) COLLATE latin1_general_cs NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`userid`, `password`) VALUES
('admin', 'hotel');

-- --------------------------------------------------------

--
-- Table structure for table `rent_history`
--

CREATE TABLE `rent_history` (
  `cust_id` varchar(30) NOT NULL,
  `check_out` date NOT NULL,
  `no_of_days` int(11) NOT NULL,
  `total_amount` int(11) NOT NULL,
  `paid_by` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rent_history`
--

INSERT INTO `rent_history` (`cust_id`, `check_out`, `no_of_days`, `total_amount`, `paid_by`) VALUES
('18', '2017-11-08', 5, 6500, 'cash'),
('19', '2017-11-04', 1, 1000, 'cheque'),
('33', '2017-11-22', 5, 4000, 'cash'),
('39', '2017-11-14', 5, 4000, 'cash'),
('43', '2017-12-01', 14, 21000, 'cheque'),
('45', '2017-11-29', 12, 18000, 'paytm'),
('48', '2017-11-30', 4, 4000, 'debit card'),
('51', '2017-11-11', 3, 4500, 'debit card'),
('52', '2017-11-10', 4, 3200, 'cash'),
('53', '2017-11-10', 1, 1300, 'cash'),
('65', '2017-11-06', 2, 3000, '.'),
('8', '2017-12-04', 8, 6400, 'debit card');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room_no` int(11) NOT NULL,
  `room_type` varchar(40) NOT NULL,
  `no_of_bed` int(11) NOT NULL,
  `rent` int(11) NOT NULL,
  `room_status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`room_no`, `room_type`, `no_of_bed`, `rent`, `room_status`) VALUES
(1, 'AC', 1, 1000, 'available'),
(2, 'AC', 2, 1500, 'available'),
(3, 'NON-AC', 1, 800, 'unavailable'),
(4, 'NON-AC', 2, 1300, 'unavailable'),
(5, 'AC', 2, 1500, 'unavailable'),
(6, 'NON-AC', 2, 1300, 'available'),
(7, 'AC', 1, 1000, 'available'),
(8, 'AC', 2, 1500, 'available'),
(9, 'NON-AC', 1, 800, 'unavailable'),
(10, 'NON-AC', 2, 1300, 'available'),
(11, 'AC', 1, 1000, 'available'),
(12, 'AC', 1, 1000, 'available'),
(13, 'AC', 1, 1000, 'available'),
(14, 'AC', 1, 1000, 'available'),
(15, 'AC', 2, 1500, 'available'),
(16, 'AC', 2, 1500, 'available'),
(17, 'NON-AC', 1, 800, 'unavailable'),
(18, 'NON-AC', 1, 800, 'available'),
(19, 'NON-AC', 1, 800, 'unavailable'),
(20, 'NON-AC', 2, 1300, 'available'),
(21, 'NON-AC', 2, 1300, 'available');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adv_payment`
--
ALTER TABLE `adv_payment`
  ADD PRIMARY KEY (`cust_id`);

--
-- Indexes for table `cd_old`
--
ALTER TABLE `cd_old`
  ADD PRIMARY KEY (`cust_id`),
  ADD KEY `fkold` (`room_no`);

--
-- Indexes for table `cust_details`
--
ALTER TABLE `cust_details`
  ADD PRIMARY KEY (`cust_id`),
  ADD KEY `fkcurrent` (`room_no`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `rent_history`
--
ALTER TABLE `rent_history`
  ADD PRIMARY KEY (`cust_id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`room_no`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `adv_payment`
--
ALTER TABLE `adv_payment`
  ADD CONSTRAINT `fkadvpay` FOREIGN KEY (`cust_id`) REFERENCES `cust_details` (`cust_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cd_old`
--
ALTER TABLE `cd_old`
  ADD CONSTRAINT `fkold` FOREIGN KEY (`room_no`) REFERENCES `room` (`room_no`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `cust_details`
--
ALTER TABLE `cust_details`
  ADD CONSTRAINT `fkcurrent` FOREIGN KEY (`room_no`) REFERENCES `room` (`room_no`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `rent_history`
--
ALTER TABLE `rent_history`
  ADD CONSTRAINT `fkhist` FOREIGN KEY (`cust_id`) REFERENCES `cd_old` (`cust_id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
