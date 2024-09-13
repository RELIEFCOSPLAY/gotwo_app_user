<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");

 if (!$conn){
    echo "connection error";
 }
 $email = $_POST['email'];
 $password = $_POST['password'];
//  $encrypted_pwd = md5($password);
 $sql = "SELECT * FROM table_customer WHERE email = '" . $email . "' AND password = '" . $password ."' ";
 $result = mysqli_query($conn, $sql);
 $count = mysqli_num_rows($result);

 if ($count == 1) {
    echo json_encode("Success");
 }else{
    echo json_encode("Error");
 }
