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
INSERT INTO `calendar` VALUES (1,'Calendar #0',1,0),(2,'Calendar #1',0,0),(3,'Calendar #2',0,0),(4,'Calendar #3',1,0),(5,'Calendar #4',0,0),(6,'Calendar #5',0,0),(7,'Calendar #6',0,0),(8,'Calendar #7',0,0),(9,'Calendar #8',1,0),(10,'Calendar #9',0,0);
/*!40000 ALTER TABLE `calendar` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
-- Table structure for table `calendartask`
--

DROP TABLE IF EXISTS `calendartask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendartask` (
  `CalendarId` int(11) NOT NULL,
  `TaskId` int(11) NOT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CalendarId`,`TaskId`),
  KEY `TaskId_idx` (`TaskId`),
  CONSTRAINT `calendartask_ibfk_1` FOREIGN KEY (`CalendarId`) REFERENCES `calendar` (`CalendarId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `calendartask_ibfk_2` FOREIGN KEY (`TaskId`) REFERENCES `task` (`TaskId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendartask`
--

LOCK TABLES `calendartask` WRITE;
/*!40000 ALTER TABLE `calendartask` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendartask` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `eventcalendar` VALUES (4,3,0,1,0),(4,8,0,1,0),(4,10,0,1,0),(6,1,0,1,0),(6,4,0,1,0),(7,1,0,1,0),(7,4,0,1,0),(8,3,0,1,0),(8,6,0,1,0),(9,1,0,1,0),(10,7,0,1,0),(11,1,0,1,0),(12,8,0,1,0),(13,6,0,1,0),(14,1,0,1,0),(14,4,0,1,0),(15,2,0,1,0),(15,3,0,1,0),(16,3,0,1,0),(16,10,0,1,0),(17,3,0,1,0),(19,2,0,1,0),(20,5,0,1,0),(20,8,0,1,0),(20,9,0,1,0),(21,2,0,1,0),(21,5,0,1,0),(22,2,0,1,0),(22,3,0,1,0),(22,4,0,1,0),(24,5,0,1,0),(25,4,0,1,0),(26,4,0,1,0),(26,7,0,1,0),(28,4,0,1,0),(28,10,0,1,0),(29,9,0,1,0),(30,5,0,1,0),(31,2,0,1,0),(31,7,0,1,0),(32,1,0,1,0),(33,5,0,1,0),(34,2,0,1,0),(34,4,0,1,0),(35,1,0,1,0),(37,1,0,1,0),(37,7,0,1,0),(37,9,0,1,0),(38,10,0,1,0),(39,7,0,1,0),(42,3,0,1,0),(44,2,0,1,0),(44,3,0,1,0),(45,7,0,1,0),(46,9,0,1,0),(47,1,0,1,0),(48,1,0,1,0),(49,3,0,1,0),(50,8,0,1,0),(52,8,0,1,0),(53,4,0,1,0),(53,8,0,1,0),(55,5,0,1,0),(56,2,0,1,0),(57,6,0,1,0),(57,9,0,1,0),(58,6,0,1,0),(60,2,0,1,0),(62,3,0,1,0),(62,4,0,1,0),(63,1,0,1,0),(63,10,0,1,0),(64,2,0,1,0),(64,6,0,1,0),(65,5,0,1,0),(66,1,0,1,0),(68,4,0,1,0),(68,6,0,1,0),(68,9,0,1,0),(69,4,0,1,0),(69,9,0,1,0),(70,5,0,1,0),(70,9,0,1,0),(74,4,0,1,0),(75,6,0,1,0),(76,2,0,1,0),(78,6,0,1,0),(79,5,0,1,0),(81,2,0,1,0),(81,5,0,1,0),(81,7,0,1,0),(82,2,0,1,0),(84,10,0,1,0),(85,5,0,1,0),(85,8,0,1,0),(85,10,0,1,0),(87,8,0,1,0),(87,10,0,1,0),(88,5,0,1,0),(89,6,0,1,0),(90,6,0,1,0),(91,6,0,1,0),(94,2,0,1,0),(97,8,0,1,0),(98,10,0,1,0),(105,8,0,1,0),(107,7,0,1,0),(107,8,0,1,0),(107,10,0,1,0),(108,6,0,1,0),(108,10,0,1,0),(109,1,0,1,0),(109,3,0,1,0),(110,9,0,1,0),(111,9,0,1,0),(114,2,0,1,0),(114,7,0,1,0),(116,7,0,1,0),(116,9,0,1,0),(117,3,0,1,0),(118,9,0,1,0),(119,4,0,1,0),(119,9,0,1,0);
/*!40000 ALTER TABLE `eventcalendar` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
INSERT INTO `eventfiles` VALUES (7,4,0),(38,5,0),(72,2,0),(102,5,0),(116,3,0);
/*!40000 ALTER TABLE `eventfiles` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
INSERT INTO `eventn` VALUES (1,'event #0',NULL,'2018-08-27 00:00:00','2018-11-22 00:00:00',NULL,0),(2,'event #1',NULL,'2017-10-19 00:00:00','2017-11-24 00:00:00',NULL,0),(3,'event #2',NULL,'2018-08-11 00:00:00','2018-11-08 00:00:00',NULL,0),(4,'event #3',NULL,'2019-07-25 00:00:00','2019-07-30 00:00:00',NULL,0),(5,'event #4',NULL,'2017-05-27 00:00:00','2017-11-20 00:00:00',NULL,0),(6,'event #5',NULL,'2019-06-07 00:00:00','2019-07-30 00:00:00',NULL,0),(7,'event #6',NULL,'2017-04-23 00:00:00','2017-05-20 00:00:00',NULL,0),(8,'event #7',NULL,'2019-11-28 00:00:00','2019-11-29 00:00:00',NULL,0),(9,'event #8',NULL,'2019-01-26 00:00:00','2019-09-16 00:00:00',NULL,0),(10,'event #9',NULL,'2017-07-01 00:00:00','2017-08-06 00:00:00',NULL,0),(11,'event #10',NULL,'2019-04-28 00:00:00','2019-05-18 00:00:00',NULL,0),(12,'event #11',NULL,'2018-02-02 00:00:00','2018-09-21 00:00:00',NULL,0),(13,'event #12',NULL,'2018-09-17 00:00:00','2018-10-13 00:00:00',NULL,0),(14,'event #13',NULL,'2019-02-05 00:00:00','2019-03-22 00:00:00',NULL,0),(15,'event #14',NULL,'2017-04-24 00:00:00','2017-08-02 00:00:00',NULL,0),(16,'event #15',NULL,'2018-02-13 00:00:00','2018-04-03 00:00:00',NULL,0),(17,'event #16',NULL,'2019-05-26 00:00:00','2019-08-11 00:00:00',NULL,0),(18,'event #17',NULL,'2017-06-03 00:00:00','2017-11-24 00:00:00',NULL,0),(19,'event #18',NULL,'2018-03-01 00:00:00','2018-05-02 00:00:00',NULL,0),(20,'event #19',NULL,'2017-09-18 00:00:00','2017-11-23 00:00:00',NULL,0),(21,'event #20',NULL,'2017-03-29 00:00:00','2017-07-11 00:00:00',NULL,0),(22,'event #21',NULL,'2018-03-27 00:00:00','2018-04-19 00:00:00',NULL,0),(23,'event #22',NULL,'2017-03-01 00:00:00','2017-10-30 00:00:00',NULL,0),(24,'event #23',NULL,'2019-07-30 00:00:00','2019-09-01 00:00:00',NULL,0),(25,'event #24',NULL,'2019-11-01 00:00:00','2019-11-14 00:00:00',NULL,0),(26,'event #25',NULL,'2018-11-07 00:00:00','2018-11-09 00:00:00',NULL,0),(27,'event #26',NULL,'2017-01-18 00:00:00','2017-03-12 00:00:00',NULL,0),(28,'event #27',NULL,'2018-01-20 00:00:00','2018-08-16 00:00:00',NULL,0),(29,'event #28',NULL,'2018-05-09 00:00:00','2018-10-01 00:00:00',NULL,0),(30,'event #29',NULL,'2019-03-26 00:00:00','2019-04-28 00:00:00',NULL,0),(31,'event #30',NULL,'2019-03-02 00:00:00','2019-06-01 00:00:00',NULL,0),(32,'event #31',NULL,'2018-03-17 00:00:00','2018-05-27 00:00:00',NULL,0),(33,'event #32',NULL,'2019-07-13 00:00:00','2019-09-01 00:00:00',NULL,0),(34,'event #33',NULL,'2019-04-14 00:00:00','2019-10-12 00:00:00',NULL,0),(35,'event #34',NULL,'2019-06-08 00:00:00','2019-10-02 00:00:00',NULL,0),(36,'event #35',NULL,'2018-04-17 00:00:00','2018-09-16 00:00:00',NULL,0),(37,'event #36',NULL,'2017-09-07 00:00:00','2017-09-24 00:00:00',NULL,0),(38,'event #37',NULL,'2017-01-22 00:00:00','2017-05-15 00:00:00',NULL,0),(39,'event #38',NULL,'2018-05-13 00:00:00','2018-11-26 00:00:00',NULL,0),(40,'event #39',NULL,'2019-02-24 00:00:00','2019-05-30 00:00:00',NULL,0),(41,'event #40',NULL,'2018-05-13 00:00:00','2018-09-04 00:00:00',NULL,0),(42,'event #41',NULL,'2017-11-21 00:00:00','2017-11-28 00:00:00',NULL,0),(43,'event #42',NULL,'2018-04-13 00:00:00','2018-11-06 00:00:00',NULL,0),(44,'event #43',NULL,'2018-02-21 00:00:00','2018-07-16 00:00:00',NULL,0),(45,'event #44',NULL,'2019-07-08 00:00:00','2019-11-28 00:00:00',NULL,0),(46,'event #45',NULL,'2017-10-12 00:00:00','2017-10-17 00:00:00',NULL,0),(47,'event #46',NULL,'2019-11-02 00:00:00','2019-11-07 00:00:00',NULL,0),(48,'event #47',NULL,'2018-07-02 00:00:00','2018-09-29 00:00:00',NULL,0),(49,'event #48',NULL,'2017-04-03 00:00:00','2017-11-13 00:00:00',NULL,0),(50,'event #49',NULL,'2017-04-16 00:00:00','2017-05-09 00:00:00',NULL,0),(51,'event #50',NULL,'2018-03-19 00:00:00','2018-04-01 00:00:00',NULL,0),(52,'event #51',NULL,'2017-02-05 00:00:00','2017-07-05 00:00:00',NULL,0),(53,'event #52',NULL,'2017-10-29 00:00:00','2017-11-22 00:00:00',NULL,0),(54,'event #53',NULL,'2017-09-14 00:00:00','2017-11-01 00:00:00',NULL,0),(55,'event #54',NULL,'2019-11-14 00:00:00','2019-11-26 00:00:00',NULL,0),(56,'event #55',NULL,'2017-08-28 00:00:00','2017-11-06 00:00:00',NULL,0),(57,'event #56',NULL,'2017-01-12 00:00:00','2017-06-28 00:00:00',NULL,0),(58,'event #57',NULL,'2017-03-24 00:00:00','2017-05-15 00:00:00',NULL,0),(59,'event #58',NULL,'2018-02-12 00:00:00','2018-05-23 00:00:00',NULL,0),(60,'event #59',NULL,'2019-03-04 00:00:00','2019-03-20 00:00:00',NULL,0),(61,'event #60',NULL,'2017-06-10 00:00:00','2017-11-18 00:00:00',NULL,0),(62,'event #61',NULL,'2019-09-22 00:00:00','2019-10-18 00:00:00',NULL,0),(63,'event #62',NULL,'2019-09-27 00:00:00','2019-11-13 00:00:00',NULL,0),(64,'event #63',NULL,'2017-11-13 00:00:00','2017-11-22 00:00:00',NULL,0),(65,'event #64',NULL,'2017-07-24 00:00:00','2017-08-20 00:00:00',NULL,0),(66,'event #65',NULL,'2018-03-11 00:00:00','2018-08-01 00:00:00',NULL,0),(67,'event #66',NULL,'2018-11-05 00:00:00','2018-11-21 00:00:00',NULL,0),(68,'event #67',NULL,'2017-08-08 00:00:00','2017-08-09 00:00:00',NULL,0),(69,'event #68',NULL,'2017-04-01 00:00:00','2017-07-21 00:00:00',NULL,0),(70,'event #69',NULL,'2017-07-06 00:00:00','2017-09-28 00:00:00',NULL,0),(71,'event #70',NULL,'2018-09-16 00:00:00','2018-10-03 00:00:00',NULL,0),(72,'event #71',NULL,'2017-07-09 00:00:00','2017-08-26 00:00:00',NULL,0),(73,'event #72',NULL,'2018-01-18 00:00:00','2018-05-29 00:00:00',NULL,0),(74,'event #73',NULL,'2018-05-06 00:00:00','2018-10-24 00:00:00',NULL,0),(75,'event #74',NULL,'2017-06-06 00:00:00','2017-07-14 00:00:00',NULL,0),(76,'event #75',NULL,'2017-08-14 00:00:00','2017-11-20 00:00:00',NULL,0),(77,'event #76',NULL,'2018-08-23 00:00:00','2018-10-30 00:00:00',NULL,0),(78,'event #77',NULL,'2019-11-02 00:00:00','2019-11-11 00:00:00',NULL,0),(79,'event #78',NULL,'2019-06-11 00:00:00','2019-10-25 00:00:00',NULL,0),(80,'event #79',NULL,'2017-04-15 00:00:00','2017-05-22 00:00:00',NULL,0),(81,'event #80',NULL,'2017-03-05 00:00:00','2017-11-03 00:00:00',NULL,0),(82,'event #81',NULL,'2018-04-28 00:00:00','2018-07-20 00:00:00',NULL,0),(83,'event #82',NULL,'2019-05-03 00:00:00','2019-05-05 00:00:00',NULL,0),(84,'event #83',NULL,'2018-03-24 00:00:00','2018-07-03 00:00:00',NULL,0),(85,'event #84',NULL,'2017-09-27 00:00:00','2017-10-17 00:00:00',NULL,0),(86,'event #85',NULL,'2018-01-03 00:00:00','2018-05-09 00:00:00',NULL,0),(87,'event #86',NULL,'2018-07-28 00:00:00','2018-10-01 00:00:00',NULL,0),(88,'event #87',NULL,'2019-10-18 00:00:00','2019-10-23 00:00:00',NULL,0),(89,'event #88',NULL,'2018-06-09 00:00:00','2018-08-08 00:00:00',NULL,0),(90,'event #89',NULL,'2017-01-25 00:00:00','2017-11-07 00:00:00',NULL,0),(91,'event #90',NULL,'2017-04-19 00:00:00','2017-08-20 00:00:00',NULL,0),(92,'event #91',NULL,'2017-09-10 00:00:00','2017-09-14 00:00:00',NULL,0),(93,'event #92',NULL,'2017-07-01 00:00:00','2017-09-07 00:00:00',NULL,0),(94,'event #93',NULL,'2018-03-23 00:00:00','2018-03-26 00:00:00',NULL,0),(95,'event #94',NULL,'2019-01-08 00:00:00','2019-03-18 00:00:00',NULL,0),(96,'event #95',NULL,'2019-02-27 00:00:00','2019-03-16 00:00:00',NULL,0),(97,'event #96',NULL,'2019-11-19 00:00:00','2019-11-23 00:00:00',NULL,0),(98,'event #97',NULL,'2019-07-19 00:00:00','2019-10-19 00:00:00',NULL,0),(99,'event #98',NULL,'2018-01-12 00:00:00','2018-05-30 00:00:00',NULL,0),(100,'event #99',NULL,'2018-01-27 00:00:00','2018-11-22 00:00:00',NULL,0),(101,'event #100',NULL,'2017-03-08 00:00:00','2017-06-03 00:00:00',NULL,0),(102,'event #101',NULL,'2017-06-20 00:00:00','2017-09-03 00:00:00',NULL,0),(103,'event #102',NULL,'2017-02-23 00:00:00','2017-11-03 00:00:00',NULL,0),(104,'event #103',NULL,'2018-02-04 00:00:00','2018-02-12 00:00:00',NULL,0),(105,'event #104',NULL,'2019-10-13 00:00:00','2019-11-27 00:00:00',NULL,0),(106,'event #105',NULL,'2018-09-07 00:00:00','2018-10-16 00:00:00',NULL,0),(107,'event #106',NULL,'2017-09-17 00:00:00','2017-11-06 00:00:00',NULL,0),(108,'event #107',NULL,'2019-09-28 00:00:00','2019-09-29 00:00:00',NULL,0),(109,'event #108',NULL,'2019-09-02 00:00:00','2019-09-26 00:00:00',NULL,0),(110,'event #109',NULL,'2017-06-09 00:00:00','2017-11-21 00:00:00',NULL,0),(111,'event #110',NULL,'2019-11-03 00:00:00','2019-11-18 00:00:00',NULL,0),(112,'event #111',NULL,'2019-06-09 00:00:00','2019-10-10 00:00:00',NULL,0),(113,'event #112',NULL,'2017-02-11 00:00:00','2017-11-02 00:00:00',NULL,0),(114,'event #113',NULL,'2017-03-13 00:00:00','2017-07-10 00:00:00',NULL,0),(115,'event #114',NULL,'2019-01-21 00:00:00','2019-01-30 00:00:00',NULL,0),(116,'event #115',NULL,'2017-07-07 00:00:00','2017-08-28 00:00:00',NULL,0),(117,'event #116',NULL,'2018-06-29 00:00:00','2018-11-12 00:00:00',NULL,0),(118,'event #117',NULL,'2019-06-02 00:00:00','2019-07-27 00:00:00',NULL,0),(119,'event #118',NULL,'2017-09-29 00:00:00','2017-11-18 00:00:00',NULL,0),(120,'event #119',NULL,'2018-11-16 00:00:00','2018-11-21 00:00:00',NULL,0);
/*!40000 ALTER TABLE `eventn` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!40000 ALTER TABLE `eventtask` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
INSERT INTO `files` VALUES (1,'tmpusxuvqd3','\\data',0),(2,'tmpp2kch7wr','\\data',0),(3,'tmp9p8cw9f5','\\data',0),(4,'tmprq5z8rqp','\\data',0),(5,'tmp28cv58oa','\\data',0);
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
  `Startdate` datetime NOT NULL,
  `Intervall` varchar(6) NOT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TaskId`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (1,'task #0','2017-10-30 09:28:02','00001',0),(2,'task #1','2017-10-30 09:28:02','16000',0),(3,'task #2','2017-10-30 09:28:02','00170',0),(4,'task #3','2017-10-30 09:28:02','00130',0),(5,'task #4','2017-10-30 09:28:02','111000',0),(6,'task #5','2017-10-30 09:28:02','00001',0),(7,'task #6','2017-10-30 09:28:02','00110',0),(8,'task #7','2017-10-30 09:28:02','111000',0),(9,'task #8','2017-10-30 09:28:02','112000',0),(10,'task #9','2017-10-30 09:28:02','00130',0),(11,'task #10','2017-10-30 09:28:02','00150',0),(12,'task #11','2017-10-30 09:28:02','18000',0),(13,'task #12','2017-10-30 09:28:02','00130',0),(14,'task #13','2017-10-30 09:28:02','00001',0),(15,'task #14','2017-10-30 09:28:02','16000',0),(16,'task #15','2017-10-30 09:28:02','13000',0),(17,'task #16','2017-10-30 09:28:02','00001',0),(18,'task #17','2017-10-30 09:28:02','00120',0);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagalltaskcontent AFTER UPDATE ON Task
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "1" AND Old.Deleted <=> "0" THEN

    UPDATE Taskchildren
	SET Deleted = '1'
	WHERE ParenttaskId = NEW.TaskId;
	
	UPDATE Taskchildren
	SET Deleted = '1'
	WHERE ChildtaskId = NEW.TaskId;
    
	UPDATE Eventtask
	SET Deleted = '1'
	WHERE TaskId = NEW.TaskId;
    
	UPDATE Usertask
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
-- Table structure for table `taskchildren`
--

DROP TABLE IF EXISTS `taskchildren`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taskchildren` (
  `ParenttaskId` int(11) NOT NULL,
  `ChildtaskId` int(11) NOT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ParenttaskId`,`ChildtaskId`),
  KEY `ChildtaskId_idx` (`ChildtaskId`),
  CONSTRAINT `ChildtaskId` FOREIGN KEY (`ChildtaskId`) REFERENCES `task` (`TaskId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ParrenttaskId` FOREIGN KEY (`ParenttaskId`) REFERENCES `task` (`TaskId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taskchildren`
--

LOCK TABLES `taskchildren` WRITE;
/*!40000 ALTER TABLE `taskchildren` DISABLE KEYS */;
INSERT INTO `taskchildren` VALUES (4,12,0),(15,5,0),(17,7,0);
/*!40000 ALTER TABLE `taskchildren` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER taskchildren_del BEFORE DELETE ON taskchildren
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
INSERT INTO `user` VALUES (1,'ola@nordmann.no','pbkdf2:sha1:1000$ZHM402nS$b52d92aad49309487ba13847c8c2a416ce4dcf9c','salt','Ola Nordmann','2017-10-30',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagallusercontentdeleted AFTER UPDATE ON User
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "1" AND Old.Deleted <=> "0" THEN

	UPDATE Usercalendars
	SET Deleted = '1'
	WHERE userId = NEW.userId;
    
    UPDATE Usertask
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER flagallusercontentrecovered AFTER UPDATE ON User
FOR EACH ROW
BEGIN
IF NEW.Deleted <=> "0" AND Old.Deleted <=> "1" THEN

	UPDATE Usercalendars
	SET Deleted = '0'
	WHERE userId = NEW.userId;
    
    UPDATE Usertask
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
INSERT INTO `usercalendars` VALUES (1,1,0,1,60,0,0),(1,2,0,1,60,0,0),(1,3,0,1,60,0,0),(1,4,3,1,60,0,0),(1,5,0,0,60,0,0),(1,6,2,1,60,0,0),(1,7,3,0,60,0,0),(1,8,1,0,60,0,0),(1,9,3,1,60,0,0),(1,10,2,0,60,0,0);
/*!40000 ALTER TABLE `usercalendars` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
-- Table structure for table `usertask`
--

DROP TABLE IF EXISTS `usertask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usertask` (
  `UserId` int(11) NOT NULL,
  `TaskId` int(11) NOT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserId`,`TaskId`),
  KEY `TaskId_idx` (`TaskId`),
  CONSTRAINT `usertask_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `usertask_ibfk_2` FOREIGN KEY (`TaskId`) REFERENCES `task` (`TaskId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usertask`
--

LOCK TABLES `usertask` WRITE;
/*!40000 ALTER TABLE `usertask` DISABLE KEYS */;
INSERT INTO `usertask` VALUES (1,1,0),(1,2,0),(1,3,0),(1,4,0),(1,5,0),(1,6,0),(1,7,0),(1,8,0),(1,9,0),(1,10,0),(1,11,0),(1,12,0),(1,13,0),(1,14,0),(1,15,0),(1,16,0),(1,17,0),(1,18,0);
/*!40000 ALTER TABLE `usertask` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER usertask_del BEFORE DELETE ON usertask
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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

-- Dump completed on 2017-10-30  9:28:24
