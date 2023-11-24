CREATE DATABASE IF NOT EXISTS `estacion_perseverance` COLLATE `utf8_unicode_ci`;

CREATE TABLE IF NOT EXISTS `datosmeteo` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT,
  `temperatura` float NOT NULL,
  `humedad` float NOT NULL,
  `presion` float NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `estacion` (
  `id` int(11) PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `datosmeteo` ADD COLUMN `estacion_id` int(11) NOT NULL;
ALTER TABLE `datosmeteo` ADD FOREIGN KEY (`estacion_id`) REFERENCES `estacion`(`id`);
ALTER TABLE `datosmeteo` CHANGE `fecha` `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `datosmeteo` ADD INDEX `datosmeteo_fecha_index` (`fecha`);
ALTER TABLE `datosmeteo` ADD INDEX `datosmeteo_estacion_fecha_index` (`estacion_id`, `fecha`);

ALTER TABLE `estacion` ADD COLUMN `pass_salt` varchar(255) NULL;
ALTER TABLE `estacion` ADD COLUMN `pass_hash` varchar(255) NULL;

DELIMITER //

CREATE PROCEDURE crear_estacion(IN in_nombre VARCHAR(255))
BEGIN
  INSERT INTO `estacion` (`nombre`) VALUES (in_nombre);
END //

CREATE PROCEDURE cambiar_clave_estacion(IN in_id VARCHAR(255), IN in_password VARCHAR(255))
BEGIN
  DECLARE new_salt VARCHAR(255) DEFAULT SHA1(RAND());
  UPDATE `estacion` SET `pass_salt` = new_salt, `pass_hash` = SHA1(CONCAT(new_salt, '_', in_password)) WHERE `id` = in_id;
END //

DELIMITER ;
