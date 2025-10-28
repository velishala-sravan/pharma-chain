// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PharmaChain
 * @dev A smart contract to track a drug's journey through the supply chain.
 */
contract PharmaChain {

    // Structure to hold all details about a drug
    struct Drug {
        uint drugID;
        string name;
        address manufacturer;
        address owner; // Current owner of the drug
        string stage; // e.g., "Manufactured", "Shipped", "Sold"
        string history; // A simple log of the drug's journey
    }

    // A mapping to store drugs using their ID
    // We make this public so Truffle can create a free 'getter' function
    mapping(uint => Drug) public drugs;
    
    // A counter to ensure each drug gets a unique ID
    uint public drugCounter;

    // Event to notify the frontend when a drug stage is updated
    event LogDrugStageUpdate(uint indexed _drugID, string _stage);

    // Modifier to restrict access to certain functions
    // Only the current owner of a specific drug can call a function
    modifier only_owner(uint _drugID) {
        // Check if the drug exists before checking owner
        require(drugs[_drugID].drugID != 0, "Drug does not exist.");
        // Check if the caller is the owner
        require(msg.sender == drugs[_drugID].owner, "You are not the owner of this drug.");
        _; // This means "run the rest of the function"
    }

    /**
     * @dev Function for the manufacturer to create a new drug entry.
     * @param _name The name of the drug (e.g., "Aspirin 500mg").
     */
    function addDrug(string memory _name) public {
        drugCounter++;
        
        // Save the new drug to the blockchain
        drugs[drugCounter] = Drug(
            drugCounter,
            _name,
            msg.sender, // The address of the account calling this function
            msg.sender, // Manufacturer is the first owner
            "Manufactured",
            "Drug was manufactured."
        );
        
        // Emit an event to notify the frontend
        emit LogDrugStageUpdate(drugCounter, "Manufactured");
    }

    /**
     * @dev Function to update the drug stage and transfer ownership.
     * This function uses the 'only_owner' modifier to ensure security.
     * @param _drugID The ID of the drug to update.
     * @param _newOwner The address of the new owner (e.g., distributor or pharmacist).
     * @param _newStage A string describing the new stage (e.g., "ShippedToDistributor").
     */
    function updateDrugStage(uint _drugID, address _newOwner, string memory _newStage) public only_owner(_drugID) {
        drugs[_drugID].owner = _newOwner;
        drugs[_drugID].stage = _newStage;
        
        // Append the new stage to the history string
        drugs[_drugID].history = string(abi.encodePacked(drugs[_drugID].history, " -> ", _newStage));
        
        // Emit an event for the frontend
        emit LogDrugStageUpdate(_drugID, _newStage);
    }

    /**
     * @dev Public function to get all details of a drug.
     * 'view' means it's read-only and doesn't cost any gas to call.
     * @param _drugID The ID of the drug to check.
     * @return All 6 fields of the Drug struct.
     */
    function getDrugDetails(uint _drugID) public view returns (
        uint, 
        string memory, 
        address, 
        address, 
        string memory, 
        string memory
    ) {
        // Check that the drug exists
        require(drugs[_drugID].drugID != 0, "Drug does not exist.");
        
        Drug storage drug = drugs[_drugID];
        
        return (
            drug.drugID,
            drug.name,
            drug.manufacturer,
            drug.owner,
            drug.stage,
            drug.history
        );
    }
}

