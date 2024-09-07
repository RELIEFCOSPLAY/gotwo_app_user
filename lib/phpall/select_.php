<!-- <?php
header("Content-Type: application/json; charset=utf-8");
include("config.php");

$sql = "SELECT * FROM post";
$result = mysqli_query($conn, $sql);

$response = array();

if (mysqli_num_rows($result) > 0) {
    while($row = mysqli_fetch_assoc($result)) {
        $tb_pos = array();
        // $tb_pos["post_id"] = $row['post_id'];
        $tb_pos["pick_up"] = $row['pick_up'];
        $tb_pos["commpick"] = $row['comment_pick'];
        $tb_pos["at_drop"] = $row['at_drop'];
        $tb_pos["commdrop"] = $row['comment_drop'];
        $tb_pos["date"] = $row['date'];
        $tb_pos["time"] = $row['time'];
        $tb_pos["price"] = $row['price'];
        $tb_pos["status"] = $row['status_helmet'];
        // $tb_pos["customer_id"] = $row['customer_id'];
        // $tb_pos["rider_id"] = $row['rider_id'];

        array_push($response, $tb_pos);
    }
    echo json_encode($response);
} else {
    echo json_encode(array("message" => "No data found"));
}

mysqli_close($conn);
?> -->
<?php
// การเชื่อมต่อฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "gotwo";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM post";
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $response[] = $row;
    }
    echo json_encode($response);
} else {
    echo json_encode(array("message" => "No data found"));
}

$conn->close();
?>
