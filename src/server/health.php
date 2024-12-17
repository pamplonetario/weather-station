<?php
  header('Content-Type: text/plain; charset=utf-8');

  $db_host = $_ENV["WEATHER_STATION_DB_HOST"];
  $db_name = $_ENV["WEATHER_STATION_DB_NAME"];
  $db_username = $_ENV["WEATHER_STATION_DB_USERNAME"];
  $db_password = $_ENV["WEATHER_STATION_DB_PASSWORD"];

  try {
    $mysqli = new mysqli(
      $db_host,
      $db_username,
      $db_password,
      $db_name
    );
  } catch(Exception $e) {
    error_log($e->getMessage());
    http_response_code(500);
    exit('Error connecting to database');
  }

  $query = $mysqli->prepare("SELECT 1");
  $query->execute();
  $result = $query->get_result();
  $n = $result->fetch_assoc();
  if(is_null($n) || $n[1] != 1) {
    http_response_code(500);
    exit("Select failed");
  }
  $mysqli->close();

  exit("Ok");
?>
