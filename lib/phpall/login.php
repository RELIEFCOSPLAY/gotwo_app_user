<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");

$sql = "
    SELECT  
        table_customer.name AS customer_name, 
        table_customer.password AS customer_password
    FROM table_customer";

$result = mysqli_query($conn, $sql);

$response = array();

// สร้าง JSON ที่ถูกต้อง
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $tb_log = array();
        $tb_log["customer_name"] = $row['customer_name'];
        $tb_log["customer_password"] = $row['customer_password'];

        array_push($response, $tb_log);
    }
} else {
    $response["error"] = "No data found.";
}

// ส่งข้อมูล JSON กลับไปยัง Flutter
echo json_encode($response,JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
mysqli_close($conn);

?>