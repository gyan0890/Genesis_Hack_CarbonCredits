pragma solidity ^0.5.4;
pragma experimental ABIEncoderV2;

contract Investment {
    
    struct Investor{
        uint investorId;
        string subRegion;
        uint numSolarPanels;
        uint investmentAmount;
        bool closed;
    }
    
    mapping (address => Investor) investors;
    address payable[]  public investorAccts;
    mapping(address => string) investorRegion;
    
    
    uint vendorId;
    
    constructor(address payable _address, uint _investorId, 
    uint _vendorId, string memory _subRegion, uint _numSolarPanels) public {
        Investor memory investor = investors[_address];
        investorRegion[_address] = _subRegion;
        investor.investorId = _investorId;
        investor.subRegion = _subRegion;
        investor.numSolarPanels = _numSolarPanels;
        investor.investmentAmount = _numSolarPanels*29;
        vendorId = _vendorId;
        investor.closed = false;
        
        investors[_address] = investor;
        investorAccts.push(_address) -1;
    }

    function amountInvested(address _address) public view
    returns(uint) {
        
            Investor memory investor = investors[_address];
            return investor.investmentAmount;
            
    }   
    
    function addInvestor(address payable _address, uint _investorId, 
    uint _vendorId, string memory _subRegion, uint _numSolarPanels) public {
        Investor memory investorNew = investors[_address];
        investorRegion[_address] = _subRegion;
        investorNew.investorId = _investorId;
        investorNew.subRegion = _subRegion;
        investorNew.numSolarPanels = _numSolarPanels;
        investorNew.investmentAmount = _numSolarPanels*29;
        vendorId = _vendorId;
        investorNew.closed = false;
        
        investors[_address] = investorNew;
        investorAccts.push(_address);
    }
    
    function compareStrings (string memory a, string memory b) public pure 
       returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );

       }
    
    function updateActivePanels(uint _activePanels, string memory _subRegion) public view {
        for(uint i = 0; i < investorAccts.length; i++){
            Investor memory investor = investors[investorAccts[i]];
            if(compareStrings(investor.subRegion,_subRegion)){
                investor.numSolarPanels = _activePanels;
            }
        }
    }
    
    function ifInvestorClosed(string memory _subRegion) public view returns(address payable) {
        for(uint i = 0; i < investorAccts.length; i++){
            Investor memory investor = investors[investorAccts[i]];
            if(compareStrings(investor.subRegion, _subRegion)) {
                if(investor.numSolarPanels == 0) {
                    investor.closed = true;
                    return(investorAccts[i]);
                }
                
            }
        }    
        
    }
    
    
    
}


contract Readings is Investment {
    string subRegion;
    uint activePanels;
    uint energyConsumed;
    
    Investment ic;
    
    mapping(string => uint) panelsRemaining;
    mapping(string => uint) energyPerRegion;
    
    constructor(string memory _subRegion, uint _activePanels, uint _energyConsumed) public{
        subRegion = _subRegion;
        activePanels = _activePanels;
        energyConsumed = _energyConsumed;
        
        energyPerRegion[_subRegion] += _energyConsumed;
        panelsRemaining[_subRegion] = activePanels;

    }
    
    function getEnergyPerRegion(string memory region) public view returns(uint){
        return energyPerRegion[region];
    }
    
    function updateEnergyConsumed(string memory _subRegion, uint _activePanels, 
    uint _energyConsumed ) public {
        energyPerRegion[_subRegion] += _energyConsumed;
        panelsRemaining[_subRegion] = _activePanels;
        ic.updateActivePanels(_activePanels, _subRegion);
        
    }
    
    function calculateCarbonCredits(string memory _subRegion) public {
        address payable investorAddress = ic.ifInvestorClosed(_subRegion);
        uint credits = energyPerRegion[_subRegion];
        //Paying the investors in ethere for the credits they have collected
        investorAddress.transfer(credits);
    }
    
}
