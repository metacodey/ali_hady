-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 16, 2025 at 11:00 PM
-- Server version: 8.4.5-5
-- PHP Version: 8.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fakhamaamir`
--
CREATE DATABASE IF NOT EXISTS `fakhamaamir` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `fakhamaamir`;

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `id` int NOT NULL,
  `customer_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'محادثة جديدة',
  `status` enum('open','closed','pending') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `closed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`id`, `customer_id`, `user_id`, `subject`, `status`, `created_at`, `updated_at`, `closed_at`) VALUES
(18, 12, 1, 'اريد مساعدة والدعم', 'closed', '2025-09-11 22:39:07', '2025-09-11 22:40:31', '2025-09-11 22:40:31'),
(19, 12, 1, 'مساعدة جديده', 'closed', '2025-09-11 22:40:57', '2025-09-11 22:42:03', '2025-09-11 22:42:03'),
(20, 12, 1, 'مساعدة جديده', 'closed', '2025-09-11 22:45:06', '2025-09-11 22:46:18', '2025-09-11 22:46:18'),
(21, 12, 1, 'اختبار جديد', 'closed', '2025-09-11 22:48:17', '2025-09-11 23:01:47', '2025-09-11 23:01:47'),
(22, 12, 1, 'اختبار جديد', 'closed', '2025-09-11 23:03:00', '2025-09-11 23:08:25', '2025-09-11 23:08:25'),
(23, 12, 1, 'اختبار جديد', 'closed', '2025-09-11 23:15:57', '2025-09-11 23:17:14', '2025-09-11 23:17:14'),
(24, 12, 1, 'موضوع جديد', 'closed', '2025-09-11 22:25:13', '2025-09-11 22:35:08', '2025-09-11 22:35:08'),
(25, 10, 1, 'ممكن مساعدة', 'open', '2025-09-11 22:29:11', '2025-09-11 22:40:41', NULL),
(26, 12, 1, 'هههههههه', 'closed', '2025-09-13 00:03:38', '2025-09-13 16:50:36', '2025-09-13 16:50:36'),
(27, 14, 1, 'مرحبا', 'closed', '2025-09-13 18:48:56', '2025-09-13 21:52:29', '2025-09-13 21:52:29'),
(28, 14, NULL, 'محتاج ثلاجه', 'closed', '2025-09-13 19:01:50', '2025-09-13 21:52:36', '2025-09-13 21:52:36'),
(29, 12, NULL, 'جديد ويظهر', 'closed', '2025-09-16 18:57:43', '2025-09-16 19:07:33', '2025-09-16 19:07:33'),
(30, 12, NULL, 'جديد جديد', 'closed', '2025-09-16 18:58:15', '2025-09-16 19:07:38', '2025-09-16 19:07:38'),
(31, 12, NULL, 'اختبار', 'closed', '2025-09-16 19:01:15', '2025-09-16 19:07:15', '2025-09-16 19:07:15'),
(32, 12, NULL, 'هههههههه', 'closed', '2025-09-16 19:01:37', '2025-09-16 19:07:12', '2025-09-16 19:07:12'),
(33, 12, NULL, 'لا لا لا', 'closed', '2025-09-16 19:02:03', '2025-09-16 19:07:23', '2025-09-16 19:07:23'),
(34, 12, NULL, 'موضوع', 'closed', '2025-09-16 19:02:49', '2025-09-16 19:07:09', '2025-09-16 19:07:09'),
(35, 12, NULL, 'موووواضيع', 'closed', '2025-09-16 19:03:32', '2025-09-16 19:07:05', '2025-09-16 19:07:05'),
(36, 12, NULL, 'هههههههههه', 'closed', '2025-09-16 19:03:51', '2025-09-16 19:06:45', '2025-09-16 19:06:45'),
(37, 12, NULL, 'احلف', 'closed', '2025-09-16 19:04:49', '2025-09-16 19:06:52', '2025-09-16 19:06:52'),
(38, 12, NULL, 'احلف يمين', 'closed', '2025-09-16 19:05:59', '2025-09-16 19:06:43', '2025-09-16 19:06:43'),
(39, 12, NULL, 'يمين والا شمال', 'closed', '2025-09-16 19:06:16', '2025-09-16 19:07:01', '2025-09-16 19:07:01'),
(40, 12, NULL, 'هههههههههههه', 'closed', '2025-09-16 19:06:31', '2025-09-16 19:06:58', '2025-09-16 19:06:58'),
(41, 12, NULL, 'جديد جديد', 'open', '2025-09-16 19:08:49', '2025-09-16 19:09:08', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `firebase_token` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'السعودية',
  `city` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `street_address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `profile_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `email_verified` tinyint(1) DEFAULT '0',
  `phone_verified` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `username`, `email`, `password_hash`, `full_name`, `phone`, `firebase_token`, `country`, `city`, `street_address`, `latitude`, `longitude`, `profile_image`, `is_active`, `email_verified`, `phone_verified`, `created_at`, `updated_at`, `last_login`) VALUES
(1, 'ahmed123', 'ahmed@example.com', '$2a$12$0llljaRBvu28F8Hk4.aT5utHHF0kK/PjWvjlCw0xxCCuVyh5qgNUK', 'أحمد محمد علي', '+966501234567', NULL, 'السعودية', 'الرياض', 'حي النخيل - شارع الملك فهد', 24.71360000, 46.67530000, NULL, 1, 0, 0, '2025-09-01 23:40:48', '2025-09-10 22:34:43', '2025-09-10 22:34:43'),
(2, 'sara_h', 'sara@example.com', '$2a$12$0llljaRBvu28F8Hk4.aT5utHHF0kK/PjWvjlCw0xxCCuVyh5qgNUK', 'سارة حسن', '+966502345678', NULL, 'السعودية', 'جدة', 'حي الصفا - شارع التحلية', 21.54280000, 39.17280000, NULL, 1, 0, 0, '2025-09-01 23:40:48', '2025-09-02 13:42:27', NULL),
(3, 'mohammed_s', 'mohammed@example.com', '$2a$12$0llljaRBvu28F8Hk4.aT5utHHF0kK/PjWvjlCw0xxCCuVyh5qgNUK', 'محمد سالم', '+966503456789', NULL, 'السعودية', 'الدمام', 'حي الفيصلية - طريق الملك عبدالعزيز', 26.42070000, 50.08880000, NULL, 1, 0, 0, '2025-09-01 23:40:48', '2025-09-02 13:42:32', NULL),
(10, 'ivif8uc', 'metacode34ye@gmail.com', '$2a$12$0llljaRBvu28F8Hk4.aT5utHHF0kK/PjWvjlCw0xxCCuVyh5qgNUK', 'metacode4y', '+964773701837', NULL, 'السعودية', 'الرياض', 'MMP2+VVX، ظافر بن قاسم، أم الحمام الشرقي، الرياض 12323، السعودية', 24.28729410, 46.63218610, NULL, 1, 0, 0, '2025-09-02 13:19:48', '2025-09-15 23:47:13', '2025-09-11 22:29:03'),
(12, 'user202509080308465w05', 'email@gmail.com', '$2a$12$0llljaRBvu28F8Hk4.aT5utHHF0kK/PjWvjlCw0xxCCuVyh5qgNUK', 'صالح', '+964773701837', 'exZwjwk7Traj5AupjBieY9:APA91bHYqrzZV60CSeD-GlL3_6a16zZ5yGguH7aVA6oGkC4xELzY7dZxcAtKiuAox5wLFHUp8EKy56dqtt6iwbdgnngR3gpBgoCvPxYclc_rqGulHFPln3s', 'السعودية', 'الرياض', 'أم الحمام 206، أم الحمام الشرقي، الرياض 12323، السعودية', 24.68688090, 46.65201340, NULL, 1, 0, 0, '2025-09-07 19:47:46', '2025-09-16 20:19:38', '2025-09-16 16:04:27'),
(13, 'user2025091304122592yg', 'test@gmail.com', '$2a$12$aUTg4Wgguk.rk6u2upmhyetzVC/srMdl1IsCxZ1KX015d.0eOkWce', 'صالح علي سعيد', '+964776701837', NULL, 'العراق', '', '', NULL, NULL, NULL, 1, 0, 0, '2025-09-13 01:13:03', '2025-09-13 01:13:03', NULL),
(14, 'user20250913214453eOTp', 'ali@gmail.com', '$2a$12$9yJCEmQMK7AFV1YSo3tGKuJjif0MkubAOel67QdJ8n9OvT7aPVKeK', 'علي هادي عباس', '+964782458388', NULL, 'العراق', 'كربلاء', 'JXRQ+JH4، كربلاء، كربلاء محافظة، 56001، العراق', 32.64205560, 43.98888880, NULL, 1, 0, 0, '2025-09-13 18:47:14', '2025-09-14 19:58:06', '2025-09-13 18:48:31');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int NOT NULL,
  `conversation_id` int NOT NULL,
  `sender_type` enum('customer','user') COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender_id` int NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `read_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `conversation_id`, `sender_type`, `sender_id`, `message`, `is_read`, `created_at`, `read_at`) VALUES
(79, 18, 'customer', 12, 'مرحبا', 1, '2025-09-11 22:39:22', '2025-09-11 22:39:24'),
(80, 18, 'user', 1, 'اهلا صالح', 1, '2025-09-11 22:39:28', '2025-09-11 22:40:36'),
(81, 18, 'customer', 12, 'هلا فيك', 1, '2025-09-11 22:39:34', '2025-09-11 22:40:25'),
(82, 18, 'user', 1, 'في ماذا يمكننا مساعدتك', 1, '2025-09-11 22:39:44', '2025-09-11 22:40:36'),
(83, 18, 'customer', 12, 'هذا كان اختبار وكان ودي اجرب', 1, '2025-09-11 22:39:54', '2025-09-11 22:40:25'),
(84, 18, 'customer', 12, 'شكرا لكم', 1, '2025-09-11 22:39:57', '2025-09-11 22:40:25'),
(85, 18, 'user', 1, 'حسا شكرا على تواصلك معنا', 1, '2025-09-11 22:40:07', '2025-09-11 22:40:36'),
(86, 18, 'user', 1, 'نحن في خدمتك', 1, '2025-09-11 22:40:20', '2025-09-11 22:40:36'),
(87, 19, 'user', 1, 'اهلا', 1, '2025-09-11 22:41:09', '2025-09-11 22:41:11'),
(88, 19, 'customer', 12, 'هلا', 1, '2025-09-11 22:41:14', '2025-09-11 22:41:47'),
(89, 19, 'user', 1, 'كيف يمكننا مساعدتك', 1, '2025-09-11 22:41:21', '2025-09-11 22:42:06'),
(90, 19, 'customer', 12, 'حسنا', 1, '2025-09-11 22:41:32', '2025-09-11 22:41:47'),
(91, 19, 'customer', 12, 'اسمع', 1, '2025-09-11 22:41:34', '2025-09-11 22:41:47'),
(92, 19, 'customer', 12, 'لدي شكوى رسميه', 1, '2025-09-11 22:41:40', '2025-09-11 22:41:47'),
(93, 19, 'user', 1, 'وماهي هذه الشكوى', 1, '2025-09-11 22:41:54', '2025-09-11 22:42:06'),
(94, 19, 'customer', 12, 'ههههههههههههه', 1, '2025-09-11 22:41:59', '2025-09-11 23:15:00'),
(95, 19, 'customer', 12, 'باي', 1, '2025-09-11 22:42:02', '2025-09-11 23:15:00'),
(96, 20, 'user', 1, 'مرحبا صالح', 1, '2025-09-11 22:45:16', '2025-09-11 22:45:18'),
(97, 20, 'customer', 12, 'هلا', 1, '2025-09-11 22:45:20', '2025-09-11 22:45:57'),
(98, 20, 'customer', 12, 'كيفك', 1, '2025-09-11 22:45:23', '2025-09-11 22:45:57'),
(99, 20, 'customer', 12, 'ويش مسوي', 1, '2025-09-11 22:45:26', '2025-09-11 22:45:57'),
(100, 20, 'user', 1, 'ممتاز', 1, '2025-09-11 22:45:30', '2025-09-11 22:46:01'),
(101, 20, 'user', 1, 'جيد جدا', 1, '2025-09-11 22:45:36', '2025-09-11 22:46:01'),
(102, 20, 'user', 1, 'بخير انت اخبارك', 1, '2025-09-11 22:45:42', '2025-09-11 22:46:01'),
(103, 20, 'customer', 12, 'ههههههههههههههههههههه', 1, '2025-09-11 22:45:50', '2025-09-11 22:45:57'),
(104, 20, 'customer', 12, 'تمام', 1, '2025-09-11 22:45:54', '2025-09-11 22:45:57'),
(105, 21, 'customer', 12, 'هلا', 1, '2025-09-11 22:48:29', '2025-09-11 22:48:35'),
(106, 21, 'customer', 12, 'كيفك', 1, '2025-09-11 22:48:32', '2025-09-11 22:48:35'),
(107, 21, 'user', 1, 'يا مرحبا', 1, '2025-09-11 22:48:41', '2025-09-11 22:49:17'),
(108, 21, 'user', 1, 'ارحب ملايين', 1, '2025-09-11 22:48:46', '2025-09-11 22:49:17'),
(109, 21, 'user', 1, 'وينك', 1, '2025-09-11 22:48:51', '2025-09-11 22:49:17'),
(110, 21, 'customer', 12, 'هههههه', 1, '2025-09-11 22:49:42', '2025-09-11 22:49:44'),
(111, 21, 'user', 1, 'ووووووو', 1, '2025-09-11 22:49:47', '2025-09-11 22:50:25'),
(112, 21, 'user', 1, 'وووووو', 1, '2025-09-11 22:53:27', '2025-09-11 22:53:57'),
(113, 21, 'user', 1, 'وووو', 1, '2025-09-11 22:54:14', '2025-09-11 22:54:51'),
(114, 21, 'user', 1, 'ووو', 1, '2025-09-11 22:54:17', '2025-09-11 22:54:51'),
(115, 21, 'user', 1, 'نعم', 1, '2025-09-11 22:54:55', '2025-09-11 23:02:48'),
(116, 21, 'customer', 12, 'هههههه', 1, '2025-09-11 22:55:37', '2025-09-11 23:01:46'),
(117, 21, 'user', 1, 'لا لا لا', 1, '2025-09-11 22:55:49', '2025-09-11 22:55:49'),
(118, 21, 'user', 1, 'ممتاز', 1, '2025-09-11 22:56:00', '2025-09-11 22:56:00'),
(119, 21, 'user', 1, 'ووووووو', 1, '2025-09-11 22:56:07', '2025-09-11 22:56:07'),
(120, 21, 'user', 1, 'يونس الشرماني', 1, '2025-09-11 22:56:23', '2025-09-11 22:56:24'),
(121, 22, 'user', 1, 'هلا', 1, '2025-09-11 23:03:12', '2025-09-11 23:03:14'),
(122, 22, 'customer', 12, 'كيفك', 1, '2025-09-11 23:03:21', '2025-09-11 23:04:29'),
(123, 22, 'customer', 12, 'وسنك', 1, '2025-09-11 23:03:53', '2025-09-11 23:04:29'),
(124, 22, 'user', 1, 'هلا', 1, '2025-09-11 23:03:58', '2025-09-11 23:03:58'),
(125, 22, 'user', 1, 'ممتاز', 1, '2025-09-11 23:04:19', '2025-09-11 23:04:19'),
(126, 22, 'customer', 12, 'ههههههههه', 1, '2025-09-11 23:04:35', '2025-09-11 23:08:23'),
(127, 23, 'user', 1, 'هلا', 1, '2025-09-11 23:16:08', '2025-09-11 23:16:15'),
(128, 23, 'customer', 12, 'هلا', 1, '2025-09-11 23:16:23', '2025-09-11 23:16:23'),
(129, 23, 'customer', 12, 'كيفك', 1, '2025-09-11 23:16:25', '2025-09-11 23:16:25'),
(130, 23, 'user', 1, 'بخير لك الخير انت اخبارك', 1, '2025-09-11 23:16:36', '2025-09-11 23:16:36'),
(131, 23, 'customer', 12, 'والله حلو', 1, '2025-09-11 23:17:00', '2025-09-11 23:17:00'),
(132, 23, 'user', 1, 'قلت افزع', 1, '2025-09-11 23:17:06', '2025-09-11 23:17:06'),
(133, 24, 'customer', 12, 'هلا', 1, '2025-09-11 22:25:25', '2025-09-11 22:25:28'),
(134, 24, 'user', 1, 'هلا', 1, '2025-09-11 22:25:30', '2025-09-11 22:25:30'),
(135, 24, 'user', 1, 'كيفك', 1, '2025-09-11 22:25:35', '2025-09-11 22:25:36'),
(136, 24, 'user', 1, 'اخبارك', 1, '2025-09-11 22:25:41', '2025-09-11 22:25:41'),
(137, 24, 'user', 1, 'وينك', 1, '2025-09-11 22:25:43', '2025-09-11 22:25:43'),
(138, 24, 'customer', 12, 'ههههههههه', 1, '2025-09-11 22:25:49', '2025-09-11 22:25:49'),
(139, 24, 'customer', 12, 'لا لا', 1, '2025-09-11 22:25:52', '2025-09-11 22:25:52'),
(140, 24, 'customer', 12, 'لا لا', 1, '2025-09-11 22:25:54', '2025-09-11 22:25:55'),
(141, 24, 'customer', 12, 'ممسنص', 1, '2025-09-11 22:26:19', '2025-09-11 22:34:57'),
(142, 24, 'customer', 12, 'نسنسن', 1, '2025-09-11 22:26:21', '2025-09-11 22:34:57'),
(143, 24, 'customer', 12, 'نينينيت', 1, '2025-09-11 22:26:23', '2025-09-11 22:34:57'),
(144, 25, 'customer', 10, 'هلا', 1, '2025-09-11 22:29:24', '2025-09-11 22:29:50'),
(145, 25, 'customer', 10, 'كيفك', 1, '2025-09-11 22:29:28', '2025-09-11 22:29:50'),
(146, 25, 'customer', 10, 'مممن مساعدة', 1, '2025-09-11 22:29:34', '2025-09-11 22:29:50'),
(147, 25, 'user', 1, 'هلا', 1, '2025-09-11 22:29:52', '2025-09-11 22:30:00'),
(148, 25, 'user', 1, 'نعم تفضل', 1, '2025-09-11 22:29:56', '2025-09-11 22:30:00'),
(149, 25, 'customer', 10, 'هههه', 1, '2025-09-11 22:30:02', '2025-09-11 22:30:02'),
(150, 25, 'customer', 10, 'ووو', 1, '2025-09-11 22:32:57', '2025-09-11 22:32:57'),
(151, 25, 'user', 1, 'هلا', 1, '2025-09-11 22:33:01', '2025-09-11 22:33:32'),
(152, 25, 'user', 1, 'كيكف', 1, '2025-09-11 22:33:17', '2025-09-11 22:33:32'),
(153, 25, 'user', 1, 'ززززز', 1, '2025-09-11 22:33:41', '2025-09-11 22:33:41'),
(154, 25, 'customer', 10, 'هلا حبيب', 1, '2025-09-11 22:33:46', '2025-09-11 22:33:46'),
(155, 25, 'customer', 10, 'كيفك', 1, '2025-09-11 22:33:49', '2025-09-11 22:33:49'),
(156, 25, 'customer', 10, 'اخبارك', 1, '2025-09-11 22:33:52', '2025-09-11 22:33:52'),
(157, 25, 'user', 1, 'ممتاز', 1, '2025-09-11 22:33:56', '2025-09-11 22:33:56'),
(158, 25, 'user', 1, 'العمل ممتاز', 1, '2025-09-11 22:34:01', '2025-09-11 22:34:01'),
(159, 24, 'user', 1, 'هلا هلا', 1, '2025-09-11 22:35:00', '2025-09-11 22:56:16'),
(160, 24, 'user', 1, 'كيف اقدر اساعدك', 1, '2025-09-11 22:35:05', '2025-09-11 22:56:16'),
(161, 25, 'user', 1, 'هههههههههههههههه', 1, '2025-09-11 22:40:26', '2025-09-11 22:40:26'),
(162, 25, 'customer', 10, 'حلو', 1, '2025-09-11 22:40:34', '2025-09-11 22:26:11'),
(163, 25, 'customer', 10, 'متى', 1, '2025-09-11 22:40:47', '2025-09-11 22:26:11'),
(164, 25, 'customer', 10, 'هلا', 1, '2025-09-11 22:26:00', '2025-09-11 22:26:11'),
(165, 25, 'user', 1, 'مرحبا', 1, '2025-09-11 22:26:14', '2025-09-11 22:26:14'),
(166, 25, 'user', 1, 'كيفك', 1, '2025-09-11 22:26:17', '2025-09-11 22:26:17'),
(167, 25, 'customer', 10, 'ههههههه', 1, '2025-09-11 22:26:22', '2025-09-11 22:26:22'),
(168, 25, 'customer', 10, 'هلا بك', 1, '2025-09-11 22:26:27', '2025-09-11 22:26:27'),
(169, 25, 'customer', 10, 'هلا', 1, '2025-09-11 22:27:23', '2025-09-11 22:27:23'),
(170, 25, 'customer', 10, 'هلا', 1, '2025-09-11 22:27:37', '2025-09-11 22:27:40'),
(171, 25, 'customer', 10, 'ههههه', 1, '2025-09-11 22:29:42', '2025-09-11 22:29:48'),
(172, 25, 'customer', 10, 'ز', 1, '2025-09-11 22:30:44', '2025-09-11 22:30:46'),
(173, 25, 'customer', 10, 'هههه', 1, '2025-09-11 22:31:10', '2025-09-11 22:31:13'),
(174, 25, 'user', 1, 'هلا', 1, '2025-09-11 22:34:35', '2025-09-11 22:35:15'),
(175, 25, 'user', 1, 'كميممس', 1, '2025-09-11 22:34:37', '2025-09-11 22:35:15'),
(176, 25, 'user', 1, 'مسمصم', 1, '2025-09-11 22:34:38', '2025-09-11 22:35:15'),
(177, 25, 'customer', 10, 'هلا', 1, '2025-09-11 22:35:34', '2025-09-11 22:35:58'),
(178, 25, 'user', 1, 'نعم', 1, '2025-09-11 22:36:00', '2025-09-11 22:36:01'),
(179, 25, 'user', 1, 'وووو', 1, '2025-09-11 22:36:06', '2025-09-11 22:36:06'),
(180, 25, 'user', 1, 'هههه', 1, '2025-09-11 22:36:16', '2025-09-11 22:36:47'),
(181, 25, 'customer', 10, 'جميل', 1, '2025-09-11 22:36:50', '2025-09-11 22:36:50'),
(182, 25, 'user', 1, 'ليش', 1, '2025-09-11 22:40:38', '2025-09-11 22:40:38'),
(183, 25, 'user', 1, 'قول والله', 1, '2025-09-11 22:40:41', '2025-09-11 22:40:41'),
(184, 26, 'user', 1, 'هلا', 1, '2025-09-13 00:49:11', '2025-09-13 00:49:27'),
(185, 26, 'customer', 12, 'مراحب', 1, '2025-09-13 00:49:29', '2025-09-13 00:49:36'),
(186, 26, 'user', 1, 'كيفك', 1, '2025-09-13 00:49:38', '2025-09-13 00:49:39'),
(187, 26, 'customer', 12, 'بخير انته كيفك', 1, '2025-09-13 00:49:44', '2025-09-13 00:49:45'),
(188, 26, 'user', 1, 'والله تمام', 1, '2025-09-13 00:49:50', '2025-09-13 00:49:50'),
(189, 26, 'user', 1, 'ههههههههه', 1, '2025-09-13 00:49:52', '2025-09-13 00:49:52'),
(190, 26, 'user', 1, 'ننرنبتثتثتتثتثت', 1, '2025-09-13 00:49:54', '2025-09-13 00:49:55'),
(191, 26, 'customer', 12, 'موووووووووووو', 1, '2025-09-13 00:49:59', '2025-09-13 00:49:59'),
(192, 26, 'customer', 12, 'موووووووووت', 1, '2025-09-13 00:50:02', '2025-09-13 00:50:03'),
(193, 26, 'customer', 12, 'ووولد', 1, '2025-09-13 16:23:18', '2025-09-13 16:23:31'),
(194, 26, 'user', 1, 'نعم', 1, '2025-09-13 16:23:33', '2025-09-13 16:23:34'),
(195, 26, 'customer', 12, 'كيفك', 1, '2025-09-13 16:23:38', '2025-09-13 16:23:39'),
(196, 26, 'user', 1, 'هههههههه', 1, '2025-09-13 16:23:43', '2025-09-13 16:23:44'),
(197, 26, 'user', 1, 'ممتاز والله', 1, '2025-09-13 16:23:47', '2025-09-13 16:23:48'),
(198, 26, 'customer', 12, 'رائع كمان حبيب', 1, '2025-09-13 16:23:56', '2025-09-13 16:23:56'),
(199, 26, 'customer', 12, 'هههههههه', 1, '2025-09-13 16:50:17', '2025-09-13 16:50:27'),
(200, 26, 'user', 1, 'عهععععع', 1, '2025-09-13 16:50:31', '2025-09-13 16:50:32'),
(201, 27, 'user', 1, 'كسختك', 1, '2025-09-13 18:49:25', '2025-09-13 18:49:26'),
(202, 30, 'user', 1, 'هلا', 1, '2025-09-16 19:00:47', '2025-09-16 19:00:52'),
(203, 30, 'customer', 12, 'هلا', 1, '2025-09-16 19:00:54', '2025-09-16 19:00:55'),
(204, 30, 'user', 1, 'كيفك', 1, '2025-09-16 19:00:59', '2025-09-16 19:00:59'),
(205, 30, 'customer', 12, 'تمام وانت', 1, '2025-09-16 19:01:05', '2025-09-16 19:01:06'),
(206, 41, 'customer', 12, 'هلا', 1, '2025-09-16 19:08:57', '2025-09-16 19:09:01'),
(207, 41, 'user', 1, 'هلا بك', 1, '2025-09-16 19:09:04', '2025-09-16 19:09:04'),
(208, 41, 'customer', 12, 'كيفك', 1, '2025-09-16 19:09:08', '2025-09-16 19:09:09');

--
-- Triggers `messages`
--
DELIMITER $$
CREATE TRIGGER `update_conversation_on_message` AFTER INSERT ON `messages` FOR EACH ROW BEGIN
    UPDATE conversations 
    SET updated_at = NOW()
    WHERE id = NEW.conversation_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int NOT NULL,
  `customer_id` int NOT NULL,
  `order_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_id` int NOT NULL DEFAULT '1',
  `total_amount` decimal(10,2) NOT NULL,
  `customer_notes` text COLLATE utf8mb4_unicode_ci,
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer_id`, `order_number`, `status_id`, `total_amount`, `customer_notes`, `admin_notes`, `created_at`, `updated_at`) VALUES
(2, 1, 'ORD-20350932-686', 2, 2500.00, NULL, NULL, '2025-09-04 21:12:30', '2025-09-04 20:35:33'),
(9, 1, 'ORD-76376502-287', 1, 12500.00, 'test test', NULL, '2025-09-07 20:19:36', '2025-09-07 20:19:36'),
(14, 1, 'ORD-76890692-049', 1, 6000.00, NULL, NULL, '2025-09-07 20:28:10', '2025-09-07 20:28:10'),
(15, 3, 'ORD-76932521-912', 2, 15750.00, NULL, NULL, '2025-09-07 20:28:52', '2025-09-07 19:36:30'),
(17, 12, 'ORD-74538607-532', 2, 35950.00, NULL, NULL, '2025-09-07 19:48:58', '2025-09-07 19:52:01'),
(20, 14, 'ORD-90221938-848', 5, 250000.00, 'ثلاجة بيضاء', NULL, '2025-09-13 19:03:41', '2025-09-13 19:04:39'),
(21, 14, 'ORD-90461199-941', 5, 5000.00, NULL, NULL, '2025-09-13 19:07:41', '2025-09-13 19:07:49');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int NOT NULL,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `product_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `product_name`, `quantity`, `unit_price`, `total_price`) VALUES
(2, 2, 1, 'هاتف ذكي سامسونج', 1, 2500.00, 2500.00),
(15, 9, 1, 'هاتف ذكي سامسونج', 5, 2500.00, 12500.00),
(24, 14, 1, 'هاتف ذكي سامسونج', 1, 2500.00, 2500.00),
(25, 14, 2, 'لابتوب ديل', 1, 3500.00, 3500.00),
(26, 15, 1, 'هاتف ذكي سامسونج', 6, 2500.00, 15000.00),
(27, 15, 3, 'قميص قطني', 5, 150.00, 750.00),
(30, 17, 1, 'هاتف ذكي سامسونج', 4, 2500.00, 10000.00),
(31, 17, 2, 'لابتوب ديل', 6, 3500.00, 21000.00),
(32, 17, 3, 'قميص قطني', 6, 150.00, 900.00),
(33, 17, 4, 'طقم أواني طبخ', 9, 450.00, 4050.00),
(40, 20, 14, 'ثلاجة', 1, 250000.00, 250000.00),
(41, 21, 1, 'هاتف ذكي سامسونج', 2, 2500.00, 5000.00);

--
-- Triggers `order_items`
--
DELIMITER $$
CREATE TRIGGER `update_order_total` AFTER INSERT ON `order_items` FOR EACH ROW BEGIN
    UPDATE orders 
    SET total_amount = (
        SELECT SUM(total_price) 
        FROM order_items 
        WHERE order_id = NEW.order_id
    )
    WHERE id = NEW.order_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_statuses`
