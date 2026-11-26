-- ====================================================================
-- CO SO DU LIEU: Website thuong mai dien tu co ban (PHP thuan - MVC - MySQL)
-- BUOI 1 - BUOI 5 CHUAN
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `shop_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `shop_db`;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `contacts`;
DROP TABLE IF EXISTS `product_images`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. BANG NGUOI DUNG (Buoi 2)
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `address` VARCHAR(255) DEFAULT NULL,
    `role` ENUM('admin', 'staff', 'customer') NOT NULL DEFAULT 'customer',
    `status` ENUM('active', 'locked') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. BANG DANH MUC (Buoi 3 & 4)
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `slug` VARCHAR(150) NOT NULL UNIQUE,
    `description` TEXT DEFAULT NULL,
    `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. BANG SAN PHAM (Buoi 3 & 4 & 5)
CREATE TABLE `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT DEFAULT NULL,
    `sku` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(200) NOT NULL,
    `slug` VARCHAR(200) DEFAULT NULL,
    `brand` VARCHAR(100) DEFAULT NULL,
    `price` DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    `stock` INT NOT NULL DEFAULT 0,
    `sold_count` INT NOT NULL DEFAULT 0,
    `description` TEXT DEFAULT NULL,
    `is_featured` TINYINT(1) NOT NULL DEFAULT 0,
    `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. BANG ANH SAN PHAM (Buoi 3 & 4)
CREATE TABLE `product_images` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT NOT NULL,
    `file_name` VARCHAR(255) NOT NULL,
    `original_name` VARCHAR(255) DEFAULT NULL,
    `alt_text` VARCHAR(255) DEFAULT NULL,
    `is_primary` TINYINT(1) NOT NULL DEFAULT 0,
    `sort_order` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===================== BUOI 4 =====================
