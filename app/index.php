<?php
include 'db_config.php';
?>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Lista Postów</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .post { border: 1px solid #ccc; padding: 10px; margin-bottom: 15px; }
        .post-text { font-size: 1.1em; margin-bottom: 5px; }
        .post-info { font-size: 0.8em; color: #555; }
    </style>
</head>
<body>
    <h1>Ostatnie Posty</h1>

    <p><a href="insert.php">Dodaj nowy post</a></p>

    <?php
    $sql = "SELECT id, post_text, created_at FROM posts ORDER BY created_at DESC";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            echo "<div class='post'>";
            echo "<div class='post-text'>**ID:** " . htmlspecialchars($row["id"]) . "</div>";
            echo "<div class='post-text'>" . nl2br(htmlspecialchars($row["post_text"])) . "</div>"; // nl2br zachowuje nowe linie
            echo "<div class='post-info'>Opublikowano: " . htmlspecialchars($row["created_at"]) . "</div>";
            echo "</div>";
        }
    } else {
        echo "<p>Brak postów do wyświetlenia.</p>";
    }

    $conn->close();
    ?>
</body>
</html>