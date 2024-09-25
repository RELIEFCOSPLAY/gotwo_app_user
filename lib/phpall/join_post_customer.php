<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");


//insert
$status = $_POST['status'];
$reason = $_POST['reason'];
$post_id = intval($_POST['post_id']);
$customer_id = intval($_POST['customer_id']);
$pay = intval($_POST['pay']);
$review = intval($_POST['review']);
$comment = $_POST['comment'];
$rider_id = intval($_POST['rider_id']);

// SQL สำหรับการ insert ข้อมูลลงในตาราง status_post
$sql = "INSERT INTO `status_post` (`status`, `reason`, `post_id`, `customer_id`, `pay`, `review`, `comment`, `rider_id`) 
VALUES ('$status', '$reason', '$post_id', '$customer_id', '$pay', '$review', '$comment', '$rider_id');";

// ดำเนินการคำสั่ง insert
if ($conn->query($sql)) {
    echo "Insert Success";

    // SQL สำหรับการ update ข้อมูลในตาราง post
    $update_sql = "UPDATE `post` SET `customer_id` = '$customer_id' WHERE `post_id` = '$post_id';";

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
