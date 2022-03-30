-- DB Table 반영 사항

CREATE SCHEMA `Auth` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE `Auth`.`User` (
	`UserID` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Email` VARCHAR(255) NOT NULL,
    `Name` VARCHAR(255) NOT NULL,
    `Gender` CHAR(1) NULL,
    `ProfileImageURL` VARCHAR(255) NULL,
    `CreateDate` DATETIME NOT NULL,
    `UpdateDate` DATETIME NOT NULL
);
CREATE UNIQUE INDEX `UIX_User` ON `Auth`.`User` (`Email` ASC);
DESC `Auth`.`User`;

CREATE TABLE `Auth`.`UserPassword` (
	`UserID` INT UNSIGNED NOT NULL PRIMARY KEY,
    `Password` BINARY(64) NOT NULL,
    `PasswordSalt` VARCHAR(20) NOT NULL,
	`CreateDate` DATETIME NOT NULL,
    `UpdateDate` DATETIME NOT NULL,
    FOREIGN KEY (`UserID`)
    REFERENCES `Auth`.`User`(UserID)
);
DESC `Auth`.`UserPassword`;
SELECT * FROM information_schema.table_constraints WHERE table_name = 'UserPassword';

CREATE TABLE `Auth`.`LoginLog` (
	`LoginDate` DATETIME(3) NOT NULL,
	`Email` VARCHAR(255) NOT NULL,
    `IP` VARCHAR(128) NOT NULL,
    `IsSuccess` BIT NOT NULL,
    PRIMARY KEY (`LoginDate`, `Email`)
);
DESC `Auth`.`LoginLog`;

ALTER TABLE `Auth`.`UserPassword` MODIFY `Password` VARCHAR(255) NOT NULL;
ALTER TABLE `Auth`.`UserPassword` MODIFY `PasswordSalt` VARCHAR(255) NOT NULL;

CREATE TABLE `Auth`.`Token` (
	`UserID` INT UNSIGNED NOT NULL PRIMARY KEY,
	`Token` VARCHAR(255) NOT NULL,
    `CreateDate` DATETIME NOT NULL,
    `UpdateDate` DATETIME NOT NULL,
    FOREIGN KEY (`UserID`)
    REFERENCES `Auth`.`User`(UserID)
);
CREATE UNIQUE INDEX `UIX_Token` ON `Auth`.`Token` (`Token` ASC);
DESC `Auth`.`Token`;

CREATE SCHEMA `Book` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE TABLE `Book`.`Meeting` (
	`MeetingID` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`Title` VARCHAR(255) NOT NULL,
	`Category` VARCHAR(20) NULL,
	`Location` VARCHAR(255) NULL,
	`MeetingImageURL` VARCHAR(255) NULL,
	`Description` TEXT NOT NULL,
    `CreateDate` DATETIME NOT NULL,
    `UpdateDate` DATETIME NOT NULL
);
DESC `Book`.`Meeting`;

CREATE TABLE `Book`.`MeetingParticipant` (
	`MeetingID` INT UNSIGNED NOT NULL,
	`UserID` INT UNSIGNED NOT NULL,
	`IsOwner` BIT NOT NULL,
    `CreateDate` DATETIME NOT NULL,
    `UpdateDate` DATETIME NOT NULL,
    PRIMARY KEY (`MeetingID`, `UserID`),
    FOREIGN KEY (`MeetingID`)
    REFERENCES `Book`.`Meeting`(MeetingID),
    FOREIGN KEY (`UserID`)
    REFERENCES `Auth`.`User`(UserID)
);
DESC `Book`.`MeetingParticipant`;

ALTER TABLE `Book`.`Meeting` ADD `CreateUserID` INT UNSIGNED NOT NULL AFTER CreateDate;
ALTER TABLE `Book`.`Meeting` ADD `UpdateUserID` INT UNSIGNED NOT NULL AFTER UpdateDate;
ALTER TABLE `Book`.`MeetingParticipant` ADD `CreateUserID` INT UNSIGNED NOT NULL AFTER CreateDate;
ALTER TABLE `Book`.`MeetingParticipant` ADD `UpdateUserID` INT UNSIGNED NOT NULL AFTER UpdateDate;

ALTER TABLE `Book`.`Meeting` ADD `IsActive` BIT NOT NULL DEFAULT 1 AFTER `Description`;
ALTER TABLE `Auth`.`User` ADD `IsActive` BIT NOT NULL DEFAULT 1 AFTER `ProfileImageURL`;

CREATE TABLE `Book`.`MeetingInvitation` (
	`MeetingID` INT UNSIGNED NOT NULL,
	`UserID` INT UNSIGNED NOT NULL,
    `IsActive` BIT NOT NULL DEFAULT 1,
    `ApprovalDate` DATETIME NULL,
    `CreateDate` DATETIME NOT NULL,
    `CreateUserID` INT UNSIGNED NOT NULL,
    `UpdateDate` DATETIME NOT NULL,
    `UpdateUserID` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`MeetingID`, `UserID`),
    FOREIGN KEY (`MeetingID`)
    REFERENCES `Book`.`Meeting`(MeetingID),
    FOREIGN KEY (`UserID`)
    REFERENCES `Auth`.`User`(UserID)
);
