<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php"); // รวมไฟล์ config.php เพื่อเชื่อมต่อกับฐานข้อมูล

// SQL ที่รวมข้อมูลจาก post, table_rider และ table_customer
$sql = "
    SELECT 
        post.post_id, 
        post.pick_up, 
        post.comment_pick, 
        post.at_drop, 
        post.comment_drop, 
        post.date, 
        post.time, 
        post.price, 
        post.status_helmet, 
        table_rider.regis_rider_id AS rider_id, 
        table_rider.name AS rider_name, 
        table_rider.gender AS rider_gender,
        table_customer.email AS customer_email,
        table_customer.regis_customer_id  AS customer_id
    FROM post
    INNER JOIN table_rider ON post.rider_id = table_rider.regis_rider_id
    INNER JOIN table_customer ON post.customer_id = table_customer.regis_customer_id";

$result = mysqli_query($conn, $sql);

$response = array();

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $tb_pos = array();
        $tb_pos["post_id"] = $row['post_id'];
        $tb_pos["pick_up"] = $row['pick_up'];
        $tb_pos["commpick"] = $row['comment_pick'];
        $tb_pos["at_drop"] = $row['at_drop'];
        $tb_pos["commdrop"] = $row['comment_drop'];
        $tb_pos["date"] = $row['date'];
        $tb_pos["time"] = $row['time'];
        $tb_pos["price"] = $row['price'];
        $tb_pos["status_helmet"] = $row['status_helmet'];
        $tb_pos["rider_id"] = $row['rider_id'];
        $tb_pos["rider_name"] = $row['rider_name'];
        $tb_pos["rider_gender"] = $row['rider_gender'];
        $tb_pos["customer_email"] = $row['customer_email'];
        $tb_pos["customer_id"] = $row['customer_id'];

        array_push($response, $tb_pos);
    }
} else {
    // หากไม่มีข้อมูลในฐานข้อมูล
    $tb_pos = array();
    $tb_pos["pick_up"] = '';
    $tb_pos["commpick"] = '';
    $tb_pos["at_drop"] = '';
    $tb_pos["commdrop"] = '';
    $tb_pos["date"] = '';
    $tb_pos["time"] = '';
    $tb_pos["price"] = '';
    $tb_pos["status_helmet"] = '';
    $tb_pos["rider_id"] = '';
    $tb_pos["rider_gender"] = '';
    $tb_pos["customer_email"] = ''; // ค่าเริ่มต้นของ customer_email

    array_push($response, $tb_pos); // เพิ่ม $tb_pos ที่เป็นข้อมูลว่างเข้าใน $response
}

echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT); // ส่งข้อมูลเป็น JSON
mysqli_close($conn);
?>