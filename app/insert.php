<?php
// insert.php
include 'db_config.php';

$message = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // 1. Walidacja i sanitacja danych
    $post_text = trim($_POST['post_text']);

    if (empty($post_text)) {
        $message = "<p style='color: red;'>Treść postu nie może być pusta!</p>";
    } else {
        // 2. Przygotowanie zapytania (DLA BEZPIECZEŃSTWA: Ochrona przed SQL Injection)
        $stmt = $conn->prepare("INSERT INTO posts (post_text, created_at) VALUES (?, NOW())");
        
        // Sprawdzenie, czy przygotowanie zapytania się powiodło
        if ($stmt === false) {
             $message = "<p style='color: red;'>Błąd przygotowania zapytania: " . $conn->error . "</p>";
        } else {
             // 3. Powiązanie parametru (s = string)
            $stmt->bind_param("s", $post_text);
            
            // 4. Wykonanie zapytania
            if ($stmt->execute()) {
                $message = "<p style='color: green;'>Pomyślnie dodano nowy post!</p>";
                // Opcjonalne: Przekierowanie po pomyślnym zapisie
                // header("Location: index.php");
                // exit();
            } else {
                $message = "<p style='color: red;'>Błąd podczas dodawania postu: " . $stmt->error . "</p>";
            }
            
            // 5. Zamknięcie zapytania
            $stmt->close();
        }
    }
}

$conn->close();
?>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Dodaj Nowy Post</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        textarea { width: 100%; height: 150px; padding: 10px; box-sizing: border-box; }
        input[type="submit"] { padding: 10px 20px; margin-top: 10px; cursor: pointer; }
    </style>
</head>
<body>
    <h1>Dodaj Nowy Post</h1>

    <p><a href="index.php">Powrót do listy postów</a></p>

    <?php echo $message; ?>

    <form method="POST" action="insert.php">
        <label for="post_text">Treść Postu:</label><br>
        <textarea id="post_text" name="post_text" required></textarea><br>
        <input type="submit" value="Dodaj Post">
    </form>
</body>
</html>