<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php"); // รวมไฟล์ config.php เพื่อเชื่อมต่อกับฐานข้อมูล


$sql = "
    SELECT 
        post.pick_up, 
        post.comment_pick, 
        post.at_drop, 
        post.comment_drop, 
        post.date, 
        post.time, 
        post.price, 
        post.status_helmet, 
        table_rider.name AS rider_id, 
        table_rider.gender AS rider_gender
    FROM post
    INNER JOIN table_rider ON post.rider_id = table_rider.regis_rider_id"; // เชื่อมต่อ post กับ table_rider

$result = mysqli_query($conn, $sql);

$response = array();

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $tb_pos = array();
        $tb_pos["pick_up"] = $row['pick_up'];
        $tb_pos["commpick"] = $row['comment_pick'];
        $tb_pos["at_drop"] = $row['at_drop'];
        $tb_pos["commdrop"] = $row['comment_drop'];
        $tb_pos["date"] = $row['date'];
        $tb_pos["time"] = $row['time'];
        $tb_pos["price"] = $row['price'];
        $tb_pos["status_helmet"] = $row['status_helmet'];
        $tb_pos["rider_id"] = $row['rider_id']; 
        $tb_pos["rider_gender"] = $row['rider_gender'];

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
    

    array_push($response, $tb_pos); // เพิ่ม $tb_pos ที่เป็นข้อมูลว่างเข้าใน $response
}

echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT) ; // ส่งข้อมูลเป็น JSON
mysqli_close($conn);
?>
