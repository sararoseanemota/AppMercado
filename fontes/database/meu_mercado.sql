-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: meu_mercado
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `mercado`
--

DROP TABLE IF EXISTS `mercado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mercado` (
  `id_mercado` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) DEFAULT NULL,
  `endereco` varchar(100) DEFAULT NULL,
  `bairro` varchar(50) DEFAULT NULL,
  `cidade` varchar(50) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  `cep` varchar(10) DEFAULT NULL,
  `dt_cadastro` datetime DEFAULT NULL,
  `vl_entrega` decimal(5,2) DEFAULT NULL,
  `vl_compra_min` decimal(9,2) DEFAULT NULL,
  `ind_entrega` char(1) DEFAULT NULL,
  `ind_retira` char(1) DEFAULT NULL,
  PRIMARY KEY (`id_mercado`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mercado`
--

LOCK TABLES `mercado` WRITE;
/*!40000 ALTER TABLE `mercado` DISABLE KEYS */;
INSERT INTO `mercado` VALUES (1,'Pão','Av. Interlagos, 850','Interlagos','São Paulo','SP','05410-010','2023-01-24 16:40:24',8.50,30.00,'S','N'),(2,'DiaAdia','Av. Paulista, 10','Zona Leste','São Paulo','SP','05310-020','2023-01-26 09:34:36',15.99,100.00,'S','S'),(3,'Ultrabox','QNN 30, AE 02 Lote 02/10','Sul','Brasília','DF','05310-020','2023-02-01 09:09:46',20.00,150.00,'S','S'),(4,'Fort Atacadista','QNN 02, AE 02 Lote 14/30','Centro','Brasília','DF','05380-020','2023-02-01 09:09:46',20.00,100.00,'S','N');
/*!40000 ALTER TABLE `mercado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `id_mercado` int NOT NULL,
  `id_usuario` int NOT NULL,
  `dt_pedido` datetime DEFAULT NULL,
  `vl_subtotal` decimal(9,2) DEFAULT NULL,
  `vl_entrega` decimal(5,2) DEFAULT NULL,
  `vl_total` decimal(9,2) DEFAULT NULL,
  `endereco` varchar(100) DEFAULT NULL,
  `bairro` varchar(50) DEFAULT NULL,
  `cidade` varchar(50) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  `cep` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_pedido`),
  KEY `id_mercado` (`id_mercado`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`id_mercado`) REFERENCES `mercado` (`id_mercado`),
  CONSTRAINT `pedido_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,1,1,'2023-01-24 16:40:24',77.10,8.50,85.60,'Av Paulista, 1500','Bela Vista','São Paulo','SP','03015-500'),(2,1,2,'2023-01-26 15:10:28',77.10,8.50,85.60,'Av Paulista, 1500','Bela Vista','São Paulo','SP','03015-500'),(3,1,2,'2023-01-26 15:13:16',77.10,8.50,85.60,'Av Paulista, 1500','Bela Vista','São Paulo','SP','03015-500');
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_item`
--

DROP TABLE IF EXISTS `pedido_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_item` (
  `id_item` int NOT NULL AUTO_INCREMENT,
  `id_pedido` int NOT NULL,
  `id_produto` int NOT NULL,
  `qtd` decimal(9,3) DEFAULT NULL,
  `vl_unitario` decimal(9,2) DEFAULT NULL,
  `vl_total` decimal(9,2) DEFAULT NULL,
  PRIMARY KEY (`id_item`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `pedido_item_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`),
  CONSTRAINT `pedido_item_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_item`
--

LOCK TABLES `pedido_item` WRITE;
/*!40000 ALTER TABLE `pedido_item` DISABLE KEYS */;
INSERT INTO `pedido_item` VALUES (1,1,1,2.000,9.75,19.50),(2,1,3,12.000,4.80,57.60),(3,2,1,2.000,9.75,19.50),(4,2,3,12.000,4.80,57.60),(7,3,1,2.000,9.75,19.50),(8,3,3,12.000,4.80,57.60);
/*!40000 ALTER TABLE `pedido_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `id_produto` int NOT NULL AUTO_INCREMENT,
  `id_categoria` int NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `descricao` varchar(1000) DEFAULT NULL,
  `unidade` varchar(20) DEFAULT NULL,
  `preco` decimal(9,2) DEFAULT NULL,
  `url_foto` varchar(1000) DEFAULT NULL,
  `id_mercado` int NOT NULL,
  PRIMARY KEY (`id_produto`),
  KEY `id_mercado` (`id_mercado`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`id_mercado`) REFERENCES `mercado` (`id_mercado`),
  CONSTRAINT `produto_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `produto_categoria` (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

LOCK TABLES `produto` WRITE;
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` VALUES (1,1,'Café Pilão Torrado e Moído','Café Pilão torrado e moído embalado a vacuo','250g',9.75,'https://static.paodeacucar.com/img/uploads/1/671/669671x200x200.jpg',1),(2,1,'Café 3 Corações Torrado e Moído','Café 3 Corações torrado e moído embalado a vacuo','500g',18.99,'https://static.paodeacucar.com/img/uploads/1/2/656002x200x200.png',1),(3,2,'Cerveja Heineken Lata','O processo de fermentação da Heineken, a exclusiva Levedura A é responsável pelo sabor característico e bem equilibrado, com notas frutadas sutis.','350ml',4.80,'https://static.paodeacucar.com/img/uploads/1/623/17634623x200x200.png',1),(4,3,'Papel Higienico','Papel Higienico Neve','24 und',20.99,'https://static.paodeacucar.com/img/uploads/1/37/12886037.jpg',1),(5,3,'Papel Higienico','Papel Higienico Neve','24 und',20.99,'https://static.paodeacucar.com/img/uploads/1/37/12886037.jpg',2),(6,3,'Papel Higienico','Papel Higienico Neve','24 und',20.99,'https://static.paodeacucar.com/img/uploads/1/37/12886037.jpg',2),(7,5,'Caderno','Caderno Rosa','1 und',15.99,'https://static.paodeacucar.com/img/uploads/1/962/24110962.jpg',1),(8,2,'Vinho Mancura Mito Carmenere','Vinho Mancura Mito Carmenere','750 ml',84.45,'https://static.paodeacucar.com/img/uploads/1/927/24653927.jpeg',1),(9,2,'Coca-Cola Original','Coca-Cola Original','1,5 lt',8.99,'https://static.paodeacucar.com/img/uploads/1/191/24599191.jpg',1);
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto_categoria`
--

DROP TABLE IF EXISTS `produto_categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto_categoria` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) DEFAULT NULL,
  `ordem` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto_categoria`
