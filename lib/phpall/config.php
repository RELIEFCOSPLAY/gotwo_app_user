<?php
// การเชื่อมต่อกับฐานข้อมูล
$servername = "localhost";  // ที่อยู่ของเซิร์ฟเวอร์
$username = "root";         // ชื่อผู้ใช้ของฐานข้อมูล
$password = "";             // รหัสผ่าน (ในกรณีนี้ว่างเปล่า)
$dbname = "gotwo";          // ชื่อฐานข้อมูลของคุณ

// สร้างการเชื่อมต่อกับฐานข้อมูล
$conn = new mysqli($servername, $username, $password, $dbname);

// ตั้งค่าชุดอักขระให้รองรับภาษาไทย
mysqli_set_charset($conn, "utf8");

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("การเชื่อมต่อฐานข้อมูลล้มเหลว: " . $conn->connect_error);
}

// Query ข้อมูลจากตาราง post
$sql = "SELECT * FROM post";
$result = $conn->query($sql);

$response = array(); // สร้าง array เพื่อเก็บข้อมูลที่ดึงมา

// ตรวจสอบว่ามีข้อมูลในฐานข้อมูลหรือไม่
if ($result->num_rows > 0) {
    // วนลูปแสดงข้อมูลแต่ละแถว
    while($row = $result->fetch_assoc()) {
        $tb_pos = array();
        $tb_pos["post_id"] = $row['post_id'];
        $tb_pos["pick_up"] = $row['pick_up'];
        $tb_pos["comment_pick"] = $row['comment_pick'];
        $tb_pos["at_drop"] = $row['at_drop'];
        $tb_pos["comment_drop"] = $row['comment_drop'];
        $tb_pos["date"] = $row['date'];
        $tb_pos["time"] = $row['time'];
        $tb_pos["price"] = $row['price'];
        
        array_push($response, $tb_pos); // ใส่ข้อมูลใน array response
    }
    echo json_encode($response); // แปลงข้อมูลเป็น JSON เพื่อส่งออก
} else {
    echo json_encode(array("message" => "No data found"));
}

// ปิดการเชื่อมต่อ
$conn->close();
?>
