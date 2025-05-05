delimiter $$

create procedure ProcessSale(
in p_prescriptionId int,
in p_quantitySold int
)
begin
	declare v_medicationId int;
    declare v_saleAmount decimal(10,2);
    declare v_price decimal(10,2) default 10.00;
    
    select medicationId into v_medicationId
    from Prescriptions
    where prescriptionId = p_prescritionId;
    
    update Inventory
    set quantityAvailable = quantityAvailable - p_quantitySold,
    lastUpdated = now()
    where medicationId = v_medicationId;
    
    set v_saleAmount = p_quantitySold * v_price;
    
    insert into Sales (prescriptionId, saleDate, quantitySold, saleAmount)
    values (p_prescriptionId, now(), p_quantitySold, v_saleAmount);
    end$$
    
    delimiter ;