// from data.js
var tableData = data;


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
  // Select the submit button
var submit = d3.select("#filter-btn");

submit.on("click", function() {

  // Prevent the page from refreshing
  d3.event.preventDefault();

  // Select the input element and get the raw HTML node
  var inputElement = d3.select("#datetime");

  // Get the value property of the input element
  var inputValue = inputElement.property("value");

  console.log(inputValue);
  //console.log(people);

  var filteredData = tableData.filter(sighting => sighting.datetime === inputValue);
  console.log(filteredData);
  tableInit(filteredData);
});

tableInit(tableData);