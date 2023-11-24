-- migrate:up
CREATE PROCEDURE crear_estacion(IN in_nombre VARCHAR(255))
BEGIN
  INSERT INTO `estacion` (`nombre`) VALUES (in_nombre);
END;

CREATE PROCEDURE cambiar_clave_estacion(IN in_id VARCHAR(255), IN in_password VARCHAR(255))
BEGIN
  DECLARE new_salt VARCHAR(255) DEFAULT SHA1(RAND());
  UPDATE `estacion` SET `pass_salt` = new_salt, `pass_hash` = SHA1(CONCAT(new_salt, '_', in_password)) WHERE `id` = in_id;
END;

-- migrate:down

