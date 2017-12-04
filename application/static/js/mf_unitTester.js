/*
	mf_unitTester.js
	
	version			: 0.0.1
	last updated	: 14.11.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This tests if mf_Tool is working correctly
		How to use it?
			TODO: ...
		What is new?
			...
*/

function mf_tool_getNextInterval_test(){
	var testNr = 0;
	var range;
	var date;
	
	//
	range = Tool.getNextInterval(new Date("Mon oct 06 2017 00:00"), false,
		interval = {
			yearInterval: {start: new Date("25 oct 2018"), modulus: 2},
			monthInterval: null,
			monthNrInYear: 2,
			weekInterval: null,
			weekNrInMonth: 1,
			weekNrInYear: null,
			dayInterval: null,
			dayNrInWeek: null,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("Mon Mar 05 2018").getTime() &&
			new Date(range.end).getTime() != new Date("Mon Mar 12 2018").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	//
	range = Tool.getNextInterval(new Date("Mon oct 06 2017 00:00"), false,
		interval = {
			yearInterval: null,
			monthInterval: {start: new Date("30 oct 2017"), modulus: 2},
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: 1,
			weekNrInYear: null,
			dayInterval: null,
			dayNrInWeek: 0,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("Mon Oct 09 2017").getTime() &&
			new Date(range.end).getTime() != new Date("Tue Oct 10 2017").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	// skip to second week if day doesn't exist in first week test
	range = Tool.getNextInterval(new Date("Mon oct 06 2017 00:00"), false,
		interval = {
			yearInterval: null,
			monthInterval: {start: new Date("30 oct 2017"), modulus: 2},
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: 0,
			weekNrInYear: null,
			dayInterval: null,
			dayNrInWeek: 3,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("Thu Dec 07 2017").getTime() &&
			new Date(range.end).getTime() != new Date("Fri Dec 08 2017").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	// day in first day of month test
	range = Tool.getNextInterval(new Date("dec 02 2017 00:00"), false,
		interval = {
			yearInterval: null,
			monthInterval: {start: new Date("30 oct 2017"), modulus: 2},
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: 0,
			weekNrInYear: null,
			dayInterval: null,
			dayNrInWeek: 4,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("Fri Feb 02 2018").getTime() &&
			new Date(range.end).getTime() != new Date("Sat Feb 03 2018").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	//
	range = Tool.getNextInterval(new Date("dec 28 2018 00:00"), false,
		interval = {
			yearInterval: {start: new Date("30 oct 2017"), modulus: 1},
			monthInterval: null,
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: null,
			weekNrInYear: 0,
			dayInterval: null,
			dayNrInWeek: null,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("Mon Jan 07 2019").getTime() &&
			new Date(range.end).getTime() != new Date("Mon Jan 14 2019").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	//
	range = Tool.getNextInterval(new Date("dec 28 2017 00:00"), false,
		interval = {
			yearInterval: {start: new Date("30 oct 2017"), modulus: 1},
			monthInterval: null,
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: null,
			weekNrInYear: 0,
			dayInterval: null,
			dayNrInWeek: null,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("Mon Jan 01 2018").getTime() &&
			new Date(range.end).getTime() != new Date("Mon Jan 08 2018").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	//
	range = Tool.getNextInterval(new Date("dec 28 2017 00:00"), false,
		interval = {
			yearInterval: {start: new Date("30 oct 2017"), modulus: 1},
			monthInterval: null,
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: null,
			weekNrInYear: 1,
			dayInterval: null,
			dayNrInWeek: null,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("Mon Jan 08 2018").getTime() &&
			new Date(range.end).getTime() != new Date("Mon Jan 15 2018").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	//
	range = Tool.getNextInterval(new Date("dec 28 2017 00:00"), false,
		interval = {
			yearInterval: {start: new Date("30 oct 2017"), modulus: 1},
			monthInterval: null,
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: null,
			weekNrInYear: 0,
			dayInterval: null,
			dayNrInWeek: 1,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("Mon Jan 02 2018").getTime() &&
			new Date(range.end).getTime() != new Date("Mon Jan 3 2018").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	// detectInProgress test 20 hours in
	range = Tool.getNextInterval(new Date("03 jan 2017 20:00"), true,
		interval = {
			yearInterval: {start: new Date("03 jan 2017"), modulus: 1},
			monthInterval: null,
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: null,
			weekNrInYear: 0,
			dayInterval: null,
			dayNrInWeek: 1,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("03 jan 2017").getTime() &&
			new Date(range.end).getTime() != new Date("04 jan 2017").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	// detectInProgress end test
	range = Tool.getNextInterval(new Date("04 jan 2017 00:00"), true,
		interval = {
			yearInterval: {start: new Date("04 jan 2017"), modulus: 1},
			monthInterval: null,
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: null,
			weekNrInYear: 0,
			dayInterval: null,
			dayNrInWeek: 1,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("03 jan 2017").getTime() &&
			new Date(range.end).getTime() != new Date("04 jan 2017").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	// detectInProgress past end test
	range = Tool.getNextInterval(new Date("04 jan 2017 00:01"), true,
		interval = {
			yearInterval: {start: new Date("04 jan 2017"), modulus: 1},
			monthInterval: null,
			monthNrInYear: null,
			weekInterval: null,
			weekNrInMonth: null,
			weekNrInYear: 0,
			dayInterval: null,
			dayNrInWeek: 1,
			dayNrInMonth: null,
			dayNrInYear: null
		}
	);
	if(new Date(range.start).getTime() != new Date("02 jan 2018").getTime() &&
			new Date(range.end).getTime() != new Date("03 jan 2018").getTime()){
		Tool.printError("Failed on test nr: " + testNr + ".");
		return false;
	}
	testNr++;
	
	return true;
}

