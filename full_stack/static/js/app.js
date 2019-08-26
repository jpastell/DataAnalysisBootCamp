function buildMetadata(sample) {

  //Complete the following function that builds the metadata panel
  var selector = d3.select("#sample-metadata");

  // Logic to update the data
  metaURL = '/metadata/'
  var sampleMetaURL = metaURL.concat(sample);
  d3.json(sampleMetaURL).then((meta) => {
    //Cleaning previos entries
    selector.html("")
    //Display the new data
    for (var key in meta) {
        //console.log(key, meta[key]);
        //selector.append("p").attr('class', 'card-text').append("small").text(key+":\n"+meta[key]);
        selector.append("p").attr('class', 'card-text').text(key+":\n"+meta[key]);
    }
  });

    // BONUS: Build the Gauge Chart
    // buildGauge(data.WFREQ);
}

function buildCharts(sample) {

  // @TODO: Use `d3.json` to fetch the sample data for the plots

  // @TODO: Build a Bubble Chart using the sample data

  // @TODO: Build a Pie Chart
  // HINT: You will need to use slice() to grab the top 10 sample_values,
  // otu_ids, and labels (10 each).

  //Clear the previos plot
  Plotly.purge("pie");
  dataURL = '/samples/'
  var sampleURL = dataURL.concat(sample);
  d3.json(sampleURL).then((data) => {
      //var layout = { margin: { t: 0 } }
      outIds = data.otu_ids.slice(0,10);
      sampVal = data.sample_values.slice(0,10);
      outLabels = data.otu_labels.slice(0,10);
      var pieTrace = {
        values : sampVal,
        labels:outIds,
        hoverinfo:"text",
        hovertext:outLabels,
        type: 'pie'
      };

      //console.log(slicedData);
      Plotly.plot("pie", [pieTrace]);
  });
}

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
