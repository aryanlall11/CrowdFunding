// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract Crowdfunding {
    uint public id = 0;
    mapping (uint => Project) public projects;

    function startProject(
        string calldata title,
        string calldata description,
        uint256 amountToRaise,
        uint256 raiseUntil
    ) external {
        uint256 deadline = block.timestamp + raiseUntil;
        Project newProject = new Project(payable(msg.sender), title, description, amountToRaise*1000000, deadline);
        projects[id] = newProject;
        id += 1;
    }  

    function getTime() external view returns (uint256)
    {
        return block.timestamp;
    }                                                                                                                               
}


contract Project {
    
    enum State {
        Unapproved,
        Fundraising,
        Expired,
        Successful
    }

    struct Request {
        string description;
        uint value;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    mapping(uint => Request) public requests;

    // State variables
    uint256 public requestLength;
    address payable public creator;
    uint256 public amountGoal;
    uint256 public raiseUntil;
    uint256 public currentBalance;
    string public title;
    string public description;
    State public state;
    mapping (address => uint) public contributions;
    uint256 public contributerCount;
    bool public activeRequest;

    // Modifier to check current state
    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    modifier restricted() {
        require(msg.sender == creator);
        _;
    }

    constructor
    (
        address payable projectStarter,
        string memory projectTitle,
        string memory projectDescription,
        uint256 goalAmount,
        uint256 deadline
    ) {
        creator = projectStarter;
        title = projectTitle;
        description = projectDescription;
        amountGoal = goalAmount;
        raiseUntil = deadline;
        currentBalance = 0;
        contributerCount = 0;
        requestLength = 0;
        state = State.Unapproved;
        activeRequest = false;
    }

    /** @dev Function to fund a certain project.
      */
    function contribute() external inState(State.Fundraising) payable {
        require(msg.sender != creator, "Creator can't contribute to the project!");
        require(!checkIfDeadlineMet(), "Contribution deadline has been crossed!");
        if(contributions[msg.sender] == 0 && msg.value > 0){
            contributerCount += 1;
        }

        contributions[msg.sender] += msg.value;
        currentBalance += msg.value;
        checkIfFundingComplete();
    }

    function createRequest(string calldata desc, uint256 value) external restricted inState(State.Successful) {
        uint256 value_scaled = value*1000000;
        require(!activeRequest, "There is already an active request!");
        require(value_scaled <= currentBalance, "Your request exceeds the available balance!");

        Request storage newRequest = requests[requestLength++];
        newRequest.description = desc;
        newRequest.value = value_scaled;
        newRequest.complete = false;
        newRequest.approvalCount = 0;
        activeRequest = true;
    }

    function approveRequest(uint idx) external inState(State.Successful) {
        Request storage request = requests[idx];
        
        require(contributions[msg.sender] > 0, "You have no contribution in this project!");
        require(!request.approvals[msg.sender], "You have already responded!");
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
        finalRequest(idx);
    }

    function finalRequest(uint idx) private inState(State.Successful) returns(bool) {
        Request storage request = requests[idx];
        // require(request.approvalCount > (contributerCount / 2), "Majority disapproves for the transaction!");
        // require(!request.complete, "Request is already completed!");
        if((request.approvalCount > (contributerCount / 2)) && !request.complete)
        {
            if(creator.send(request.value))
            {
                activeRequest = false;
                currentBalance -= request.value;
                request.complete = true;
                return true;
            }
        }
        return false;
    }

    function approve() external inState(State.Unapproved) {
        require(msg.sender != creator, "Creator can\'t approve the project!");
        state = State.Fundraising;
    }

    function checkIfDeadlineMet() public returns (bool) {
        if (block.timestamp > raiseUntil) {
            state = State.Expired;
            return true;
        }
        return false;
    }

    /** @dev Function to change the project state depending on conditions.
      */
    function checkIfFundingComplete() internal returns (bool) {
        if (currentBalance >= amountGoal) {
            state = State.Successful;
            //payOut();
            return true;
        }
        return false;
    }

    /** @dev Function to give the received funds to project starter.
      */
    function payOut() private inState(State.Successful) returns (bool) {
        if (creator.send(currentBalance)) {
            currentBalance = 0;
            return true;
        }
        return false;
    }

    /** @dev Function to retrieve donated amount when a project expires.
      */
    function getRefund() external payable inState(State.Expired) returns (bool) {
        require(contributions[msg.sender] > 0, "You have no contribution in this project!");

        uint amountToRefund = contributions[msg.sender];

        if (payable(msg.sender).send(amountToRefund)) {
            currentBalance -= amountToRefund;
            contributions[msg.sender] = 0;
            return true;
        }
        return false;
    }

    function getDetails() external view returns (
        address payable, uint256, uint256, uint256, State, uint256, uint256, bool
    ) {
        return (
            creator,
            currentBalance,
            amountGoal,
            raiseUntil,
            state,
            requestLength,
            contributerCount,
            activeRequest
        );
    }

    function isApproval(uint idx) external view returns (bool){
        return requests[idx].approvals[msg.sender];
    }
}