function buildGauge(freq)
{

	//Erase the previos table
	Plotly.purge("gauge");
	var level = freq;

	//Avoid nukks for the math operations
	if ( level == null )
	{
		level = 0;
	} else if ( level > 9 ) {
		level = 9;
	}

	//The data look skewd in th egraph afte rthe degree calulation; Therfore, I
	//defined levels for each pie partition and calculate fractions base don teh diference
	//between each section
	var truncated = Math.trunc(level);
	var decimals = level %1 ;
	//Value per index
	//								  0    1    2	 3   4   5   6   7   8  9
	var needle_base = new Array(	180, 155, 132, 113, 97, 82, 68, 49, 25, 0);
	var needle_diff = new Array(	needle_base[0]-needle_base[1],
									needle_base[1]-needle_base[2],
									needle_base[2]-needle_base[3],
									needle_base[3]-needle_base[4],
									needle_base[4]-needle_base[5],
									needle_base[5]-needle_base[6],
									needle_base[6]-needle_base[7],
									needle_base[7]-needle_base[8],
									needle_base[8]-needle_base[9],
									0);
	//Degrees calculation
	var degrees = needle_base[truncated] - (decimals * needle_diff[truncated]);
	radius = .5;
	var radians = degrees * Math.PI / 180;
	var x = radius * Math.cos(radians);
	var y = radius * Math.sin(radians);


	// Path parameter creation
	var mainPath = 'M -.0 -0.035 L .0 0.035 L ',
	     pathX = String(x),
	     space = ' ',
	     pathY = String(y),
	     pathEnd = ' Z';

   	//Path definition for the neddle 
	var path = mainPath.concat(pathX,space,pathY,pathEnd);

	//Data drawing
	var data = [{ type: 'category',
	   x: [0], y:[0],
	    marker: {size: 28, color:'850000'},
	    showlegend: false,
	    name: 'speed',
	    text: level,
	    hoverinfo: 'text+name'},
	  { values: [20,20,20,20,20,20,20,20,20, 180],
	  rotation: 90,
	  text: ['0-1', '1-2', '2-3', '3-4','4-5', '5-6', '6-7', '7-8', '8-9',''],
	  textinfo: 'text',
	  textposition:'inside',      
	  marker: {colors:[	'rgba(169, 223, 191, .9)',
	  					'rgba(162, 217, 206, .9)',
	  					'rgba(163, 228, 215, .9)',
	  					'rgba(174, 214, 241, .9)',
	  					'rgba(169, 204, 227, .9)',
	  					'rgba(210, 180, 222, .9)',
	  					'rgba(215, 189, 226, .9)',
						'rgba(245, 183, 177, .9)',
	  					'rgba(230, 176, 170, .9)',
	                    'rgba(255, 255, 255, 0)']},
	  labels: ['0-1', '1-2', '2-3', '3-4','4-5', '5-6', '6-7', '7-8', '8-9'],
	  hoverinfo: 'label',
	  direction: "clockwise",
	  hole: .5,
	  type: 'pie',
	  showlegend: false
	}];

	//Layout definition
	var layout = {
	  shapes:[{
	      type: 'path',
	      path: path,
	      fillcolor: '850000',
	      line: {
	        color: '850000'
	      }
	    }],
		title: 'Belly Button Washing Frequncy',
		height: 500,
		width: 600,
		xaxis: {type:'category',zeroline:false, showticklabels:false,
		            showgrid: false, range: [-1, 1]},
		yaxis: {type:'category',zeroline:false, showticklabels:false,
		            showgrid: false, range: [-1, 1]}
	};

	//Draw the plot
	Plotly.plot("gauge",data,layout);
}
