DELIMITER $$

CREATE PROCEDURE AddOrUpdateUser(

IN p_userId INT,
IN p_userName VARCHAR(45),
IN p_contactInfo VARCHAR(200),
IN p_userType ENUM('pharmacist', 'patient')

)

BEGIN

IF p_userId IS NULL THEN
INSERT INTO Users (userName, contactInfo, userType)
VALUES (p_userName, p_contactInfo, p_userType);
ELSE
UPDATE Users
SET userName = p_userName,
contactInfo = p_contactInfo,
userType = p_userType
where userId = p_userId;
end if;
end$$
delimiter ;
