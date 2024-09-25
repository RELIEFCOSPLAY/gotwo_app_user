<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");


$sql = "
    SELECT 
        post.pick_up, 
        post.comment_pick, 
        post.at_drop, 
        post.comment_drop, 
        post.date, 
        post.time, 
        post.price, 
        post.status_helmet, 
        table_rider.name AS rider_id, 
        table_rider.gender AS rider_gender
    FROM post
    INNER JOIN table_rider ON post.rider_id = table_rider.regis_rider_id"; // เชื่อมต่อ post กับ table_rider

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
        $tb_pos["status_helmet"] = $row['status_helmet'];
        $tb_pos["rider_id"] = $row['rider_id']; 
        $tb_pos["rider_gender"] = $row['rider_gender'];

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
    $tb_pos["status_helmet"] = '';
    $tb_pos["rider_id"] = '';
    $tb_pos["rider_gender"] = '';
    

    array_push($response, $tb_pos); // เพิ่ม $tb_pos ที่เป็นข้อมูลว่างเข้าใน $response
}


//insert
$status = $_POST['status'];
$reason = $_POST['reason'];
$post_id = intval($_POST['post_id']);
$customer_id = intval($_POST['customer_id']);
$pay = intval($_POST['pay']);
$review = intval($_POST['review']);
$comment = $_POST['comment'];
$rider_id = intval($_POST['rider_id']);

// SQL สำหรับการ insert ข้อมูลลงในตาราง status_post
$sql = "INSERT INTO `status_post` (`status`, `reason`, `post_id`, `customer_id`, `pay`, `review`, `comment`, `rider_id`) 
VALUES ('$status', '$reason', '$post_id', '$customer_id', '$pay', '$review', '$comment', '$rider_id');";

// ดำเนินการคำสั่ง insert
if ($conn->query($sql)) {
    echo "Insert Success";

    // SQL สำหรับการ update ข้อมูลในตาราง post
    $update_sql = "UPDATE `post` SET `customer_id` = '$customer_id' WHERE `post_id` = '$post_id';";

    // ดำเนินการคำสั่ง update
    if ($conn->query($update_sql)) {
        echo " and Update Success";
    } else {
        echo " but Error updating post!";
    }

} else {
    echo "Error insert!";
}

echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT) ; // ส่งข้อมูลเป็น JSON
mysqli_close($conn);
?>
