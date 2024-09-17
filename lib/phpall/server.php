<?php
  include 'db_connection.php';

  if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $sql = "SELECT id, email, password FROM users WHERE email='$email' AND password='$password'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
      $row = $result->fetch_assoc();
      echo json_encode(array("status" => "success", "id" => $row['id'], "email" => $row['email']));
    } else {
      echo json_encode(array("status" => "error", "message" => "Invalid email or password"));
    }
  }

  $conn->close();
?>
