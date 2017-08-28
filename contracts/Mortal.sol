pragma solidity ^0.4.0;

import "./Owned.sol";

contract Mortal is Owned {
    function kill() {
        if (msg.sender == owner)
            selfdestruct(owner);
    }
}