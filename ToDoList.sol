// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ToDoLisst {
    //----------------------------------------
    struct ToDo {
        string txt;
        bool completed;
    }
    //----------------------------------------
    address public owner;
    ToDo[] public todos;
    //----------------------------------------
    constructor() {
        owner = msg.sender;
    }
    //----------------------------------------
    modifier onlyOwner() {
        require(msg.sender == owner, "You Are Not The Owner Of The Contract.");
        _;
    }
    //----------------------------------------
    event TodoCreated(uint256 indexed index, string text);
    event TodoUpdated(uint256 indexed index, string text);
    event TodoToggled(uint256 indexed index, bool completed);
    event TodoDeleted(uint256 indexed index);
    //----------------------------------------
    //Create a task
    function create(string calldata _txt) public onlyOwner {
        require(bytes(_txt).length > 0, "Task Description Cannot Be Empty");
        todos.push(ToDo(_txt, false));
        emit TodoCreated(todos.length - 1, _txt);
    }
    //----------------------------------------
    //Title update
    //Calda replaced memory to reduce gas
    function updateTxt(uint256 _index, string calldata _txt) public onlyOwner {
        require(_index < todos.length, "Index Out Of Range");
        // String is not lenght so must be used
        require(bytes(_txt).length > 0, "Task description cannot be empty");
        //todo Local variable
        ToDo storage todo = todos[_index];
        todo.txt = _txt;
        emit TodoUpdated(_index, _txt);
    }
    //----------------------------------------
    //Task update
    function updateComp(uint256 _index) public onlyOwner {
        require(_index < todos.length, "Index Out Of Range");
        ToDo storage todo = todos[_index];
        todo.completed = !todo.completed;
        emit TodoToggled(_index, todo.completed);
    }
    //----------------------------------------
    //Delete task
    function del(uint256 _index) public onlyOwner {
        require(_index < todos.length, "Index Out Of Range");
        todos[_index] = todos[todos.length - 1];
        //Alternative to direct removal and gas reduction
        todos.pop();
        emit TodoDeleted(_index);
    }
    //----------------------------------------
    // show one task
    function get(
        uint256 _index
    ) public view returns (string memory txt, bool completed) {
        require(_index < todos.length, "Index Out Of Range");
        ToDo storage todo = todos[_index];
        return (todo.txt, todo.completed);
    }
    //----------------------------------------
    //show all task
    function getAll() public view returns (ToDo[] memory) {
        return todos;
    }
}
