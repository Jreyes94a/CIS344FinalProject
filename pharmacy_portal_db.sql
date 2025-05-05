-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Create Schema
CREATE SCHEMA IF NOT EXISTS `pharmacy_portal_db` DEFAULT CHARACTER SET utf8;
USE `pharmacy_portal_db`;

-- Users Table
CREATE TABLE IF NOT EXISTS `Users` (
  `userId` INT NOT NULL AUTO_INCREMENT,
  `userName` VARCHAR(45) NOT NULL,
  `contactInfo` VARCHAR(200) DEFAULT NULL,
  `userType` ENUM('pharmacist', 'patient') NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `userName_UNIQUE` (`userName`)
) ENGINE = InnoDB;

-- Medications Table
CREATE TABLE IF NOT EXISTS `Medications` (
  `medicationId` INT NOT NULL AUTO_INCREMENT,
  `medicationName` VARCHAR(45) NOT NULL,
  `dosage` VARCHAR(45) NOT NULL,
  `manufacturer` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`medicationId`)
) ENGINE = InnoDB;

-- Prescriptions Table
CREATE TABLE IF NOT EXISTS `Prescriptions` (
  `prescriptionId` INT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `medicationId` INT NOT NULL,
  `prescribedDate` DATETIME NOT NULL,
  `dosageInstructions` VARCHAR(200) DEFAULT NULL,
  `quantity` INT NOT NULL,
  `refillCount` INT DEFAULT 0,
  PRIMARY KEY (`prescriptionId`),
  INDEX `idx_prescription_user` (`userId`),
  INDEX `idx_prescription_medication` (`medicationId`),
  CONSTRAINT `fk_prescriptions_user`
    FOREIGN KEY (`userId`)
    REFERENCES `Users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_prescriptions_medication`
    FOREIGN KEY (`medicationId`)
    REFERENCES `Medications` (`medicationId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Inventory Table
CREATE TABLE IF NOT EXISTS `Inventory` (
  `inventoryId` INT NOT NULL AUTO_INCREMENT,
  `medicationId` INT NOT NULL,
  `quantityAvailable` INT NOT NULL,
  `lastUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`inventoryId`),
  INDEX `idx_inventory_medication` (`medicationId`),
  CONSTRAINT `fk_inventory_medication`
    FOREIGN KEY (`medicationId`)
    REFERENCES `Medications` (`medicationId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Sales Table
CREATE TABLE IF NOT EXISTS `Sales` (
  `saleId` INT NOT NULL AUTO_INCREMENT,
  `prescriptionId` INT NOT NULL,
  `saleDate` DATETIME NOT NULL,
  `quantitySold` INT NOT NULL,
  `saleAmount` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`saleId`),
  INDEX `idx_sales_prescription` (`prescriptionId`),
  CONSTRAINT `fk_sales_prescription`
    FOREIGN KEY (`prescriptionId`)
    REFERENCES `Prescriptions` (`prescriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Restore SQL mode and checks
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