--

CREATE TABLE `order_statuses` (
  `id` int NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT '#000000',
  `sort_order` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_statuses`
--

INSERT INTO `order_statuses` (`id`, `name`, `description`, `color`, `sort_order`) VALUES
(1, 'pending', 'قيد المراجعة', '#ffc107', 1),
(2, 'confirmed', 'مؤكد', '#17a2b8', 2),
(3, 'processing', 'قيد التحضير', '#fd7e14', 3),
(4, 'shipped', 'تم الشحن', '#6f42c1', 4),
(5, 'delivered', 'تم التسليم', '#28a745', 5),
(6, 'cancelled', 'ملغي', '#dc3545', 6);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int NOT NULL,
  `order_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'نقداً',
  `status` enum('pending','paid','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `payment_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `amount`, `payment_method`, `status`, `notes`, `payment_date`, `created_at`, `updated_at`) VALUES
(1, 15, 10000.00, 'نقداً', 'paid', NULL, '2025-09-07 19:39:19', '2025-09-07 19:39:48', '2025-09-07 19:45:25'),
(2, 15, 2000.00, 'نقداً', 'paid', NULL, '2025-09-07 19:39:19', '2025-09-07 19:39:48', '2025-09-07 19:45:25'),
(3, 15, 3750.00, 'بطاقة ائتمان', 'paid', NULL, NULL, '2025-09-07 19:36:07', '2025-09-07 19:38:24'),
(6, 17, 35950.00, 'نقداً', 'paid', NULL, NULL, '2025-09-07 19:51:53', '2025-09-07 19:51:53'),
(8, 9, 12500.00, 'نقداً', 'paid', NULL, NULL, '2025-09-13 01:13:56', '2025-09-13 01:13:56'),
(10, 14, 3000.00, 'نقداً', 'paid', NULL, NULL, '2025-09-13 01:40:21', '2025-09-13 01:40:21'),
(11, 14, 1000.00, 'نقداً', 'paid', NULL, NULL, '2025-09-13 01:43:12', '2025-09-13 01:43:12'),
(12, 14, 50.00, 'نقداً', 'paid', NULL, NULL, '2025-09-13 01:51:10', '2025-09-13 01:51:10'),
(13, 14, 50.00, 'نقداً', 'paid', 'كسي', NULL, '2025-09-13 18:54:20', '2025-09-13 18:54:20'),
(14, 20, 50000.00, 'نقداً', 'paid', 'تسديد شهر الاول', NULL, '2025-09-13 19:06:08', '2025-09-13 19:06:08'),
(15, 20, 200000.00, 'نقداً', 'paid', NULL, NULL, '2025-09-13 19:08:44', '2025-09-13 19:08:44'),
(16, 21, 5000.00, 'تحويل بنكي', 'paid', NULL, NULL, '2025-09-13 19:09:59', '2025-09-13 19:09:59');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sku` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int DEFAULT '0',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `description`, `sku`, `price`, `quantity`, `image`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'هاتف ذكي سامسونج', 'هاتف ذكي بمواصفات عالية', 'PHONE001', 2500.00, 2, NULL, 1, '2025-09-01 23:40:48', '2025-09-07 20:28:10'),
(2, 1, 'لابتوب ديل', 'لابتوب للأعمال والدراسة', 'LAP001', 3500.00, 4, NULL, 1, '2025-09-01 23:40:48', '2025-09-07 20:28:10'),
(3, 2, 'قميص قطني', 'قميص قطني عالي الجودة', 'SHIRT001', 150.00, 25, NULL, 1, '2025-09-01 23:40:48', '2025-09-01 23:40:48'),
(4, 3, 'طقم أواني طبخ', 'طقم أواني من الستانلس ستيل', 'COOK001', 450.00, 8, NULL, 1, '2025-09-01 23:40:48', '2025-09-01 23:40:48'),
(14, NULL, 'ثلاجة', 'ثلاجة بابين', 'PRD111', 250000.00, 1, NULL, 1, '2025-09-13 18:51:05', '2025-09-13 18:51:05');

-- --------------------------------------------------------

--
-- Table structure for table `product_categories`
--

CREATE TABLE `product_categories` (
  `id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_categories`
--

INSERT INTO `product_categories` (`id`, `name`, `description`, `image`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'إلكترونيات', 'أجهزة إلكترونية ومعدات تقنية', NULL, 1, 1, '2025-09-01 23:40:48', '2025-09-01 23:40:48'),
(2, 'ملابس', 'ملابس رجالية ونسائية', NULL, 1, 2, '2025-09-01 23:40:48', '2025-09-01 23:40:48'),
(3, 'منزل ومطبخ', 'أدوات منزلية ومطبخية', NULL, 1, 3, '2025-09-01 23:40:48', '2025-09-01 23:40:48');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `full_name`, `phone`, `is_active`, `created_at`, `updated_at`, `last_login`) VALUES
(1, 'admin', 'admin@company.com', '$2a$12$0llljaRBvu28F8Hk4.aT5utHHF0kK/PjWvjlCw0xxCCuVyh5qgNUK', 'مدير النظام', '+966501111111', 1, '2025-09-01 23:40:48', '2025-09-16 20:29:42', '2025-09-16 20:29:42'),
(2, 'support1', 'support1@company.com', '$2a$12$0llljaRBvu28F8Hk4.aT5utHHF0kK/PjWvjlCw0xxCCuVyh5qgNUK', 'موظف الدعم الأول', '+966502222222', 1, '2025-09-01 23:40:48', '2025-09-02 13:42:46', NULL),
(3, 'support2', 'support2@company.com', '$2a$12$0llljaRBvu28F8Hk4.aT5utHHF0kK/PjWvjlCw0xxCCuVyh5qgNUK', 'موظف الدعم الثاني', '+966503333333', 1, '2025-09-01 23:40:48', '2025-09-02 13:42:49', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customer_id` (`customer_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_location` (`latitude`,`longitude`),
  ADD KEY `idx_city` (`city`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_conversation_id` (`conversation_id`),
  ADD KEY `idx_sender` (`sender_type`,`sender_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_is_read` (`is_read`),
  ADD KEY `idx_messages_conversation_time` (`conversation_id`,`created_at`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `idx_customer_id` (`customer_id`),
  ADD KEY `idx_order_number` (`order_number`),
  ADD KEY `idx_status_id` (`status_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_orders_customer_status` (`customer_id`,`status_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_id` (`order_id`),
  ADD KEY `idx_product_id` (`product_id`);

--
-- Indexes for table `order_statuses`
--
ALTER TABLE `order_statuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_id` (`order_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_payment_date` (`payment_date`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `idx_category_id` (`category_id`),
  ADD KEY `idx_sku` (`sku`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_price` (`price`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_products_category_active` (`category_id`,`is_active`);
ALTER TABLE `products` ADD FULLTEXT KEY `name` (`name`,`description`);

--
-- Indexes for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_sort_order` (`sort_order`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `order_statuses`
--
ALTER TABLE `order_statuses`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `conversations_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`status_id`) REFERENCES `order_statuses` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
