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
INSERT INTO `calendar` VALUES (1,'Calendar #0',1,0),(2,'Calendar #1',1,0),(3,'Calendar #2',1,0),(4,'Calendar #3',0,0),(5,'Calendar #4',1,0),(6,'Calendar #5',1,0),(7,'Calendar #6',0,0),(8,'Calendar #7',1,0),(9,'Calendar #8',0,0),(10,'Calendar #9',1,0);
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
INSERT INTO `eventcalendar` VALUES (1,3,0,1,0),(2,5,0,1,0),(2,10,0,1,0),(4,3,0,1,0),(6,4,0,1,0),(7,8,0,1,0),(8,1,0,1,0),(9,5,0,1,0),(10,2,0,1,0),(11,1,0,1,0),(12,2,0,1,0),(12,9,0,1,0),(13,3,0,1,0),(13,6,0,1,0),(13,7,0,1,0),(14,3,0,1,0),(14,5,0,1,0),(16,4,0,1,0),(17,1,0,1,0),(17,5,0,1,0),(18,3,0,1,0),(19,1,0,1,0),(19,2,0,1,0),(19,6,0,1,0),(20,2,0,1,0),(21,1,0,1,0),(21,2,0,1,0),(21,9,0,1,0),(22,6,0,1,0),(23,2,0,1,0),(24,1,0,1,0),(25,5,0,1,0),(25,7,0,1,0),(26,9,0,1,0),(27,10,0,1,0),(29,10,0,1,0),(30,3,0,1,0);
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
INSERT INTO `eventfiles` VALUES (6,4,0),(10,2,0),(25,2,0),(25,5,0),(29,2,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventn`
--

LOCK TABLES `eventn` WRITE;
/*!40000 ALTER TABLE `eventn` DISABLE KEYS */;
INSERT INTO `eventn` VALUES (1,'event #0',NULL,'2019-05-05 00:00:00','2019-11-10 00:00:00',NULL,0),(2,'event #1',NULL,'2019-11-08 00:00:00','2019-11-26 00:00:00',NULL,0),(3,'event #2',NULL,'2017-07-11 00:00:00','2017-09-17 00:00:00',NULL,0),(4,'event #3',NULL,'2019-07-15 00:00:00','2019-11-20 00:00:00',NULL,0),(5,'event #4',NULL,'2018-02-05 00:00:00','2018-02-25 00:00:00',NULL,0),(6,'event #5',NULL,'2018-02-21 00:00:00','2018-11-17 00:00:00',NULL,0),(7,'event #6',NULL,'2017-05-26 00:00:00','2017-06-27 00:00:00',NULL,0),(8,'event #7',NULL,'2019-02-21 00:00:00','2019-07-19 00:00:00',NULL,0),(9,'event #8',NULL,'2017-02-02 00:00:00','2017-06-15 00:00:00',NULL,0),(10,'event #9',NULL,'2018-04-21 00:00:00','2018-08-18 00:00:00',NULL,0),(11,'event #10',NULL,'2017-05-03 00:00:00','2017-08-14 00:00:00',NULL,0),(12,'event #11',NULL,'2019-01-23 00:00:00','2019-11-25 00:00:00',NULL,0),(13,'event #12',NULL,'2018-06-07 00:00:00','2018-06-19 00:00:00',NULL,0),(14,'event #13',NULL,'2017-11-27 00:00:00','2017-11-28 00:00:00',NULL,0),(15,'event #14',NULL,'2019-07-09 00:00:00','2019-07-22 00:00:00',NULL,0),(16,'event #15',NULL,'2017-03-26 00:00:00','2017-11-02 00:00:00',NULL,0),(17,'event #16',NULL,'2017-07-01 00:00:00','2017-07-27 00:00:00',NULL,0),(18,'event #17',NULL,'2018-11-05 00:00:00','2018-11-12 00:00:00',NULL,0),(19,'event #18',NULL,'2017-02-22 00:00:00','2017-06-25 00:00:00',NULL,0),(20,'event #19',NULL,'2017-05-18 00:00:00','2017-08-13 00:00:00',NULL,0),(21,'event #20',NULL,'2019-06-15 00:00:00','2019-09-11 00:00:00',NULL,0),(22,'event #21',NULL,'2017-11-17 00:00:00','2017-11-21 00:00:00',NULL,0),(23,'event #22',NULL,'2018-02-25 00:00:00','2018-10-02 00:00:00',NULL,0),(24,'event #23',NULL,'2019-03-11 00:00:00','2019-11-20 00:00:00',NULL,0),(25,'event #24',NULL,'2017-01-03 00:00:00','2017-08-12 00:00:00',NULL,0),(26,'event #25',NULL,'2019-09-06 00:00:00','2019-11-29 00:00:00',NULL,0),(27,'event #26',NULL,'2017-01-13 00:00:00','2017-04-16 00:00:00',NULL,0),(28,'event #27',NULL,'2017-04-23 00:00:00','2017-04-27 00:00:00',NULL,0),(29,'event #28',NULL,'2018-11-12 00:00:00','2018-11-15 00:00:00',NULL,0),(30,'event #29',NULL,'2017-01-05 00:00:00','2017-11-25 00:00:00',NULL,0);
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
INSERT INTO `eventtask` VALUES (5,9,0),(5,11,0),(6,10,0),(8,14,0),(8,17,0),(12,10,0),(16,5,0),(19,12,0),(20,6,0),(21,12,0),(22,10,0),(23,12,0),(30,8,0);
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
INSERT INTO `files` VALUES (1,'tmph1uecxcr','\\data',0),(2,'tmplbcs7smr','\\data',0),(3,'tmpwuv60v9s','\\data',0),(4,'tmpqnlfjgtc','\\data',0),(5,'tmpb_txpxpt','\\data',0);
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
  `Interval` varchar(512) NOT NULL,
  `Timestamp` bigint(20) DEFAULT NULL,
  `CalendarId` int(11) DEFAULT NULL,
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
INSERT INTO `task` VALUES (1,'task #0',NULL,'2017-11-01 12:53:25',' ',NULL,8,NULL,0,0),(2,'task #1',NULL,'2017-11-01 12:53:25',' ',NULL,3,NULL,0,0),(3,'task #2',NULL,'2017-11-01 12:53:25',' ',NULL,3,NULL,0,0),(4,'task #3',NULL,'2017-11-01 12:53:25',' ',NULL,7,NULL,0,0),(5,'task #4',NULL,'2017-11-01 12:53:25',' ',NULL,5,NULL,0,0),(6,'task #5',NULL,'2017-11-01 12:53:25',' ',NULL,9,NULL,0,0),(7,'task #6',NULL,'2017-11-01 12:53:25',' ',NULL,7,NULL,0,0),(8,'task #7',NULL,'2017-11-01 12:53:25',' ',NULL,6,NULL,0,0),(9,'task #8',NULL,'2017-11-01 12:53:25',' ',NULL,3,NULL,0,0),(10,'task #9',NULL,'2017-11-01 12:53:25',' ',NULL,5,NULL,0,0),(11,'task #10',NULL,'2017-11-01 12:53:25',' ',NULL,9,NULL,0,0),(12,'task #11',NULL,'2017-11-01 12:53:25',' ',NULL,3,NULL,0,0),(13,'task #12',NULL,'2017-11-01 12:53:25',' ',NULL,10,NULL,0,0),(14,'task #13',NULL,'2017-11-01 12:53:25',' ',NULL,7,NULL,0,0),(15,'task #14',NULL,'2017-11-01 12:53:25',' ',NULL,10,NULL,0,0),(16,'task #15',NULL,'2017-11-01 12:53:25',' ',NULL,1,NULL,0,0),(17,'task #16',NULL,'2017-11-01 12:53:25',' ',NULL,4,NULL,0,0),(18,'task #17',NULL,'2017-11-01 12:53:25',' ',NULL,7,NULL,0,0);
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
INSERT INTO `user` VALUES (1,'ola@nordmann.no','pbkdf2:sha1:1000$e5nA2giH$dce81ea22fdcd5937f5642ca2daf3ad5b17b1ade','salt','Ola Nordmann','2017-11-01',0);
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
INSERT INTO `usercalendars` VALUES (1,1,3,0,60,0,0),(1,2,3,0,60,0,0),(1,3,3,1,60,0,0),(1,4,0,0,60,0,0),(1,5,3,0,60,0,0),(1,6,1,0,60,0,0),(1,7,2,1,60,0,0),(1,8,1,0,60,0,0),(1,9,2,1,60,0,0),(1,10,0,0,60,0,0);
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

-- Dump completed on 2017-11-01 12:53:38
