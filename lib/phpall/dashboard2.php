<?php

$severname = "localhost";
$username = "root";
$password = "";
$dbname = "gotwo";

try {
    $conn = new PDO("mysql:host=$severname;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <script src="/public/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/public/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://cdn.lineicons.com/4.0/lineicons.css" rel="stylesheet" />
    <link rel="stylesheet" href="/public/css/css_gotwo/sidebar.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
    <link rel="stylesheet" href="/public/css/css_gotwo/dashboard.css">
</head>

<body>
    <div class="wrapper">
        <aside id="sidebar">
            <div class="d-flex">
                <button class="toggle-btn" type="button">
                    <i class="bi bi-grid-fill"></i>
                </button>
                <div class="sidebar-logo">
                    <a href="#" class="fw-bold" style="font-size: 40px;">GOTWO</a>
                </div>

            </div>
            <a href="#" class="sidebar-person">
                <div class="text-white ">
                    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor"
                        class="bi bi-person-circle" viewBox="0 0 16 16">
                        <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0" />
                        <path fill-rule="evenodd"
                            d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8m8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1" />
                    </svg>
                    <span class="mx-4 fw-bold"> Natthawut Sinnamkham</span>
                </div>
            </a>

            <p class="text-white mt-4 ms-2 fw-bold">MEUN</p>
            <hr class="text-white d-none d-sm-block" />

            <ul class="sidebar-nav">
                <li class="sidebar-item">
                    <a href="/public/gotwo_app/Dashboard.html" class="sidebar-link">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-item">
                    <a href="#" class="sidebar-link collapsed has-dropdown" data-bs-toggle="collapse"
                        data-bs-target="#Management" aria-expanded="false" aria-controls="Management">
                        <i class="bi bi-kanban"></i>
                        <span>Management</span>
                    </a>
                    <ul id="Management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                        <li class="sidebar-item">
                            <a href="/public/gotwo_app/Rider_Request.html" class="sidebar-link">Rider</a>
                        </li>
                        <li class="sidebar-item">
                            <a href="/public/gotwo_app/Customer_Suspend.html" class="sidebar-link">Customer</a>
                        </li>
                    </ul>
                </li>

                <li class="sidebar-item">
                    <a href="/public/gotwo_app/pending_tracking.html" class="sidebar-link">
                        <i class="bi bi-pin-map-fill"></i>
                        <span>Travel Tracking</span>
                    </a>
                </li>

                <li class="sidebar-item">
                    <a href="#" class="sidebar-link collapsed has-dropdown" data-bs-toggle="collapse"
                        data-bs-target="#Payment" aria-expanded="false" aria-controls="Payment">
                        <i class="bi bi-credit-card-fill"></i>
                        <span>Payment</span>
                    </a>
                    <ul id="Payment" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                        <li class="sidebar-item">
                            <a href="/public/gotwo_app/payment_ride.html" class="sidebar-link">Rider</a>
                        </li>
                        <li class="sidebar-item">
                            <a href="/public/gotwo_app/payment_cus.html" class="sidebar-link">Refund</a>
                        </li>
                    </ul>
                </li>
                <!-- <li class="sidebar-item">
                 <a href="#" class="sidebar-link collapsed has-dropdown" data-bs-toggle="collapse"
                     data-bs-target="#Report" aria-expanded="false" aria-controls="Report">
                     <i class="bi bi-flag-fill"></i>
                     <span>Report</span>
                 </a>
                 <ul id="Report" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                     <li class="sidebar-item">
                         <a href="#" class="sidebar-link">Rider</a>
                     </li>
                     <li class="sidebar-item">
                         <a href="#" class="sidebar-link">Customer</a>
                     </li>
                 </ul>
             </li> -->
                <li class="sidebar-item">
                    <a href="#" class="sidebar-link">
                        <i class="bi bi-person-circle"></i>
                        <span>Profile</span>
                    </a>
                </li>

            </ul>
            <div class="sidebar-footer">
                <a href="/public/gotwo_app/login_gotwo2.html" class="sidebar-link">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>
        <div class="main p-3">
            <div class="ms-4 mt-3 row">
                <!-- dashboard -->
                <div class="container col" id="buttonn">
                    <div class="btn-toolbar justify-content-between" role="toolbar"
                        aria-label="Toolbar with button groups">
                        <div class="btn-group" role="group" aria-label="First group">
                            <a href="/public/gotwo_app/Rider_Request.html"><button type="verifly"
                                    class="btn butt rounded btn-lg"><i class="bi bi-file-text"
                                        style="color: #0C7536;"></i>Verifly rider<br>
                                      <!-- ------------------------------------------------- -->
                                      <?php
                                    $sql = "SELECT COUNT(*) as status_rider FROM table_rider WHERE status_rider = 0";
                                    $query = $conn->prepare($sql);
                                    $query->execute();
                                    $fetch = $query->fetch();
                                    $status_rider = $fetch['status_rider'] ?? 0;
                                    ?>
                                    <!-- ------------------------------------------------- -->
                                    <p><?= $status_rider ?></p>
                                </button></a>
                            <a href="/public/gotwo_app/pending_tracking.html"><button type="pending"
                                    class="btn butt rounded btn-lg"><i class="bi bi-clock-history"
                                        style="color: #B65252;"></i>Pending<br>
                                      <!-- ------------------------------------------------- -->
                                      <?php
                                    $sql = "SELECT COUNT(*) as status FROM status_post WHERE status = 1";
                                    $query = $conn->prepare($sql);
                                    $query->execute();
                                    $fetch = $query->fetch();
                                    $status = $fetch['status'] ?? 1;
                                    ?>
                                    <!-- ------------------------------------------------- -->
                                    <p><?= $status ?></p>
                                </button></a>
                            <a href="/public/gotwo_app/req_tracking.html"><button type="request"
                                    class="btn butt rounded btn-lg"><i class="bi bi-list-ul"
                                        style="color: #F0A007;"></i>Request<br>
                                      <!-- ------------------------------------------------- -->
                                      <?php
                                    $sql = "SELECT COUNT(*) as status FROM status_post WHERE status = 0";
                                    $query = $conn->prepare($sql);
                                    $query->execute();
                                    $fetch = $query->fetch();
                                    $status = $fetch['status'] ?? 0;
                                    ?>
                                    <!-- ------------------------------------------------- -->
                                    <p><?= $status ?></p>
                                </button></a>
                        </div>

                    </div>
                    <div class="btn-toolbar justify-content-between" role="toolbar"
                        aria-label="Toolbar with button groups">
                        <div class="btn-group" role="group" aria-label="First group">
                            <a href="/public/gotwo_app/confirm_tracking.html"><button type="confirm"
                                    class="btn butt rounded btn-lg"><i class="bi bi-check-circle"
                                        style="color: #5C368C;"></i>Confirm<br>
                                      <!-- ------------------------------------------------- -->
                                      <?php
                                    $sql = "SELECT COUNT(*) as status FROM status_post WHERE status = 2";
                                    $query = $conn->prepare($sql);
                                    $query->execute();
                                    $fetch = $query->fetch();
                                    $status = $fetch['status'] ?? 2;
                                    ?>
                                    <!-- ------------------------------------------------- -->
                                    <p><?= $status ?></p>
                                </button></a>
                            <a href="/public/gotwo_app/totravel_tracking.html"><button type="travel"
                                    class="btn butt rounded btn-lg"><i class="bi bi-bicycle"
                                        style="color: #405189;"></i>To travel<br>
                                      <!-- ------------------------------------------------- -->
                                      <?php
                                    $sql = "SELECT COUNT(*) as status FROM status_post WHERE status = 3";
                                    $query = $conn->prepare($sql);
                                    $query->execute();
                                    $fetch = $query->fetch();
                                    $status = $fetch['status'] ?? 3;
                                    ?>
                                    <!-- ------------------------------------------------- -->
                                    <p><?= $status ?></p>
                                </button></a>
                            <a href="/public/gotwo_app/success_tracking.html"><button type="success"
                                    class="btn butt rounded btn-lg"><i class="bi bi-check-all"
                                        style="color: #009C3E;"></i>Success<br>
                                    <!-- ------------------------------------------------- -->
                                    <?php
                                    $sql = "SELECT COUNT(*) as status FROM status_post WHERE status = 4";
                                    $query = $conn->prepare($sql);
                                    $query->execute();
                                    $fetch = $query->fetch();
                                    $status = $fetch['status'] ?? 4;
                                    ?>
                                    <!-- ------------------------------------------------- -->
                                    <p><?= $status ?></p>
                                    
                                </button></a>

                        </div>
                    </div>

                    <div class="btn-toolbar justify-content-between" role="toolbar"
                        aria-label="Toolbar with button groups">
                        <div class="btn-group" role="group" aria-label="First group">

                            <a href="/public/gotwo_app/cancel_tracking.html"><button type="cancel"
                                    class="btn butt rounded btn-lg"><i class="bi bi-x-circle"
                                        style="color: #E51A1A;"></i>Cancel<br>
                                      <!-- ------------------------------------------------- -->
                                      <?php
                                    $sql = "SELECT COUNT(*) as status FROM status_post WHERE status = 5";
                                    $query = $conn->prepare($sql);
                                    $query->execute();
                                    $fetch = $query->fetch();
                                    $status = $fetch['status'] ?? 5;
                                    ?>
                                    <!-- ------------------------------------------------- -->
                                    <p><?= $status ?></p>
                                </button></a>
                            <a href="/public/gotwo_app/payment_ride.html"><button type="payment"
                                    class="btn butt rounded btn-lg"><i class="bi bi-credit-card"
                                        style="color: #D6A3DA;"></i>Payment unpaid<br>
                                    <p>6</p>
                                </button></a>
                            <a href="/public/gotwo_app/report.html"><button type="report"
                                    class="btn butt rounded btn-lg"><i class="bi bi-exclamation-octagon"
                                        style="color: #D6C211;"></i>Report<br>
                                    <p>7</p>
                                </button></a>

                        </div>
                    </div>
                </div>

                <div class="btn-group col" role="group" aria-label="First group">
                    <div class="col-d-flex">

                        <!-- money -->
                        <div class="badge text-wrap"
                            style="background-color: #B7E9B4;border: 2px solid #A1A1A1; padding: 20px;">
                            <h4 style="color: #6E6E6E; font-size: 50px; text-align: start;">Income money</h4>
                            <hr style="color: #6E6E6E;">
                            <h2 style="color: black; text-align: center; font-size: 50px;">10,602 THB</h2>
                        </div>

                        <!-- กราฟ -->
                        <canvas id="myChart"
                            style="width:100%;max-width:500px; background-color: #DBE2EF; padding:50px 100px; margin-top: 50px;"
                            class="chart-with-background"></canvas>

                        <script src="/public/js/gotwo_js/dashboard.js">
                        </script>

                    </div>
                </div>




            </div>
        </div>
    </div>

    <script src="/public/js/gotwo_js/nav_animation.js"></script>
</body>

</html>