--

LOCK TABLES `produto_categoria` WRITE;
/*!40000 ALTER TABLE `produto_categoria` DISABLE KEYS */;
INSERT INTO `produto_categoria` VALUES (1,'Alimentos',1),(2,'Bebidas',2),(3,'Limpeza',3),(4,'Petshop',4),(5,'Papelaria',5),(6,'Brinquedos',6);
/*!40000 ALTER TABLE `produto_categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `senha` varchar(50) DEFAULT NULL,
  `endereco` varchar(100) DEFAULT NULL,
  `bairro` varchar(50) DEFAULT NULL,
  `cidade` varchar(50) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  `cep` varchar(10) DEFAULT NULL,
  `dt_cadastro` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Heber Stein Mazutti','heber@teste.com.br','12345','Av Paulista, 1500','Bela Vista','São Paulo','SP','03015-500','2023-01-24 16:40:24'),(2,'João Silva','joao@teste.com.br','12345','Av Interlagos, 555','Interlagos','São Paulo','SP','15850-010','2023-01-24 16:40:24'),(3,'Sara Mota','sara@teste.com.br','12345','Rua 45, casa 05','Taguatinga','Brasilia','DF','72258-410','2023-01-25 16:45:31'),(4,'Italo','italo@teste.com.br','12345','Rua 05','Centro','Abb',NULL,'7212584','2023-01-31 11:01:12'),(5,'Sara','sara@teste.com','1234','Rua','Rua','Centro','DF','12345678','2023-01-31 11:22:38'),(6,'Jair','jair@teste.com','1234','Rua ','Centro','Cei',NULL,'12345678','2023-01-31 11:26:08'),(7,'sara','sara','123','teste','teste','teste',NULL,'12345678','2023-01-31 12:06:18'),(8,'Maria','maria@teste.com','1234','Rua 05','Sul','Rio',NULL,'12345678','2023-01-31 13:41:41'),(9,'Maria','maria@teste.com','1234','Rua 05','Sul','Rio',NULL,'12345678','2023-01-31 13:42:16'),(10,'Maria','maria@teste.com','1234','Rua 05','Sul','Rio',NULL,'12345678','2023-01-31 13:42:23'),(11,'José','jose@teste.com','123','Rua x','Norte','Ceará',NULL,'12345-789','2023-01-31 13:43:17'),(12,'Ruan','ruan@teste.com','12','teste','teste','teste','tt','72235-413','2023-01-31 13:46:06'),(13,'','','','','','',NULL,'','2023-01-31 13:53:32'),(14,'','','','','','','','','2023-01-31 13:55:18'),(15,'','','','','','',NULL,'','2023-01-31 14:00:15'),(16,'','','','','','',NULL,'','2023-01-31 14:01:05'),(17,'Isa','isa@teste.com.br','12345','Rua 21','Centro','Brasilia',NULL,'72.000-000','2023-02-09 15:10:53');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'meu_mercado'
--

--
-- Dumping routines for database 'meu_mercado'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-02-10 17:40:03
