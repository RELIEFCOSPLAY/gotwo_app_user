<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");
//-------------------------------------------------------
//insert
$check_status = $_POST['check_status'];
$post_id = intval($_POST['post_id']);

    // SQL สำหรับการ update ข้อมูลในตาราง post
$update_sql = "UPDATE `post` SET `check_status` = '$check_status' WHERE `post_id` = '$post_id';";

    // ดำเนินการคำสั่ง update
    if ($conn->query($update_sql)) {
        echo "Update Success";
    } else {
        echo "Error updating post!";
    }


// ปิดการเชื่อมต่อฐานข้อมูล
$conn->close();
?>