<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "dbtm";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Koneksi ke database gagal: " . $conn->connect_error);
}
$method = $_SERVER["REQUEST_METHOD"];
if ($method === "GET") {
    // Mengambil data tracker
    $sql = "SELECT * FROM tracker";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $tracker = array();
        while ($row = $result->fetch_assoc()) {
            $tracker[] = $row;
        }
        echo json_encode($tracker);
    }
    else {
        echo "Data tracker kosong.";
    }
}
if ($method === "POST") {
    // Menambahkan data tracker
    $data = json_decode(file_get_contents("php://input"), true);
    $keterangan = $data["keterangan"];
    $masuk = $data["masuk"];
    $keluar = $data["keluar"];
    $sql = "INSERT INTO tracker (keterangan, masuk) VALUES ('$keterangan', $masuk, $keluar)";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
        //echo "Berhasil tambah data";
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "PUT") {
    // Memperbarui data tracker
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];
    $keterangan = $data["keterangan"];
    $masuk = $data["masuk"];
    $keluar = $data["keluar"];
    $sql = "UPDATE tracker SET keterangan='$keterangan', masuk=$masuk, keluar=$keluar WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = "berhasil";
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "DELETE") {
    // Menghapus data tracker
    $id = $_GET["id"];
    $sql = "DELETE FROM tracker WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
?>