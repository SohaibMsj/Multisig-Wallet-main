pragma solidity ^0.7.5;
pragma abicoder v2;

contract Wallet {

    address[] public owners;
    uint limit;

    constructor(address[] memory _owners, uint _limt) {
        owners = _owners;
        limit = _limt;
    }

    modifier onlyOwner() {
        bool owner = false;
        for(uint i=0; i<owners.length; i++) {
            if(owners[i] == msg.sender) {
                owner = true;
            }
        }
        require(owner == true);
        _;
    }

    function deposit() public payable {}

    struct Transfer {
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id; 
    }

    event transferRequestsCreated(uint _id, uint _amount, address _intitiator, address _receiver);
    event approvalrecived(uint _id, uint _approvals, address _approver);
    event transferApproved(uint _id);

    Transfer[] transferRequests;
    
    function createTransfer(uint _amount, address payable _receiver) public onlyOwner {
                emit transferRequestsCreated(transferRequests.length, _amount, msg.sender, _receiver);
        transferRequests.push(Transfer(_amount, _receiver, 0, false, transferRequests.length));
    }

    mapping(address => mapping(uint => bool)) approvals;

    function approve(uint _id) public onlyOwner {
        require (transferRequests[_id].hasBeenSent == false);
        require (approvals[msg.sender][_id] == false, "You have already voted");

        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++;

        emit approvalrecived(_id, transferRequests[_id].approvals, msg.sender);

        if(transferRequests[_id].approvals >= limit) {
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
            emit transferApproved(_id);
        }
    }

    function getTransferRequest() public view returns(Transfer[] memory) {
        return transferRequests;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }




}   