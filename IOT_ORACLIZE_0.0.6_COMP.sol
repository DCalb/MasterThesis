pragma solidity ^0.4.0;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract IOT_NEW is usingOraclize {
function IOT_NEW() {
  OAR = OraclizeAddrResolverI(0x2550756bDdC90A6c1FE650E403d548F7E87A5C07);
}
    uint public SP;
    uint public status;
    uint public LLimit;
    uint public ULimit;
    address private owner = msg.sender;

event SPUpdated(, uint status);

function () payable {
}

 function balance() constant public returns (uint256) {
   return address(this).balance;
 }

  function setLimits(uint _LLimit, uint _ULimit) payable public {
   LLimit = _LLimit;
   ULimit = _ULimit;
   update();

 }

function __callback(bytes32 myid, string result) {
   if (msg.sender == oraclize_cbAddress())

  SP = parseInt (result,2);

  if (SP >= ULimit)
  status = 1;

  if(SP <= LLimit)
  status = 0;

  SPUpdated(status);

  update();

}

function update() payable {
  oraclize_query (30, "URL","json(https://api.exchangeratesapi.io/latest?base=PLN).rates[USD]");
}

   function getSP() constant public returns(uint) {
       return(SP);
   }

   function getLimit() constant public returns (uint, uint) {
      return(ULimit, LLimit);

  }

  function getStatus() constant public returns (uint) {
    return(status);
}

}
