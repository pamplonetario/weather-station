<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Carga Perseverance</title>
  <style>
    body {
      background-color: whitesmoke;
    }
    div.content {
      background-color: white;
      padding: 1px 1em;
      display: block;
      margin: auto;
      max-width: 600px;
    }
    pre {
      white-space: break-spaces;
      background-color: antiquewhite;
      padding: 1em;
    }
  </style>
</head>
<body>
  <div class="content">

    <?php
      $temperature = $_GET["temperatura"];
      $humidity = $_GET["humedad"];
      $pressure = $_GET["presion"];
      $station = $_GET["estacion"];
      $password = $_GET["clave"];

      echo "<h3>Data received</h3>";
      echo "<ul>";
      echo "<li>temperatura: ".$temperature."</li>";
      echo "<li>humedad: ".$humidity."</li>";
      echo "<li>presion: ".$pressure."</li>";
      echo "<li>estacion: ".$station."</li>";
      echo "<li>clave: ".(is_string($password) ? 'true' : 'false')."</li>";
      echo "</ul>";

      if(!is_numeric($temperature) || !is_numeric($humidity) || !is_numeric($pressure) || !is_numeric($station) || !is_string($password)) {
        exit("<p>Some data is missing or wrong</p>");
      }

      echo "<h3>Insertion</h3>";

      $meteo_db_host = $_ENV["METEO_DB_HOST"];
      $meteo_db_name = $_ENV["METEO_DB_NAME"];
      $meteo_db_username = $_ENV["METEO_DB_USERNAME"];
      $meteo_db_password = $_ENV["METEO_DB_PASSWORD"];

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

      $login = $mysqli->prepare("SELECT id FROM `estacion` WHERE id = ? AND `pass_hash` = SHA1(CONCAT(`pass_salt`, '_', ?))");
      $login->bind_param("ds", $station, $password);
      $login->execute();
      $login_result = $login->get_result();
      $user = $login_result->fetch_assoc();
      if(is_null($user)) {
        exit("<p>Login failed</p>");
      }

      $insertion = $mysqli->prepare("INSERT INTO `datosmeteo` (`temperatura`, `humedad`, `presion`, `estacion_id`) VALUES (?, ?, ?, ?)");
      $insertion->bind_param("dddd", $temperature, $humidity, $pressure, $user["id"]);
      $insertion->execute();
      if($insertion->affected_rows === -1) {
        error_log($insertion->error);
        echo '<p>Insertion failed</p>';
        exit("<pre>".$insertion->error."</pre>");
      }
      if($insertion->affected_rows === 0) exit('<p>No rows updated</p>');
      $insertion->close();
      $mysqli->close();

      echo "<p>Ok</p>"
    ?>

  </div>
</body>
</html>
