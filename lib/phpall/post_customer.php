<!-- <?php
header('Content-Type: application/json; charset=utf-8');
include("config.php"); 

if (!isset($_POST['status'], $_POST['reason'], $_POST['post_id'], $_POST['customer_id'], $_POST['pay'], $_POST['review'], $_POST['comment'])) {
    echo json_encode(["error" => "Missing required parameters"]);
    exit;
}

// รับค่าจาก POST
$status = $_POST['status'];
$reason = $_POST['reason'];
$post_id = $_POST['post_id'];
$customer_id = $_POST['customer_id'];
$pay = $_POST['pay'];
$review = $_POST['review'];
$comment = $_POST['comment'];


// ตรวจสอบ post_id
$checkPostId = "SELECT * FROM post WHERE post_id = '$post_id'";
$result = $conn->query($checkPostId);

if ($result->num_rows == 0) {
    echo json_encode(["error" => "post_id does not exist"]);
    exit;
}


$sql = "INSERT INTO `status_post` (`status`, `reason`, `post_id`, `customer_id`, `pay`, `review`, `comment`) 
        VALUES ('$status', '$reason', '$post_id', '$customer_id', '$pay', '$review', '$comment')";
        
if ($conn->query($sql)) {
    echo json_encode(["message" => "Insert Success"]);
} else {
    echo json_encode(["error" => "Error inserting data!"]);
}

// ปิดการเชื่อมต่อ
$conn->close();
?> -->

<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php"); 

if (!isset($_POST['status'], $_POST['reason'], $_POST['post_id'], $_POST['customer_id'], $_POST['pay'], $_POST['review'], $_POST['comment'])) {
    echo json_encode(["error" => "Missing required parameters"]);
    exit;
}

// รับค่าจาก POST
$status = $_POST['status'];
$reason = $_POST['reason'];
$post_id = $_POST['post_id'];
$customer_id = $_POST['customer_id'];
$pay = $_POST['pay'];
$review = $_POST['review'];
$comment = $_POST['comment'];

// ตรวจสอบ post_id
$checkPostId = $conn->prepare("SELECT * FROM post WHERE post_id = ?");
$checkPostId->bind_param("i", $post_id);
$checkPostId->execute();
$result = $checkPostId->get_result();

if ($result->num_rows == 0) {
    echo json_encode(["error" => "post_id does not exist"]);
    exit;
}

// ใช้ Prepared Statement เพื่อบันทึกข้อมูล
$sql = "INSERT INTO status_post (status, reason, post_id, customer_id, pay, review, comment) 
        VALUES (?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssiiiss", $status, $reason, $post_id, $customer_id, $pay, $review, $comment);

if ($stmt->execute()) {
    echo json_encode(["message" => "Insert Success"]);
} else {
    echo json_encode(["error" => "Error inserting data!"]);
}

// ปิดการเชื่อมต่อ
$stmt->close();
$conn->close();
?>
