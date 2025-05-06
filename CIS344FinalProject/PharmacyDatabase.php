<?php
class PharmacyDatabase {
    private $host = "localhost";
    private $port = "3306";
    private $database = "pharmacy_portal_db";
    private $user = "root";
    private $password = "YourPassword";
    private $connection;

    public function __construct() {
        $this->connect();
    }

    private function connect() {
        $this->connection = new mysqli($this->host, $this->user, $this->password, $this->database, $this->port);
        if ($this->connection->connect_error) {
            die("Connection failed: " . $this->connection->connect_error);
        }
        echo "Successfully connected to the database";
    }

    public function addPrescription($patientUserName, $medicationId, $dosageInstructions, $quantity)  {
        $stmt = $this->connection->prepare(
            "SELECT userId FROM Users WHERE userName = ? AND userType = 'patient'"
        );
        $stmt->bind_param("s", $patientUserName);
        $stmt->execute();
        $stmt->bind_result($patientId);
        $stmt->fetch();
        $stmt->close();
        
        if ($patientId){
            $stmt = $this->connection->prepare(
                "INSERT INTO prescriptions (userId, medicationId, dosageInstructions, quantity) VALUES (?, ?, ?, ?)"
            );
            $stmt->bind_param("iisi", $patientId, $medicationId, $dosageInstructions, $quantity);
            $stmt->execute();
            $stmt->close();
            echo "Prescription added successfully";
        }else{
            echo "failed to add prescription";
        }
    }

    public function getAllPrescriptions() {
        $result = $this->connection->query("SELECT * FROM  prescriptions join medications on prescriptions.medicationId= medications.medicationId");
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    
    public function MedicationInventory() {
        /*
        Complete this function to test the functionality of
        MedicationInventoryView and implement it in the server
        */
        $query = "SELECT medicationId, name, dosage, quantity FROM medications";
        $result = $this->connection->query($query);
    
        if ($result) {
            return $result->fetch_all(MYSQLI_ASSOC);
        } else {
            return [];
        }   
     }

    public function addUser($userName, $contactInfo, $userType) {
     //Write Code here

    $stmt = $this->connection->prepare(
        "INSERT INTO Users (userName, contactInfo, userType) VALUES (?, ?, ?)"
    );
    $stmt->bind_param("sss", $userName, $contactInfo, $userType);
    
    if ($stmt->execute()) {
        echo "User added successfully";
    } else {
        echo "Failed to add user: " . $stmt->error;
    }

    $stmt->close();



    }

    //Add Other needed functions here

    public function addMedication($name, $dosage, $quantity) {
        $stmt = $this->connection->prepare(
            "INSERT INTO medications (name, dosage, quantity) VALUES (?, ?, ?)"
        );
        $stmt->bind_param("ssi", $name, $dosage, $quantity);
        
        if ($stmt->execute()) {
            echo "Medication added successfully";
        } else {
            echo "Failed to add medication: " . $stmt->error;
        }
    
        $stmt->close();
    }

    public function getUserDetails($userId) {
        $stmt = $this->connection->prepare("SELECT * FROM Users WHERE userId = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $userResult = $stmt->get_result()->fetch_assoc();
        $stmt->close();
    
        $stmt = $this->connection->prepare(
            "SELECT prescriptions.*, medications.name AS medicationName
             FROM prescriptions 
             JOIN medications ON prescriptions.medicationId = medications.medicationId 
             WHERE prescriptions.userId = ?"
        );
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $prescriptions = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();
    
        $userResult['prescriptions'] = $prescriptions;
        return $userResult;
    }
    
    
}
?>
