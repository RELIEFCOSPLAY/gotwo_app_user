<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");

// รับค่าจาก POST;
$customer_id = intval($_POST['customer_id']);
$review = intval($_POST['review']);
$comment = ($_POST['comment']);
$status = ($_POST['status']);


// SQL สำหรับการอัปเดตข้อมูลในตาราง status_post
$update_sql = "UPDATE `status_post` 
               SET `review` = '$review', `comment` = '$comment', `status` = '$status'
               WHERE `customer_id` = '$customer_id';";


// ดำเนินการคำสั่ง update
if ($conn->query($update_sql)) {
    echo json_encode(["message" => "Update Success"]);
} else {
    echo json_encode(["message" => "Error updating status_post!", "error" => $conn->error]);
}


// ปิดการเชื่อมต่อฐานข้อมูล
$conn->close();
?>
