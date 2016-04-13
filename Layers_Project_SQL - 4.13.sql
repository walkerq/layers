-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Layers_Project
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Layers_Project
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Layers_Project`;
CREATE SCHEMA IF NOT EXISTS `Layers_Project` DEFAULT CHARACTER SET latin1 ;
USE `Layers_Project` ;

-- -----------------------------------------------------
-- Table `Layers_Project`.`Hashtag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Layers_Project`.`Hashtag`;
CREATE TABLE `Layers_Project`.`Hashtag` (
  `Hashtag` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Hashtag`),
  UNIQUE INDEX `Hashtag_UNIQUE` (`Hashtag` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `Layers_Project`.`User`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Layers_Project`.`User`;
CREATE TABLE `Layers_Project`.`User` (
  `Username` VARCHAR(45) NOT NULL UNIQUE,
  `Age` INT(3) NOT NULL,
  `Country` ENUM('Afghanistan','Albania','Algeria','Andorra','Angola','Antigua and Barbuda','Argentina','Armenia','Australia','Austria','Azerbaijan','Bahamas','Bahrain','Bangladesh','Barbados','Belarus','Belgium','Belize','Benin','Bhutan','Bolivia','Bosnia and Herzegovina','Botswana','Brazil','Brunei Darussalam','Bulgaria','Burkina Faso','Burundi','Cabo Verde','Cambodia','Cameroon','Canada','Central African Republic','Chad','Chile','China','Colombia','Comoros','Congo','Costa Rica','Côte dIvoire','Croatia','Cuba','Cyprus','Czech Republic','Democratic Peoples Republic of Korea (North Korea)','Democratic Republic of the Cong','Denmark','Djibouti','Dominica','Dominican Republic','Ecuador','Egypt','El Salvador','Equatorial Guinea','Eritrea','Estonia','Ethiopia','Fiji','Finland','France','Gabon','Gambia','Georgia','Germany','Ghana','Greece','Grenada','Guatemala','Guinea','Guinea-Bissau','Guyana','Haiti','Honduras','Hungary','Iceland','India','Indonesia','Iran','Iraq','Ireland','Israel','Italy','Jamaica','Japan','Jordan','Kazakhstan','Kenya','Kiribati','Kuwait','Kyrgyzstan','Lao Peoples Democratic Republic (Laos)','Latvia','Lebanon','Lesotho','Liberia','Libya','Liechtenstein','Lithuania','Luxembourg','Macedonia','Madagascar','Malawi','Malaysia','Maldives','Mali','Malta','Marshall Islands','Mauritania','Mauritius','Mexico','Micronesia (Federated States of)','Monaco','Mongolia','Montenegro','Morocco','Mozambique','Myanmar','Namibia','Nauru','Nepal','Netherlands','New Zealand','Nicaragua','Niger','Nigeria','Norway','Oman','Pakistan','Palau','Panama','Papua New Guinea','Paraguay','Peru','Philippines','Poland','Portugal','Qatar','Republic of Korea (South Korea)','Republic of Moldova','Romania','Russian Federation','Rwanda','Saint Kitts and Nevis','Saint Lucia','Saint Vincent and the Grenadines','Samoa','San Marino','Sao Tome and Principe','Saudi Arabia','Senegal','Serbia','Seychelles','Sierra Leone','Singapore','Slovakia','Slovenia','Solomon Islands','Somalia','South Africa','South Sudan','Spain','Sri Lanka','Sudan','Suriname','Swaziland','Sweden','Switzerland','Syrian Arab Republic','Tajikistan','Thailand','Timor-Leste','Togo','Tonga','Trinidad Tobago','Tunisia','Turkey','Turkmenistan','Tuvalu','Uganda','Ukraine','United Arab Emirates','United Kingdom of Great Britain and Northern Ireland','United Republic of Tanzania','United States of America','Uruguay','Uzbekistan','Vanuatu','Venezuela','Vietnam','Yemen','Zambia','Zimbabwe'),
  PRIMARY KEY (`Username`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `Layers_Project`.`Layer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Layers_Project`.`Layer`;
CREATE TABLE `Layers_Project`.`Layer` (
  `LayerID` INT(11) NOT NULL AUTO_INCREMENT,
  `LayerName` VARCHAR(45) NOT NULL,
  `Length_of_Layer` INT(11) NOT NULL COMMENT 'Time in seconds',
  `Created_Date` DATETIME NOT NULL,
  `FileLayer` VARCHAR(45) NOT NULL COMMENT 'Represents relative path to file',
  `Username` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`LayerID`),
  INDEX `Username_idx` (`Username` ASC),
  CONSTRAINT `Username`
    FOREIGN KEY (`Username`)
    REFERENCES `Layers_Project`.`User` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `Layers_Project`.`Hashtag_Layer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Layers_Project`.`Hashtag_Layer`;
CREATE TABLE `Layers_Project`.`Hashtag_Layer` (
  `Hashtag` VARCHAR(45) NOT NULL,
  `LayerID` INT(11) NOT NULL,
  PRIMARY KEY (`Hashtag`, `LayerID`),
  INDEX `LayerID_idx` (`LayerID` ASC),
  CONSTRAINT `Hashtag`
    FOREIGN KEY (`Hashtag`)
    REFERENCES `Layers_Project`.`Hashtag` (`Hashtag`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `LayerID`
    FOREIGN KEY (`LayerID`)
    REFERENCES `Layers_Project`.`Layer` (`LayerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `Layers_Project`.`Layer_Junction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Layers_Project`.`Layer_Junction`;
CREATE TABLE `Layers_Project`.`Layer_Junction` (
  `BaseLayerID` INT(11) NOT NULL,
  `LinkedLayerID` INT(11) NOT NULL,
  PRIMARY KEY (`BaseLayerID`, `LinkedLayerID`),
  INDEX `LinkedLayerID_idx` (`LinkedLayerID` ASC),
  CONSTRAINT `BaseLayerID`
    FOREIGN KEY (`BaseLayerID`)
    REFERENCES `Layers_Project`.`Layer` (`LayerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `LinkedLayerID`
    FOREIGN KEY (`LinkedLayerID`)
    REFERENCES `Layers_Project`.`Layer` (`LayerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

use Layers_Project;

/* TRIGGERS TO ENSURE DATA INTEGRITY --------------------------------------- */

/* Trigger to automatically insert date as today */
DROP TRIGGER IF EXISTS `Created_Date_As_Today`;
DELIMITER ;;
CREATE TRIGGER `Created_Date_As_Today` BEFORE INSERT ON `Layer` FOR EACH ROW
BEGIN
    SET NEW.Created_Date = NOW();
END;;
DELIMITER ;

/* Trigger to check that length of layer is greater than 0 */
DROP TRIGGER IF EXISTS `Layer_Length_>0`;
DELIMITER ;;
CREATE TRIGGER `Layer_Length_>0` BEFORE INSERT ON `Layer` FOR EACH ROW
BEGIN
	DECLARE baddata INT;
    DECLARE specialty CONDITION FOR SQLSTATE '45000';
    SET baddata = 0;
    /* length of layer cannot be negative */
    IF (NEW.Length_of_Layer <= 0) THEN
		SET baddata = 1;
	END IF;
	IF (baddata = 1) THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Length of Layer must be greater than 0';
	END IF;
END;;
DELIMITER ;

/* Trigger to check that the file being uploaded is an mp3 */
DROP TRIGGER IF EXISTS `File_mp3`;
DELIMITER ;;
CREATE TRIGGER `File_mp3` BEFORE INSERT ON `Layer` FOR EACH ROW
BEGIN
	DECLARE baddata INT;
    DECLARE specialty CONDITION FOR SQLSTATE '45000';
    SET baddata = 0;
    /* file must end in .mp3 */
    IF (NEW.FileLayer LIKE '%.mp3') THEN
		SET baddata = 1;
	END IF;
	IF (baddata = 0) THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'File must be in ".mp3" format';
	END IF;
END;;
DELIMITER ;

/* Trigger to check that the hashtag has an # at the front */
DROP TRIGGER IF EXISTS `Hashtag_at_front`;
DELIMITER ;;
CREATE TRIGGER `Hashtag_at_front` BEFORE INSERT ON `Hashtag` FOR EACH ROW
BEGIN
	DECLARE baddata INT;
    DECLARE specialty CONDITION FOR SQLSTATE '45000';
    SET baddata = 0;
    /* hashtag has to start with a # */
    IF (NEW.Hashtag LIKE '#%') THEN
		SET baddata = 1;
	END IF;
	IF (baddata = 0) THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Hashtag must start with an #';
	END IF;
END;;
DELIMITER ;

/* Trigger to check that the hashtag has no spaces */
DROP TRIGGER IF EXISTS `Hashtag_no_spaces`;
DELIMITER ;;
CREATE TRIGGER `Hashtag_no_spaces` BEFORE INSERT ON `Hashtag` FOR EACH ROW
BEGIN
	DECLARE baddata INT;
    DECLARE specialty CONDITION FOR SQLSTATE '45000';
    SET baddata = 0;
    /* hashtag cannot have spaces */
    IF (NEW.Hashtag LIKE '% %') THEN
		SET baddata = 1;
	END IF;
	IF (baddata = 1) THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Hashtag cannot contains spaces';
	END IF;
END;;
DELIMITER ;


/* Trigger to check that the username has no spaces */
DROP TRIGGER IF EXISTS `Username_no_spaces`;
DELIMITER ;;
CREATE TRIGGER `Username_no_spaces` BEFORE INSERT ON `User` FOR EACH ROW
BEGIN
	DECLARE baddata INT;
    DECLARE specialty CONDITION FOR SQLSTATE '45000';
    SET baddata = 0;
    /* username cannot have spaces */
    IF (NEW.Username LIKE '% %') THEN
		SET baddata = 1;
	END IF;
	IF (baddata = 1) THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Username cannot contains spaces';
	END IF;
END;;
DELIMITER ;



/* INSERT, UPDATE, DELETE FUNCTIONALITY --------------------------------------- */

/* USERS --------------------------------------- */


/* To insert a User */
DROP PROCEDURE IF EXISTS insert_user;
DELIMITER $$
CREATE PROCEDURE insert_user(IN InputUsername VARCHAR(45),
                            InputAge INT(3),
                            InputCountry VARCHAR(45))
 BEGIN
	INSERT INTO User(Username, Age, Country)
    VALUES(InputUsername, InputAge, InputCountry);
 END $$
 DELIMITER ;
 
  /* To delete a User */
DROP PROCEDURE IF EXISTS delete_user;
DELIMITER $$
CREATE PROCEDURE delete_user(IN InputUsername INT)
 BEGIN
	DELETE FROM User
	WHERE Username = InputUsername;
 END $$
 DELIMITER ;
 
 
/* HASHTAGS --------------------------------------- */
 
  /* To insert a Hashtag */
DROP PROCEDURE IF EXISTS insert_hashtag;
DELIMITER $$
CREATE PROCEDURE insert_hashtag(IN InputHashtag INT)
 BEGIN
	INSERT INTO Hashtag(Hashtag)
    VALUES(InputHashtag);
 END $$
 DELIMITER ;


  /* To delete a Hashtag */
DROP PROCEDURE IF EXISTS delete_hashtag;
DELIMITER $$
CREATE PROCEDURE delete_hashtag(IN InputHashtag INT)
 BEGIN
	DELETE FROM Hashtag
	WHERE Hashtag = InputHashtag;
 END $$
 DELIMITER ;
 
/* LAYERS --------------------------------------- */

  /* To insert a Layer */
DROP PROCEDURE IF EXISTS insert_layer;
DELIMITER $$
CREATE PROCEDURE insert_layer(IN InputLayerName VARCHAR(45),
								InputLength_of_Layer INT(11), 
                                InputFileLayer VARCHAR(45), 
                                InputUsername INT)
 BEGIN
	INSERT INTO Layer(LayerName, Length_of_Layer, FileLayer, Username)
    VALUES(InputLayerName, InputLength_of_Layer, InputFileLayer, InputUsername);
 END $$
 DELIMITER ;

  /* To delete a Layer */
DROP PROCEDURE IF EXISTS delete_layer;
DELIMITER $$
CREATE PROCEDURE delete_layer(IN InputLayerID INT)
 BEGIN
	DELETE FROM Layer
	WHERE LayerID = InputLayerID;
 END $$
 DELIMITER ;

 /* To update a Layer Name */
DROP PROCEDURE IF EXISTS update_layer_name;
DELIMITER $$
CREATE PROCEDURE update_layer_name(IN InputLayerName VARCHAR(45),
										InputLayerID INT)
 BEGIN
	UPDATE Layer
    SET LayerName = InputLayerName
	WHERE LayerID = InputLayerID;
 END $$
 DELIMITER ;
 
  /* To update the Layer Length */
DROP PROCEDURE IF EXISTS update_layer_length;
DELIMITER $$
CREATE PROCEDURE update_layer_length(IN InputLength_of_Layer INT,
										InputLayerID INT)
 BEGIN
	UPDATE Layer
    SET Length_of_Layer = InputLength_of_Layer
	WHERE LayerID = InputLayerID;
 END $$
 DELIMITER ;
 
   /* To update a Layer FileLayer */
DROP PROCEDURE IF EXISTS update_filelayer;
DELIMITER $$
CREATE PROCEDURE update_filelayer(IN InputFileLayer VARCHAR(45),
										InputLayerID INT)
 BEGIN
	UPDATE Layer
    SET FileLayer = InputFileLayer
	WHERE LayerID = InputLayerID;
 END $$
 DELIMITER ;
 
  
   /* To update a Layer Username */
DROP PROCEDURE IF EXISTS update_userusername;
DELIMITER $$
CREATE PROCEDURE update_userusername(IN InputUsername INT,
										InputLayerID INT)
 BEGIN
	UPDATE Layer
    SET Username = InputUsername
	WHERE LayerID = InputLayerID;
 END $$
 DELIMITER ;


/* LAYER JUNCTIONS --------------------------------------- */

  /* To insert a Layer Junction */
DROP PROCEDURE IF EXISTS insert_layer_junction;
DELIMITER $$
CREATE PROCEDURE insert_layer_junction(IN InputBaseLayerID INT,
											InputLinkedLayerID INT)
 BEGIN
	INSERT INTO Layer_Junction(BaseLayerID, LinkedLayerID)
    VALUES(InputBaseLayerID, InputLinkedLayerID);
 END $$
 DELIMITER ;

  /* To delete a Layer Junction */
DROP PROCEDURE IF EXISTS delete_layer_junction;
DELIMITER $$
CREATE PROCEDURE delete_layer_junction(IN InputBaseLayerID INT,
									InputLinkedLayerID INT)
 BEGIN
	DELETE FROM Layer_Junction
	WHERE (BaseLayerID = InputBaseLayerID AND LinkedLayerID = InputLinkedLayerID);
 END $$
 DELIMITER ;

/* HASHTAG LAYERS --------------------------------------- */

  /* To insert a Hashtag Layer */
DROP PROCEDURE IF EXISTS insert_hashtag_layer;
DELIMITER $$
CREATE PROCEDURE insert_hashtag_layer(IN InputHashtag VARCHAR(45),
											InputLayerID INT)
 BEGIN
	INSERT INTO Hashtag_Layer(Hashtag, LayerID)
    VALUES(InputHashtag, InputLayerID);
 END $$
 DELIMITER ;

  /* To delete a Hashtag Layer */
DROP PROCEDURE IF EXISTS delete_hashtag_layer;
DELIMITER $$
CREATE PROCEDURE delete_hashtag_layer(IN InputHashtag VARCHAR(45),
											InputLayerID INT)
 BEGIN
	DELETE FROM Hashtag_Layer
	WHERE (Hashtag = InputHashtag AND LayerID = InputLayerID);
 END $$
 DELIMITER ;


/* EXAMPLE DATA FOR TABLES --------------------------------------- */

/*Hashtag Examples */
INSERT INTO Hashtag (Hashtag)
VALUES ("#socool");

INSERT INTO Hashtag (Hashtag)
VALUES ("#awesome");

INSERT INTO Hashtag (Hashtag)
VALUES ("#favoritesongever");


/*User Examples */
INSERT INTO User (Username, Age, Country)
VALUES ("samsmith", 20, "United States of America");

INSERT INTO User (Username, Age, Country)
VALUES ("emilyplatt", 30, "Canada");

INSERT INTO User (Username, Age, Country)
VALUES ("caseysamuels", 50, "South Africa");

INSERT INTO User (Username, Age, Country)
VALUES ("lilybilly", 15, "United States of America");

INSERT INTO User (Username, Age, Country)
VALUES ("tammywilliams", 27, "Canada");


/* Layer Examples */
INSERT INTO Layer (LayerName, Length_of_Layer, FileLayer, Username)
VALUES ("Sorry_Beat", 60, "sorrybeat.mp3", "samsmith");

INSERT INTO Layer (LayerName, Length_of_Layer, FileLayer, Username)
VALUES ("Dreamer Drums", 105, "dreamerdrums.mp3", "emilyplatt");

INSERT INTO Layer (LayerName, Length_of_Layer, FileLayer, Username)
VALUES ("Dance Beat", 50, "dancebeat.mp3", "tammywilliams");

INSERT INTO Layer (LayerName, Length_of_Layer, FileLayer, Username)
VALUES ("Classical Violin", 170, "classicalviolin.mp3", "caseysamuels");

INSERT INTO Layer (LayerName, Length_of_Layer, FileLayer, Username)
VALUES ("Blues Base", 30, "bluesbase.mp3", "caseysamuels");


/* Layer Junction Examples */
INSERT INTO Layer_Junction (BaseLayerID, LinkedLayerID)
VALUES (1, 2);

INSERT INTO Layer_Junction (BaseLayerID, LinkedLayerID)
VALUES (2, 3);

INSERT INTO Layer_Junction (BaseLayerID, LinkedLayerID)
VALUES (2, 4);

INSERT INTO Layer_Junction (BaseLayerID, LinkedLayerID)
VALUES (2, 5);

INSERT INTO Layer_Junction (BaseLayerID, LinkedLayerID)
VALUES (3, 5);


/* Hashtag_Layer Examples */
INSERT INTO Hashtag_Layer (Hashtag, LayerID)
VALUES ("#socool", 2);

INSERT INTO Hashtag_Layer (Hashtag, LayerID)
VALUES ("#awesome", 4);

INSERT INTO Hashtag_Layer (Hashtag, LayerID)
VALUES ("#awesome", 2);

INSERT INTO Hashtag_Layer (Hashtag, LayerID)
VALUES ("#socool", 5);



/* TESTS THAT TRIGGERS WORK --------------------------------------------------- */

/* TEST that trigger error for usernames do not contain spaces works */
INSERT INTO User (Username, Age, Country)
VALUES ("sam smith", 20, "United States of America");

/* TEST that trigger error for hashtags start with # works */
INSERT INTO Hashtag (Hashtag)
VALUES ("socool");

/* TEST that trigger error for hashtags do not contain spaces works */
INSERT INTO Hashtag (Hashtag)
VALUES ("#so cool");

/* TEST that trigger error for file that is not an mp3 */
INSERT INTO Layer (LayerName, Length_of_Layer, FileLayer)
VALUES ("Blues Base", 30, "bluesbase.mp4");

/* TEST that trigger error for negative layer length works */
INSERT INTO Layer (LayerName, Length_of_Layer, FileLayer)
VALUES ("Sorry_Beat", -60, "sorrybeat.mp3");