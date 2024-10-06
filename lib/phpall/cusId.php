<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php"); // รวมไฟล์ config.php เพื่อเชื่อมต่อกับฐานข้อมูล

// SQL ที่รวมข้อมูลจาก post, table_rider และ table_customer
$sql = "
    SELECT 
        table_customer.regis_customer_id  AS customer_id
    FROM table_customer"; 

$result = mysqli_query($conn, $sql);

$response = array();

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $tb_pos = array(); 
        $tb_pos["customer_id"] = $row['customer_id']; 

        array_push($response, $tb_pos); 
    }
} else {
    // หากไม่มีข้อมูลในฐานข้อมูล
    $tb_pos = array();
    
    array_push($response, $tb_pos); // เพิ่ม $tb_pos ที่เป็นข้อมูลว่างเข้าใน $response
}

echo json_encode($response ,JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT); // ส่งข้อมูลเป็น JSON
mysqli_close($conn);
?>
