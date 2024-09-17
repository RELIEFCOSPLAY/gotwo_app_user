<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");

$response = array();

// ตรวจสอบว่ามีการส่ง rider_id, status, และ post_id หรือไม่
if (isset($_POST['rider_id']) && isset($_POST['status']) && isset($_POST['post_id'])) {
    $rider_id = $_POST['rider_id'];
    $status = $_POST['status'];
    $post_id = $_POST['post_id'];

    // คำสั่ง SQL เพื่อบันทึกข้อมูลการ join
    $stmt = $conn->prepare("INSERT INTO status_post (rider_id, status, post_id) VALUES (?, ?, ?)");
    $stmt->bind_param("isi", $rider_id, $status, $post_id);

    if ($stmt->execute()) {
        $response['success'] = true;
        $response['message'] = "Join successful.";
    } else {
        $response['success'] = false;
        $response['message'] = "Error: " . $stmt->error;
    }

    $stmt->close();
} else {
    $response['success'] = false;
    $response['message'] = "Missing required parameters.";
}

echo json_encode($response);
$conn->close();
