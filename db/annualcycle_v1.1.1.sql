CREATE DATABASE  IF NOT EXISTS `annualcycle` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `annualcycle`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: annualcycle v 1.1.1
-- ------------------------------------------------------
-- Server version	5.7.17-log

--Last edited by: Vebjørn A.A

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
INSERT INTO `calendar` VALUES (1,1,0),(2,1,0),(3,1,0),(4,1,0),(5,0,0),(6,0,0),(7,1,0),(8,0,0),(9,0,0),(10,1,0);
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
INSERT INTO `eventcalendar` VALUES (2,2,0),(4,1,0),(4,3,0),(4,6,0),(5,4,0),(5,7,0),(5,10,0),(8,2,0),(8,7,0),(9,1,0),(9,6,0),(10,3,0),(12,10,0),(13,7,0),(15,5,0),(18,10,0),(20,3,0),(20,9,0),(21,9,0),(22,1,0),(22,2,0),(22,4,0),(23,3,0),(23,4,0),(23,8,0),(24,3,0),(24,8,0),(25,2,0),(25,5,0),(26,7,0),(28,10,0),(29,5,0),(30,7,0),(31,6,0),(32,1,0),(34,7,0),(41,4,0),(42,6,0),(43,1,0),(44,7,0),(44,8,0),(45,4,0),(48,2,0),(49,8,0),(50,4,0),(50,10,0),(51,4,0),(52,4,0),(52,5,0),(52,10,0),(55,1,0),(57,2,0),(57,8,0),(59,5,0),(60,6,0),(60,10,0),(62,3,0),(62,9,0),(63,3,0),(63,4,0),(63,7,0),(64,7,0),(65,8,0),(67,2,0),(67,6,0),(69,1,0),(70,2,0),(70,9,0),(71,5,0),(71,10,0),(73,6,0),(74,1,0),(76,9,0),(77,2,0),(77,7,0),(78,1,0),(79,3,0),(79,4,0),(79,6,0),(80,1,0),(80,4,0),(80,9,0),(80,10,0),(83,8,0),(86,8,0),(87,3,0),(89,8,0),(90,7,0),(91,2,0),(92,7,0),(92,8,0),(93,4,0),(93,10,0),(94,5,0),(95,4,0),(95,7,0),(96,1,0),(96,4,0),(97,1,0),(97,3,0),(97,9,0),(98,9,0),(99,4,0),(100,2,0),(101,3,0),(102,2,0),(103,7,0),(107,9,0),(107,10,0),(109,4,0),(109,9,0),(109,10,0),(111,3,0),(111,7,0),(114,2,0),(114,7,0),(114,8,0),(115,1,0),(115,2,0),(115,5,0),(115,9,0),(118,3,0);
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
INSERT INTO `eventfiles` VALUES (32,2,0),(35,2,0),(56,1,0),(86,2,0),(103,1,0);
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
  `Start` datetime NOT NULL,
  `End` datetime DEFAULT NULL,
  `Interval` char(1) DEFAULT NULL,
  `Terminatedate` char(1) DEFAULT NULL,
  `Deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`EventId`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventn`
--

