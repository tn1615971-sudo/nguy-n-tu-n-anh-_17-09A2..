<?php
// app/core/Database.php
// Ket noi CSDL bang PDO, chi tao MOT ket noi duy nhat dung chung (singleton)

class Database
{
    private static ?PDO $instance = null;

    /** Bo dem thu cong, phuc vu BAI TAP quan sat so truy van tren 1 trang (xem Buoi 5, muc 5).
     * KHONG phai co che tu dong - noi nao muon dem thi tu tang bien nay truoc khi execute(). */
    public static int $queryCount = 0;

    private function __construct() {}
    private function __clone() {}

    /**
     * Tra ve doi tuong PDO duy nhat cho toan ung dung.
     */
    public static function getInstance(): PDO
    {
        if (self::$instance === null) {
            $host = defined('DB_HOST') ? DB_HOST : 'localhost';
            $name = defined('DB_NAME') ? DB_NAME : 'shop_db';
            $user = defined('DB_USER') ? DB_USER : 'root';
            $pass = defined('DB_PASS') ? DB_PASS : '';
            $charset = defined('DB_CHARSET') ? DB_CHARSET : 'utf8mb4';

            $dsn = "mysql:host={$host};dbname={$name};charset={$charset}";
            $options = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ];

            try {
                self::$instance = new PDO($dsn, $user, $pass, $options);
            } catch (PDOException $e) {
                // Tu dong tao database va nap schema.sql neu chua ton tai
                try {
                    $initDsn = "mysql:host={$host};charset={$charset}";
                    $initPdo = new PDO($initDsn, $user, $pass, $options);
                    $initPdo->exec("CREATE DATABASE IF NOT EXISTS `{$name}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");

                    self::$instance = new PDO($dsn, $user, $pass, $options);

                    $schemaFile = __DIR__ . '/../../database/schema.sql';
                    if (file_exists($schemaFile)) {
                        $sql = file_get_contents($schemaFile);
                        self::$instance->exec($sql);
                    }
                } catch (PDOException $ex) {
                    error_log('Loi ket noi CSDL: ' . $ex->getMessage());
                    http_response_code(500);
                    die('Lỗi kết nối cơ sở dữ liệu: ' . $ex->getMessage());
                }
            }
        }

        return self::$instance;
    }
}
