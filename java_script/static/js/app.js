// from data.js
var tableData = data;
var filter_format = "andFilt"


/*
Function used to update the table
*/
function tableInit(my_data) {
    // Find the table
    // Use D3 to select the table
    var table = d3.select("#ufo-table");
    //Remove the las tbody to avoid unwanted data
    var my_tbody = table.select('tbody');
    my_tbody.remove();
    //Create e new tbody entity to append the data
    var tbody = table.append("tbody");
    // Build the table
    my_data.forEach((sighting) => {
        var row = tbody.append("tr");
        Object.entries(sighting).forEach(([key, value]) => {
        var cell = row.append("td");
        cell.text(value);
        });
    });
}

/*
Function used to calculate and condition for filter
if the input is not define the condition will be ignored
returning true for further logical condition
*/
function andCond(input, data){
  var flag = false;
  if(input){
    if(data === input){
      flag = true;
    }
  }else {
    flag = true;
  }
  return flag;
}

/*
Function used to calculate or condition for filter
if the input is not define the condition will be ignored
returning true for further logical condition
*/
function orCond(input, data){
  var flag = false;
  if(input){
    if(data === input){
      flag = true;
    }
  }
  return flag;
}

//Used for dropdoen menu to update the filter format
function getData(dataset) {
  filter_format=dataset;
}


  // Select the submit button
var submit = d3.select("#filter-btn");

//Action on button click
submit.on("click", function() {
  // Prevent the page from refreshing
  d3.event.preventDefault();
  //-------------------------------
  //Get the data form the form
  //-------------------------------
  //[-] Date/Time
  var inputElement = d3.select("#datetime");
  var inputDate = inputElement.property("value");
  //[-] City
  inputElement = d3.select("#city");
  var inputCity = inputElement.property("value");
  //[-] State
  inputElement = d3.select("#state");
  var inputState = inputElement.property("value");
  //[-] Country
  inputElement = d3.select("#country");
  var inputCountry = inputElement.property("value");
  //[-] Shape
  inputElement = d3.select("#shape");
  var inputShape= inputElement.property("value");
  //-------------------------------
  //Check the filter format
  if(filter_format === "andFilt"){
    //Filter anding the conditions
    var filteredData = tableData.filter(sighting => {
      var dateFlag = andCond(inputDate, sighting.datetime);
      var cityFlag = andCond(inputCity, sighting.city);
      var stateFlag = andCond(inputState, sighting.state);
      var countryFlag = andCond(inputCountry, sighting.country);
      var shapeFlag = andCond(inputShape, sighting.shape);
      return dateFlag && cityFlag && stateFlag && countryFlag && shapeFlag;
    });
  } else {
    var filteredData = tableData.filter(sighting => {
      //Filter anding the conditions
      var dateFlag = orCond(inputDate, sighting.datetime);
      var cityFlag = orCond(inputCity, sighting.city);
      var stateFlag = orCond(inputState, sighting.state);
      var countryFlag = orCond(inputCountry, sighting.country);
      var shapeFlag = orCond(inputShape, sighting.shape);
      return dateFlag || cityFlag || stateFlag || countryFlag || shapeFlag;
    });
  }
  tableInit(filteredData);
});

tableInit(tableData);