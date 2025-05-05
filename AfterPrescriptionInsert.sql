delimiter $$

create trigger AfterPrescriptionInsert
after insert on Prescriptions
for each row
begin

update Inventory
set quantityAvailable = quantityAvailable - new.quantity,
lastUpdated = now()
where medicationId = new.medicationId;

if(select quantityAvailable from Inventory where medicationId = new.medicationId) < 10 then
signal sqlstate '45000'
set message_text = 'Warning: low stock!';
end if;
end$$

delimiter ;