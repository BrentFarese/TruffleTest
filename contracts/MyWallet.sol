pragma solidity ^0.4.0;

import "./Mortal.sol";

contract MyWallet is Mortal {
    event receivedFunds(address _from, uint256 _amount);
    event proposalReceived(address indexed _from, address indexed _to, string _reason);
    event sendMoneyPlain(address _from, address _to);
    event proposalConfirmed(uint proposal_id, uint256 _value, string _reason);

    struct Proposal {
        address _from;
        address _to;
        uint256 _value;
        string _reason;
        bool sent;
    }
    
    uint proposal_counter;
    
    mapping(uint => Proposal) m_proposals;

    function spendMoneyOn(address _to, uint256 _value, string _reason) returns (uint256) {
        if(owner == msg.sender) {
            bool sent = _to.send(_value);
            if(!sent) {
                throw;
            } else {
                sendMoneyPlain(msg.sender, _to);
                }
        } else {
            proposal_counter++;
            m_proposals[proposal_counter] = Proposal(msg.sender, _to, _value, _reason, false);
            proposalReceived(msg.sender, _to, _reason);
            return proposal_counter;
        }
    }
    
    function confirmProposal(uint proposal_id) onlyowner returns (bool) {
        Proposal storage proposal = m_proposals[proposal_id];
        if(proposal._from != address(0)) {
            if(proposal.sent != true) {
                proposal.sent = true;
                if(proposal._to.send(proposal._value)) {
                    proposalConfirmed(proposal_id, proposal._value, proposal._reason);
                    return true;
                }
                proposal.sent = false;
                return false;
            }
        }
    }
    
   function() payable {
       if(msg.value > 0) {
           receivedFunds(msg.sender, msg.value);
       }
   }
}