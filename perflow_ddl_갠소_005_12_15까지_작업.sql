-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        11.4.2-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- 테이블 perflow.ai_perfo_summary 구조 내보내기
DROP TABLE IF EXISTS `ai_perfo_summary`;
CREATE TABLE IF NOT EXISTS `ai_perfo_summary` (
  `ai_summary_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `perfo_type` varchar(30) NOT NULL,
  `ai_summary` varchar(255) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ai_summary_id`),
  KEY `FK_employee_TO_ai_perfo_summary_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_ai_perfo_summary_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.ai_perfo_summary:~0 rows (대략적) 내보내기
DELETE FROM `ai_perfo_summary`;

-- 테이블 perflow.announcement 구조 내보내기
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE IF NOT EXISTS `announcement` (
  `ann_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dept_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `title` varchar(50) NOT NULL,
  `content` longtext NOT NULL,
  `create_datetime` datetime NOT NULL COMMENT 'JPA Auditing',
  `update_datetime` datetime DEFAULT NULL COMMENT 'JPA  Auditing',
  `status` varchar(30) NOT NULL DEFAULT 'SAVED' COMMENT 'SAVED, DELETED',
  PRIMARY KEY (`ann_id`),
  KEY `FK_department_TO_announcement_1` (`dept_id`),
  KEY `FK_employee_TO_announcement_1` (`emp_id`),
  CONSTRAINT `FK_department_TO_announcement_1` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `FK_employee_TO_announcement_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.announcement:~0 rows (대략적) 내보내기
DELETE FROM `announcement`;

-- 테이블 perflow.annual 구조 내보내기
DROP TABLE IF EXISTS `annual`;
CREATE TABLE IF NOT EXISTS `annual` (
  `annual_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `approve_sbj_id` bigint(20) NOT NULL,
  `enroll_annual` datetime NOT NULL,
  `annual_start` datetime NOT NULL,
  `annual_end` datetime NOT NULL,
  `annual_status` varchar(30) NOT NULL COMMENT '대기 승인 반려',
  `annual_reject_reason` varchar(255) DEFAULT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE,DELETED',
  `is_annual_retroactive` tinyint(1) NOT NULL DEFAULT 0 COMMENT '소급 여부 (0: 일반, 1: 소급)',
  `annual_retroactive_reason` varchar(255) DEFAULT NULL COMMENT '소급 사유',
  `annual_retroactive_status` varchar(30) DEFAULT NULL COMMENT '소급 상태 (대기, 승인, 반려)',
  PRIMARY KEY (`annual_id`),
  KEY `FK_employee_TO_annual_1` (`emp_id`),
  KEY `FK_approve_sbj_TO_annual_1` (`approve_sbj_id`),
  CONSTRAINT `FK_approve_sbj_TO_annual_1` FOREIGN KEY (`approve_sbj_id`) REFERENCES `approve_sbj` (`approve_sbj_id`),
  CONSTRAINT `FK_employee_TO_annual_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.annual:~0 rows (대략적) 내보내기
DELETE FROM `annual`;

-- 테이블 perflow.appoint 구조 내보내기
DROP TABLE IF EXISTS `appoint`;
CREATE TABLE IF NOT EXISTS `appoint` (
  `appointId` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `type` varchar(30) NOT NULL COMMENT '승진, 부서이동',
  `before` varchar(30) NOT NULL,
  `after` varchar(30) NOT NULL,
  `appoint_datetime` datetime NOT NULL,
  PRIMARY KEY (`appointId`),
  KEY `FK_employee_TO_appoint_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_appoint_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.appoint:~0 rows (대략적) 내보내기
DELETE FROM `appoint`;

