create or replace view MedicationInventoryView as
select
	m.medicationName,
    m.dosage,
    m.manufacturer,
    i.quantityAvailable
from
	medications m 
join
	Inventory i on m.medicationId = i.medicationId;