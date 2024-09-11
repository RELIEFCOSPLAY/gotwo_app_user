<?php
    $servername = "localhost";
    $username = "root";
    // $email = "root":
    $password = "";
    $dbname = "register_db";

    //Creat Connection
    $conn = mysqli_connect( $servername,$username,$email,$password,$dbname);

    //check connection
    if (!$conn) {
        die("Connection failed" . mysqli_connect_error());
    } else {
        echo "Connection Successfilly";
    }
?>