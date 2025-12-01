<?php

$servername = "localhost";
$username = "twoja_nazwa_uzytkownika"; // Zmień na swoją nazwę użytkownika
$password = "twoje_haslo";             // Zmień na swoje hasło
$dbname = "twoja_nazwa_bazy";         // Zmień na nazwę Twojej bazy danych

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Błąd połączenia z bazą danych: " . $conn->connect_error);
}
?>