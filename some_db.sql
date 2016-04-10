-- MySQL dump 10.13  Distrib 5.7.9, for osx10.9 (x86_64)
--
-- Host: localhost    Database: db_api
-- ------------------------------------------------------
-- Server version	5.7.11

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
-- Table structure for table `follows`
--

DROP TABLE IF EXISTS `follows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `follows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `followee` varchar(30) NOT NULL,
  `follower` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `followee` (`followee`,`follower`),
  KEY `follower` (`follower`),
  CONSTRAINT `follows_ibfk_1` FOREIGN KEY (`followee`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `follows_ibfk_2` FOREIGN KEY (`follower`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follows`
--

LOCK TABLES `follows` WRITE;
/*!40000 ALTER TABLE `follows` DISABLE KEYS */;
/*!40000 ALTER TABLE `follows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forums`
--

DROP TABLE IF EXISTS `forums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `shortname` varchar(60) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user` varchar(30) NOT NULL,
  PRIMARY KEY (`shortname`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `user` (`user`),
  CONSTRAINT `forums_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=313 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forums`
--

LOCK TABLES `forums` WRITE;
/*!40000 ALTER TABLE `forums` DISABLE KEYS */;
INSERT INTO `forums` VALUES (310,'Forum I','forum1','2016-04-10 20:44:54','example@mail.ru'),(311,'Forum II','forum2','2016-04-10 20:44:54','example2@mail.ru'),(312,'Форум Три','forum3','2016-04-10 20:44:54','example2@mail.ru'),(309,'Forum With Sufficiently Large Name','forumwithsufficientlylargename','2016-04-10 20:44:54','example@mail.ru');
/*!40000 ALTER TABLE `forums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `forum` varchar(60) NOT NULL,
  `isHighlighted` tinyint(1) DEFAULT '0',
  `isApproved` tinyint(1) DEFAULT '0',
  `isDeleted` tinyint(1) DEFAULT '0',
  `isEdited` tinyint(1) DEFAULT '0',
  `isSpam` tinyint(1) DEFAULT '0',
  `message` text NOT NULL,
  `parent` int(11) DEFAULT NULL,
  `thread` int(11) NOT NULL,
  `user` varchar(30) NOT NULL,
  `likes` int(11) DEFAULT '0',
  `dislikes` int(11) DEFAULT '0',
  `points` int(11) DEFAULT '0',
  `mpath` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `forum` (`forum`),
  KEY `thread` (`thread`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`forum`) REFERENCES `forums` (`shortname`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `posts_ibfk_3` FOREIGN KEY (`thread`) REFERENCES `threads` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2549 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (2514,'2014-03-19 18:29:16','forumwithsufficientlylargename',0,0,0,1,0,'my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0',NULL,305,'example2@mail.ru',0,0,0,'000002514/'),(2515,'2014-06-25 20:25:21','forumwithsufficientlylargename',0,0,0,1,1,'my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1',2514,305,'richard.nixon@example.com',0,0,0,'000002514/000002515/'),(2516,'2015-10-11 06:49:11','forumwithsufficientlylargename',0,1,0,0,1,'my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2',NULL,305,'example@mail.ru',0,0,0,'000002516/'),(2517,'2015-12-14 20:36:16','forumwithsufficientlylargename',0,1,0,1,0,'my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3',NULL,305,'example4@mail.ru',0,0,0,'000002517/'),(2518,'2016-01-17 23:05:08','forumwithsufficientlylargename',1,1,0,1,0,'my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4',2516,305,'richard.nixon@example.com',0,0,0,'000002516/000002518/'),(2519,'2016-02-22 20:20:56','forumwithsufficientlylargename',1,1,0,0,1,'my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5',NULL,305,'example2@mail.ru',0,0,0,'000002519/'),(2520,'2016-03-12 00:48:29','forumwithsufficientlylargename',0,1,0,1,1,'my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6',NULL,305,'richard.nixon@example.com',0,0,0,'000002520/'),(2521,'2016-04-09 06:24:16','forumwithsufficientlylargename',0,1,0,0,1,'my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7',2514,305,'example@mail.ru',0,0,0,'000002514/000002521/'),(2522,'2016-04-09 10:47:10','forumwithsufficientlylargename',0,0,0,1,1,'my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8',2521,305,'richard.nixon@example.com',0,0,0,'000002514/000002521/000002522/'),(2523,'2016-04-09 20:33:00','forumwithsufficientlylargename',1,0,0,1,0,'my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9',2514,305,'example2@mail.ru',0,0,0,'000002514/000002523/'),(2524,'2015-04-28 19:20:24','forum1',0,0,0,0,0,'my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0',NULL,306,'richard.nixon@example.com',1,0,1,'000002524/'),(2525,'2015-10-31 07:09:02','forum1',0,0,0,0,1,'my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1',NULL,306,'example@mail.ru',0,0,0,'000002525/'),(2526,'2016-02-06 13:19:41','forum1',1,1,0,0,1,'my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2',2525,306,'example3@mail.ru',0,0,0,'000002525/000002526/'),(2527,'2016-03-29 18:34:13','forum1',0,0,0,1,1,'my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3',NULL,306,'example4@mail.ru',0,0,0,'000002527/'),(2528,'2016-04-09 17:38:31','forum1',1,1,0,0,0,'my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4',NULL,306,'example4@mail.ru',0,0,0,'000002528/'),(2529,'2016-04-10 17:27:56','forum1',1,0,0,0,1,'my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5',2525,306,'example3@mail.ru',0,0,0,'000002525/000002529/'),(2530,'2016-04-10 19:44:39','forum1',1,0,0,1,0,'my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6',NULL,306,'example@mail.ru',0,0,0,'000002530/'),(2531,'2016-04-10 20:11:25','forum1',0,1,0,0,1,'my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7',NULL,306,'example3@mail.ru',0,0,0,'000002531/'),(2532,'2016-04-10 20:12:34','forum1',0,1,0,1,0,'my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8my message 8',2531,306,'example@mail.ru',0,0,0,'000002531/000002532/'),(2533,'2016-04-10 20:22:06','forum1',0,0,0,0,1,'my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9my message 9',NULL,306,'richard.nixon@example.com',0,0,0,'000002533/'),(2534,'2015-11-22 09:51:48','forum3',0,1,0,1,0,'my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0',NULL,307,'richard.nixon@example.com',0,0,0,'000002534/'),(2535,'2016-04-01 21:52:57','forum3',0,1,0,0,0,'my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1',NULL,307,'example3@mail.ru',0,0,0,'000002535/'),(2536,'2016-04-08 14:28:36','forum3',0,1,0,1,0,'my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2',NULL,307,'example4@mail.ru',0,0,0,'000002536/'),(2537,'2016-04-08 20:29:18','forum3',1,0,0,0,0,'my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3',2535,307,'example@mail.ru',0,0,0,'000002535/000002537/'),(2538,'2016-04-09 09:07:12','forum3',0,1,0,1,0,'my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4',NULL,307,'example@mail.ru',0,0,0,'000002538/'),(2539,'2016-04-10 02:03:20','forum3',1,1,0,1,0,'my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5',2537,307,'example4@mail.ru',0,0,0,'000002535/000002537/000002539/'),(2540,'2016-04-10 12:15:06','forum3',0,0,0,1,1,'my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6',2536,307,'example3@mail.ru',0,0,0,'000002536/000002540/'),(2541,'2016-04-10 15:57:00','forum3',1,0,0,0,0,'my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7my message 7',NULL,307,'example2@mail.ru',0,0,0,'000002541/'),(2542,'2014-04-14 11:58:32','forum1',0,0,0,1,0,'my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0my message 0',NULL,308,'example2@mail.ru',0,0,0,'000002542/'),(2543,'2015-11-17 18:50:47','forum1',1,0,0,1,0,'my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1my message 1',2542,308,'example@mail.ru',0,0,0,'000002542/000002543/'),(2544,'2015-11-20 18:53:33','forum1',0,1,0,0,1,'my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2my message 2',NULL,308,'example2@mail.ru',0,0,0,'000002544/'),(2545,'2015-12-01 23:18:34','forum1',0,1,0,0,1,'my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3my message 3',2543,308,'richard.nixon@example.com',0,0,0,'000002542/000002543/000002545/'),(2546,'2016-03-03 16:21:37','forum1',1,0,0,0,0,'my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4my message 4',NULL,308,'richard.nixon@example.com',0,0,0,'000002546/'),(2547,'2016-04-07 00:32:30','forum1',1,1,0,1,1,'my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5my message 5',2542,308,'example@mail.ru',0,0,0,'000002542/000002547/'),(2548,'2016-04-07 09:32:00','forum1',1,1,0,1,1,'my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6my message 6',2547,308,'richard.nixon@example.com',0,0,0,'000002542/000002547/000002548/');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscribes`
--

DROP TABLE IF EXISTS `subscribes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscribes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `thread` int(11) NOT NULL,
  `user` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `thread` (`thread`,`user`),
  KEY `user` (`user`),
  CONSTRAINT `subscribes_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `subscribes_ibfk_2` FOREIGN KEY (`thread`) REFERENCES `threads` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=371 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscribes`
--

LOCK TABLES `subscribes` WRITE;
/*!40000 ALTER TABLE `subscribes` DISABLE KEYS */;
INSERT INTO `subscribes` VALUES (367,305,'example3@mail.ru'),(368,305,'example@mail.ru'),(369,307,'example3@mail.ru'),(366,307,'richard.nixon@example.com'),(370,308,'example2@mail.ru');
/*!40000 ALTER TABLE `subscribes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threads`
--

DROP TABLE IF EXISTS `threads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `forum` varchar(60) NOT NULL,
  `isClosed` tinyint(1) DEFAULT NULL,
  `isDeleted` tinyint(1) DEFAULT NULL,
  `message` text NOT NULL,
  `slug` varchar(60) NOT NULL,
  `title` varchar(60) NOT NULL,
  `user` varchar(30) NOT NULL,
  `likes` int(11) DEFAULT '0',
  `dislikes` int(11) DEFAULT '0',
  `points` int(11) DEFAULT '0',
  `posts` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `forum` (`forum`),
  CONSTRAINT `threads_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `threads_ibfk_2` FOREIGN KEY (`forum`) REFERENCES `forums` (`shortname`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=309 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threads`
--

LOCK TABLES `threads` WRITE;
/*!40000 ALTER TABLE `threads` DISABLE KEYS */;
INSERT INTO `threads` VALUES (305,'2013-12-31 20:00:01','forumwithsufficientlylargename',1,0,'hey hey hey hey!','Threadwithsufficientlylargetitle','Thread With Sufficiently Large Title','example@mail.ru',0,0,0,10),(306,'2013-12-30 20:01:01','forum1',0,0,'hey!','newslug','Thread I','example4@mail.ru',0,0,0,10),(307,'2013-12-29 20:01:01','forum3',0,0,'hey hey!','thread2','Thread II','richard.nixon@example.com',0,0,0,8),(308,'2013-12-28 20:01:01','forum1',0,0,'hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! hey hey hey! ','thread3','Тред Три','example2@mail.ru',0,1,-1,7);
/*!40000 ALTER TABLE `threads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) DEFAULT NULL,
  `username` varchar(30) DEFAULT NULL,
  `email` varchar(30) NOT NULL,
  `about` text,
  `isAnonymous` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`email`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=803 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (799,'NewName','user2','example2@mail.ru','Wowowowow',0),(800,'NewName2','user3','example3@mail.ru','Wowowowow!!!',0),(801,'Jim','user4','example4@mail.ru','hello im user4',0),(797,'John','user1','example@mail.ru','hello im user1',0),(798,NULL,NULL,'richard.nixon@example.com',NULL,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-04-11  0:10:43
