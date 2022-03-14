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
DESC `Auth`.`Token`;