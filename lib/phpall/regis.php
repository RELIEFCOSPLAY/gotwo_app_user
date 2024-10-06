<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");

// รับค่าจาก POST;
$regis_customer_id = intval($_POST['regis_customer_id']);
// $img_profile = ($_POST['img_profile']);
$name = ($_POST['name']);
$email = ($_POST['email']);
$tel = ($_POST['tel']);
$gender = ($_POST['gender']);
$password = ($_POST['password']);
// $img_id_card = ($_POST['img_id_card']);
$bank = ($_POST['bank']);
$name_account = ($_POST['name_account']);
$number_bank = intval($_POST['number_bank']);
$status_customer = intval($_POST['status_customer']);


// SQL สำหรับการอัปเดตข้อมูลในตาราง status_post
$sql = "INSERT INTO `table_customer`  (`regis_customer_id`, 
-- `img_profile`, 
`name`, `email`, `tel`, `gender`, `password`, 
-- `img_id_card`, 
`bank`, `name_account`, `number_bank`, `status_customer`) 
               VALUES ('$regis_customer_id', '$img_profile','$name', '$email', '$tel', '$gender', '$password',  '$img_id_card', '$bank', '$name_account','$number_bank', '$status_customer');";
              



// ดำเนินการคำสั่ง insert
if ($conn->query($sql)) {
    echo "Insert Success";

    $update_sql = "UPDATE `table_customer` 
    SET `img_profile` = '$img_profile', `name` = '$name', `email` = '$email', `tel` = '$tel', `gender` = '$gender', `password` = '$password', `img_id_card` = '$img_id_card', `bank` = '$bank', `name_account` = '$name_account', `number_bank` = '$number_bank', `status_customer` = '$status_customer'
    WHERE `regis_customer_id` = '$regis_customer_id';";
    
    // ดำเนินการคำสั่ง update
    if ($conn->query($update_sql)) {
        echo " and Update Success";
    } else {
        echo " but Error updating post!";
    }

} else {
    echo "Error insert!";
}

// ปิดการเชื่อมต่อฐานข้อมูล
$conn->close();
?>
