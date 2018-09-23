pragma solidity ^0.4.18;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract IOT_OPT is usingOraclize {

address owner;
address RaPi = 0x01061d85B994E3c70fb28b266E4c3DcCD3bB6d75;

modifier OwnerAccess() {
require(msg.sender == owner);
_;
}

modifier RaPiAccess(){
    require (msg.sender == RaPi);
    _;
}

enum oraclizeState { ForPesos, ForYuan, ForRupees, ForZloty }

struct oraclizeCallback {

    oraclizeState oState;

  }

mapping (bytes32 => oraclizeCallback) public oraclizeCallbacks;

function IOT_OPT () public {
owner = msg.sender;
OAR = OraclizeAddrResolverI(0x1b37EcfC92c0283f31EE1F25dF7A3f43eB37d3e5);
}

event OptCapUpdated (uint OptCapPesos, uint OptCapYuan, uint OptCapRupees, uint OptCapZloty);

event rdy4opt(string);

function () public payable {

}

uint capacity_pesos;
uint capacity_yuan;
uint capacity_rupees;
uint capacity_zloty;
uint OptCapPesos;
uint OptCapYuan;
uint OptCapRupees;
uint OptCapZloty;
string UC_pesos;
string UC_yuan;
string UC_rupees;
string UC_zloty;
uint demand;
string pesos;
string yuan;
string rupees;
string zloty;

function deposit() public payable  {

}

function balance() constant public returns(uint) {

  return address(this).balance;

}

function __callback(bytes32 myid, string result) public {

  require (msg.sender == oraclize_cbAddress());

  oraclizeCallback memory o = oraclizeCallbacks[myid];

  if (o.oState == oraclizeState.ForPesos){

      pesos = result;

  }

  else if (o.oState == oraclizeState.ForYuan){

      yuan = result;

  }

  else if (o.oState == oraclizeState.ForRupees){

      rupees = result;

  }

  else if (o.oState == oraclizeState.ForZloty){

      zloty = result;

  }

  }

function update_pesos() private  {

  bytes32 queryID = oraclize_query("URL","json(https://api.exchangeratesapi.io/latest?base=MXN).rates[USD]");

  oraclizeCallbacks[queryID] = oraclizeCallback(oraclizeState.ForPesos);

}

function update_yuan() private  {

  bytes32 queryID = oraclize_query("URL","json(https://api.exchangeratesapi.io/latest?base=CNY).rates[USD]");

  oraclizeCallbacks[queryID] = oraclizeCallback(oraclizeState.ForYuan);

}

function update_rupees() private  {

  bytes32 queryID = oraclize_query("URL","json(https://api.exchangeratesapi.io/latest?base=INR).rates[USD]");

  oraclizeCallbacks[queryID] = oraclizeCallback(oraclizeState.ForRupees);

}

function update_zloty() private  {

  bytes32 queryID = oraclize_query("URL","json(https://api.exchangeratesapi.io/latest?base=PLN).rates[USD]");

  oraclizeCallbacks[queryID] = oraclizeCallback(oraclizeState.ForZloty);

}

function getXrates() constant public returns(string,string,string,string) {
  return(pesos,yuan,rupees,zloty);
}

function getCapacities() constant public returns(uint,uint,uint,uint) {
  return(capacity_pesos, capacity_yuan, capacity_rupees, capacity_zloty);
}

function getOptCaps() constant public returns(uint,uint,uint,uint){
  return(OptCapPesos, OptCapYuan, OptCapRupees, OptCapZloty);
}

function getUC() constant public returns(string,string,string,string) {
  return(UC_pesos, UC_yuan, UC_rupees, UC_zloty);
}

function getDemand() public constant returns(uint) {

  return(demand);

}

function setCapacities(uint _CapPesos, uint _CapYuan, uint _CapRupees, uint _CapZloty) public OwnerAccess {

  capacity_pesos = _CapPesos;
  capacity_yuan = _CapYuan;
  capacity_rupees = _CapRupees;
  capacity_zloty = _CapZloty;

}

function setUnitCost(string _UC_pesos, string _UC_yuan, string _UC_rupees, string _UC_zloty) public OwnerAccess {

  UC_pesos = _UC_pesos;
  UC_yuan = _UC_yuan;
  UC_rupees = _UC_rupees;
  UC_zloty = _UC_zloty;

}

function setOptCap(uint _OptCapPesos, uint _OptCapYuan, uint _OptCapRupees, uint _OptCapZloty) public OwnerAccess {

OptCapPesos = _OptCapPesos;
OptCapYuan = _OptCapYuan;
OptCapRupees = _OptCapRupees;
OptCapZloty = _OptCapZloty;

OptCapUpdated (OptCapPesos, OptCapYuan, OptCapRupees, OptCapZloty);

}

function setDemand(uint _Demand) public OwnerAccess {

  demand = _Demand;

}

function StartUpdate() public payable RaPiAccess {
  update_pesos();
  update_yuan();
  update_rupees();
  update_zloty();
  rdy4opt ("Optimization initiated!");
}


}