-- 테이블 perflow.approve_line 구조 내보내기
DROP TABLE IF EXISTS `approve_line`;
CREATE TABLE IF NOT EXISTS `approve_line` (
  `approve_line_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `doc_id` bigint(20) DEFAULT NULL COMMENT 'NULL 이면 나의결재선템플릿 사용한다는 뜻',
  `create_user_id` varchar(30) NOT NULL,
  `group_id` varchar(30) NOT NULL,
  `name` varchar(30) DEFAULT NULL COMMENT '나의결재선이름 or NULL(문서 결재선인 경우)',
  `description` longtext DEFAULT NULL,
  `approve_template_type` varchar(30) NOT NULL,
  `approve_line_order` int(11) NOT NULL COMMENT '결재선 안에서 처리되는 순서',
  `pll_group_id` bigint(20) DEFAULT NULL,
  `approve_type` varchar(30) NOT NULL COMMENT '동의, 병렬, 합의 등',
  `status` varchar(30) NOT NULL COMMENT '결재선의 각 단계의 대기/진행/완료',
  `create_datetime` datetime NOT NULL,
  `complete_datetime` datetime DEFAULT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`approve_line_id`),
  KEY `FK_doc_TO_approve_line_1` (`doc_id`),
  KEY `FK_employee_TO_approve_line_1` (`create_user_id`),
  CONSTRAINT `FK_doc_TO_approve_line_1` FOREIGN KEY (`doc_id`) REFERENCES `doc` (`doc_id`),
  CONSTRAINT `FK_employee_TO_approve_line_1` FOREIGN KEY (`create_user_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.approve_line:~29 rows (대략적) 내보내기
DELETE FROM `approve_line`;
INSERT INTO `approve_line` (`approve_line_id`, `doc_id`, `create_user_id`, `group_id`, `name`, `description`, `approve_template_type`, `approve_line_order`, `pll_group_id`, `approve_type`, `status`, `create_datetime`, `complete_datetime`, `update_datetime`) VALUES
	(26, 38, '23-MK004', '38', NULL, NULL, 'MANUAL', 1, NULL, 'SEQ', 'PENDING', '2024-12-14 21:26:23', NULL, '2024-12-14 21:26:23'),
	(27, 38, '23-MK004', '38', NULL, NULL, 'MANUAL', 2, 1, 'PLLAGR', 'PENDING', '2024-12-14 21:26:23', NULL, '2024-12-14 21:26:23'),
	(28, 38, '23-MK004', '38', NULL, NULL, 'MANUAL', 3, NULL, 'AGR', 'PENDING', '2024-12-14 21:26:23', NULL, '2024-12-14 21:26:23'),
	(29, 39, '23-MK004', '39', NULL, NULL, 'MANUAL', 1, NULL, 'CC', 'PENDING', '2024-12-14 21:31:12', NULL, '2024-12-14 21:31:12'),
	(30, 39, '23-MK004', '39', NULL, NULL, 'MANUAL', 2, 1, 'PLL', 'PENDING', '2024-12-14 21:31:12', NULL, '2024-12-14 21:31:12'),
	(31, 39, '23-MK004', '39', NULL, NULL, 'MANUAL', 3, NULL, 'AGR', 'PENDING', '2024-12-14 21:31:12', NULL, '2024-12-14 21:31:12'),
	(32, 43, '23-MK004', '43', NULL, NULL, 'MANUAL', 1, NULL, 'CC', 'PENDING', '2024-12-14 21:44:45', NULL, '2024-12-14 21:44:45'),
	(33, 43, '23-MK004', '43', NULL, NULL, 'MANUAL', 2, 1, 'PLL', 'PENDING', '2024-12-14 21:44:45', NULL, '2024-12-14 21:44:45'),
	(34, 43, '23-MK004', '43', NULL, NULL, 'MANUAL', 3, NULL, 'AGR', 'PENDING', '2024-12-14 21:44:45', NULL, '2024-12-14 21:44:45'),
	(35, 44, '23-MK004', '44', NULL, NULL, 'MANUAL', 1, NULL, 'CC', 'PENDING', '2024-12-14 22:24:26', NULL, '2024-12-14 22:24:26'),
	(36, 44, '23-MK004', '44', NULL, NULL, 'MANUAL', 2, 1, 'PLL', 'PENDING', '2024-12-14 22:24:26', NULL, '2024-12-14 22:24:26'),
	(37, 44, '23-MK004', '44', NULL, NULL, 'MANUAL', 3, NULL, 'AGR', 'PENDING', '2024-12-14 22:24:26', NULL, '2024-12-14 22:24:26'),
	(38, 45, '23-MK004', '45', NULL, NULL, 'MANUAL', 1, NULL, 'CC', 'PENDING', '2024-12-15 00:05:55', NULL, '2024-12-15 00:05:55'),
	(39, 45, '23-MK004', '45', NULL, NULL, 'MANUAL', 2, 1, 'PLL', 'PENDING', '2024-12-15 00:05:55', NULL, '2024-12-15 00:05:55'),
	(40, 45, '23-MK004', '45', NULL, NULL, 'MANUAL', 3, NULL, 'AGR', 'PENDING', '2024-12-15 00:05:55', NULL, '2024-12-15 00:05:55'),
	(41, 46, '23-MK004', '46', NULL, NULL, 'MANUAL', 1, NULL, 'CC', 'PENDING', '2024-12-15 00:47:06', NULL, '2024-12-15 00:47:06'),
	(42, 46, '23-MK004', '46', NULL, NULL, 'MANUAL', 2, 1, 'PLL', 'PENDING', '2024-12-15 00:47:06', NULL, '2024-12-15 00:47:06'),
	(43, 46, '23-MK004', '46', NULL, NULL, 'MANUAL', 3, NULL, 'AGR', 'PENDING', '2024-12-15 00:47:06', NULL, '2024-12-15 00:47:06'),
	(44, 47, '23-MK004', '47', NULL, NULL, 'MANUAL', 1, NULL, 'SEQ', 'PENDING', '2024-12-15 14:50:45', NULL, '2024-12-15 14:50:45'),
	(45, 48, '23-MK004', '48', NULL, NULL, 'MANUAL', 1, NULL, 'SEQ', 'PENDING', '2024-12-15 16:00:17', NULL, '2024-12-15 16:00:17'),
	(46, 48, '23-MK004', '48', NULL, NULL, 'MANUAL', 1, NULL, 'PLL', 'PENDING', '2024-12-15 16:00:17', NULL, '2024-12-15 16:00:17'),
	(47, 49, '23-MK004', '49', NULL, NULL, 'MANUAL', 1, NULL, 'SEQ', 'APPROVED', '2024-12-15 16:45:21', NULL, '2024-12-15 16:46:44'),
	(48, 49, '23-MK004', '49', NULL, NULL, 'MANUAL', 1, NULL, 'PLL', 'APPROVED', '2024-12-15 16:45:21', NULL, '2024-12-15 16:48:08'),
	(49, 50, '23-MK004', '50', NULL, NULL, 'MANUAL', 1, NULL, 'SEQ', 'APPROVED', '2024-12-15 16:53:15', NULL, '2024-12-15 16:55:09'),
	(50, 50, '23-MK004', '50', NULL, NULL, 'MANUAL', 1, NULL, 'PLL', 'APPROVED', '2024-12-15 16:53:15', NULL, '2024-12-15 16:57:08'),
	(51, NULL, '23-MK004', '51', NULL, 'My Approve Line', 'MY_APPROVE_LINE', 1, NULL, 'SEQ', 'PENDING', '2024-12-15 20:41:42', NULL, '2024-12-15 20:41:42'),
	(52, NULL, '23-MK004', '52', NULL, 'My Approve Line', 'MY_APPROVE_LINE', 1, NULL, 'PLL', 'PENDING', '2024-12-15 20:41:42', NULL, '2024-12-15 20:41:42'),
	(53, NULL, '23-MK004', '53', '마케팅팀 초과근로신청서 결재선', '마케팅팀 초과근로신청서 결재선 입니다.', 'MY_APPROVE_LINE', 1, NULL, 'SEQ', 'PENDING', '2024-12-15 20:49:58', NULL, '2024-12-15 20:49:58'),
	(54, NULL, '23-MK004', '53', '마케팅팀 초과근로신청서 결재선', '마케팅팀 초과근로신청서 결재선 입니다.', 'MY_APPROVE_LINE', 1, NULL, 'PLL', 'PENDING', '2024-12-15 20:49:58', NULL, '2024-12-15 20:49:58');

-- 테이블 perflow.approve_sbj 구조 내보내기
DROP TABLE IF EXISTS `approve_sbj`;
CREATE TABLE IF NOT EXISTS `approve_sbj` (
  `approve_sbj_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `approve_line_id` bigint(20) NOT NULL,
  `sbj_user_id` varchar(30) DEFAULT NULL,
  `dept_id` bigint(20) DEFAULT NULL,
  `sbj_department_pic` varchar(30) DEFAULT NULL COMMENT '결재주체가 부서인 경우, 해당 부서에서 결재를 처리하는 담당자(문서를 접수한 사람)',
  `sbj_type` varchar(30) NOT NULL COMMENT 'USER, DEPARTMENT',
  `is_pll` tinyint(4) NOT NULL DEFAULT 0,
  `status` varchar(30) NOT NULL,
  `complete_datetime` datetime DEFAULT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  PRIMARY KEY (`approve_sbj_id`),
  KEY `FK_approve_line_TO_approve_sbj_1` (`approve_line_id`),
  KEY `FK_employee_TO_approve_sbj_1` (`sbj_user_id`),
  KEY `FK_employee_TO_approve_sbj_2` (`sbj_department_pic`),
  KEY `FK_department_TO_approve_sbj_1` (`dept_id`),
  CONSTRAINT `FK_approve_line_TO_approve_sbj_1` FOREIGN KEY (`approve_line_id`) REFERENCES `approve_line` (`approve_line_id`),
  CONSTRAINT `FK_department_TO_approve_sbj_1` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `FK_employee_TO_approve_sbj_1` FOREIGN KEY (`sbj_user_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_employee_TO_approve_sbj_2` FOREIGN KEY (`sbj_department_pic`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.approve_sbj:~39 rows (대략적) 내보내기
DELETE FROM `approve_sbj`;
INSERT INTO `approve_sbj` (`approve_sbj_id`, `approve_line_id`, `sbj_user_id`, `dept_id`, `sbj_department_pic`, `sbj_type`, `is_pll`, `status`, `complete_datetime`, `create_datetime`, `update_datetime`, `comment`) VALUES
	(26, 26, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-14 21:26:23', '2024-12-14 21:26:23', NULL),
	(27, 27, '23-MK004', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-14 21:26:23', '2024-12-14 21:26:23', NULL),
	(28, 27, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-14 21:26:23', '2024-12-14 21:26:23', NULL),
	(29, 28, '23-MK004', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-14 21:26:23', '2024-12-14 21:26:23', NULL),
	(30, 29, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-14 21:31:12', '2024-12-14 21:31:12', NULL),
	(31, 30, '23-IT003', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-14 21:31:12', '2024-12-14 21:31:12', NULL),
	(32, 30, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-14 21:31:12', '2024-12-14 21:31:12', NULL),
	(33, 31, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-14 21:31:12', '2024-12-14 21:31:12', NULL),
	(34, 32, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-14 21:44:45', '2024-12-14 21:44:45', NULL),
	(35, 33, '23-IT003', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-14 21:44:45', '2024-12-14 21:44:45', NULL),
	(36, 33, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-14 21:44:45', '2024-12-14 21:44:45', NULL),
	(37, 34, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-14 21:44:45', '2024-12-14 21:44:45', NULL),
	(38, 35, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-14 22:24:26', '2024-12-14 22:24:26', NULL),
	(39, 36, '23-IT003', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-14 22:24:26', '2024-12-14 22:24:26', NULL),
	(40, 36, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-14 22:24:26', '2024-12-14 22:24:26', NULL),
	(41, 37, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-14 22:24:26', '2024-12-14 22:24:26', NULL),
	(42, 38, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-15 00:05:55', '2024-12-15 00:05:55', NULL),
	(43, 39, '23-IT003', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-15 00:05:55', '2024-12-15 00:05:55', NULL),
	(45, 40, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-15 00:05:55', '2024-12-15 00:05:55', NULL),
	(46, 41, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-15 00:47:06', '2024-12-15 00:47:06', NULL),
	(47, 42, '23-IT003', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-15 00:47:06', '2024-12-15 00:47:06', NULL),
	(48, 42, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-15 00:47:06', '2024-12-15 00:47:06', NULL),
	(49, 43, '23-IT003', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-15 00:47:06', '2024-12-15 00:47:06', NULL),
	(50, 44, '23-OP005', NULL, NULL, 'EMPLOYEE', 0, 'APPROVED', NULL, '2024-12-15 14:50:45', '2024-12-15 14:53:13', '다음부터는 제목에 이름 소속 써주세요.'),
	(51, 45, '23-OP005', NULL, NULL, 'EMPLOYEE', 0, 'APPROVED', NULL, '2024-12-15 16:00:17', '2024-12-15 16:04:19', '굿굿.'),
	(52, 46, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'APPROVED', NULL, '2024-12-15 16:00:17', '2024-12-15 16:07:35', '굿굿.'),
	(53, 46, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'APPROVED', NULL, '2024-12-15 16:00:17', '2024-12-15 16:07:43', '굿굿.'),
	(54, 47, '23-OP005', NULL, NULL, 'EMPLOYEE', 0, 'APPROVED', NULL, '2024-12-15 16:45:21', '2024-12-15 16:46:44', '굿굿.'),
	(55, 48, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'APPROVED', NULL, '2024-12-15 16:45:21', '2024-12-15 16:47:45', '굿굿.'),
	(56, 48, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'APPROVED', NULL, '2024-12-15 16:45:21', '2024-12-15 16:48:08', '굿굿.'),
	(57, 49, '23-OP005', NULL, NULL, 'EMPLOYEE', 0, 'APPROVED', NULL, '2024-12-15 16:53:15', '2024-12-15 16:55:09', '굿굿.'),
	(58, 50, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'APPROVED', NULL, '2024-12-15 16:53:15', '2024-12-15 16:57:08', '굿굿.'),
	(59, 50, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'APPROVED', NULL, '2024-12-15 16:53:15', '2024-12-15 16:56:55', '굿굿.'),
	(60, 51, '23-OP005', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-15 20:41:42', '2024-12-15 20:41:42', NULL),
	(61, 52, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-15 20:41:42', '2024-12-15 20:41:42', NULL),
	(62, 52, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-15 20:41:42', '2024-12-15 20:41:42', NULL),
	(63, 53, '23-OP005', NULL, NULL, 'EMPLOYEE', 0, 'ACTIVATED', NULL, '2024-12-15 20:49:58', '2024-12-15 20:49:58', NULL),
	(64, 54, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-15 20:49:58', '2024-12-15 20:49:58', NULL),
	(65, 54, '23-OP005', NULL, NULL, 'EMPLOYEE', 1, 'ACTIVATED', NULL, '2024-12-15 20:49:58', '2024-12-15 20:49:58', NULL);

-- 테이블 perflow.attendance 구조 내보내기
DROP TABLE IF EXISTS `attendance`;
CREATE TABLE IF NOT EXISTS `attendance` (
  `attendance_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `get_work_datetime` datetime DEFAULT NULL COMMENT '출근 기록 생성 시간과 같음',
  `get_off_datetime` datetime DEFAULT NULL COMMENT '퇴근 시간',
  `status` varchar(10) NOT NULL COMMENT '현재 상태 (출근/퇴근 등)',
  PRIMARY KEY (`attendance_id`),
  KEY `FK_employee_TO_attendance_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_attendance_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.attendance:~0 rows (대략적) 내보내기
DELETE FROM `attendance`;

-- 테이블 perflow.authority 구조 내보내기
DROP TABLE IF EXISTS `authority`;
CREATE TABLE IF NOT EXISTS `authority` (
  `authority_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `menu_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `type` varchar(30) NOT NULL DEFAULT 'READ' COMMENT 'READ,WRITE',
  PRIMARY KEY (`authority_id`),
  KEY `FK_menu_TO_authority_1` (`menu_id`),
  KEY `FK_employee_TO_authority_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_authority_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_menu_TO_authority_1` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.authority:~0 rows (대략적) 내보내기
DELETE FROM `authority`;

-- 테이블 perflow.company 구조 내보내기
DROP TABLE IF EXISTS `company`;
CREATE TABLE IF NOT EXISTS `company` (
  `company_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `chairman` varchar(30) NOT NULL,
  `establish` datetime NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `annual_count` int(11) NOT NULL,
  `payment_datetime` int(11) NOT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.company:~0 rows (대략적) 내보내기
DELETE FROM `company`;

-- 테이블 perflow.department 구조 내보내기
DROP TABLE IF EXISTS `department`;
CREATE TABLE IF NOT EXISTS `department` (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `manage_dept_id` bigint(20) DEFAULT NULL,
  `name` varchar(30) NOT NULL,
  `responsibility` varchar(255) NOT NULL,
  `contact` varchar(30) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(30) DEFAULT 'ACTIVE',
  PRIMARY KEY (`dept_id`),
  KEY `FK_department_TO_department_1` (`manage_dept_id`),
  CONSTRAINT `FK_department_TO_department_1` FOREIGN KEY (`manage_dept_id`) REFERENCES `department` (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.department:~5 rows (대략적) 내보내기
DELETE FROM `department`;
INSERT INTO `department` (`dept_id`, `manage_dept_id`, `name`, `responsibility`, `contact`, `create_datetime`, `update_datetime`, `status`) VALUES
	(1, NULL, '인사부', '인사 관리 및 채용', '010-1234-5678', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(2, 1, '재무부', '재무 관리 및 예산 책정', '010-2345-6789', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(3, 1, 'IT부', '정보기술 지원 및 유지보수', '010-3456-7890', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(4, 3, '마케팅부', '마케팅 및 광고 기획', '010-4567-8901', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(5, 1, '운영부', '운영 및 프로세스 관리', '010-5678-9012', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE');

-- 테이블 perflow.doc 구조 내보내기
DROP TABLE IF EXISTS `doc`;
CREATE TABLE IF NOT EXISTS `doc` (
  `doc_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_user_id` varchar(30) NOT NULL,
  `template_id` bigint(20) NOT NULL,
  `title` varchar(50) NOT NULL,
  `status` varchar(30) NOT NULL COMMENT '임시저장, 삭제, 회수,.',
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `collect_datetime` datetime DEFAULT NULL,
  `draft_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`doc_id`),
  KEY `FK_employee_TO_doc_1` (`create_user_id`),
  KEY `FK_template_TO_doc_1` (`template_id`),
  CONSTRAINT `FK_employee_TO_doc_1` FOREIGN KEY (`create_user_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_template_TO_doc_1` FOREIGN KEY (`template_id`) REFERENCES `template` (`template_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.doc:~10 rows (대략적) 내보내기
DELETE FROM `doc`;
INSERT INTO `doc` (`doc_id`, `create_user_id`, `template_id`, `title`, `status`, `create_datetime`, `update_datetime`, `collect_datetime`, `draft_datetime`) VALUES
	(38, '23-MK004', 16, '2024_12_10_긴급조퇴신청서', 'ACTIVATED', '2024-12-14 21:26:23', '2024-12-14 21:26:23', NULL, NULL),
	(39, '23-MK004', 16, '2024_12_12_노래신청서', 'ACTIVATED', '2024-12-14 21:31:12', '2024-12-14 21:31:12', NULL, NULL),
	(43, '23-MK004', 14, '2024_12_14_초과근로신청서', 'ACTIVATED', '2024-12-14 21:44:45', '2024-12-14 21:44:45', NULL, NULL),
	(44, '23-MK004', 14, '2024_12_14_초과근로신청서', 'ACTIVATED', '2024-12-14 22:24:26', '2024-12-14 22:24:26', NULL, NULL),
	(45, '23-MK004', 14, '2024_12_14_연장근무신청서', 'ACTIVATED', '2024-12-15 00:05:55', '2024-12-15 00:05:55', NULL, NULL),
	(46, '23-MK004', 14, '2024_12_14_연장근무신청서', 'ACTIVATED', '2024-12-15 00:47:06', '2024-12-15 00:47:06', NULL, NULL),
	(47, '23-MK004', 14, '2024_12_15_연장근무신청서', 'APPROVED', '2024-12-15 14:50:45', '2024-12-15 14:53:13', NULL, NULL),
	(48, '23-MK004', 14, '2024_12_15_연장근무신청서', 'APPROVED', '2024-12-15 16:00:16', '2024-12-15 16:04:19', NULL, NULL),
	(49, '23-MK004', 14, '2024_12_15_연장근무신청서', 'APPROVED', '2024-12-15 16:45:21', '2024-12-15 16:46:44', NULL, NULL),
	(50, '23-MK004', 14, '2024_12_15_연장근무신청서', 'APPROVED', '2024-12-15 16:53:14', '2024-12-15 16:57:08', NULL, NULL);

-- 테이블 perflow.doc_field 구조 내보내기
DROP TABLE IF EXISTS `doc_field`;
CREATE TABLE IF NOT EXISTS `doc_field` (
  `doc_field_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `doc_id` bigint(20) NOT NULL,
  `field_key` varchar(50) NOT NULL DEFAULT '',
  `user_value` longtext DEFAULT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  PRIMARY KEY (`doc_field_id`),
  KEY `doc_id` (`doc_id`),
  CONSTRAINT `doc_field_ibfk_1` FOREIGN KEY (`doc_id`) REFERENCES `doc` (`doc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.doc_field:~48 rows (대략적) 내보내기
DELETE FROM `doc_field`;
INSERT INTO `doc_field` (`doc_field_id`, `doc_id`, `field_key`, `user_value`, `create_datetime`, `update_datetime`, `status`) VALUES
	(20, 45, 'TITLE', '연장근무신청', '2024-12-15 00:05:55', '2024-12-15 00:05:55', '0'),
	(21, 45, 'DEPARTMENT', '개발부서', '2024-12-15 00:05:55', '2024-12-15 00:05:55', '0'),
	(22, 45, 'EMPLOYEE', '홍길동', '2024-12-15 00:05:55', '2024-12-15 00:05:55', '0'),
	(23, 45, 'WORKDATE', '2024-12-14', '2024-12-15 00:05:55', '2024-12-15 00:05:55', '0'),
	(24, 45, 'WORKTIME_FROM', '18:00', '2024-12-15 00:05:55', '2024-12-15 00:05:55', '0'),
	(25, 45, 'WORKTIME_TO', '21:00', '2024-12-15 00:05:55', '2024-12-15 00:05:55', '0'),
	(26, 45, 'REASON', '긴급 프로젝트로 인한 연장 근무', '2024-12-15 00:05:55', '2024-12-15 00:05:55', '0'),
	(27, 45, 'CONTENT', 'API 개발', '2024-12-15 00:05:55', '2024-12-15 00:05:55', '0'),
	(28, 46, 'TITLE', '연장근무신청', '2024-12-15 00:47:06', '2024-12-15 00:47:06', '0'),
	(29, 46, 'DEPARTMENT', '개발부서', '2024-12-15 00:47:06', '2024-12-15 00:47:06', '0'),
	(30, 46, 'EMPLOYEE', '홍길동', '2024-12-15 00:47:06', '2024-12-15 00:47:06', '0'),
	(31, 46, 'WORKDATE', '2024-12-14', '2024-12-15 00:47:06', '2024-12-15 00:47:06', '0'),
	(32, 46, 'WORKTIME_FROM', '18:00', '2024-12-15 00:47:06', '2024-12-15 00:47:06', '0'),
	(33, 46, 'WORKTIME_TO', '21:00', '2024-12-15 00:47:06', '2024-12-15 00:47:06', '0'),
	(34, 46, 'REASON', '긴급 프로젝트로 인한 연장 근무', '2024-12-15 00:47:06', '2024-12-15 00:47:06', '0'),
	(35, 46, 'CONTENT', 'API 개발', '2024-12-15 00:47:06', '2024-12-15 00:47:06', '0'),
	(36, 47, 'TITLE', '연장근무신청', '2024-12-15 14:50:45', '2024-12-15 14:50:45', '0'),
	(37, 47, 'DEPARTMENT', '개발부서', '2024-12-15 14:50:45', '2024-12-15 14:50:45', '0'),
	(38, 47, 'EMPLOYEE', '홍길동', '2024-12-15 14:50:45', '2024-12-15 14:50:45', '0'),
	(39, 47, 'WORKDATE', '2024-12-14', '2024-12-15 14:50:45', '2024-12-15 14:50:45', '0'),
	(40, 47, 'WORKTIME_FROM', '18:00', '2024-12-15 14:50:45', '2024-12-15 14:50:45', '0'),
	(41, 47, 'WORKTIME_TO', '21:00', '2024-12-15 14:50:45', '2024-12-15 14:50:45', '0'),
	(42, 47, 'REASON', '긴급 프로젝트로 인한 연장 근무', '2024-12-15 14:50:45', '2024-12-15 14:50:45', '0'),
	(43, 47, 'CONTENT', 'API 개발', '2024-12-15 14:50:45', '2024-12-15 14:50:45', '0'),
	(44, 48, 'TITLE', '연장근무신청', '2024-12-15 16:00:16', '2024-12-15 16:00:16', '0'),
	(45, 48, 'DEPARTMENT', '개발부서', '2024-12-15 16:00:16', '2024-12-15 16:00:16', '0'),
	(46, 48, 'EMPLOYEE', '홍길동', '2024-12-15 16:00:16', '2024-12-15 16:00:16', '0'),
	(47, 48, 'WORKDATE', '2024-12-14', '2024-12-15 16:00:16', '2024-12-15 16:00:16', '0'),
	(48, 48, 'WORKTIME_FROM', '18:00', '2024-12-15 16:00:16', '2024-12-15 16:00:16', '0'),
	(49, 48, 'WORKTIME_TO', '21:00', '2024-12-15 16:00:16', '2024-12-15 16:00:16', '0'),
	(50, 48, 'REASON', '긴급 프로젝트로 인한 연장 근무', '2024-12-15 16:00:16', '2024-12-15 16:00:16', '0'),
	(51, 48, 'CONTENT', 'API 개발', '2024-12-15 16:00:16', '2024-12-15 16:00:16', '0'),
	(52, 49, 'TITLE', '연장근무신청', '2024-12-15 16:45:21', '2024-12-15 16:45:21', '0'),
	(53, 49, 'DEPARTMENT', '개발부서', '2024-12-15 16:45:21', '2024-12-15 16:45:21', '0'),
	(54, 49, 'EMPLOYEE', '홍길동', '2024-12-15 16:45:21', '2024-12-15 16:45:21', '0'),
	(55, 49, 'WORKDATE', '2024-12-14', '2024-12-15 16:45:21', '2024-12-15 16:45:21', '0'),
	(56, 49, 'WORKTIME_FROM', '18:00', '2024-12-15 16:45:21', '2024-12-15 16:45:21', '0'),
	(57, 49, 'WORKTIME_TO', '21:00', '2024-12-15 16:45:21', '2024-12-15 16:45:21', '0'),
	(58, 49, 'REASON', '긴급 프로젝트로 인한 연장 근무', '2024-12-15 16:45:21', '2024-12-15 16:45:21', '0'),
	(59, 49, 'CONTENT', 'API 개발', '2024-12-15 16:45:21', '2024-12-15 16:45:21', '0'),
	(60, 50, 'TITLE', '연장근무신청', '2024-12-15 16:53:14', '2024-12-15 16:53:14', '0'),
	(61, 50, 'DEPARTMENT', '개발부서', '2024-12-15 16:53:14', '2024-12-15 16:53:14', '0'),
	(62, 50, 'EMPLOYEE', '홍길동', '2024-12-15 16:53:14', '2024-12-15 16:53:14', '0'),
	(63, 50, 'WORKDATE', '2024-12-14', '2024-12-15 16:53:14', '2024-12-15 16:53:14', '0'),
	(64, 50, 'WORKTIME_FROM', '18:00', '2024-12-15 16:53:14', '2024-12-15 16:53:14', '0'),
	(65, 50, 'WORKTIME_TO', '21:00', '2024-12-15 16:53:14', '2024-12-15 16:53:14', '0'),
	(66, 50, 'REASON', '긴급 프로젝트로 인한 연장 근무', '2024-12-15 16:53:14', '2024-12-15 16:53:14', '0'),
	(67, 50, 'CONTENT', 'API 개발', '2024-12-15 16:53:14', '2024-12-15 16:53:14', '0');

-- 테이블 perflow.doc_share_obj 구조 내보내기
DROP TABLE IF EXISTS `doc_share_obj`;
CREATE TABLE IF NOT EXISTS `doc_share_obj` (
  `doc_share_obj` bigint(20) NOT NULL AUTO_INCREMENT,
  `doc_id` bigint(20) NOT NULL,
  `share_obj_user_id` varchar(30) DEFAULT NULL,
  `share_obj_department_id` bigint(20) DEFAULT NULL,
  `share_add_user_id` varchar(30) NOT NULL COMMENT '공유 대상을 추가한 사람(작성자 or 결재자)',
  `share_obj_type` varchar(30) NOT NULL COMMENT 'USER, DEPARTMENT',
  `status` varchar(30) NOT NULL COMMENT 'SHARED, DELETED',
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`doc_share_obj`),
  KEY `FK_doc_TO_doc_share_obj_1` (`doc_id`),
  KEY `FK_employee_TO_doc_share_obj_1` (`share_obj_user_id`),
  KEY `FK_employee_TO_doc_share_obj_2` (`share_add_user_id`),
  KEY `FK_department_TO_doc_share_obj_1` (`share_obj_department_id`),
  CONSTRAINT `FK_department_TO_doc_share_obj_1` FOREIGN KEY (`share_obj_department_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `FK_doc_TO_doc_share_obj_1` FOREIGN KEY (`doc_id`) REFERENCES `doc` (`doc_id`),
  CONSTRAINT `FK_employee_TO_doc_share_obj_1` FOREIGN KEY (`share_obj_user_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_employee_TO_doc_share_obj_2` FOREIGN KEY (`share_add_user_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.doc_share_obj:~21 rows (대략적) 내보내기
DELETE FROM `doc_share_obj`;
INSERT INTO `doc_share_obj` (`doc_share_obj`, `doc_id`, `share_obj_user_id`, `share_obj_department_id`, `share_add_user_id`, `share_obj_type`, `status`, `create_datetime`, `update_datetime`) VALUES
	(12, 38, NULL, 3, '23-MK004', 'DEPARTMENT', 'ACTIVATED', '2024-12-14 21:26:23', '2024-12-14 21:26:23'),
	(13, 38, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-14 21:26:23', '2024-12-14 21:26:23'),
	(14, 39, NULL, 1, '23-MK004', 'DEPARTMENT', 'ACTIVATED', '2024-12-14 21:31:12', '2024-12-14 21:31:12'),
	(15, 39, NULL, 3, '23-MK004', 'DEPARTMENT', 'ACTIVATED', '2024-12-14 21:31:12', '2024-12-14 21:31:12'),
	(16, 39, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-14 21:31:12', '2024-12-14 21:31:12'),
	(17, 43, NULL, 1, '23-MK004', 'DEPARTMENT', 'ACTIVATED', '2024-12-14 21:44:45', '2024-12-14 21:44:45'),
	(18, 43, NULL, 3, '23-MK004', 'DEPARTMENT', 'ACTIVATED', '2024-12-14 21:44:45', '2024-12-14 21:44:45'),
	(19, 43, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-14 21:44:45', '2024-12-14 21:44:45'),
	(20, 44, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-14 22:24:26', '2024-12-14 22:24:26'),
	(21, 45, '23-MK004', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 00:05:55', '2024-12-15 00:05:55'),
	(22, 45, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 00:05:55', '2024-12-15 00:05:55'),
	(23, 46, '23-MK004', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 00:47:06', '2024-12-15 00:47:06'),
	(24, 46, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 00:47:06', '2024-12-15 00:47:06'),
	(25, 47, '23-MK004', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 14:50:45', '2024-12-15 14:50:45'),
	(26, 47, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 14:50:45', '2024-12-15 14:50:45'),
	(27, 48, '23-MK004', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 16:00:17', '2024-12-15 16:00:17'),
	(28, 48, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 16:00:17', '2024-12-15 16:00:17'),
	(29, 49, '23-MK004', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 16:45:21', '2024-12-15 16:45:21'),
	(30, 49, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 16:45:21', '2024-12-15 16:45:21'),
	(31, 50, '23-MK004', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 16:53:15', '2024-12-15 16:53:15'),
	(32, 50, '23-OP005', NULL, '23-MK004', 'EMPLOYEE', 'ACTIVATED', '2024-12-15 16:53:15', '2024-12-15 16:53:15');

-- 테이블 perflow.employee 구조 내보내기
DROP TABLE IF EXISTS `employee`;
CREATE TABLE IF NOT EXISTS `employee` (
  `emp_id` varchar(30) NOT NULL,
  `position_id` bigint(20) NOT NULL,
  `job_id` bigint(20) NOT NULL,
  `dept_id` bigint(20) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `name` varchar(30) NOT NULL,
  `gender` varchar(30) NOT NULL,
  `rrn` varchar(30) NOT NULL,
  `pay` bigint(20) NOT NULL,
  `address` varchar(30) NOT NULL,
  `contact` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `join_date` date NOT NULL,
  `status` varchar(30) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `resign_date` date DEFAULT NULL,
  PRIMARY KEY (`emp_id`),
  KEY `FK_position_TO_employee_1` (`position_id`),
  KEY `FK_job_TO_employee_1` (`job_id`),
  KEY `FK_department_TO_employee_1` (`dept_id`),
  CONSTRAINT `FK_department_TO_employee_1` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `FK_job_TO_employee_1` FOREIGN KEY (`job_id`) REFERENCES `job` (`job_id`),
  CONSTRAINT `FK_position_TO_employee_1` FOREIGN KEY (`position_id`) REFERENCES `position` (`position_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.employee:~5 rows (대략적) 내보내기
DELETE FROM `employee`;
INSERT INTO `employee` (`emp_id`, `position_id`, `job_id`, `dept_id`, `password`, `name`, `gender`, `rrn`, `pay`, `address`, `contact`, `email`, `join_date`, `status`, `create_datetime`, `update_datetime`, `resign_date`) VALUES
	('23-FN002', 3, 5, 2, '$2a$10$NUcfCKwlQrgzAdl9zZSEbuy5DVJf9WjQK7Scl1yjKpJ.Uh5MABkya', '이재무', 'Female', '880305-2345678', 60000000, '부산광역시 해운대구', '010-2345-6789', 'finance.lee@example.com', '2023-02-10', 'ACTIVE', '2023-02-10 11:00:00', '2024-12-14 19:18:00', NULL),
	('23-HR001', 2, 3, 1, '$2a$10$yblhS4YLEsdYG2ZmnlfiOeyzKDP3OfWJ8X24/eBKYqkyR5//EVL/q', '김인사', 'Male', '900101-1234567', 50000000, '서울특별시 강남구', '010-1234-5678', 'hr.kim@example.com', '2023-01-15', 'ACTIVE', '2023-01-15 10:00:00', '2024-12-14 19:18:08', NULL),
	('23-IT003', 4, 7, 3, '$2a$10$UuKplsxhPBhK3Ll2/q4u0ePQqyZA41StcU7T2mZ2xY87GWd8du2NW', '박IT', 'Male', '950710-3456789', 70000000, '인천광역시 미추홀구', '010-3456-7890', 'it.park@example.com', '2023-03-20', 'ACTIVE', '2023-03-20 12:30:00', '2024-12-14 19:18:16', NULL),
	('23-MK004', 4, 9, 4, '$2a$10$Cii5HzPO5jcimJm.Y8gjWuxDLxMi.g.gTSspD7aysRzlMP4r9VEVu', '최마케팅', 'Female', '920201-4567890', 45000000, '대구광역시 달서구', '010-4567-8901', 'marketing.choi@example.com', '2023-04-25', 'ACTIVE', '2023-04-25 14:00:00', '2024-12-14 18:29:09', NULL),
	('23-OP005', 5, 11, 5, '$2a$10$EBbOvCqAn3GDW0vnsQVJE.9d/nnnU4R83MhOYEyt66w55/mlQcVQi', '정운영', 'Male', '870620-5678901', 55000000, '대전광역시 서구', '010-5678-9012', 'operations.jung@example.com', '2023-05-15', 'ACTIVE', '2023-05-15 09:00:00', '2024-12-14 19:18:21', NULL);

-- 테이블 perflow.fav_template 구조 내보내기
DROP TABLE IF EXISTS `fav_template`;
CREATE TABLE IF NOT EXISTS `fav_template` (
  `fav_template_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `template_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `fav_datetime` datetime NOT NULL,
  PRIMARY KEY (`fav_template_id`),
  KEY `FK_template_TO_fav_template_1` (`template_id`),
  KEY `FK_employee_TO_fav_template_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_fav_template_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_template_TO_fav_template_1` FOREIGN KEY (`template_id`) REFERENCES `template` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.fav_template:~0 rows (대략적) 내보내기
DELETE FROM `fav_template`;

-- 테이블 perflow.field_type 구조 내보내기
DROP TABLE IF EXISTS `field_type`;
CREATE TABLE IF NOT EXISTS `field_type` (
  `field_type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`details`)),
  PRIMARY KEY (`field_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.field_type:~8 rows (대략적) 내보내기
DELETE FROM `field_type`;
INSERT INTO `field_type` (`field_type_id`, `type`, `details`) VALUES
	(1, 'TEXT', '{"name": "", "isReq": false, "defaultValue": ""}'),
	(2, 'LTEXT', '{"name": "", "isReq": false, "defaultValue": ""}'),
	(3, 'DIVIDER', '{}'),
	(4, 'DATE', '{"name": ""}'),
	(5, 'MONEY', '{"name": "", "isReq": false, "defaultValue": "", "currency": "USD"}'),
	(6, 'NUMBER', '{"name": "", "isReq": false, "defaultValue": ""}'),
	(7, 'FILE', '{}'),
	(8, 'COMBOBOX', '{"name": "", "isReq": false, "options": []}');

-- 테이블 perflow.file 구조 내보내기
DROP TABLE IF EXISTS `file`;
CREATE TABLE IF NOT EXISTS `file` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `doc_id` bigint(20) DEFAULT NULL,
  `ann_id` bigint(20) DEFAULT NULL,
  `origin_name` varchar(255) NOT NULL,
  `file_name` varchar(255) DEFAULT NULL COMMENT 'UUID 붙인 이름',
  `url` varchar(255) DEFAULT NULL COMMENT 'S3 파일 url',
  `type` varchar(10) NOT NULL COMMENT 'PNG, CSV, XLSX, HWP, PDF, JPEG',
  `size` int(11) NOT NULL COMMENT 'byte',
  `upload_datetime` datetime NOT NULL COMMENT 'S3에 파일이 저장된 시간',
  `delete_datetime` datetime DEFAULT NULL COMMENT '문서에서 파일을 삭제한 시간',
  `status` varchar(30) NOT NULL DEFAULT 'SAVED' COMMENT 'SAVED, DELETED',
  PRIMARY KEY (`file_id`),
  KEY `FK_doc_TO_file_1` (`doc_id`),
  KEY `FK_announcement_TO_file_1` (`ann_id`),
  CONSTRAINT `FK_announcement_TO_file_1` FOREIGN KEY (`ann_id`) REFERENCES `announcement` (`ann_id`),
  CONSTRAINT `FK_doc_TO_file_1` FOREIGN KEY (`doc_id`) REFERENCES `doc` (`doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.file:~0 rows (대략적) 내보내기
DELETE FROM `file`;

-- 테이블 perflow.grade_ratio 구조 내보내기
DROP TABLE IF EXISTS `grade_ratio`;
CREATE TABLE IF NOT EXISTS `grade_ratio` (
  `grade_ratio_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `s_ratio` bigint(20) NOT NULL,
  `a_ratio` bigint(20) NOT NULL,
  `b_ratio` bigint(20) NOT NULL,
  `c_ratio` bigint(20) NOT NULL,
  `d_ratio` bigint(20) NOT NULL,
  `update_reason` varchar(255) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`grade_ratio_id`),
  KEY `FK_employee_TO_grade_ratio_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_grade_ratio_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.grade_ratio:~0 rows (대략적) 내보내기
DELETE FROM `grade_ratio`;

-- 테이블 perflow.hr_perfo 구조 내보내기
DROP TABLE IF EXISTS `hr_perfo`;
CREATE TABLE IF NOT EXISTS `hr_perfo` (
  `hr_perfo_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `grade` varchar(30) DEFAULT NULL,
  `score` bigint(20) NOT NULL,
  `status` varchar(30) NOT NULL,
  `review` varchar(255) DEFAULT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`hr_perfo_id`),
  KEY `FK_employee_TO_hr_perfo_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_hr_perfo_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.hr_perfo:~0 rows (대략적) 내보내기
DELETE FROM `hr_perfo`;

-- 테이블 perflow.hr_perfo_history 구조 내보내기
DROP TABLE IF EXISTS `hr_perfo_history`;
CREATE TABLE IF NOT EXISTS `hr_perfo_history` (
  `hr_perfo_history_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `hr_perfo_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `adjustment_degree` bigint(20) NOT NULL,
  `adjustment_score` bigint(20) NOT NULL,
  `adjustment_reason` varchar(255) NOT NULL,
  `perfo_type` varchar(30) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`hr_perfo_history_id`),
  KEY `FK_hr_perfo_TO_hr_perfo_history_1` (`hr_perfo_id`),
  KEY `FK_employee_TO_hr_perfo_history_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_hr_perfo_history_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_hr_perfo_TO_hr_perfo_history_1` FOREIGN KEY (`hr_perfo_id`) REFERENCES `hr_perfo` (`hr_perfo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.hr_perfo_history:~0 rows (대략적) 내보내기
DELETE FROM `hr_perfo_history`;

-- 테이블 perflow.hr_perfo_inquiry 구조 내보내기
DROP TABLE IF EXISTS `hr_perfo_inquiry`;
CREATE TABLE IF NOT EXISTS `hr_perfo_inquiry` (
  `hr_perfo_inquiry_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `hr_perfo_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `status` varchar(30) NOT NULL,
  `pass_reason` varchar(255) DEFAULT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`hr_perfo_inquiry_id`),
  KEY `FK_hr_perfo_TO_hr_perfo_inquiry_1` (`hr_perfo_id`),
  KEY `FK_employee_TO_hr_perfo_inquiry_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_hr_perfo_inquiry_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_hr_perfo_TO_hr_perfo_inquiry_1` FOREIGN KEY (`hr_perfo_id`) REFERENCES `hr_perfo` (`hr_perfo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.hr_perfo_inquiry:~0 rows (대략적) 내보내기
DELETE FROM `hr_perfo_inquiry`;

-- 테이블 perflow.job 구조 내보내기
DROP TABLE IF EXISTS `job`;
CREATE TABLE IF NOT EXISTS `job` (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dept_id` bigint(20) NOT NULL COMMENT '해당 직책이 담당하는 부서',
  `name` varchar(30) NOT NULL,
  `responsibility` varchar(255) NOT NULL COMMENT '해당 직책 담당 업무',
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(30) DEFAULT 'ACTIVE',
  PRIMARY KEY (`job_id`),
  KEY `FK_department_TO_job_1` (`dept_id`),
  CONSTRAINT `FK_department_TO_job_1` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.job:~11 rows (대략적) 내보내기
DELETE FROM `job`;
INSERT INTO `job` (`job_id`, `dept_id`, `name`, `responsibility`, `create_datetime`, `update_datetime`, `status`) VALUES
	(1, 1, '채용 담당자', '신입 및 경력 사원 채용 관리', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(2, 1, '교육 담당자', '직원 교육 및 평가 관리', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(3, 1, '인사부 팀장', '인사부 총괄 및 업무 조율', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(4, 2, '회계 담당자', '회계 및 재무 보고 관리', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(5, 2, '재무부 팀장', '재무부 총괄 및 업무 조율', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(6, 3, '시스템 엔지니어', '사내 시스템 유지보수 및 기술 지원', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(7, 3, 'IT부 팀장', 'IT부 총괄 및 프로젝트 관리', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(8, 4, '마케팅 기획자', '광고 및 마케팅 전략 기획', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(9, 4, '마케팅부 팀장', '마케팅부 총괄 및 업무 조율', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(10, 5, '운영 담당자', '운영 프로세스 관리 및 개선', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(11, 5, '운영부 팀장', '운영부 총괄 및 업무 조율', '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE');

-- 테이블 perflow.kpi 구조 내보내기
DROP TABLE IF EXISTS `kpi`;
CREATE TABLE IF NOT EXISTS `kpi` (
  `kpi_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `goal` varchar(255) NOT NULL,
  `goal_value` bigint(20) NOT NULL,
  `goal_value_unit` varchar(30) NOT NULL,
  `current_value` double NOT NULL DEFAULT 0,
  `status` varchar(30) NOT NULL,
  `personal_type` varchar(30) NOT NULL,
  `goal_detail` varchar(255) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`kpi_id`),
  KEY `FK_employee_TO_kpi_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_kpi_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.kpi:~15 rows (대략적) 내보내기
DELETE FROM `kpi`;
INSERT INTO `kpi` (`kpi_id`, `emp_id`, `goal`, `goal_value`, `goal_value_unit`, `current_value`, `status`, `personal_type`, `goal_detail`, `create_datetime`, `update_datetime`) VALUES
	(1, '23-FN002', '목표1', 100, '%', 0, 'WAIT', 'PERSONAL', '목표1이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(2, '23-FN002', '목표2', 200, '개', 0, 'WAIT', 'PERSONAL', '목표2이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(3, '23-FN002', '목표3', 300, '원', 0, 'WAIT', 'PERSONAL', '목표3이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(4, '23-FN002', '목표4', 400, '%', 0, 'WAIT', 'PERSONAL', '목표4이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(5, '23-FN002', '목표5', 500, '%', 0, 'WAIT', 'TEAM', '목표5이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(6, '23-FN003', '목표6', 100, '%', 100, 'ACTIVE', 'PERSONAL', '목표6이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(7, '23-FN003', '목표7', 200, '개', 150, 'ACTIVE', 'PERSONAL', '목표7이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(8, '23-FN003', '목표8', 300, '원', 500, 'ACTIVE', 'PERSONAL', '목표8이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(9, '23-FN003', '목표9', 400, '%', 400, 'ACTIVE', 'PERSONAL', '목표9이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(10, '23-FN003', '목표10', 500, '%', 450, 'ACTIVE', 'PERSONAL', '목표10이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(11, '23-FN003', '목표11', 100, '%', 100, 'ACTIVE', 'TEAM', '목표11이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(12, '23-FN003', '목표12', 200, '개', 300, 'ACTIVE', 'TEAM', '목표12이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(13, '23-FN003', '목표13', 300, '원', 400, 'ACTIVE', 'TEAM', '목표13이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(14, '23-FN003', '목표14', 400, '%', 300, 'ACTIVE', 'TEAM', '목표14이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(15, '23-FN003', '목표15', 500, '%', 500, 'ACTIVE', 'TEAM', '목표15이유', '2024-01-01 09:00:00', '2024-01-01 09:00:00');

-- 테이블 perflow.kpi_limit 구조 내보내기
DROP TABLE IF EXISTS `kpi_limit`;
CREATE TABLE IF NOT EXISTS `kpi_limit` (
  `kpi_limit_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dept_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `personal_kpi_min` bigint(20) NOT NULL,
  `personal_kpi_max` bigint(20) NOT NULL,
  `team_kpi_min` bigint(20) NOT NULL,
  `team_kpi_max` bigint(20) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`kpi_limit_id`),
  KEY `FK_department_TO_kpi_limit_1` (`dept_id`),
  KEY `FK_employee_TO_kpi_limit_1` (`emp_id`),
  CONSTRAINT `FK_department_TO_kpi_limit_1` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `FK_employee_TO_kpi_limit_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.kpi_limit:~0 rows (대략적) 내보내기
DELETE FROM `kpi_limit`;
INSERT INTO `kpi_limit` (`kpi_limit_id`, `dept_id`, `emp_id`, `personal_kpi_min`, `personal_kpi_max`, `team_kpi_min`, `team_kpi_max`, `create_datetime`, `update_datetime`) VALUES
	(1, 2, '23-FN002', 5, 10, 5, 10, '2020-01-01 09:00:00', '2020-01-01 09:00:00');

-- 테이블 perflow.kpi_progress_status 구조 내보내기
DROP TABLE IF EXISTS `kpi_progress_status`;
CREATE TABLE IF NOT EXISTS `kpi_progress_status` (
  `kpi_progress_pass_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kpi_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `progress_status` double NOT NULL,
  `update_reason` varchar(255) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`kpi_progress_pass_id`),
  KEY `FK_kpi_TO_kpi_progress_status_1` (`kpi_id`),
  KEY `FK_employee_TO_kpi_progress_status_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_kpi_progress_status_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_kpi_TO_kpi_progress_status_1` FOREIGN KEY (`kpi_id`) REFERENCES `kpi` (`kpi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.kpi_progress_status:~0 rows (대략적) 내보내기
DELETE FROM `kpi_progress_status`;

-- 테이블 perflow.kpi_status 구조 내보내기
DROP TABLE IF EXISTS `kpi_status`;
CREATE TABLE IF NOT EXISTS `kpi_status` (
  `kpi_pass_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kpi_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `pass_status` varchar(30) NOT NULL,
  `pass_reason` varchar(255) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`kpi_pass_id`),
  KEY `FK_kpi_TO_kpi_status_1` (`kpi_id`),
  KEY `FK_employee_TO_kpi_status_1` (`emp_id`),
  CONSTRAINT `FK_employee_TO_kpi_status_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_kpi_TO_kpi_status_1` FOREIGN KEY (`kpi_id`) REFERENCES `kpi` (`kpi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.kpi_status:~0 rows (대략적) 내보내기
DELETE FROM `kpi_status`;

-- 테이블 perflow.menu 구조 내보내기
DROP TABLE IF EXISTS `menu`;
CREATE TABLE IF NOT EXISTS `menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) DEFAULT NULL,
  `name` varchar(30) NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`menu_id`),
  KEY `FK_menu_TO_menu_1` (`parent_id`),
  CONSTRAINT `FK_menu_TO_menu_1` FOREIGN KEY (`parent_id`) REFERENCES `menu` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.menu:~0 rows (대략적) 내보내기
DELETE FROM `menu`;

-- 테이블 perflow.notification 구조 내보내기
DROP TABLE IF EXISTS `notification`;
CREATE TABLE IF NOT EXISTS `notification` (
  `noti_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `approve_sbj_id` bigint(20) DEFAULT NULL,
  `hr_perfo_id` bigint(20) DEFAULT NULL,
  `appointId` bigint(20) DEFAULT NULL,
  `overtime_id` bigint(20) DEFAULT NULL,
  `annual_id` bigint(20) DEFAULT NULL,
  `vacation_id` bigint(20) DEFAULT NULL,
  `travel_id` bigint(20) DEFAULT NULL,
  `payroll_id` bigint(20) DEFAULT NULL,
  `content` varchar(50) NOT NULL,
  `url` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '읽음/안읽음',
  `create_datetime` datetime NOT NULL COMMENT 'JPA Auditing',
  PRIMARY KEY (`noti_id`),
  KEY `FK_approve_sbj_TO_notification_1` (`approve_sbj_id`),
  KEY `FK_hr_perfo_TO_notification_1` (`hr_perfo_id`),
  KEY `FK_appoint_TO_notification_1` (`appointId`),
  KEY `FK_overtime_TO_notification_1` (`overtime_id`),
  KEY `FK_annual_TO_notification_1` (`annual_id`),
  KEY `FK_vacation_TO_notification_1` (`vacation_id`),
  KEY `FK_travel_TO_notification_1` (`travel_id`),
  KEY `FK_payroll_TO_notification_1` (`payroll_id`),
  CONSTRAINT `FK_annual_TO_notification_1` FOREIGN KEY (`annual_id`) REFERENCES `annual` (`annual_id`),
  CONSTRAINT `FK_appoint_TO_notification_1` FOREIGN KEY (`appointId`) REFERENCES `appoint` (`appointId`),
  CONSTRAINT `FK_approve_sbj_TO_notification_1` FOREIGN KEY (`approve_sbj_id`) REFERENCES `approve_sbj` (`approve_sbj_id`),
  CONSTRAINT `FK_hr_perfo_TO_notification_1` FOREIGN KEY (`hr_perfo_id`) REFERENCES `hr_perfo` (`hr_perfo_id`),
  CONSTRAINT `FK_overtime_TO_notification_1` FOREIGN KEY (`overtime_id`) REFERENCES `overtime` (`overtime_id`),
  CONSTRAINT `FK_payroll_TO_notification_1` FOREIGN KEY (`payroll_id`) REFERENCES `payroll` (`payroll_id`),
  CONSTRAINT `FK_travel_TO_notification_1` FOREIGN KEY (`travel_id`) REFERENCES `travel` (`travel_id`),
  CONSTRAINT `FK_vacation_TO_notification_1` FOREIGN KEY (`vacation_id`) REFERENCES `vacation` (`vacation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.notification:~0 rows (대략적) 내보내기
DELETE FROM `notification`;

-- 테이블 perflow.overtime 구조 내보내기
DROP TABLE IF EXISTS `overtime`;
CREATE TABLE IF NOT EXISTS `overtime` (
  `overtime_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `approve_sbj_id` bigint(20) NOT NULL,
  `overtime_type` varchar(30) NOT NULL COMMENT '연장, 야간, 휴일',
  `enroll_overtime` datetime NOT NULL,
  `overtime_start` datetime NOT NULL,
  `overtime_end` datetime NOT NULL,
  `overtime_status` varchar(30) NOT NULL COMMENT '대기 승인 반려',
  `travel_reject_time` varchar(255) DEFAULT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `is_overtime_retroactive` tinyint(1) NOT NULL DEFAULT 0 COMMENT '소급 여부 (0: 일반, 1: 소급)',
  `overtime_retroactive_reason` varchar(255) DEFAULT NULL COMMENT '소급 사유',
  `overtime_retroactive_status` varchar(30) DEFAULT NULL COMMENT '소급 상태 (대기, 승인, 반려)',
  PRIMARY KEY (`overtime_id`),
  KEY `FK_employee_TO_overtime_1` (`emp_id`),
  KEY `FK_approve_sbj_TO_overtime_1` (`approve_sbj_id`),
  CONSTRAINT `FK_approve_sbj_TO_overtime_1` FOREIGN KEY (`approve_sbj_id`) REFERENCES `approve_sbj` (`approve_sbj_id`),
  CONSTRAINT `FK_employee_TO_overtime_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.overtime:~0 rows (대략적) 내보내기
DELETE FROM `overtime`;

-- 테이블 perflow.payroll 구조 내보내기
DROP TABLE IF EXISTS `payroll`;
CREATE TABLE IF NOT EXISTS `payroll` (
  `payroll_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`payroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.payroll:~0 rows (대략적) 내보내기
DELETE FROM `payroll`;

-- 테이블 perflow.payroll_detail 구조 내보내기
DROP TABLE IF EXISTS `payroll_detail`;
CREATE TABLE IF NOT EXISTS `payroll_detail` (
  `payroll_detail_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `payroll_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `extend_labor_allowance` bigint(20) DEFAULT NULL,
  `night_labor_allowance` bigint(20) DEFAULT NULL,
  `holiday_labor_allowance` bigint(20) DEFAULT NULL,
  `annual_allowance` bigint(20) DEFAULT NULL,
  `incentive` bigint(20) DEFAULT NULL,
  `national_pension` bigint(20) NOT NULL,
  `health_insurance` bigint(20) NOT NULL,
  `hire_insurance` bigint(20) NOT NULL,
  `long_term_care_insurance` bigint(20) NOT NULL,
  `income_tax` bigint(20) NOT NULL,
  `local_income_tax` bigint(20) NOT NULL,
  `total_amount` bigint(20) NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'PENDING' COMMENT '대기, 승인, 반려, 완료',
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`payroll_detail_id`),
  KEY `FK_employee_TO_payroll_detail_1` (`emp_id`),
  KEY `FK_payroll_TO_payroll_detail_1` (`payroll_id`),
  CONSTRAINT `FK_employee_TO_payroll_detail_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_payroll_TO_payroll_detail_1` FOREIGN KEY (`payroll_id`) REFERENCES `payroll` (`payroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.payroll_detail:~0 rows (대략적) 내보내기
DELETE FROM `payroll_detail`;

-- 테이블 perflow.perfo 구조 내보내기
DROP TABLE IF EXISTS `perfo`;
CREATE TABLE IF NOT EXISTS `perfo` (
  `perfo_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `perfo_question_id` bigint(20) NOT NULL,
  `perfo_emp_id` varchar(30) NOT NULL,
  `perfoed_emp_id` varchar(30) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`perfo_id`),
  KEY `FK_perfoquestion_TO_perfo_1` (`perfo_question_id`),
  KEY `FK_employee_TO_perfo_1` (`perfo_emp_id`),
  KEY `FK_employee_TO_perfo_2` (`perfoed_emp_id`),
  CONSTRAINT `FK_employee_TO_perfo_1` FOREIGN KEY (`perfo_emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_employee_TO_perfo_2` FOREIGN KEY (`perfoed_emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_perfoquestion_TO_perfo_1` FOREIGN KEY (`perfo_question_id`) REFERENCES `perfoquestion` (`perfo_question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.perfo:~0 rows (대략적) 내보내기
DELETE FROM `perfo`;

-- 테이블 perflow.perfoquestion 구조 내보내기
DROP TABLE IF EXISTS `perfoquestion`;
CREATE TABLE IF NOT EXISTS `perfoquestion` (
  `perfo_question_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dept_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `question_type` varchar(30) NOT NULL,
  `question_content` varchar(255) NOT NULL,
  `perfo_type` varchar(30) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`perfo_question_id`),
  KEY `FK_department_TO_perfoquestion_1` (`dept_id`),
  KEY `FK_employee_TO_perfoquestion_1` (`emp_id`),
  CONSTRAINT `FK_department_TO_perfoquestion_1` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `FK_employee_TO_perfoquestion_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.perfoquestion:~10 rows (대략적) 내보내기
DELETE FROM `perfoquestion`;
INSERT INTO `perfoquestion` (`perfo_question_id`, `dept_id`, `emp_id`, `question_type`, `question_content`, `perfo_type`, `create_datetime`, `update_datetime`) VALUES
	(1, 2, '23-HR001', 'MULTIPLE', '문제1번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(2, 2, '23-HR001', 'MULTIPLE', '문제2번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(3, 2, '23-HR001', 'MULTIPLE', '문제3번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(4, 2, '23-HR001', 'MULTIPLE', '문제4번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(5, 2, '23-HR001', 'MULTIPLE', '문제5번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(6, 2, '23-HR001', 'SUBJECTIVE', '문제6번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(7, 2, '23-HR001', 'SUBJECTIVE', '문제7번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(8, 2, '23-HR001', 'SUBJECTIVE', '문제8번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(9, 2, '23-HR001', 'SUBJECTIVE', '문제9번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00'),
	(10, 2, '23-HR001', 'SUBJECTIVE', '문제10번', 'COL', '2024-01-01 09:00:00', '2024-01-01 09:00:00');

-- 테이블 perflow.pic 구조 내보내기
DROP TABLE IF EXISTS `pic`;
CREATE TABLE IF NOT EXISTS `pic` (
  `dept_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  PRIMARY KEY (`dept_id`) USING BTREE,
  KEY `fk_pic_employee` (`emp_id`) USING BTREE,
  CONSTRAINT `fk_pic_department` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `fk_pic_employee` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.pic:~0 rows (대략적) 내보내기
DELETE FROM `pic`;

-- 테이블 perflow.position 구조 내보내기
DROP TABLE IF EXISTS `position`;
CREATE TABLE IF NOT EXISTS `position` (
  `position_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `position_level` int(11) NOT NULL COMMENT '직위의 계층 구조를 표현',
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(30) DEFAULT 'ACTIVE',
  PRIMARY KEY (`position_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.position:~5 rows (대략적) 내보내기
DELETE FROM `position`;
INSERT INTO `position` (`position_id`, `name`, `position_level`, `create_datetime`, `update_datetime`, `status`) VALUES
	(1, '인턴', 1, '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(2, '사원', 2, '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(3, '대리', 3, '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(4, '과장', 4, '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE'),
	(5, '부장', 5, '2020-01-01 09:00:00', '2020-01-01 09:00:00', 'ACTIVE');

-- 테이블 perflow.severance_pay 구조 내보내기
DROP TABLE IF EXISTS `severance_pay`;
CREATE TABLE IF NOT EXISTS `severance_pay` (
  `severance_pay_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`severance_pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.severance_pay:~0 rows (대략적) 내보내기
DELETE FROM `severance_pay`;

-- 테이블 perflow.severance_pay_detail 구조 내보내기
DROP TABLE IF EXISTS `severance_pay_detail`;
CREATE TABLE IF NOT EXISTS `severance_pay_detail` (
  `severance_pay_detail_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `severance_pay_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `total_amount` bigint(20) NOT NULL,
  `extend_labor_allowance` bigint(20) DEFAULT NULL,
  `night_labor_allowance` bigint(20) DEFAULT NULL,
  `holiday_labor_allowance` bigint(20) DEFAULT NULL,
  `annual_allowance` bigint(20) DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'PENDING' COMMENT '대기, 승인, 반려, 완료',
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`severance_pay_detail_id`),
  KEY `FK_employee_TO_severance_pay_detail_1` (`emp_id`),
  KEY `FK_severance_pay_TO_severance_pay_detail_1` (`severance_pay_id`),
  CONSTRAINT `FK_employee_TO_severance_pay_detail_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`),
  CONSTRAINT `FK_severance_pay_TO_severance_pay_detail_1` FOREIGN KEY (`severance_pay_id`) REFERENCES `severance_pay` (`severance_pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.severance_pay_detail:~0 rows (대략적) 내보내기
DELETE FROM `severance_pay_detail`;

-- 테이블 perflow.template 구조 내보내기
DROP TABLE IF EXISTS `template`;
CREATE TABLE IF NOT EXISTS `template` (
  `template_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_user_id` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` longtext DEFAULT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'ACTIVATED',
  PRIMARY KEY (`template_id`),
  KEY `FK_employee_TO_template_1` (`create_user_id`),
  CONSTRAINT `FK_employee_TO_template_1` FOREIGN KEY (`create_user_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.template:~13 rows (대략적) 내보내기
DELETE FROM `template`;
INSERT INTO `template` (`template_id`, `create_user_id`, `name`, `description`, `create_datetime`, `update_datetime`, `status`) VALUES
	(3, '23-FN002', '초과근로신청서', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-05 12:40:48', '2024-12-06 14:59:19', 'DELETED'),
	(4, '23-FN002', '초과근로확인서2', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-05 12:43:11', '2024-12-06 15:37:30', 'DELETED'),
	(5, '23-FN002', '지출품의서1', '물품 등 구매 전 미리 작성하는 문서 서식', '2024-12-05 12:43:14', '2024-12-06 15:37:30', 'DELETED'),
	(6, '23-FN002', '초과근로확인서3', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-06 15:38:08', '2024-12-06 15:39:05', 'DELETED'),
	(7, '23-FN002', '초과근로확인서4', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-06 15:38:13', '2024-12-06 15:39:11', 'DELETED'),
	(8, '23-FN002', '초과근로확인서5', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-06 15:38:16', '2024-12-06 15:39:20', 'DELETED'),
	(9, '23-FN002', '초과근로확인서6', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-06 15:38:24', '2024-12-06 15:39:20', 'DELETED'),
	(10, '23-FN002', '초과근로확인서7', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-06 16:18:45', '2024-12-06 16:19:31', 'DELETED'),
	(11, '23-FN002', '초과근로확인서8', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-06 16:19:01', '2024-12-06 16:19:42', 'DELETED'),
	(12, '23-FN002', '초과근로확인서9', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-06 16:19:05', '2024-12-06 16:19:42', 'DELETED'),
	(13, '23-FN002', '초과근로확인서10', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-06 16:19:09', '2024-12-06 16:19:09', 'ACTIVATED'),
	(14, '23-FN002', '초과근로신청서11', '초과 근로 신청 시 미리 작성하는 문서 서식', '2024-12-12 15:00:27', '2024-12-12 15:00:27', 'ACTIVATED'),
	(16, '23-FN002', '기본 서식', '서식을 선택하지 않은 경우 자동으로 로드되는 기본 서식', '2024-12-13 12:01:08', '2024-12-13 12:01:08', 'ACTIVATED');

-- 테이블 perflow.travel 구조 내보내기
DROP TABLE IF EXISTS `travel`;
CREATE TABLE IF NOT EXISTS `travel` (
  `travel_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `approve_sbj_id` bigint(20) NOT NULL,
  `enroll_travel` datetime NOT NULL,
  `travel_reason` varchar(255) NOT NULL,
  `travel_start` datetime NOT NULL,
  `travel_end` datetime NOT NULL,
  `travel_status` varchar(30) NOT NULL COMMENT '대기, 승인, 반려',
  `travel_reject_reason` varchar(255) DEFAULT NULL,
  `travel_division` varchar(30) NOT NULL COMMENT '해외, 국내',
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`travel_id`),
  KEY `FK_employee_TO_travel_1` (`emp_id`),
  KEY `FK_approve_sbj_TO_travel_1` (`approve_sbj_id`),
  CONSTRAINT `FK_approve_sbj_TO_travel_1` FOREIGN KEY (`approve_sbj_id`) REFERENCES `approve_sbj` (`approve_sbj_id`),
  CONSTRAINT `FK_employee_TO_travel_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.travel:~0 rows (대략적) 내보내기
DELETE FROM `travel`;

-- 테이블 perflow.vacation 구조 내보내기
DROP TABLE IF EXISTS `vacation`;
CREATE TABLE IF NOT EXISTS `vacation` (
  `vacation_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `emp_id` varchar(30) NOT NULL,
  `approve_sbj_id` bigint(20) NOT NULL,
  `enroll_vacation` datetime NOT NULL,
  `vacation_type` varchar(30) NOT NULL COMMENT '경조사, 병가,하계 휴가',
  `vacation_start` datetime NOT NULL,
  `vacation_end` datetime NOT NULL,
  `vacation_status` varchar(30) NOT NULL COMMENT '대기, 승인, 반려',
  `vacation_reject_reason` varchar(255) DEFAULT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`vacation_id`),
  KEY `FK_employee_TO_vacation_1` (`emp_id`),
  KEY `FK_approve_sbj_TO_vacation_1` (`approve_sbj_id`),
  CONSTRAINT `FK_approve_sbj_TO_vacation_1` FOREIGN KEY (`approve_sbj_id`) REFERENCES `approve_sbj` (`approve_sbj_id`),
  CONSTRAINT `FK_employee_TO_vacation_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.vacation:~0 rows (대략적) 내보내기
DELETE FROM `vacation`;

-- 테이블 perflow.weight 구조 내보내기
DROP TABLE IF EXISTS `weight`;
CREATE TABLE IF NOT EXISTS `weight` (
  `weight_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dept_id` bigint(20) NOT NULL,
  `emp_id` varchar(30) NOT NULL,
  `personal_weight` bigint(20) NOT NULL,
  `team_weight` bigint(20) NOT NULL,
  `col_weight` bigint(20) NOT NULL,
  `downward_weight` bigint(20) NOT NULL,
  `attendance_weight` bigint(20) NOT NULL,
  `update_reason` varchar(255) NOT NULL,
  `create_datetime` datetime NOT NULL,
  `update_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`weight_id`),
  KEY `FK_department_TO_weight_1` (`dept_id`),
  KEY `FK_employee_TO_weight_1` (`emp_id`),
  CONSTRAINT `FK_department_TO_weight_1` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`),
  CONSTRAINT `FK_employee_TO_weight_1` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 perflow.weight:~0 rows (대략적) 내보내기
DELETE FROM `weight`;
INSERT INTO `weight` (`weight_id`, `dept_id`, `emp_id`, `personal_weight`, `team_weight`, `col_weight`, `downward_weight`, `attendance_weight`, `update_reason`, `create_datetime`, `update_datetime`) VALUES
	(1, 2, '23-FN002', 20, 30, 10, 20, 20, '가중치 1차 테스트', '2024-09-01 00:00:00', '2024-12-11 15:08:26');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
