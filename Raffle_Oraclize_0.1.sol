pragma solidity ^0.4.20;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Raffle is usingOraclize {

  uint winning_number;
  address owner;
  uint ticket_price;
  uint ticket_amount = 0;
  mapping (uint => address) Player_Tickets;
  mapping(address => uint)  Tickets_Owned;

  modifier OwnerAccess() {
    if(msg.sender == owner)_;
    else throw;
    }

  event RaffleEnded(uint, address);


  function Raffle(uint _ticket_price) public {
    ticket_price = _ticket_price*1 ether;
    owner = msg.sender;
  }

  function EnterRaffle() payable public {
    uint i=ticket_amount;
    uint bought_tickets = msg.value / ticket_price;
    for (i;i<=bought_tickets+ticket_amount; i++)
    Player_Tickets[i] = msg.sender;
    ticket_amount += msg.value/ ticket_price;
    Tickets_Owned[msg.sender] += bought_tickets;
  }

  function getPrice() constant public returns(uint) {
    return(ticket_price);
  }

  function getTickets() constant public returns(uint,uint){
    return (Tickets_Owned[msg.sender], Tickets_Owned[msg.sender]*100/ticket_amount);

  }

  function CheckTicket(uint _ticket) constant public returns(address) {
    return(Player_Tickets[_ticket]);
  }

  function __callback(bytes32 myid, string result) public {
    if (msg.sender != oraclize_cbAddress()) throw;
    winning_number = parseInt(result,0);
    RaffleEnded(winning_number, Player_Tickets[winning_number]);
    selfdestruct(Player_Tickets[winning_number]);

  }

  function EndRaffle() payable OwnerAccess {
    string memory string1 ="RandomInteger[{0,";
    string memory string2 = uint2str(ticket_amount-1);
    string memory string3 = "}]";
    string memory query = strConcat(string1, string2, string3);
    oraclize_query("WolframAlpha", query);
  }

}
