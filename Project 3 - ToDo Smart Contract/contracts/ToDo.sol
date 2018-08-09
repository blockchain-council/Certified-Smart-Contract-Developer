pragma solidity ^0.4.24;


contract ToDo {
    struct Routine { //structure for storing data
        string task;
        string time;    
    }
    event LogTaskAdded(uint id, string task, string time); //logging the event after task gets added.
    
    mapping(uint => Routine) private routines;
    uint[] private ids;

    function getTaskCount() //function for getting all the task counts.
            public view
            returns (uint length) {
        return ids.length;    
    }

    function getTaskIdAt(uint index) //function for getting the task id.
            public view
            returns (uint id) {
        return ids[index];
    }

    function getTask(uint id) //function for getting the task deatail by supplying the task id.
            public view
            returns (string task, string time) {
        Routine storage routine = routines[id];
        return (
            routine.task,
            routine.time);
    }

    function addTask(uint id, string task, string time)//function for adding the task.
    public
            returns (bool successful) {
        routines[id] = Routine({
            task: task,
            time: time
        });
        ids.push(id);
        emit LogTaskAdded(id, task, time);
        return true;
    }

   
}