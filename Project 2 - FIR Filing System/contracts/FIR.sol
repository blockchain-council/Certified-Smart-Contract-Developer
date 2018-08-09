pragma solidity ^0.4.24;
//version of solidity

contract DIR_contract{
//name of the contract    

    address reporter;
    string name;
    string report_type;
    string desc;
    uint report_status;

    event createReportEvent(address indexed _reporter,string _name, string _report_type, string _desc);
    // an event with defining the report filed

    //function to create an  investigation report with the name of the filer, the type of report, with the report description
    // initial state of report will be 1
    function createReport(string _name, string _report_type, string _desc) public {
        reporter = msg.sender;
        name = _name;
        report_type = _report_type;
        desc = _desc;
        report_status = 1;
        emit createReportEvent(reporter,name,report_type,desc);
    }

    // function getReport() will simply display the details of the latest report filed
    // function wil display the name of the reporter, the type of report, its description and the current status
    function getReport() public view returns(
        address _reporter,string _name, string _report_type, string _desc, uint _report_status){
        return(reporter,name,report_type,desc,report_status);
    }

    // function setStatus() will simply update the status of the report filed by the reporter 
    function setStatus(uint _report_status) public{
        report_status = _report_status;
    }
}