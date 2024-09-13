<?php
// การเชื่อมต่อกับฐานข้อมูล
$db_name = "gotwo";  // ชื่อฐานข้อมูล
$db_user = "root";   // ชื่อผู้ใช้ของฐานข้อมูล
$db_pass = "";       // รหัสผ่าน (ว่างเปล่าในกรณีนี้)
$db_host = "localhost"; // ที่อยู่ของเซิร์ฟเวอร์

// สร้างการเชื่อมต่อกับฐานข้อมูล
$conn = mysqli_connect($db_host, $db_user, $db_pass, $db_name);

// ตั้งค่าชุดอักขระให้รองรับภาษาไทย
mysqli_set_charset($conn, "utf8");

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
} else {
    
}
?>
