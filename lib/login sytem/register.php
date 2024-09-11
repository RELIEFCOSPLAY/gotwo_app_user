<?php
if (!con){
    echo "connection error";
}

$name = $_POST['name']; 
$password = $_POST['password']; 
$email = $_POST['email']; 
$encryted_pwd = md5($password); 
// sql = ""

?>