-- 5. BANG LIEN HE (Buoi 4)
CREATE TABLE `contacts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(150) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `message` TEXT NOT NULL,
    `status` ENUM('new','resolved') NOT NULL DEFAULT 'new',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ===================== DU LIEU KHOI TAO MAU =====================

-- Tai khoan mau: admin123, staff123, customer123
INSERT INTO `users` (`id`, `full_name`, `email`, `password`, `role`, `status`) VALUES
(1, 'Quản trị viên', 'admin@shop.local', '$2y$10$3bcAYXYYxv7TuWI9KH3zOOSDGTT8Q7P/ptvLmboC/WyXdJRWkVYku', 'admin', 'active'),
(2, 'Nhân viên bán hàng', 'staff@shop.local', '$2y$10$Q2u2cILb1athiBr5Nz9njOJSvQwfjB333zsvP4omlakUD9rCTpBO2', 'staff', 'active'),
(3, 'Nguyễn Văn Khách', 'customer@shop.local', '$2y$10$3bcAYXYYxv7TuWI9KH3zOOSDGTT8Q7P/ptvLmboC/WyXdJRWkVYku', 'customer', 'active');

-- Danh muc mau
INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `status`) VALUES
(1, 'Điện thoại & Tablet', 'dien-thoai-tablet', 'Các thiết bị di động, smartphone và máy tính bảng mới nhất', 'active'),
(2, 'Laptop & Máy tính', 'laptop-may-tinh', 'Laptop văn phòng, máy tính để bàn và laptop gaming', 'active'),
(3, 'Phụ kiện công nghệ', 'phu-kien-cong-nghe', 'Tai nghe, chuột, bàn phím cơ và các phụ kiện số', 'active'),
(4, 'Đồng hồ thông minh', 'dong-ho-thong-minh', 'Smartwatch theo dõi sức khoẻ và thời trang', 'active');

-- San pham mau
INSERT INTO `products` (`id`, `category_id`, `sku`, `name`, `slug`, `brand`, `price`, `stock`, `sold_count`, `description`, `is_featured`, `status`, `created_at`) VALUES
(1, 1, 'IP15PM-256', 'iPhone 15 Pro Max 256GB', 'iphone-15-pro-max-256gb', 'Apple', 29990000.00, 15, 120, 'Thiết kế khung viền Titanium siêu bền nhẹ, nút Action đa năng và camera tiềm vọng zoom quang học 5x.', 1, 'active', NOW() - INTERVAL 10 DAY),
(2, 1, 'SS-S24U', 'Samsung Galaxy S24 Ultra', 'samsung-galaxy-s24-ultra', 'Samsung', 27990000.00, 20, 95, 'Quyền năng Galaxy AI đỉnh cao, chip Snapdragon 8 Gen 3 for Galaxy, bút S-Pen tiện dụng.', 1, 'active', NOW() - INTERVAL 9 DAY),
(3, 1, 'IP14-128', 'iPhone 14 128GB', 'iphone-14-128gb', 'Apple', 16990000.00, 0, 45, 'Sản phẩm mẫu hết hàng để kiểm tra hiển thị badge Hết hàng.', 0, 'active', NOW() - INTERVAL 8 DAY),
(4, 2, 'MAC-M3-16', 'MacBook Air 13 inch M3', 'macbook-air-13-inch-m3', 'Apple', 26990000.00, 12, 68, 'Hiệu năng mạnh mẽ từ chip Apple M3, thiết kế mỏng nhẹ, pin sử dụng liên tục lên tới 18 giờ.', 1, 'active', NOW() - INTERVAL 7 DAY),
(5, 2, 'ASUS-ROG-G16', 'Asus ROG Strix G16 Gaming', 'asus-rog-strix-g16-gaming', 'Asus', 34500000.00, 8, 30, 'Màn hình 16 inch 165Hz sắc nét, CPU Intel Core i7-13650HX, card đồ hoạ RTX 4060 8GB mạnh mẽ.', 1, 'active', NOW() - INTERVAL 6 DAY),
(6, 3, 'AP-PRO2', 'Tai nghe AirPods Pro 2 MagSafe', 'airpods-pro-2-magsafe', 'Apple', 5490000.00, 30, 150, 'Khử tiếng ồn chủ động ANC gấp 2 lần, chất âm chân thực sống động, cổng sạc Type-C hiện đại.', 1, 'active', NOW() - INTERVAL 5 DAY),
(7, 3, 'MX-MASTER3S', 'Chuột không dây Logitech MX Master 3S', 'logitech-mx-master-3s', 'Logitech', 2290000.00, 25, 80, 'Cuộn siêu nhanh MagSpeed, cảm biến 8000 DPI di chuyển trên mọi bề mặt kể cả mặt kính.', 0, 'active', NOW() - INTERVAL 4 DAY),
(8, 4, 'AW-S9-41', 'Apple Watch Series 9 41mm GPS', 'apple-watch-series-9-41mm-gps', 'Apple', 9890000.00, 14, 55, 'Cảm biến cử chỉ Double Tap kỳ diệu, màn hình sáng gấp đôi, theo dõi nhịp tim và giấc ngủ chính xác.', 1, 'active', NOW() - INTERVAL 3 DAY),
(9, 1, 'XIAOMI-14', 'Xiaomi 14 5G 12GB/256GB', 'xiaomi-14-5g', 'Xiaomi', 19990000.00, 10, 40, 'Hệ thống ống kính Leica quang học cao cấp, sạc siêu tốc 90W, thiết kế gọn gàng vừa vặn trong lòng bàn tay.', 1, 'active', NOW() - INTERVAL 2 DAY),
(10, 2, 'DELL-XPS-13', 'Dell XPS 13 9340 Core Ultra 7', 'dell-xps-13-9340', 'Dell', 41900000.00, 5, 25, 'Kiệt tác thiết kế siêu mỏng nhẹ, bàn rê chuột bằng kính tàng hình, màn hình vô cực OLED sống động.', 1, 'active', NOW() - INTERVAL 1 DAY);

-- Anh san pham mau (san pham 1 co 3 anh de test thu vien anh, san pham 2 co 2 anh, san pham 4 co 1 anh, san pham 10 khong co anh nao de test no-image)
INSERT INTO `product_images` (`product_id`, `file_name`, `original_name`, `alt_text`, `is_primary`, `sort_order`) VALUES
(1, 'demo_ip15_1.jpg', 'iphone-15-pro-max-titan.jpg', 'iPhone 15 Pro Max Titanium', 1, 0),
(1, 'demo_ip15_2.jpg', 'iphone-15-pro-max-back.jpg', 'iPhone 15 Pro Max Mặt lưng', 0, 1),
(1, 'demo_ip15_3.jpg', 'iphone-15-pro-max-camera.jpg', 'iPhone 15 Pro Max Camera zoom 5x', 0, 2),
(2, 'demo_s24_1.jpg', 'samsung-s24-ultra.jpg', 'Samsung Galaxy S24 Ultra Xám', 1, 0),
(2, 'demo_s24_2.jpg', 'samsung-s24-pen.jpg', 'Samsung Galaxy S24 Ultra với S-Pen', 0, 1),
(4, 'demo_mac_1.jpg', 'macbook-air-m3.jpg', 'MacBook Air M3 Midnight', 1, 0),
(5, 'demo_rog_1.jpg', 'asus-rog-g16.jpg', 'Asus ROG Strix G16', 1, 0),
(6, 'demo_airpods_1.jpg', 'airpods-pro-2.jpg', 'AirPods Pro 2', 1, 0),
(7, 'demo_mx_1.jpg', 'logitech-mx-master-3s.jpg', 'Logitech MX Master 3S', 1, 0),
(8, 'demo_aw_1.jpg', 'apple-watch-s9.jpg', 'Apple Watch Series 9', 1, 0),
(9, 'demo_xiaomi_1.jpg', 'xiaomi-14.jpg', 'Xiaomi 14 5G', 1, 0);

-- Lien he mau de kiem tra chuc nang quan tri
INSERT INTO `contacts` (`id`, `full_name`, `email`, `message`, `status`, `created_at`) VALUES
(1, 'Trần Minh Hoàng', 'hoang.tm@gmail.com', 'Tôi muốn hỏi thời gian bảo hành của sản phẩm iPhone 15 Pro Max là bao lâu?', 'new', NOW() - INTERVAL 1 HOUR),
(2, 'Lê Thị Thuỷ', 'thuy.le@outlook.com', 'Shop có hỗ trợ trả góp 0% qua thẻ tín dụng ngân hàng Techcombank không ạ?', 'resolved', NOW() - INTERVAL 1 DAY);

-- ===================== BUOI 5 =====================
-- Them chi muc cho cac cot thuong dung trong WHERE / ORDER BY de tang toc do truy van.
-- category_id da duoc danh chi muc tu dong vi la khoa ngoai, khong can them.
ALTER TABLE products ADD INDEX idx_products_name (name);
ALTER TABLE products ADD INDEX idx_products_brand (brand);
ALTER TABLE products ADD INDEX idx_products_price (price);
ALTER TABLE products ADD INDEX idx_products_sold_count (sold_count);
