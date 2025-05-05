insert into Users (userName, contactInfo, userType) values
('Juan Mann', 'juanm@goggle.com', 'patient'),
('Joe Mama', 'jmama@compuserve.com', 'pharmacist'),
('Snow White', 'swhite@fakemail.com', 'patient');

insert into Medications(medicationName, dosage, manufacturer) values
('Atorvastatin', '100mg', 'MediCorp'),
('Levothyroxine', '200mg', 'BigPharma'),
('Metformin', '300mg', 'DrugCo');

insert into Inventory (medicationId, quantityAvailable, lastUpdated) values
(1, 100, now()),
(2, 75, now()),
(3, 50, now());

insert into Prescriptions(userId, medicationId, prescribedDate, dosageInstructions, quantity, refillCount) values
(1,1, now(), 'Take 1 per 4 hours', 10, 1),
(1,1, now(), 'Take 4 per 8 hours', 5, 2),
(1,1, now(), 'Take 3 per 24 hours', 7, 0);

call ProcessSale(1,5);
call ProcessSale(2,3);
call ProcessSale(3,4);

