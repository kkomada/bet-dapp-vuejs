pragma solidity ^0.4.24;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Casino is Ownable {
  uint minBet;
  uint houseEdge; //in %
  //true+amount or false+0
  event Won(bool _status, uint _amount);

  constructor(uint _minBet, uint _houseEdge) payable public {
    require(_minBet > 0);
    require(_houseEdge <= 100);
    minBet = _minBet;
    houseEdge = _houseEdge;
  }

  function() public { //fallback
    revert();
  }

  function bet(uint _number) payable public {
    require(_number > 0 && _number <= 10);
    require(msg.value >= minBet);
    uint winningNumber = block.number % 10 + 1;

    if (_number == winningNumber) {
      uint amountWon = msg.value * (100 - houseEdge) / 10;

      if(!msg.sender.send(amountWon)) {
        revert();
      }
      emit Won(true, amountWon);
    } else {
      emit Won(false, 0);
    }
  }

  function checkContractBalance() onlyOwner public view returns(uint) {
    return address(this).balance;
  }
}
