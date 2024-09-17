<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php"); 
//-------------------------------------------------------
$action = $_POST['action'];

if ($action == "INSERT") {
    //insert
    $status = $_POST['status'];
    $reason = $_POST['reason'];
    $post_id = $_POST['post_id'];
    $customer_id = $_POST['customer_id'];
    $pay = $_POST['pay'];
    $review = $_POST['review'];
    $comment = $_POST['comment'];
    $sql = " INSERT INTO `post` (`status`, `reason`, `post_id`, `customer_id`, `pay`, `review`, `comment`) VALUES ('$status', '$reason', '$post_id', '$customer_id', '$pay', '$review', '$comment');";
    if ($conn->query($sql)) {
        echo "insert Sucsess";
    } else {
        echo "Error insert !";
    }
}

// $result = mysqli_query($conn, $sql);
// $response = array();
// echo json_encode($response); // ส่งข้อมูลเป็น JSON
// mysqli_close($conn);
?>
