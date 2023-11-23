<?php
  $temperature = $_GET["temperatura"];
  $humidity = $_GET["humedad"];
  $pressure = $_GET["presion"];

  echo "<h3>Data received</h3>";
  echo "<ul>";
  echo "<li>temperatura: ".$temperature."</li>";
  echo "<li>humedad: ".$humidity."</li>";
  echo "<li>presion: ".$pressure."</li>";
  echo "</ul>";

  $meteo_db_host = $_ENV["METEO_DB_HOST"];
  $meteo_db_name = $_ENV["METEO_DB_NAME"];
  $meteo_db_username = $_ENV["METEO_DB_USERNAME"];
  $meteo_db_password = $_ENV["METEO_DB_PASSWORD"];

  echo "<h3>Insertion</h3>";

  if(!is_numeric($temperature) || !is_numeric($humidity) || !is_numeric($pressure)) {
    exit("<p>Some data is missing or wrong</p>");
  }

  try {
    $mysqli = new mysqli(
      $meteo_db_host,
      $meteo_db_username,
      $meteo_db_password,
      $meteo_db_name
    );
  } catch(Exception $e) {
    error_log($e->getMessage());
    exit('<p>Error connecting to database</p>');
  }

  $stmt = $mysqli->prepare("INSERT INTO `datosmeteo` (`temperatura`, `humedad`, `presion`, `estacion_id`) VALUES (?, ?, ?, 1)");
  $stmt->bind_param("ddd", $temperature, $humidity, $pressure);
  $stmt->execute();
  if($stmt->affected_rows === -1) {
    error_log($stmt->error);
    exit('<p>Insertion failed</p>');
  }
  if($stmt->affected_rows === 0) exit('<p>No rows updated</p>');
  $stmt->close();
  $mysqli->close();

  echo "<p>OK</p>"
?>
