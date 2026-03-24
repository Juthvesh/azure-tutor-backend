-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 24, 2026 at 09:23 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flask_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `start_time` time NOT NULL,
  `duration_minutes` int(11) NOT NULL,
  `meeting_url` text NOT NULL,
  `class_type` enum('1-ON-1','GROUP') NOT NULL,
  `frequency` enum('ONE_TIME','WEEKLY','BI_WEEKLY','MONTHLY') NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `payout_verified` tinyint(1) DEFAULT 0,
  `tutor_email` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `curriculum` text DEFAULT NULL,
  `professor_message` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `grade_level` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `title`, `subject`, `start_date`, `start_time`, `duration_minutes`, `meeting_url`, `class_type`, `frequency`, `price`, `payout_verified`, `tutor_email`, `created_at`, `curriculum`, `professor_message`, `user_id`, `grade_level`) VALUES
(3, 'Full Stack Development Updated', 'Computer Science', '2026-03-10', '11:00:00', 90, 'https://zoom.us/abc123', 'GROUP', 'WEEKLY', 799.00, 0, 'tutor@test.com', '2026-03-05 04:53:21', 'HTML, CSS, JavaScript, Flask', 'Updated course message', 1, NULL),
(4, 'Full Stack Development ', 'Computer Science engineering', '2026-03-10', '11:00:00', 60, 'https://zoom.us/abc123', 'GROUP', 'WEEKLY', 799.00, 0, 'tutor@test.com', '2026-03-05 07:58:07', 'HTML, CSS, JavaScript, Flask', 'Updated course message', 1, NULL),
(5, 'Full Stack ', 'Computer Science', '2026-03-10', '10:00:00', 60, 'https://zoom.us/abc123', 'GROUP', 'WEEKLY', 500.00, 0, 'tutor@test.com', '2026-03-05 08:26:47', 'HTML, CSS, JavaScript, Flask', 'Welcome to the course!', 1, NULL),
(6, 'kim', 'BIOLOGY', '2026-03-20', '11:00:00', 36, '', '1-ON-1', 'WEEKLY', 90.00, 0, 'tutor2@gmail.com', '2026-03-09 08:57:43', 'bi', 'bi', 8, NULL),
(8, 'bio basics ', 'BIOLOGY', '2026-03-27', '10:00:00', 60, '', '1-ON-1', 'WEEKLY', 350.00, 0, 'tutor2@gmail.com', '2026-03-10 11:52:43', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(9, 'chem', 'CHEMISTRY', '2026-03-27', '10:00:00', 60, '', '1-ON-1', 'ONE_TIME', 1000.00, 0, 'tutor2@gmail.com', '2026-03-10 12:10:42', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(10, 'em2', 'MATHEMATICS', '2026-03-27', '10:00:00', 20, '', '1-ON-1', 'ONE_TIME', 1000.00, 0, 'tutor2@gmail.com', '2026-03-11 04:53:57', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(11, 'probability ', 'PHYSICS', '2026-03-28', '10:00:00', 20, '', '1-ON-1', 'ONE_TIME', 1000.00, 0, 'tutor2@gmail.com', '2026-03-11 07:42:56', 'book', 'boook', 8, NULL),
(12, 'games', 'GAMES', '2026-03-27', '10:00:00', 60, '', '1-ON-1', 'ONE_TIME', 1000.00, 0, 'tutor2@gmail.com', '2026-03-11 07:51:26', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(13, 'kids', 'PHYSICS', '2026-03-26', '10:00:00', 30, '', '1-ON-1', 'ONE_TIME', 1500.00, 0, 'tutor2@gmail.com', '2026-03-11 08:21:27', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(14, 'algebra', 'MATHEMATICS', '2026-03-26', '10:00:00', 60, '', '1-ON-1', 'ONE_TIME', 1200.00, 0, 'tutor2@gmail.com', '2026-03-11 10:09:05', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(15, 'integration', 'MATHEMATICS', '2026-03-26', '10:00:00', 300, '', '1-ON-1', 'ONE_TIME', 2000.00, 0, 'tutor2@gmail.com', '2026-03-11 10:17:51', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(17, 'linear algebra ', 'PHYSICS', '2026-03-26', '10:00:00', 60, '', '1-ON-1', 'ONE_TIME', 4000.00, 0, 'tutor2@gmail.com', '2026-03-11 10:51:19', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(18, 'circles', 'MATHEMATICS', '2026-03-26', '10:00:00', 60, '', '1-ON-1', 'ONE_TIME', 6000.00, 0, 'tutor2@gmail.com', '2026-03-11 11:11:10', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(19, 'blood', 'BIOLOGY', '2026-03-26', '10:00:00', 60, '', '1-ON-1', 'WEEKLY', 8000.00, 0, 'tutor2@gmail.com', '2026-03-11 11:12:47', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 8, NULL),
(20, 'python basic', 'PROGRAMMING ', '2026-03-27', '10:00:00', 60, '', 'GROUP', 'ONE_TIME', 1200.00, 0, 'tutor@gmail.com', '2026-03-12 04:02:42', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 2, NULL),
(21, 'python basics', 'PROGRAMING', '2026-03-27', '10:00:00', 60, '', '1-ON-1', 'ONE_TIME', 1200.00, 0, 'tutor@gmail.com', '2026-03-12 04:32:50', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 2, NULL),
(22, 'light', 'PHYSICS', '2026-03-28', '11:00:00', 60, '', '1-ON-1', 'WEEKLY', 600.00, 0, 'tutor@gmail.com', '2026-03-12 05:07:21', 'Master core concepts and advanced techniques in this comprehensive session.', 'Welcome to the session!', 2, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `payment_status` enum('PENDING','PAID','REFUNDED') DEFAULT 'PENDING',
  `completion_status` enum('NOT_COMPLETED','COMPLETED') DEFAULT 'NOT_COMPLETED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `tutor_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`id`, `student_id`, `course_id`, `payment_status`, `completion_status`, `created_at`, `tutor_id`) VALUES
(1, 7, 5, 'PAID', 'NOT_COMPLETED', '2026-03-10 03:26:18', 1),
(4, 7, 3, 'PAID', 'NOT_COMPLETED', '2026-03-09 09:18:35', 1),
(5, 7, 3, 'PAID', 'NOT_COMPLETED', '2026-03-10 12:12:19', 1),
(6, 7, 4, 'PAID', 'NOT_COMPLETED', '2026-03-11 04:54:21', 1),
(7, 7, 5, 'PENDING', 'NOT_COMPLETED', '2026-03-11 07:43:18', NULL),
(8, 7, 6, 'PAID', 'NOT_COMPLETED', '2026-03-11 07:51:51', 8),
(10, 7, 13, 'PAID', 'NOT_COMPLETED', '2026-03-11 09:22:18', 8),
(11, 7, 8, 'PAID', 'NOT_COMPLETED', '2026-03-11 10:09:23', 8),
(12, 7, 9, 'PAID', 'NOT_COMPLETED', '2026-03-11 10:18:21', 8),
(13, 7, 15, 'PAID', 'NOT_COMPLETED', '2026-03-11 10:29:15', 8),
(14, 7, 10, 'PAID', 'NOT_COMPLETED', '2026-03-11 10:31:34', 8),
(16, 7, 11, 'PAID', 'NOT_COMPLETED', '2026-03-11 10:52:04', 8),
(17, 7, 18, 'PAID', 'NOT_COMPLETED', '2026-03-11 11:11:43', 8),
(18, 7, 19, 'PAID', 'NOT_COMPLETED', '2026-03-11 11:13:18', 8),
(19, 4, 20, 'PAID', 'NOT_COMPLETED', '2026-03-12 04:03:12', 2),
(20, 4, 21, 'PAID', 'NOT_COMPLETED', '2026-03-12 04:33:46', 2),
(21, 4, 22, 'PAID', 'NOT_COMPLETED', '2026-03-12 05:07:48', 2),
(22, 4, 6, 'PAID', 'NOT_COMPLETED', '2026-03-14 11:12:48', 8),
(23, 4, 8, 'PAID', 'NOT_COMPLETED', '2026-03-14 11:17:06', 8),
(24, 4, 9, 'PAID', 'NOT_COMPLETED', '2026-03-16 07:37:51', 8);

-- --------------------------------------------------------

--
-- Table structure for table `otp_verifications`
--

CREATE TABLE `otp_verifications` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `otp` varchar(10) NOT NULL,
  `expires` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `otp_verifications`
--

INSERT INTO `otp_verifications` (`id`, `email`, `otp`, `expires`) VALUES
(2, 'chadalavadajuthvesh@gmail.com', '3174', '2026-03-13 09:22:01');

-- --------------------------------------------------------

--
-- Table structure for table `tutor_bank_details`
--

CREATE TABLE `tutor_bank_details` (
  `id` int(11) NOT NULL,
  `tutor_id` int(11) NOT NULL,
  `account_holder_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `pan_number` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_bank_details`
--

INSERT INTO `tutor_bank_details` (`id`, `tutor_id`, `account_holder_name`, `account_number`, `ifsc_code`, `created_at`, `pan_number`) VALUES
(1, 2, 'Tutor rahkl', '99999999999', 'hdfc0001234', '2026-03-07 07:02:32', 'ABCDE1234F');

-- --------------------------------------------------------

--
-- Table structure for table `tutor_earnings`
--

CREATE TABLE `tutor_earnings` (
  `id` int(11) NOT NULL,
  `tutor_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `platform_fee` decimal(10,2) DEFAULT NULL,
  `tutor_earning` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_earnings`
--

INSERT INTO `tutor_earnings` (`id`, `tutor_id`, `course_id`, `student_id`, `amount`, `platform_fee`, `tutor_earning`, `created_at`) VALUES
(2, 1, 4, 1, 799.00, 0.00, 799.00, '2026-03-07 08:19:56'),
(3, 1, 5, 7, 500.00, 0.00, 500.00, '2026-03-10 03:57:08'),
(4, 1, 5, 7, 500.00, 0.00, 500.00, '2026-03-10 06:34:40'),
(5, 1, 5, 7, 500.00, 0.00, 500.00, '2026-03-10 06:36:20'),
(6, 1, 5, 7, 500.00, 0.00, 500.00, '2026-03-10 06:43:14'),
(7, 1, 5, 7, 500.00, 0.00, 500.00, '2026-03-10 06:43:16'),
(8, 1, 3, 7, 799.00, 0.00, 799.00, '2026-03-10 07:05:43'),
(9, 1, 3, 7, 799.00, 0.00, 799.00, '2026-03-10 12:12:33'),
(10, 1, 4, 7, 799.00, 0.00, 799.00, '2026-03-11 04:54:33'),
(11, 8, 6, 7, 90.00, 0.00, 90.00, '2026-03-11 07:52:06'),
(12, 8, 13, 7, 1500.00, 0.00, 1500.00, '2026-03-11 09:22:27'),
(13, 8, 8, 7, 350.00, 0.00, 350.00, '2026-03-11 10:09:34'),
(14, 8, 9, 7, 1000.00, 0.00, 1000.00, '2026-03-11 10:18:33'),
(15, 8, 15, 7, 2000.00, 0.00, 2000.00, '2026-03-11 10:29:30'),
(16, 8, 10, 7, 1000.00, 0.00, 1000.00, '2026-03-11 10:31:43'),
(17, 8, 11, 7, 1000.00, 0.00, 1000.00, '2026-03-11 10:52:19'),
(18, 8, 18, 7, 6000.00, 0.00, 6000.00, '2026-03-11 11:11:53'),
(19, 8, 19, 7, 8000.00, 0.00, 8000.00, '2026-03-11 11:13:28'),
(20, 2, 20, 4, 1200.00, 0.00, 1200.00, '2026-03-12 04:03:33'),
(22, 2, 21, 4, 1200.00, 0.00, 1200.00, '2026-03-12 04:33:56'),
(23, 2, 22, 4, 600.00, 0.00, 600.00, '2026-03-12 05:07:59'),
(24, 8, 6, 4, 90.00, 0.00, 90.00, '2026-03-14 11:12:49'),
(25, 8, 8, 4, 350.00, 0.00, 350.00, '2026-03-14 11:17:06'),
(26, 8, 9, 4, 1000.00, 0.00, 1000.00, '2026-03-16 07:37:51');

-- --------------------------------------------------------

--
-- Table structure for table `tutor_subjects`
--

CREATE TABLE `tutor_subjects` (
  `id` int(11) NOT NULL,
  `tutor_id` int(11) DEFAULT NULL,
  `subject` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_subjects`
--

INSERT INTO `tutor_subjects` (`id`, `tutor_id`, `subject`) VALUES
(1, 8, 'PHYSICS'),
(2, 8, 'BIOLOGY'),
(3, 8, 'CHEMISTRY'),
(4, 8, 'MATHEMATICS'),
(5, 8, 'PHYSICS'),
(6, 8, 'GAMES'),
(7, 8, 'PHYSICS'),
(8, 8, 'MATHEMATICS'),
(9, 8, 'MATHEMATICS'),
(10, 8, 'PHYSICS'),
(11, 8, 'PHYSICS'),
(12, 8, 'MATHEMATICS'),
(13, 8, 'BIOLOGY'),
(14, 2, 'PROGRAMMING '),
(15, 2, 'PROGRAMING'),
(16, 2, 'PHYSICS');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `grade_level` varchar(50) DEFAULT NULL,
  `phone_verified` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `role`, `name`, `phone`, `grade_level`, `phone_verified`) VALUES
(2, 'tutor@gmail.com', 'scrypt:32768:8:1$U9nxG6UQTPqGNKnN$2412888672daf7c52e2b19c860811d6f29db688c7e7ed85e531c4b54bfbc89c0329619b689b89f0bdb48ee04d28f676a25c8362a1bb4683dc9385ad3b84cbde8', 'tutor', 'Tutor Rahul', '7656789076', NULL, 1),
(4, 'new@gmail.com', 'scrypt:32768:8:1$Hc7BeE1I1JaoNu25$d19ab4ec04084b5cce8b6a4ae757c2884c0ccddfe4f8228e794481e27fa163d0b8569683d1c44928a415749f68a3e18d3267edfa77576a95487a77855942f4c2', 'student', 'Priya', '9823765098', 'graduate', 1),
(7, 'student2@gmail.com', 'scrypt:32768:8:1$LsTC7wThHBje8bSZ$f2ebf254bfc4d4978a058840752fa5e77b50057dfcf1b50d2309a1971c73e28f1f4b24741f47934acd60ec392f9f0f835ea7d2357ea2430bf2a78525f9080f1d', 'student', 'ravi', '9758930476', 'grade 11-12', 1),
(8, 'tutor2@gmail.com', 'scrypt:32768:8:1$U9nxG6UQTPqGNKnN$2412888672daf7c52e2b19c860811d6f29db688c7e7ed85e531c4b54bfbc89c0329619b689b89f0bdb48ee04d28f676a25c8362a1bb4683dc9385ad3b84cbde8', 'tutor', NULL, NULL, NULL, 0),
(9, 'chjithu23@gmail.com', 'scrypt:32768:8:1$91DU4I5SQe2RMblL$df485e8eae368627fd3ab918c9b5b51234e051499ad96a7c0db6639ea064c4bd6004f8e0b686a5692432a4c10f97074ea07b897e396919a5ecd5a79dcf15a462', 'Tutor', NULL, '7075747045', NULL, 0),
(10, 'gurukandukuri1817@gmail.com', 'scrypt:32768:8:1$hh3spE4Gtag0oUfu$48a490a33289885d7d2ffc9b5af32b42bbf9c2faa203ba3b7aba9c7fa86a840d4a96ba17d4606c95f2189e8692a3104773d405a0c922914690b3acb51534c6d0', 'Student', NULL, '9989082713', NULL, 0),
(11, 'juthveshch@gmail.com', 'scrypt:32768:8:1$cZmlm49ZS4B0wq8u$a39adff1245c120d01f64d761abba3125bd1de368dd1b1b047ec9249ea65c52c4c56e6e8f8a10cfca6fc3381eca71506dbfd9be9f3db043926e92ab357e4fd43', 'Student', NULL, '7075747045', NULL, 0),
(12, 'kandukuriguru704@gmail.com', 'scrypt:32768:8:1$ES8khygsPIRyldrm$9b9e6d273a52125de7412dcf6abf2a23d3ad3a58ac1b376078e9c66a92dc2613773f88e70b7e78e54e25cdd536ccc7f4401afe7cee10802b01c6d5d205e3d314', 'Student', NULL, '9989082713', NULL, 0),
(14, 'kandukuriguru951@gmail.com', 'scrypt:32768:8:1$19k2Swx8CIXb32X4$7718d8d86f1af8921bb7961cb99c4e14024b34ffa2f7efbd834c3cdd50ae9f5c35590407baccb514c74ae73ffab2a44ebe88553ecc5812c34732e8b129ffa71a', 'student', 'rohit', '7075747045', '10', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `otp_verifications`
--
ALTER TABLE `otp_verifications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `tutor_bank_details`
--
ALTER TABLE `tutor_bank_details`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tutor_id` (`tutor_id`);

--
-- Indexes for table `tutor_earnings`
--
ALTER TABLE `tutor_earnings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tutor_subjects`
--
ALTER TABLE `tutor_subjects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `email_2` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `otp_verifications`
--
ALTER TABLE `otp_verifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tutor_bank_details`
--
ALTER TABLE `tutor_bank_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tutor_earnings`
--
ALTER TABLE `tutor_earnings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `tutor_subjects`
--
ALTER TABLE `tutor_subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tutor_bank_details`
--
ALTER TABLE `tutor_bank_details`
  ADD CONSTRAINT `tutor_bank_details_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `tutor_subjects`
--
ALTER TABLE `tutor_subjects`
  ADD CONSTRAINT `tutor_subjects_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
