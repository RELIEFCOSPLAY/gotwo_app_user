<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php"); // รวมไฟล์ config.php เพื่อเชื่อมต่อกับฐานข้อมูล

$sql = "SELECT * FROM post";
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
        $tb_pos["rider_id"] = $row['rider_id'];

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
    $tb_pos["rider_id"] = '';

    array_push($response, $tb_pos); // เพิ่ม $tb_pos ที่เป็นข้อมูลว่างเข้าใน $response
}

echo json_encode($response); // ส่งข้อมูลเป็น JSON
mysqli_close($conn);
?>
