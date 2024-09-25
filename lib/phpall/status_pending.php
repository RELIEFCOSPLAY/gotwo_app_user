<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php"); // รวมไฟล์ config.php เพื่อเชื่อมต่อกับฐานข้อมูล

$sql = "
    SELECT 
        status_post.status, 
        status_post.reason, 
        status_post.pay, 
        status_post.review, 
        status_post.comment,  
        post.post_id AS post_id, 
        table_customer.regis_customer_id AS customer_id, 
        table_rider.name AS rider_id, 
        table_rider.gender AS rider_gender,
        table_rider.tel AS rider_tel,
        post.pick_up AS pick_up, 
        post.comment_pick AS comment_pick, 
        post.at_drop AS at_drop, 
        post.comment_drop AS comment_drop, 
        post.date AS date, 
        post.time AS time,
        post.status_helmet AS status_helmet,
        post.price AS price
    FROM status_post
    INNER JOIN post ON status_post.post_id = post.post_id
    INNER JOIN table_customer ON status_post.customer_id = table_customer.regis_customer_id
    INNER JOIN table_rider ON post.rider_id = table_rider.regis_rider_id";

$result = mysqli_query($conn, $sql);

$response = array();

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $tb_sta = array();
        $tb_sta["status"] = $row['status'];
        $tb_sta["reason"] = $row['reason'];
        $tb_sta["post_id"] = $row['post_id']; 
        $tb_sta["customer_id"] = $row['customer_id'];
        $tb_sta["pay"] = $row['pay'];
        $tb_sta["review"] = $row['review'];
        $tb_sta["comment"] = $row['comment'];
        $tb_sta["rider_id"] = $row['rider_id']; // แสดงชื่อไรเดอร์
        $tb_sta["rider_gender"] = $row['rider_gender'];
        $tb_sta["rider_tel"] = $row['rider_tel'];
        $tb_sta["pick_up"] = $row['pick_up']; 
        $tb_sta["comment_pick"] = $row['comment_pick']; 
        $tb_sta["at_drop"] = $row['at_drop']; 
        $tb_sta["comment_drop"] = $row['comment_drop']; 
        $tb_sta["date"] = $row['date']; 
        $tb_sta["time"] = $row['time']; 
        $tb_sta["status_helmet"] = $row['status_helmet'];
        $tb_sta["price"] = $row['price'];
        
        array_push($response, $tb_sta);
    }
} else {
    $tb_sta = array(); 
    $tb_sta["status"] = '';
    $tb_sta["reason"] = '';
    $tb_sta["post_id"] = ''; 
    $tb_sta["customer_id"] = '';
    $tb_sta["pay"] = '';
    $tb_sta["review"] = '';
    $tb_sta["comment"] = '';
    $tb_sta["rider_id"] = ''; 
    $tb_sta["rider_gender"] = '';
    $tb_sta["rider_tel"] = '';
    $tb_sta["pick_up"] = ''; 
    $tb_sta["comment_pick"] = ''; 
    $tb_sta["at_drop"] = ''; 
    $tb_sta["comment_drop"] = ''; 
    $tb_sta["date"] = ''; 
    $tb_sta["time"] = ''; 
    $tb_sta["status_helmet"] = '';
    $tb_sta["price"] = '';

    array_push($response, $tb_sta); 
}

echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT); 
mysqli_close($conn);



// //insert
$status = $_POST['status'];
$reason = $_POST['reason'];
$post_id = intval($_POST['post_id']);
$customer_id = intval($_POST['customer_id']);
$pay = intval($_POST['pay']);
$review = intval($_POST['review']);
$comment = $_POST['comment'];
$rider_id = intval($_POST['rider_id']);

// // SQL สำหรับการ insert ข้อมูลลงในตาราง status_post
$sql = "INSERT INTO status_post (status, reason, post_id, customer_id, pay, review, comment, rider_id) 
VALUES ('$status', '$reason', '$post_id', '$customer_id', '$pay', '$review', '$comment', '$rider_id');";

// ดำเนินการคำสั่ง insert
// if ($conn->query($sql)) {
//     echo "Insert Success";

    // SQL สำหรับการ update ข้อมูลในตาราง post
    $update_sql = "UPDATE post SET customer_id = '$customer_id' WHERE post_id = '$post_id';";


    // ดำเนินการคำสั่ง update
    if ($conn->query($update_sql)) {
        echo " and Update Success";
    } else {
        echo " but Error updating status_post!";
    }
?>
