pragma solidity ^0.4.0;

contract Raffle {

  uint32 winning_number;
  uint ticket_price;
  uint ticket_amount = 0;
  uint[] public Ticket_Numbers;
  mapping (address => uint) Player_Tickets;


  function Raffle(uint _ticket_price) public {
    ticket_price = _ticket_price*1 ether;

  }

  function EnterRaffle() payable public {
    uint i=ticket_amount;
    uint bought_tickets = msg.value / ticket_price;
    for (i;i<=bought_tickets; i++) {Ticket_Number[i] = msg.sender;}
    ticket_amount += msg.value/ ticket_price ether;
    Player_Tickets[msg.sendedr] += bought_tickets;
  }

function getGuess(uint _player) constant public returns(address) {
  return(Player_Guess[_player]);

}

}
