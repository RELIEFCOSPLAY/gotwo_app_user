<?php
$conn = new mysqli('localhost', 'root', '', 'gotwo');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "Connected successfully<br>";
}

$action = $_POST['action'];

// Insert
if ($action == "INSERT") {
    // รับค่าจาก POST
    $status = $_POST['status'];
    $reason = $_POST['reason'];
    $post_id = $_POST['post_id'];
    $customer_id = $_POST['customer_id'];
    $pay = $_POST['pay'];
    $review = $_POST['review'];
    $comment = $_POST['comment'];

    // คำสั่ง SQL สำหรับการแทรกข้อมูล
    $sql = "INSERT INTO status_post (status_post_id, status, reason, post_id, customer_id, pay, review, comment) 
            VALUES (NULL, ?, ?, ?, ?, ?, ?, ?)";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssiiiss", $status, $reason, $post_id, $customer_id, $pay, $review, $comment);

    if ($stmt->execute()) {
        echo "Insert status: 1";
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
}

// Update
if ($action == "UPDATE") {
    // รับค่าจาก POST สำหรับการอัปเดต
    $status_post_id = $_POST['status_post_id'];
    $status = $_POST['status'];
    $reason = $_POST['reason'];
    $post_id = $_POST['post_id'];
    $customer_id = $_POST['customer_id'];
    $pay = $_POST['pay'];
    $review = $_POST['review'];
    $comment = $_POST['comment'];

    // คำสั่ง SQL สำหรับการอัปเดตข้อมูล
    $sql = "UPDATE status_post SET status=?, reason=?, post_id=?, customer_id=?, pay=?, review=?, comment=? 
            WHERE status_post_id=?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssiiissi", $status, $reason, $post_id, $customer_id, $pay, $review, $comment, $status_post_id);

    if ($stmt->execute()) {
        echo "Update status: 1";
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
}

// ปิดการเชื่อมต่อ
$conn->close();
?>
