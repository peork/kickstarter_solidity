pragma solidity ^0.4.17;


contract CampaignFactory {

    address[] public deployedCampaigns;

    function createCampaign(uint _minumumContribution) public {
        address newCampaign = new Campaign(_minumumContribution, msg.sender);
        deployedCampaigns.push(newCampaign);

    }

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {

    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint public minumumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    modifier onlyManager () {
        require(msg.sender == manager);
        _;
    }

    constructor(uint _minumumContribution, address _creator) public {
        manager = _creator;
        minumumContribution = _minumumContribution;
    }



    function contribute() public payable {
        require(msg.value > minumumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string _description, uint _value, address _recipient)
    public onlyManager{
        Request memory newRequest = Request({
        description: _description,
        value: _value,
        recipient: _recipient,
        complete: false,
        approvalCount: 0

        });
        requests.push(newRequest);
    }

    function approveRequest(uint _index) public {
        Request storage request = requests[_index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;

    }

    function finalizeRequest(uint _index) public onlyManager {
        Request storage request = requests[_index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;

    }

    function getSummary() public view returns (uint, uint, uint, uint, address) {
        return (
            minumumContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}
