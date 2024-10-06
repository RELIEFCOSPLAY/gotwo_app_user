<?php
header('Content-Type: application/json; charset=utf-8');
include("config.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];

    // ค้นหา user_id ตาม email
    $sql = "SELECT regis_customer_id FROM table_customer WHERE email = '$email'";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        echo json_encode([
            'success' => true,
            'user_id' => $row['regis_customer_id']
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'User not found.'
        ]);
    }

    mysqli_close($conn);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method.'
    ]);
}
?>
