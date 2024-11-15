<?php
// การเชื่อมต่อกับฐานข้อมูล
$severname = 'localhost';  // ชื่อฐานข้อมูล
$username = 'root';   // ชื่อผู้ใช้ของฐานข้อมูล
$password = '';       // รหัสผ่าน (ว่างเปล่าในกรณีนี้)
$databasename = 'webgotwo'; // ที่อยู่ของเซิร์ฟเวอร์

// สร้างการเชื่อมต่อกับฐานข้อมูล
$conn = mysqli_connect($severname, $username, $password, $databasename);

// ตั้งค่าชุดอักขระให้รองรับภาษาไทย
mysqli_set_charset($conn, "utf8");

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
} 
?>