<?php

$servername = "localhost";
$username = "twoja_nazwa_uzytkownika";
$password = "twoje_haslo";
$dbname = "twoja_nazwa_bazy";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Błąd połączenia z bazą danych: " . $conn->connect_error);
}
?>