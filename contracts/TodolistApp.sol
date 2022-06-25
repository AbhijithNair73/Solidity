// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract todoApp
{
    enum taskStatus
    {
        not_started,
        in_progress,
        on_hold,
        completed
    }
    struct todo
    {
        string task_name;
        taskStatus currentStatus;
    }

    todo[] public todos;

    function addTask(string calldata _name) external
    {
        todos.push(todo({task_name: _name, currentStatus: taskStatus.not_started }));
    }

    function startTask(uint index) external{
        todos[index].currentStatus = taskStatus.in_progress;
    }

    function completeTask(uint index) external{
        todos[index].currentStatus = taskStatus.completed;
    }

    function HoldTask(uint index) external{
        todos[index].currentStatus = taskStatus.on_hold;
    }

    function checkStatus(uint index) view external returns(taskStatus){
        return todos[index].currentStatus;
    }
    
}