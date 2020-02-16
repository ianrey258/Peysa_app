-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 16, 2020 at 06:50 PM
-- Server version: 10.1.40-MariaDB
-- PHP Version: 7.1.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hanapyesa`
--

-- --------------------------------------------------------

--
-- Table structure for table `bidders`
--

CREATE TABLE `bidders` (
  `id` int(11) NOT NULL,
  `bidsectionId` int(11) NOT NULL,
  `accountId` int(11) NOT NULL,
  `itemId` int(11) NOT NULL,
  `isWinner` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bid_item`
--

CREATE TABLE `bid_item` (
  `id` int(11) NOT NULL,
  `accountId` int(11) NOT NULL,
  `bidItem` int(11) NOT NULL,
  `budgetMoney` int(11) NOT NULL,
  `bidStatus` int(11) NOT NULL,
  `datetime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gio_address`
--

CREATE TABLE `gio_address` (
  `id` int(11) NOT NULL,
  `storeId` int(11) NOT NULL,
  `longtitude` varchar(255) NOT NULL,
  `latitude` varchar(255) NOT NULL,
  `zipCode` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `id` int(11) NOT NULL,
  `itemName` varchar(255) NOT NULL,
  `itemPrice` varchar(255) NOT NULL,
  `itemDescription` varchar(255) NOT NULL,
  `itemStack` int(11) NOT NULL,
  `tagId` int(11) NOT NULL,
  `categoryId` int(11) NOT NULL,
  `topupId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `item_category`
--

CREATE TABLE `item_category` (
  `id` int(11) NOT NULL,
  `categoryName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `item_img`
--

CREATE TABLE `item_img` (
  `id` int(11) NOT NULL,
  `itemId` int(11) NOT NULL,
  `itemFilename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `item_rating`
--

CREATE TABLE `item_rating` (
  `itemId` int(11) NOT NULL,
  `5_Star` int(11) NOT NULL DEFAULT '0',
  `4_Star` int(11) NOT NULL DEFAULT '0',
  `3_Star` int(11) NOT NULL DEFAULT '0',
  `2_Star` int(11) NOT NULL DEFAULT '0',
  `1_Star` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `item_reviews`
--

CREATE TABLE `item_reviews` (
  `itemId` int(11) NOT NULL,
  `useraccountId` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `item_tags`
--

CREATE TABLE `item_tags` (
  `id` int(11) NOT NULL,
  `tagName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `id` int(11) NOT NULL,
  `customerId` int(11) NOT NULL,
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `orderStatus` int(11) NOT NULL,
  `taxId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order_list`
--

CREATE TABLE `order_list` (
  `orderId` int(11) NOT NULL,
  `itemId` int(11) NOT NULL,
  `orderQty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `statustype`
--

CREATE TABLE `statustype` (
  `id` int(11) NOT NULL,
  `statusName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `store`
--

CREATE TABLE `store` (
  `StoreId` int(11) NOT NULL,
  `accountId` int(11) NOT NULL,
  `storeName` varchar(255) NOT NULL,
  `storeInfo` varchar(255) NOT NULL,
  `storeAddress` varchar(255) NOT NULL,
  `storeRating` int(11) NOT NULL DEFAULT '0',
  `storeFollowers` int(11) NOT NULL DEFAULT '0',
  `storeVisited` int(11) NOT NULL DEFAULT '0',
  `vertificationImgName` varchar(255) NOT NULL,
  `storeAgreement` varchar(255) NOT NULL,
  `storeStatus` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `storefollowers`
--

CREATE TABLE `storefollowers` (
  `id` int(11) NOT NULL,
  `storeId` int(11) NOT NULL,
  `accountId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `storeimg`
--

CREATE TABLE `storeimg` (
  `id` int(11) NOT NULL,
  `storeId` int(11) NOT NULL,
  `storeFilename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `storeitem`
--

CREATE TABLE `storeitem` (
  `storeId` int(11) NOT NULL,
  `itemId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `store_rating`
--

CREATE TABLE `store_rating` (
  `storeId` int(11) NOT NULL,
  `5_Star` int(11) NOT NULL DEFAULT '0',
  `4_Star` int(11) NOT NULL DEFAULT '0',
  `3_Star` int(11) NOT NULL DEFAULT '0',
  `2_Star` int(11) NOT NULL DEFAULT '0',
  `1_Star` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tax_percentage`
--

CREATE TABLE `tax_percentage` (
  `id` int(11) NOT NULL,
  `taxPercentage` int(11) NOT NULL,
  `effectivityDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `topup_percentage`
--

CREATE TABLE `topup_percentage` (
  `id` int(11) NOT NULL,
  `topupPercentage` int(11) NOT NULL,
  `effectivityDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `UserId` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `userType` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_account`
--

CREATE TABLE `user_account` (
  `AccountId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `contactNo` varchar(255) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `userFilename` varchar(100) NOT NULL,
  `accountStatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_reports`
--

CREATE TABLE `user_reports` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reportStatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `zip_code`
--

CREATE TABLE `zip_code` (
  `id` int(11) NOT NULL,
  `province` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bidders`
--
ALTER TABLE `bidders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accountId` (`accountId`),
  ADD KEY `bidsectionId` (`bidsectionId`);

--
-- Indexes for table `bid_item`
--
ALTER TABLE `bid_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accountId` (`accountId`);

--
-- Indexes for table `gio_address`
--
ALTER TABLE `gio_address`
  ADD PRIMARY KEY (`id`),
  ADD KEY `storeId` (`storeId`),
  ADD KEY `zipCode` (`zipCode`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoryId` (`categoryId`),
  ADD KEY `tagId` (`tagId`),
  ADD KEY `topupId` (`topupId`);

--
-- Indexes for table `item_category`
--
ALTER TABLE `item_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `item_img`
--
ALTER TABLE `item_img`
  ADD PRIMARY KEY (`id`),
  ADD KEY `itemId` (`itemId`);

--
-- Indexes for table `item_rating`
--
ALTER TABLE `item_rating`
  ADD KEY `itemId` (`itemId`);

--
-- Indexes for table `item_reviews`
--
ALTER TABLE `item_reviews`
  ADD KEY `itemId` (`itemId`);

--
-- Indexes for table `item_tags`
--
ALTER TABLE `item_tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customerId` (`customerId`),
  ADD KEY `taxId` (`taxId`);

--
-- Indexes for table `order_list`
--
ALTER TABLE `order_list`
  ADD KEY `itemId` (`itemId`),
  ADD KEY `orderId` (`orderId`);

--
-- Indexes for table `statustype`
--
ALTER TABLE `statustype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`StoreId`),
  ADD KEY `accountId` (`accountId`),
  ADD KEY `storeStatus` (`storeStatus`);

--
-- Indexes for table `storefollowers`
--
ALTER TABLE `storefollowers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accountId` (`accountId`),
  ADD KEY `storeId` (`storeId`);

--
-- Indexes for table `storeimg`
--
ALTER TABLE `storeimg`
  ADD PRIMARY KEY (`id`),
  ADD KEY `storeId` (`storeId`);

--
-- Indexes for table `storeitem`
--
ALTER TABLE `storeitem`
  ADD KEY `itemId` (`itemId`),
  ADD KEY `storeId` (`storeId`);

--
-- Indexes for table `store_rating`
--
ALTER TABLE `store_rating`
  ADD KEY `storeId` (`storeId`);

--
-- Indexes for table `tax_percentage`
--
ALTER TABLE `tax_percentage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `topup_percentage`
--
ALTER TABLE `topup_percentage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserId`);

--
-- Indexes for table `user_account`
--
ALTER TABLE `user_account`
  ADD PRIMARY KEY (`AccountId`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `user_reports`
--
ALTER TABLE `user_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `zip_code`
--
ALTER TABLE `zip_code`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bidders`
--
ALTER TABLE `bidders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bid_item`
--
ALTER TABLE `bid_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gio_address`
--
ALTER TABLE `gio_address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_category`
--
ALTER TABLE `item_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_img`
--
ALTER TABLE `item_img`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_tags`
--
ALTER TABLE `item_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `statustype`
--
ALTER TABLE `statustype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `store`
--
ALTER TABLE `store`
  MODIFY `StoreId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `storefollowers`
--
ALTER TABLE `storefollowers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `storeimg`
--
ALTER TABLE `storeimg`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_percentage`
--
ALTER TABLE `tax_percentage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `topup_percentage`
--
ALTER TABLE `topup_percentage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `UserId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_account`
--
ALTER TABLE `user_account`
  MODIFY `AccountId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_reports`
--
ALTER TABLE `user_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `zip_code`
--
ALTER TABLE `zip_code`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bidders`
--
ALTER TABLE `bidders`
  ADD CONSTRAINT `bidders_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `user_account` (`AccountId`),
  ADD CONSTRAINT `bidders_ibfk_2` FOREIGN KEY (`bidsectionId`) REFERENCES `bid_item` (`id`);

--
-- Constraints for table `bid_item`
--
ALTER TABLE `bid_item`
  ADD CONSTRAINT `bid_item_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `user_account` (`AccountId`);

--
-- Constraints for table `gio_address`
--
ALTER TABLE `gio_address`
  ADD CONSTRAINT `gio_address_ibfk_1` FOREIGN KEY (`storeId`) REFERENCES `store` (`StoreId`),
  ADD CONSTRAINT `gio_address_ibfk_2` FOREIGN KEY (`zipCode`) REFERENCES `zip_code` (`id`);

--
-- Constraints for table `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `item_ibfk_1` FOREIGN KEY (`categoryId`) REFERENCES `item_category` (`id`),
  ADD CONSTRAINT `item_ibfk_2` FOREIGN KEY (`tagId`) REFERENCES `item_tags` (`id`),
  ADD CONSTRAINT `item_ibfk_3` FOREIGN KEY (`topupId`) REFERENCES `topup_percentage` (`id`);

--
-- Constraints for table `item_img`
--
ALTER TABLE `item_img`
  ADD CONSTRAINT `item_img_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `item` (`id`);

--
-- Constraints for table `item_rating`
--
ALTER TABLE `item_rating`
  ADD CONSTRAINT `item_rating_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `item` (`id`);

--
-- Constraints for table `item_reviews`
--
ALTER TABLE `item_reviews`
  ADD CONSTRAINT `item_reviews_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `item` (`id`);

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `user_account` (`AccountId`),
  ADD CONSTRAINT `order_ibfk_2` FOREIGN KEY (`taxId`) REFERENCES `tax_percentage` (`id`);

--
-- Constraints for table `order_list`
--
ALTER TABLE `order_list`
  ADD CONSTRAINT `order_list_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `item` (`id`),
  ADD CONSTRAINT `order_list_ibfk_2` FOREIGN KEY (`orderId`) REFERENCES `order` (`id`);

--
-- Constraints for table `store`
--
ALTER TABLE `store`
  ADD CONSTRAINT `store_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `user_account` (`AccountId`),
  ADD CONSTRAINT `store_ibfk_2` FOREIGN KEY (`storeStatus`) REFERENCES `statustype` (`id`);

--
-- Constraints for table `storefollowers`
--
ALTER TABLE `storefollowers`
  ADD CONSTRAINT `storefollowers_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `user_account` (`AccountId`),
  ADD CONSTRAINT `storefollowers_ibfk_2` FOREIGN KEY (`storeId`) REFERENCES `store` (`StoreId`);

--
-- Constraints for table `storeimg`
--
ALTER TABLE `storeimg`
  ADD CONSTRAINT `storeimg_ibfk_1` FOREIGN KEY (`storeId`) REFERENCES `store` (`StoreId`);

--
-- Constraints for table `storeitem`
--
ALTER TABLE `storeitem`
  ADD CONSTRAINT `storeitem_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `item` (`id`),
  ADD CONSTRAINT `storeitem_ibfk_2` FOREIGN KEY (`storeId`) REFERENCES `store` (`StoreId`);

--
-- Constraints for table `store_rating`
--
ALTER TABLE `store_rating`
  ADD CONSTRAINT `store_rating_ibfk_1` FOREIGN KEY (`storeId`) REFERENCES `store` (`StoreId`);

--
-- Constraints for table `user_account`
--
ALTER TABLE `user_account`
  ADD CONSTRAINT `user_account_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`UserId`);

--
-- Constraints for table `user_reports`
--
ALTER TABLE `user_reports`
  ADD CONSTRAINT `user_reports_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user_account` (`AccountId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
