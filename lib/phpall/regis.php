<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");

// รับค่าที่ส่งมาจาก Flutter
// $regis_rider_id = $_POST['regis_rider_id'];
$img_profile = $_POST['img_profile'];
$name = $_POST['name'];
$email = $_POST['email'];
$tel = $_POST['tel'];
$gender = $_POST['gender'];
$password = $_POST['password'];
$img_id_card = $_POST['img_id_card'];
$bank = $_POST['bank'];
$name_account = $_POST['name_account'];
$number_bank = intval($_POST['number_bank']);
$status_rider = intval($_POST['status_customer']);

// เตรียมคำสั่ง SQL สำหรับการ INSERT
$sql = "INSERT INTO `table_customer` 
        (`img_profile`, `name`, `email`, `tel`, `gender`, `password`, `img_id_card`, `bank`, `name_account`, `number_bank`, `status_customer`) 
        VALUES 
        ('$img_profile', '$name', '$email', '$tel', '$gender', '$password', '$img_id_card', '$bank', '$name_account', '$number_bank', '$status_customer' )";

if ($conn->query($sql)) {
    echo "insert Sucsess";
} else {
    echo "Error insert !";
}

?>