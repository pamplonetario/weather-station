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
