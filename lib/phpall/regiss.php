<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");

// รับค่าจาก POST;
$id = intval($_POST['id']);



// SQL สำหรับการอัปเดตข้อมูลในตาราง status_post
$sql = "INSERT INTO `img`  (`id`, `img`, `) 
               VALUES ('$id', '$img');";
              



// ดำเนินการคำสั่ง insert
if ($conn->query($sql)) {
    echo "Insert Success";

    $update_sql = "UPDATE `img` 
    SET `img` = '$img', `img`
    WHERE `id` = '$id';";
    
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
