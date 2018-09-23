pragma solidity ^0.4.21;

contract Raffle {

  uint winning_number;
  address owner;
  uint ticket_price;
  uint ticket_amount = 0;
  mapping (uint => address) Player_Tickets;
  mapping(address => uint)  Tickets_Owned;

  modifier OwnerAccess() {
    require(msg.sender == owner);
    _;
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

  function endRaffle() public OwnerAccess  {
    winning_number = GenerateNumber();
    emit RaffleEnded(winning_number, Player_Tickets[winning_number]);
    selfdestruct(Player_Tickets[winning_number]);
  }

  function GenerateNumber() private constant returns(uint) {
    return uint256(keccak256(block.timestamp))%ticket_amount;
  }

}
