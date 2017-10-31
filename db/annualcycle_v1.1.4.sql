CREATE DATABASE  IF NOT EXISTS `annualcycle` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `annualcycle`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: annualcycle
-- ------------------------------------------------------
-- Server version	5.7.17-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `calendar`
--

DROP TABLE IF EXISTS `calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendar` (
  `CalendarId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  `Public` tinyint(1) NOT NULL DEFAULT '0',
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CalendarId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendar`
--

LOCK TABLES `calendar` WRITE;
/*!40000 ALTER TABLE `calendar` DISABLE KEYS */;
INSERT INTO `calendar` VALUES (1,'Calendar #0',1,0),(2,'Calendar #1',0,0),(3,'Calendar #2',0,0),(4,'Calendar #3',1,0),(5,'Calendar #4',0,0),(6,'Calendar #5',0,0),(7,'Calendar #6',0,0),(8,'Calendar #7',1,0),(9,'Calendar #8',0,0),(10,'Calendar #9',0,0);
/*!40000 ALTER TABLE `calendar` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagallcalendarcontent AFTER UPDATE ON Calendar
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "1" AND Old.Deleted <=> "0" THEN

    UPDATE EventCalendar
	SET Deleted = '1'
	WHERE CalendarId = NEW.CalendarId;
    
	UPDATE Usercalendars
	SET Deleted = '1'
	WHERE CalendarId = NEW.CalendarId;
    
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER Calendar_del BEFORE DELETE ON Calendar
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `eventcalendar`
--

DROP TABLE IF EXISTS `eventcalendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventcalendar` (
  `EventId` int(11) NOT NULL,
  `CalendarId` int(11) NOT NULL,
  `Notificationsent` tinyint(1) NOT NULL DEFAULT '0',
  `rw` tinyint(1) NOT NULL DEFAULT '1',
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EventId`,`CalendarId`),
  KEY `CalendarId_idx` (`CalendarId`),
  CONSTRAINT `eventcalendar_ibfk_1` FOREIGN KEY (`EventId`) REFERENCES `eventn` (`EventId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `eventcalendar_ibfk_2` FOREIGN KEY (`CalendarId`) REFERENCES `calendar` (`CalendarId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventcalendar`
--

LOCK TABLES `eventcalendar` WRITE;
/*!40000 ALTER TABLE `eventcalendar` DISABLE KEYS */;
INSERT INTO `eventcalendar` VALUES (1,6,0,1,0),(1,9,0,1,0),(2,8,0,1,0),(3,6,0,1,0),(5,4,0,1,0),(5,6,0,1,0),(5,7,0,1,0),(6,6,0,1,0),(9,4,0,1,0),(10,2,0,1,0),(10,5,0,1,0),(12,6,0,1,0),(13,3,0,1,0),(13,10,0,1,0),(15,1,0,1,0),(15,8,0,1,0),(17,1,0,1,0),(17,2,0,1,0),(18,5,0,1,0),(19,5,0,1,0),(19,6,0,1,0),(20,3,0,1,0),(21,4,0,1,0),(23,3,0,1,0),(23,6,0,1,0),(23,8,0,1,0),(25,1,0,1,0),(25,6,0,1,0),(26,2,0,1,0),(26,7,0,1,0),(26,10,0,1,0),(28,5,0,1,0),(29,10,0,1,0),(30,2,0,1,0),(31,1,0,1,0),(31,3,0,1,0),(31,8,0,1,0),(33,4,0,1,0),(33,5,0,1,0),(33,9,0,1,0),(36,6,0,1,0),(36,9,0,1,0),(37,8,0,1,0),(38,4,0,1,0),(39,2,0,1,0),(39,4,0,1,0),(40,2,0,1,0),(41,3,0,1,0),(42,8,0,1,0),(43,2,0,1,0),(43,10,0,1,0),(44,6,0,1,0),(48,2,0,1,0),(48,8,0,1,0),(49,2,0,1,0),(50,1,0,1,0),(50,5,0,1,0),(51,9,0,1,0),(55,7,0,1,0),(57,6,0,1,0),(57,7,0,1,0),(58,9,0,1,0),(59,1,0,1,0),(61,1,0,1,0),(61,2,0,1,0),(62,8,0,1,0),(62,10,0,1,0),(63,2,0,1,0),(64,5,0,1,0),(65,5,0,1,0),(65,6,0,1,0),(66,9,0,1,0),(67,10,0,1,0),(68,7,0,1,0),(68,8,0,1,0),(69,5,0,1,0),(69,7,0,1,0),(70,9,0,1,0),(70,10,0,1,0),(72,8,0,1,0),(75,8,0,1,0),(77,2,0,1,0),(77,4,0,1,0),(78,7,0,1,0),(78,10,0,1,0),(79,7,0,1,0),(80,3,0,1,0),(82,2,0,1,0),(83,1,0,1,0),(83,8,0,1,0),(84,3,0,1,0),(84,6,0,1,0),(86,1,0,1,0),(89,2,0,1,0),(90,1,0,1,0),(90,4,0,1,0),(91,1,0,1,0),(91,3,0,1,0),(93,4,0,1,0),(93,9,0,1,0),(95,3,0,1,0),(95,5,0,1,0),(97,5,0,1,0),(97,6,0,1,0),(98,3,0,1,0),(102,1,0,1,0),(102,8,0,1,0),(103,2,0,1,0),(103,9,0,1,0),(103,10,0,1,0),(104,3,0,1,0),(105,3,0,1,0),(105,7,0,1,0),(106,2,0,1,0),(108,1,0,1,0),(108,5,0,1,0),(109,7,0,1,0),(110,5,0,1,0),(114,2,0,1,0),(115,1,0,1,0),(115,3,0,1,0),(115,7,0,1,0),(115,8,0,1,0),(118,1,0,1,0),(119,5,0,1,0),(120,5,0,1,0);
/*!40000 ALTER TABLE `eventcalendar` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER EventCalendar_del BEFORE DELETE ON EventCalendar
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `eventfiles`
--

DROP TABLE IF EXISTS `eventfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventfiles` (
  `EventId` int(11) NOT NULL,
  `FileId` int(11) NOT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EventId`,`FileId`),
  KEY `FileId_idx` (`FileId`),
  CONSTRAINT `eventfiles_ibfk_1` FOREIGN KEY (`EventId`) REFERENCES `eventn` (`EventId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `eventfiles_ibfk_2` FOREIGN KEY (`FileId`) REFERENCES `files` (`FileId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventfiles`
--

LOCK TABLES `eventfiles` WRITE;
/*!40000 ALTER TABLE `eventfiles` DISABLE KEYS */;
INSERT INTO `eventfiles` VALUES (25,3,0),(29,2,0),(48,3,0),(82,2,0),(107,4,0);
/*!40000 ALTER TABLE `eventfiles` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER eventfiles_del BEFORE DELETE ON eventfiles
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `eventn`
--

DROP TABLE IF EXISTS `eventn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventn` (
  `EventId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  `Description` text,
  `Start` datetime NOT NULL,
  `End` datetime DEFAULT NULL,
  `Interval` char(1) DEFAULT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EventId`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventn`
--

LOCK TABLES `eventn` WRITE;
/*!40000 ALTER TABLE `eventn` DISABLE KEYS */;
INSERT INTO `eventn` VALUES (1,'event #0',NULL,'2018-03-23 00:00:00','2018-07-06 00:00:00',NULL,0),(2,'event #1',NULL,'2018-04-07 00:00:00','2018-07-13 00:00:00',NULL,0),(3,'event #2',NULL,'2019-02-22 00:00:00','2019-10-25 00:00:00',NULL,0),(4,'event #3',NULL,'2018-01-11 00:00:00','2018-08-15 00:00:00',NULL,0),(5,'event #4',NULL,'2017-01-12 00:00:00','2017-09-15 00:00:00',NULL,0),(6,'event #5',NULL,'2018-05-18 00:00:00','2018-05-29 00:00:00',NULL,0),(7,'event #6',NULL,'2017-01-14 00:00:00','2017-09-15 00:00:00',NULL,0),(8,'event #7',NULL,'2018-05-27 00:00:00','2018-09-09 00:00:00',NULL,0),(9,'event #8',NULL,'2018-02-01 00:00:00','2018-10-11 00:00:00',NULL,0),(10,'event #9',NULL,'2017-08-18 00:00:00','2017-09-29 00:00:00',NULL,0),(11,'event #10',NULL,'2017-01-24 00:00:00','2017-05-27 00:00:00',NULL,0),(12,'event #11',NULL,'2017-08-22 00:00:00','2017-10-27 00:00:00',NULL,0),(13,'event #12',NULL,'2018-06-14 00:00:00','2018-08-08 00:00:00',NULL,0),(14,'event #13',NULL,'2017-11-28 00:00:00','2017-11-29 00:00:00',NULL,0),(15,'event #14',NULL,'2017-04-28 00:00:00','2017-08-08 00:00:00',NULL,0),(16,'event #15',NULL,'2018-05-09 00:00:00','2018-07-08 00:00:00',NULL,0),(17,'event #16',NULL,'2018-04-02 00:00:00','2018-06-08 00:00:00',NULL,0),(18,'event #17',NULL,'2018-02-16 00:00:00','2018-11-23 00:00:00',NULL,0),(19,'event #18',NULL,'2019-07-10 00:00:00','2019-10-15 00:00:00',NULL,0),(20,'event #19',NULL,'2018-10-17 00:00:00','2018-10-20 00:00:00',NULL,0),(21,'event #20',NULL,'2017-04-14 00:00:00','2017-04-26 00:00:00',NULL,0),(22,'event #21',NULL,'2018-03-26 00:00:00','2018-09-13 00:00:00',NULL,0),(23,'event #22',NULL,'2019-01-26 00:00:00','2019-11-17 00:00:00',NULL,0),(24,'event #23',NULL,'2019-07-30 00:00:00','2019-10-10 00:00:00',NULL,0),(25,'event #24',NULL,'2017-05-19 00:00:00','2017-09-15 00:00:00',NULL,0),(26,'event #25',NULL,'2019-01-12 00:00:00','2019-09-21 00:00:00',NULL,0),(27,'event #26',NULL,'2018-06-26 00:00:00','2018-07-11 00:00:00',NULL,0),(28,'event #27',NULL,'2018-07-18 00:00:00','2018-09-10 00:00:00',NULL,0),(29,'event #28',NULL,'2017-03-05 00:00:00','2017-04-26 00:00:00',NULL,0),(30,'event #29',NULL,'2018-01-19 00:00:00','2018-05-16 00:00:00',NULL,0),(31,'event #30',NULL,'2017-04-19 00:00:00','2017-07-12 00:00:00',NULL,0),(32,'event #31',NULL,'2018-08-02 00:00:00','2018-10-27 00:00:00',NULL,0),(33,'event #32',NULL,'2018-02-06 00:00:00','2018-07-29 00:00:00',NULL,0),(34,'event #33',NULL,'2018-01-25 00:00:00','2018-04-10 00:00:00',NULL,0),(35,'event #34',NULL,'2019-02-19 00:00:00','2019-09-08 00:00:00',NULL,0),(36,'event #35',NULL,'2018-05-19 00:00:00','2018-09-29 00:00:00',NULL,0),(37,'event #36',NULL,'2019-02-02 00:00:00','2019-02-14 00:00:00',NULL,0),(38,'event #37',NULL,'2019-07-27 00:00:00','2019-07-28 00:00:00',NULL,0),(39,'event #38',NULL,'2019-10-12 00:00:00','2019-11-08 00:00:00',NULL,0),(40,'event #39',NULL,'2019-01-23 00:00:00','2019-01-27 00:00:00',NULL,0),(41,'event #40',NULL,'2019-06-15 00:00:00','2019-11-03 00:00:00',NULL,0),(42,'event #41',NULL,'2019-09-13 00:00:00','2019-09-27 00:00:00',NULL,0),(43,'event #42',NULL,'2019-05-16 00:00:00','2019-05-20 00:00:00',NULL,0),(44,'event #43',NULL,'2018-02-02 00:00:00','2018-02-06 00:00:00',NULL,0),(45,'event #44',NULL,'2019-05-20 00:00:00','2019-05-27 00:00:00',NULL,0),(46,'event #45',NULL,'2017-06-22 00:00:00','2017-06-23 00:00:00',NULL,0),(47,'event #46',NULL,'2017-02-21 00:00:00','2017-06-17 00:00:00',NULL,0),(48,'event #47',NULL,'2018-07-05 00:00:00','2018-07-07 00:00:00',NULL,0),(49,'event #48',NULL,'2017-05-28 00:00:00','2017-11-06 00:00:00',NULL,0),(50,'event #49',NULL,'2017-11-13 00:00:00','2017-11-22 00:00:00',NULL,0),(51,'event #50',NULL,'2017-05-01 00:00:00','2017-10-02 00:00:00',NULL,0),(52,'event #51',NULL,'2017-08-04 00:00:00','2017-10-03 00:00:00',NULL,0),(53,'event #52',NULL,'2019-03-05 00:00:00','2019-07-24 00:00:00',NULL,0),(54,'event #53',NULL,'2018-09-19 00:00:00','2018-11-16 00:00:00',NULL,0),(55,'event #54',NULL,'2019-06-27 00:00:00','2019-07-16 00:00:00',NULL,0),(56,'event #55',NULL,'2017-01-07 00:00:00','2017-02-17 00:00:00',NULL,0),(57,'event #56',NULL,'2018-03-09 00:00:00','2018-10-27 00:00:00',NULL,0),(58,'event #57',NULL,'2019-04-25 00:00:00','2019-07-29 00:00:00',NULL,0),(59,'event #58',NULL,'2017-05-27 00:00:00','2017-10-17 00:00:00',NULL,0),(60,'event #59',NULL,'2018-03-23 00:00:00','2018-04-18 00:00:00',NULL,0),(61,'event #60',NULL,'2019-06-12 00:00:00','2019-06-13 00:00:00',NULL,0),(62,'event #61',NULL,'2018-07-06 00:00:00','2018-10-18 00:00:00',NULL,0),(63,'event #62',NULL,'2018-09-26 00:00:00','2018-09-27 00:00:00',NULL,0),(64,'event #63',NULL,'2017-01-09 00:00:00','2017-01-14 00:00:00',NULL,0),(65,'event #64',NULL,'2017-08-12 00:00:00','2017-08-17 00:00:00',NULL,0),(66,'event #65',NULL,'2018-04-25 00:00:00','2018-08-26 00:00:00',NULL,0),(67,'event #66',NULL,'2019-07-21 00:00:00','2019-11-06 00:00:00',NULL,0),(68,'event #67',NULL,'2018-01-18 00:00:00','2018-06-23 00:00:00',NULL,0),(69,'event #68',NULL,'2019-09-08 00:00:00','2019-11-12 00:00:00',NULL,0),(70,'event #69',NULL,'2017-07-18 00:00:00','2017-09-05 00:00:00',NULL,0),(71,'event #70',NULL,'2018-01-21 00:00:00','2018-09-18 00:00:00',NULL,0),(72,'event #71',NULL,'2017-07-29 00:00:00','2017-10-26 00:00:00',NULL,0),(73,'event #72',NULL,'2018-07-15 00:00:00','2018-10-25 00:00:00',NULL,0),(74,'event #73',NULL,'2019-03-18 00:00:00','2019-05-12 00:00:00',NULL,0),(75,'event #74',NULL,'2018-07-17 00:00:00','2018-10-09 00:00:00',NULL,0),(76,'event #75',NULL,'2018-08-27 00:00:00','2018-08-30 00:00:00',NULL,0),(77,'event #76',NULL,'2019-05-01 00:00:00','2019-06-28 00:00:00',NULL,0),(78,'event #77',NULL,'2019-07-22 00:00:00','2019-09-27 00:00:00',NULL,0),(79,'event #78',NULL,'2019-01-22 00:00:00','2019-03-11 00:00:00',NULL,0),(80,'event #79',NULL,'2018-09-11 00:00:00','2018-10-29 00:00:00',NULL,0),(81,'event #80',NULL,'2017-04-23 00:00:00','2017-04-28 00:00:00',NULL,0),(82,'event #81',NULL,'2019-05-02 00:00:00','2019-05-21 00:00:00',NULL,0),(83,'event #82',NULL,'2017-04-03 00:00:00','2017-09-01 00:00:00',NULL,0),(84,'event #83',NULL,'2019-03-13 00:00:00','2019-08-13 00:00:00',NULL,0),(85,'event #84',NULL,'2018-04-07 00:00:00','2018-09-25 00:00:00',NULL,0),(86,'event #85',NULL,'2018-03-22 00:00:00','2018-06-19 00:00:00',NULL,0),(87,'event #86',NULL,'2017-08-30 00:00:00','2017-09-12 00:00:00',NULL,0),(88,'event #87',NULL,'2017-08-16 00:00:00','2017-11-13 00:00:00',NULL,0),(89,'event #88',NULL,'2017-04-24 00:00:00','2017-06-23 00:00:00',NULL,0),(90,'event #89',NULL,'2019-11-16 00:00:00','2019-11-28 00:00:00',NULL,0),(91,'event #90',NULL,'2017-03-26 00:00:00','2017-05-23 00:00:00',NULL,0),(92,'event #91',NULL,'2017-08-01 00:00:00','2017-10-19 00:00:00',NULL,0),(93,'event #92',NULL,'2017-02-19 00:00:00','2017-06-01 00:00:00',NULL,0),(94,'event #93',NULL,'2017-10-30 00:00:00','2017-10-31 00:00:00',NULL,0),(95,'event #94',NULL,'2018-06-13 00:00:00','2018-07-28 00:00:00',NULL,0),(96,'event #95',NULL,'2017-01-15 00:00:00','2017-07-21 00:00:00',NULL,0),(97,'event #96',NULL,'2019-04-04 00:00:00','2019-09-05 00:00:00',NULL,0),(98,'event #97',NULL,'2017-11-15 00:00:00','2017-11-28 00:00:00',NULL,0),(99,'event #98',NULL,'2018-11-04 00:00:00','2018-11-06 00:00:00',NULL,0),(100,'event #99',NULL,'2017-02-24 00:00:00','2017-07-25 00:00:00',NULL,0),(101,'event #100',NULL,'2019-01-15 00:00:00','2019-11-03 00:00:00',NULL,0),(102,'event #101',NULL,'2018-01-17 00:00:00','2018-09-10 00:00:00',NULL,0),(103,'event #102',NULL,'2019-07-17 00:00:00','2019-08-04 00:00:00',NULL,0),(104,'event #103',NULL,'2019-01-24 00:00:00','2019-09-05 00:00:00',NULL,0),(105,'event #104',NULL,'2019-08-06 00:00:00','2019-10-08 00:00:00',NULL,0),(106,'event #105',NULL,'2018-01-21 00:00:00','2018-09-11 00:00:00',NULL,0),(107,'event #106',NULL,'2018-04-09 00:00:00','2018-11-23 00:00:00',NULL,0),(108,'event #107',NULL,'2019-04-10 00:00:00','2019-09-10 00:00:00',NULL,0),(109,'event #108',NULL,'2017-03-10 00:00:00','2017-03-15 00:00:00',NULL,0),(110,'event #109',NULL,'2017-11-12 00:00:00','2017-11-20 00:00:00',NULL,0),(111,'event #110',NULL,'2019-07-22 00:00:00','2019-09-20 00:00:00',NULL,0),(112,'event #111',NULL,'2017-08-09 00:00:00','2017-08-11 00:00:00',NULL,0),(113,'event #112',NULL,'2019-11-04 00:00:00','2019-11-14 00:00:00',NULL,0),(114,'event #113',NULL,'2019-08-28 00:00:00','2019-09-29 00:00:00',NULL,0),(115,'event #114',NULL,'2017-02-26 00:00:00','2017-10-28 00:00:00',NULL,0),(116,'event #115',NULL,'2019-11-06 00:00:00','2019-11-12 00:00:00',NULL,0),(117,'event #116',NULL,'2018-01-25 00:00:00','2018-09-06 00:00:00',NULL,0),(118,'event #117',NULL,'2017-04-21 00:00:00','2017-08-06 00:00:00',NULL,0),(119,'event #118',NULL,'2018-03-04 00:00:00','2018-03-22 00:00:00',NULL,0),(120,'event #119',NULL,'2018-01-11 00:00:00','2018-08-27 00:00:00',NULL,0);
/*!40000 ALTER TABLE `eventn` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER checkstartendinsert BEFORE INSERT ON Eventn
FOR EACH ROW
BEGIN
	IF New.Start > New.End THEN
		CALL raise_application_error(-10001, "Start date has to be before end date");
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER checkstartendupdate BEFORE UPDATE ON Eventn
FOR EACH ROW
BEGIN
	IF New.Start > New.End THEN
		CALL raise_application_error(-10001, "Start date has to be before end date");
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagalleventcontent AFTER UPDATE ON Eventn
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "1" AND Old.Deleted <=> "0" THEN

	UPDATE EventFiles
	SET Deleted = '1'
	WHERE EventId = NEW.EventId;
    
    UPDATE EventCalendar
	SET Deleted = '1'
	WHERE EventId = NEW.EventId;
    
	UPDATE EventFiles
	SET Deleted = '1'
	WHERE EventId = NEW.EventId;
    
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER Eventn_del BEFORE DELETE ON Eventn
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `eventtask`
--

DROP TABLE IF EXISTS `eventtask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventtask` (
  `EventId` int(11) NOT NULL,
  `TaskId` int(11) NOT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EventId`,`TaskId`),
  KEY `TaskId_idx` (`TaskId`),
  CONSTRAINT `EventId` FOREIGN KEY (`EventId`) REFERENCES `eventn` (`EventId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `TaskId` FOREIGN KEY (`TaskId`) REFERENCES `task` (`TaskId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventtask`
--

LOCK TABLES `eventtask` WRITE;
/*!40000 ALTER TABLE `eventtask` DISABLE KEYS */;
INSERT INTO `eventtask` VALUES (1,4,0),(17,16,0),(19,1,0),(19,3,0),(22,18,0),(24,7,0),(24,14,0),(28,5,0),(31,5,0),(31,13,0),(32,4,0),(32,15,0),(33,6,0),(35,5,0),(36,10,0),(36,15,0),(40,7,0),(42,8,0),(43,5,0),(43,7,0),(43,12,0),(45,2,0),(45,12,0),(46,18,0),(47,8,0),(50,7,0),(53,4,0),(53,5,0),(58,4,0),(58,14,0),(58,15,0),(68,10,0),(69,4,0),(71,8,0),(75,14,0),(76,13,0),(78,11,0),(78,15,0),(84,18,0),(87,11,0),(88,3,0),(90,5,0),(90,9,0),(90,13,0),(92,11,0),(96,5,0),(98,3,0),(98,10,0),(101,1,0),(107,11,0),(108,17,0),(110,3,0),(110,4,0),(113,2,0),(113,7,0),(114,8,0),(118,2,0),(119,7,0),(120,17,0);
/*!40000 ALTER TABLE `eventtask` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER eventtask_del BEFORE DELETE ON eventtask
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `files` (
  `FileId` int(11) NOT NULL AUTO_INCREMENT,
  `Filename` varchar(100) NOT NULL,
  `Path` varchar(100) NOT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`FileId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
INSERT INTO `files` VALUES (1,'tmp3ivka3g9','\\data',0),(2,'tmphx33m_31','\\data',0),(3,'tmpizr3473b','\\data',0),(4,'tmp2zsycgca','\\data',0),(5,'tmpig256o_q','\\data',0);
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagallfilecontent AFTER UPDATE ON Files
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "1" AND Old.Deleted <=> "0" THEN

	UPDATE EventFiles
	SET Deleted = '1'
	WHERE FileId = NEW.FileId;
    
    
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER files_del BEFORE DELETE ON files
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task` (
  `TaskId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  `Description` text,
  `Startdate` datetime NOT NULL,
  `Interval` varchar(256) NOT NULL,
  `CalendarId` int(11) NOT NULL,
  `ParentId` int(11) DEFAULT NULL,
  `IsDone` tinyint(1) NOT NULL DEFAULT '0',
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TaskId`),
  KEY `CalendarId` (`CalendarId`),
  KEY `ParentId` (`ParentId`),
  CONSTRAINT `task_ibfk_1` FOREIGN KEY (`CalendarId`) REFERENCES `calendar` (`CalendarId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `task_ibfk_2` FOREIGN KEY (`ParentId`) REFERENCES `task` (`TaskId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (1,'task #0',NULL,'2017-10-31 12:58:05',' ',3,NULL,0,0),(2,'task #1',NULL,'2017-10-31 12:58:05',' ',4,NULL,0,0),(3,'task #2',NULL,'2017-10-31 12:58:05',' ',4,NULL,0,0),(4,'task #3',NULL,'2017-10-31 12:58:05',' ',2,NULL,0,0),(5,'task #4',NULL,'2017-10-31 12:58:05',' ',10,NULL,0,0),(6,'task #5',NULL,'2017-10-31 12:58:05',' ',2,NULL,0,0),(7,'task #6',NULL,'2017-10-31 12:58:05',' ',1,NULL,0,0),(8,'task #7',NULL,'2017-10-31 12:58:05',' ',4,NULL,0,0),(9,'task #8',NULL,'2017-10-31 12:58:05',' ',7,NULL,0,0),(10,'task #9',NULL,'2017-10-31 12:58:05',' ',7,NULL,0,0),(11,'task #10',NULL,'2017-10-31 12:58:05',' ',7,NULL,0,0),(12,'task #11',NULL,'2017-10-31 12:58:05',' ',5,NULL,0,0),(13,'task #12',NULL,'2017-10-31 12:58:05',' ',7,NULL,0,0),(14,'task #13',NULL,'2017-10-31 12:58:05',' ',9,NULL,0,0),(15,'task #14',NULL,'2017-10-31 12:58:05',' ',5,NULL,0,0),(16,'task #15',NULL,'2017-10-31 12:58:05',' ',4,NULL,0,0),(17,'task #16',NULL,'2017-10-31 12:58:05',' ',8,NULL,0,0),(18,'task #17',NULL,'2017-10-31 12:58:05',' ',1,NULL,0,0);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagalltaskcontent AFTER UPDATE ON Task
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "1" AND Old.Deleted <=> "0" THEN
	
    
	UPDATE Eventtask
	SET Deleted = '1'
	WHERE TaskId = NEW.TaskId;
    
    
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER task_del BEFORE DELETE ON task
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `UserId` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(45) NOT NULL,
  `Password` varchar(125) NOT NULL,
  `Salt` varchar(20) NOT NULL,
  `Name` varchar(60) NOT NULL,
  `Datecreated` date NOT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'ola@nordmann.no','pbkdf2:sha1:1000$BKLdwinV$c4809c9101575fcc59e5202e95e00002dde45803','salt','Ola Nordmann','2017-10-31',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER userjoindate BEFORE INSERT ON User
FOR EACH ROW
BEGIN
    SET New.Datecreated = NOW();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagallusercontentdeleted AFTER UPDATE ON User
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "1" AND Old.Deleted <=> "0" THEN

	UPDATE Usercalendars
	SET Deleted = '1'
	WHERE userId = NEW.userId;

END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagallusercontentrecovered AFTER UPDATE ON User
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "0" AND Old.Deleted <=> "1" THEN

	UPDATE Usercalendars
	SET Deleted = '0'
	WHERE userId = NEW.userId;
    
    
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER User_del BEFORE DELETE ON User
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usercalendars`
--

DROP TABLE IF EXISTS `usercalendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usercalendars` (
  `UserId` int(11) NOT NULL,
  `CalendarId` int(11) NOT NULL,
  `Adminlevel` int(11) NOT NULL,
  `Notifications` tinyint(1) NOT NULL DEFAULT '0',
  `Notificationalerttime` int(11) NOT NULL DEFAULT '60',
  `Userdeleted` tinyint(1) NOT NULL DEFAULT '0',
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserId`,`CalendarId`),
  KEY `CalendarId_idx` (`CalendarId`),
  CONSTRAINT `CalendarId` FOREIGN KEY (`CalendarId`) REFERENCES `calendar` (`CalendarId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `UserId` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usercalendars`
--

LOCK TABLES `usercalendars` WRITE;
/*!40000 ALTER TABLE `usercalendars` DISABLE KEYS */;
INSERT INTO `usercalendars` VALUES (1,1,0,1,60,0,0),(1,2,0,1,60,0,0),(1,3,1,0,60,0,0),(1,4,1,1,60,0,0),(1,5,2,0,60,0,0),(1,6,2,0,60,0,0),(1,7,2,1,60,0,0),(1,8,3,0,60,0,0),(1,9,2,0,60,0,0),(1,10,2,1,60,0,0);
/*!40000 ALTER TABLE `usercalendars` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER usercalendars_del BEFORE DELETE ON usercalendars
FOR EACH ROW
BEGIN
	CALL raise_application_error(-20001, "Records can not be deleted");
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'annualcycle'
--

--
-- Dumping routines for database 'annualcycle'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_last_custom_error` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_last_custom_error`()
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
  SELECT @error_code, @error_message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `raise_application_error` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `raise_application_error`(IN CODE INTEGER, IN MESSAGE VARCHAR(255))
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
  CREATE TEMPORARY TABLE IF NOT EXISTS RAISE_ERROR(F1 INT NOT NULL);

  SELECT CODE, MESSAGE INTO @error_code, @error_message;
  INSERT INTO RAISE_ERROR VALUES(NULL);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-10-31 12:58:19