LOCK TABLES `eventn` WRITE;
/*!40000 ALTER TABLE `eventn` DISABLE KEYS */;
INSERT INTO `eventn` VALUES (1,'2019-09-28 00:00:00','2019-10-08 00:00:00',NULL,NULL,0),(2,'2018-06-07 00:00:00','2018-07-28 00:00:00',NULL,NULL,0),(3,'2018-07-17 00:00:00','2018-07-27 00:00:00',NULL,NULL,0),(4,'2017-06-07 00:00:00','2017-07-20 00:00:00',NULL,NULL,0),(5,'2019-02-01 00:00:00','2019-10-21 00:00:00',NULL,NULL,0),(6,'2018-10-09 00:00:00','2018-11-09 00:00:00',NULL,NULL,0),(7,'2018-01-20 00:00:00','2018-11-09 00:00:00',NULL,NULL,0),(8,'2018-02-05 00:00:00','2018-11-01 00:00:00',NULL,NULL,0),(9,'2017-11-05 00:00:00','2017-11-26 00:00:00',NULL,NULL,0),(10,'2018-07-02 00:00:00','2018-09-17 00:00:00',NULL,NULL,0),(11,'2018-03-09 00:00:00','2018-11-27 00:00:00',NULL,NULL,0),(12,'2017-02-08 00:00:00','2017-03-26 00:00:00',NULL,NULL,0),(13,'2019-02-06 00:00:00','2019-09-22 00:00:00',NULL,NULL,0),(14,'2017-04-06 00:00:00','2017-04-17 00:00:00',NULL,NULL,0),(15,'2017-08-13 00:00:00','2017-09-03 00:00:00',NULL,NULL,0),(16,'2017-05-29 00:00:00','2017-10-11 00:00:00',NULL,NULL,0),(17,'2019-01-21 00:00:00','2019-08-09 00:00:00',NULL,NULL,0),(18,'2019-10-14 00:00:00','2019-10-22 00:00:00',NULL,NULL,0),(19,'2019-04-13 00:00:00','2019-10-14 00:00:00',NULL,NULL,0),(20,'2018-01-14 00:00:00','2018-10-25 00:00:00',NULL,NULL,0),(21,'2017-02-12 00:00:00','2017-05-25 00:00:00',NULL,NULL,0),(22,'2019-02-16 00:00:00','2019-09-01 00:00:00',NULL,NULL,0),(23,'2017-05-12 00:00:00','2017-06-10 00:00:00',NULL,NULL,0),(24,'2019-07-15 00:00:00','2019-09-06 00:00:00',NULL,NULL,0),(25,'2018-01-28 00:00:00','2018-09-17 00:00:00',NULL,NULL,0),(26,'2018-06-15 00:00:00','2018-07-01 00:00:00',NULL,NULL,0),(27,'2017-05-21 00:00:00','2017-06-24 00:00:00',NULL,NULL,0),(28,'2019-09-23 00:00:00','2019-10-16 00:00:00',NULL,NULL,0),(29,'2018-03-12 00:00:00','2018-07-28 00:00:00',NULL,NULL,0),(30,'2018-10-23 00:00:00','2018-10-30 00:00:00',NULL,NULL,0),(31,'2018-06-02 00:00:00','2018-10-29 00:00:00',NULL,NULL,0),(32,'2019-04-06 00:00:00','2019-04-25 00:00:00',NULL,NULL,0),(33,'2017-07-27 00:00:00','2017-08-19 00:00:00',NULL,NULL,0),(34,'2019-01-08 00:00:00','2019-01-20 00:00:00',NULL,NULL,0),(35,'2019-09-03 00:00:00','2019-11-26 00:00:00',NULL,NULL,0),(36,'2017-01-22 00:00:00','2017-11-01 00:00:00',NULL,NULL,0),(37,'2017-01-03 00:00:00','2017-05-09 00:00:00',NULL,NULL,0),(38,'2017-02-07 00:00:00','2017-04-19 00:00:00',NULL,NULL,0),(39,'2019-01-02 00:00:00','2019-02-25 00:00:00',NULL,NULL,0),(40,'2019-07-21 00:00:00','2019-11-16 00:00:00',NULL,NULL,0),(41,'2018-02-15 00:00:00','2018-07-07 00:00:00',NULL,NULL,0),(42,'2019-03-16 00:00:00','2019-09-27 00:00:00',NULL,NULL,0),(43,'2018-06-16 00:00:00','2018-06-19 00:00:00',NULL,NULL,0),(44,'2019-01-19 00:00:00','2019-01-21 00:00:00',NULL,NULL,0),(45,'2018-01-10 00:00:00','2018-08-02 00:00:00',NULL,NULL,0),(46,'2017-07-03 00:00:00','2017-11-21 00:00:00',NULL,NULL,0),(47,'2019-10-08 00:00:00','2019-10-19 00:00:00',NULL,NULL,0),(48,'2017-09-04 00:00:00','2017-09-08 00:00:00',NULL,NULL,0),(49,'2017-11-21 00:00:00','2017-11-22 00:00:00',NULL,NULL,0),(50,'2018-04-20 00:00:00','2018-06-27 00:00:00',NULL,NULL,0),(51,'2018-01-07 00:00:00','2018-08-16 00:00:00',NULL,NULL,0),(52,'2019-10-16 00:00:00','2019-10-17 00:00:00',NULL,NULL,0),(53,'2019-06-17 00:00:00','2019-08-22 00:00:00',NULL,NULL,0),(54,'2019-07-17 00:00:00','2019-08-25 00:00:00',NULL,NULL,0),(55,'2017-02-09 00:00:00','2017-10-29 00:00:00',NULL,NULL,0),(56,'2018-07-13 00:00:00','2018-11-29 00:00:00',NULL,NULL,0),(57,'2019-08-01 00:00:00','2019-09-10 00:00:00',NULL,NULL,0),(58,'2019-09-12 00:00:00','2019-10-16 00:00:00',NULL,NULL,0),(59,'2017-08-01 00:00:00','2017-10-27 00:00:00',NULL,NULL,0),(60,'2018-11-03 00:00:00','2018-11-25 00:00:00',NULL,NULL,0),(61,'2018-05-10 00:00:00','2018-09-01 00:00:00',NULL,NULL,0),(62,'2019-06-27 00:00:00','2019-08-01 00:00:00',NULL,NULL,0),(63,'2018-02-19 00:00:00','2018-10-20 00:00:00',NULL,NULL,0),(64,'2019-04-25 00:00:00','2019-10-23 00:00:00',NULL,NULL,0),(65,'2018-03-14 00:00:00','2018-11-25 00:00:00',NULL,NULL,0),(66,'2017-10-02 00:00:00','2017-11-08 00:00:00',NULL,NULL,0),(67,'2018-10-21 00:00:00','2018-10-26 00:00:00',NULL,NULL,0),(68,'2018-10-23 00:00:00','2018-11-08 00:00:00',NULL,NULL,0),(69,'2018-05-14 00:00:00','2018-08-22 00:00:00',NULL,NULL,0),(70,'2017-02-25 00:00:00','2017-11-24 00:00:00',NULL,NULL,0),(71,'2017-06-03 00:00:00','2017-06-26 00:00:00',NULL,NULL,0),(72,'2018-05-08 00:00:00','2018-05-24 00:00:00',NULL,NULL,0),(73,'2019-09-18 00:00:00','2019-10-24 00:00:00',NULL,NULL,0),(74,'2019-01-12 00:00:00','2019-11-14 00:00:00',NULL,NULL,0),(75,'2019-10-28 00:00:00','2019-11-16 00:00:00',NULL,NULL,0),(76,'2019-06-23 00:00:00','2019-10-22 00:00:00',NULL,NULL,0),(77,'2017-06-25 00:00:00','2017-09-22 00:00:00',NULL,NULL,0),(78,'2017-02-10 00:00:00','2017-07-21 00:00:00',NULL,NULL,0),(79,'2019-09-02 00:00:00','2019-10-18 00:00:00',NULL,NULL,0),(80,'2019-08-27 00:00:00','2019-08-30 00:00:00',NULL,NULL,0),(81,'2018-05-04 00:00:00','2018-08-06 00:00:00',NULL,NULL,0),(82,'2019-11-04 00:00:00','2019-11-10 00:00:00',NULL,NULL,0),(83,'2019-05-05 00:00:00','2019-09-27 00:00:00',NULL,NULL,0),(84,'2017-01-02 00:00:00','2017-01-22 00:00:00',NULL,NULL,0),(85,'2018-11-15 00:00:00','2018-11-26 00:00:00',NULL,NULL,0),(86,'2017-07-20 00:00:00','2017-10-26 00:00:00',NULL,NULL,0),(87,'2018-06-05 00:00:00','2018-09-09 00:00:00',NULL,NULL,0),(88,'2019-05-22 00:00:00','2019-05-27 00:00:00',NULL,NULL,0),(89,'2019-09-08 00:00:00','2019-09-13 00:00:00',NULL,NULL,0),(90,'2019-03-11 00:00:00','2019-11-18 00:00:00',NULL,NULL,0),(91,'2017-04-21 00:00:00','2017-07-20 00:00:00',NULL,NULL,0),(92,'2019-01-21 00:00:00','2019-07-21 00:00:00',NULL,NULL,0),(93,'2017-01-11 00:00:00','2017-03-26 00:00:00',NULL,NULL,0),(94,'2017-01-08 00:00:00','2017-11-26 00:00:00',NULL,NULL,0),(95,'2019-01-10 00:00:00','2019-03-15 00:00:00',NULL,NULL,0),(96,'2019-05-13 00:00:00','2019-11-02 00:00:00',NULL,NULL,0),(97,'2019-09-27 00:00:00','2019-11-05 00:00:00',NULL,NULL,0),(98,'2017-08-23 00:00:00','2017-11-03 00:00:00',NULL,NULL,0),(99,'2017-06-06 00:00:00','2017-07-19 00:00:00',NULL,NULL,0),(100,'2017-05-16 00:00:00','2017-11-26 00:00:00',NULL,NULL,0),(101,'2019-08-17 00:00:00','2019-10-23 00:00:00',NULL,NULL,0),(102,'2019-03-30 00:00:00','2019-06-10 00:00:00',NULL,NULL,0),(103,'2019-04-04 00:00:00','2019-09-20 00:00:00',NULL,NULL,0),(104,'2017-01-08 00:00:00','2017-02-06 00:00:00',NULL,NULL,0),(105,'2019-04-28 00:00:00','2019-07-08 00:00:00',NULL,NULL,0),(106,'2019-04-14 00:00:00','2019-10-03 00:00:00',NULL,NULL,0),(107,'2017-11-17 00:00:00','2017-11-26 00:00:00',NULL,NULL,0),(108,'2017-06-26 00:00:00','2017-07-18 00:00:00',NULL,NULL,0),(109,'2017-01-04 00:00:00','2017-09-07 00:00:00',NULL,NULL,0),(110,'2018-09-27 00:00:00','2018-10-05 00:00:00',NULL,NULL,0),(111,'2017-05-20 00:00:00','2017-07-06 00:00:00',NULL,NULL,0),(112,'2019-11-03 00:00:00','2019-11-14 00:00:00',NULL,NULL,0),(113,'2017-07-03 00:00:00','2017-08-16 00:00:00',NULL,NULL,0),(114,'2017-02-03 00:00:00','2017-04-11 00:00:00',NULL,NULL,0),(115,'2017-10-29 00:00:00','2017-11-26 00:00:00',NULL,NULL,0),(116,'2017-11-07 00:00:00','2017-11-25 00:00:00',NULL,NULL,0),(117,'2017-04-25 00:00:00','2017-11-28 00:00:00',NULL,NULL,0),(118,'2017-11-24 00:00:00','2017-11-29 00:00:00',NULL,NULL,0),(119,'2018-05-25 00:00:00','2018-08-24 00:00:00',NULL,NULL,0),(120,'2018-07-05 00:00:00','2018-11-06 00:00:00',NULL,NULL,0);
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
INSERT INTO `files` VALUES (1,'tmpgapf2s57','\\data',0),(2,'tmpi93mmar_','\\data',0),(3,'tmpffiy1iac','\\data',0),(4,'tmpze5ihzau','\\data',0),(5,'tmp__nh3yyc','\\data',0);
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
INSERT INTO `task` VALUES (1,'00160',0),(2,'00160',0),(3,'13000',0),(4,'13000',0),(5,'00110',0),(6,'00150',0),(7,'00001',0),(8,'00001',0),(9,'00110',0),(10,'00001',0),(11,'11000',0),(12,'00001',0),(13,'13000',0),(14,'12000',0),(15,'110000',0),(16,'00110',0),(17,'110000',0),(18,'00140',0);
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
INSERT INTO `taskchildren` VALUES (1,10,0),(4,9,0),(4,10,0);
/*!40000 ALTER TABLE `taskchildren` ENABLE KEYS */;
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
  `Salt` varchar(10) NOT NULL,
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
INSERT INTO `user` VALUES (1,'ola@nordmann.com','pbkdf2:sha1:1000$475RKTd7$cfcaa82c56359b7474f8aa9ae10868f3783d2425','salt','Ola Nordmann','2017-10-17',0);
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
INSERT INTO `usercalendars` VALUES (1,1,0,1,0,0),(1,2,0,1,0,0),(1,3,3,1,0,0),(1,4,3,1,0,0),(1,5,2,0,0,0),(1,6,3,1,0,0),(1,7,1,1,0,0),(1,8,3,1,0,0),(1,9,0,1,0,0),(1,10,3,1,0,0);
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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

-- Dump completed on 2017-10-17 12:48:21
