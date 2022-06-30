// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFund {

    uint public target;
    uint public deadline;
    uint public minContribution;
    mapping(address => uint) public contributers;
    uint public numberOfContributers;
    uint totalRaisedAmount;
    address public manager;

    enum requestStatus
    {
        submitted,
        votingStarted,
        funded
    }

    struct Request {
        string reqName;
        address payable receipent;
        uint amount;
        requestStatus currentStatus;
        uint totalVotes;
        mapping(address => bool) voters;
    }

    uint public numberOfRequests;
    mapping(uint=>Request) public requests;

    constructor (uint _target, uint _deadline, uint _minContribution) {
        manager = msg.sender;
        target = _target;
        deadline = block.timestamp + _deadline;
        minContribution = _minContribution; // try 100 and see if it is 100 wei or 100 eth or what?
    }                                           // It is coming as wei only

    modifier onlyOwner() 
    {
        require(msg.sender == manager, "Only manager is permitted to perform this action");
        _;
    }

    modifier targetMet() 
    {
        require(totalRaisedAmount <= target, "target is already met contribution not needed");
        _;
    }

    modifier deadlineReached() 
    {
        require(block.timestamp <= deadline, "Deadline finished! contribution not needed");
        _;
    }

    modifier minContributionCheck() 
    {
        require(msg.value >= minContribution, "minimum contribution not received");
        _;
    }

    modifier onlyContributers()
    {
        require(contributers[msg.sender] > 0, "Not a contributor! cannot raise request");
        _;
    }

    modifier votingAllowedOnce(uint _requestid)
    {
        require (requests[_requestid].voters[msg.sender] == false, "Voting for a fund request allowed only once");
        _;
    }

    modifier validRequest(uint _requestid)
    {
        require (_requestid < numberOfRequests, "InvalidRequest id");
        _;
    }

    function contributeEth() external payable targetMet deadlineReached minContributionCheck {
        if(contributers[msg.sender] == 0)
        {
            numberOfContributers++;
        }
        contributers[msg.sender] += msg.value;
        totalRaisedAmount += msg.value;
    }

    function fetchContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getTotalRaisedAmount() public view returns (uint) {
        return totalRaisedAmount;
    }

    function refund() external onlyContributers {
        require((totalRaisedAmount >= target || block.timestamp >= deadline),"amount insufficient");
        address payable user = payable(msg.sender);
        user.transfer(contributers[msg.sender]);
        totalRaisedAmount -= contributers[msg.sender];
        contributers[msg.sender] = 0;
        delete contributers[msg.sender];
        numberOfContributers --;
    }


   function fundRequest(uint _amount, address payable _receipent, string memory _reqName) public onlyOwner {

        require((totalRaisedAmount >= target || block.timestamp >= deadline), "target or deadline not met"); // make it require because if deadline not reached and target not reached still fund request created
        require(totalRaisedAmount >= _amount, "We dont have enough funds to cater this request");
        // requests.push(Request(_reqName,_receipent,_amount,requestStatus.submitted,0));
        // https://ethereum.stackexchange.com/questions/87451/solidity-error-struct-containing-a-nested-mapping-cannot-be-constructed
        // the above will not work as we cannot construct struct containing map like that. So we need to use below method.

        Request storage newreq = requests[numberOfRequests];
        numberOfRequests++;
        newreq.amount = _amount;
        newreq.receipent = _receipent;
        newreq.reqName = _reqName;
        newreq.currentStatus = requestStatus.submitted;
        newreq.totalVotes = 0;
    }
 

    function vote(uint requestid) public onlyContributers validRequest(requestid) votingAllowedOnce(requestid) payable {
        require(totalRaisedAmount >= target, "We dont have enough funds to cater this request.Please do some contribution");
        require((requests[requestid].currentStatus != requestStatus.funded),"Already funded");
        requests[requestid].voters[msg.sender] = true;
        requests[requestid].totalVotes++;
        requests[requestid].currentStatus = requestStatus.votingStarted;
        if(requests[requestid].totalVotes > numberOfContributers/2)
        {
            makePayment(requestid);
            requests[requestid].currentStatus = requestStatus.funded;
            totalRaisedAmount -= requests[requestid].amount;
        }
    }

    function makePayment(uint _requestid) private {
        address payable receiver = requests[_requestid].receipent;
        receiver.transfer(requests[_requestid].amount);
    }

}