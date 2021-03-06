function draw_bar_chart_on(element_id, attendance_data)
{
	var timeslots = ["9-11", "11-13", "13-15", "15-17", "17-19"];
	var weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri"];
	var timeslots_during_week = weekdays.map(function(day) {
		return timeslots.map(function(slot) { return day + " " + slot; });
	});

	var chart_data = weekdays.map(function(day) {
		return timeslots.map(function(slot) {
			var nr_students = 0;
			var key = day + " " + slot;
			if (key in attendance_data) {
				nr_students = attendance_data[key];
			}
			return { day: day, timeslot: slot, students: nr_students }; 
		});
	});

	var student_counts = [].concat.apply([], chart_data).map(function(datum) {
		return datum.students;
	});
	var max_students = Math.max.apply([], student_counts);

	if (max_students == 0) {
		$(element_id).append('<p>No attendance data.</p>');
		return;
	}

	var margin = {top: 20, right: 20, bottom: 30, left: 60},
	    width = 1600 - margin.left - margin.right,
	    height = 500 - margin.top - margin.bottom;

	var scaleDays = d3.scale.ordinal()
		    .domain(weekdays)
		    .rangeRoundBands([0, width]);

	var scaleTimeslots = d3.scale.ordinal()
		    .domain(timeslots)
		    .rangeRoundBands([0, scaleDays.rangeBand()]);

	var y = d3.scale.linear()
		    .domain([0, max_students])
		    .range([height, 0]);

	var xAxis = d3.svg.axis()
		    .scale(scaleTimeslots)
		    .orient("bottom");

	var yAxis = d3.svg.axis()
		    .scale(y)
		    .orient("left");

	var chart = d3.select(element_id)
		    .append("svg")
		    .attr("width", width + margin.left + margin.right)
		    .attr("height", height + margin.top + margin.bottom)
		    .append("g")
		    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	var days = chart.selectAll("g")
		    .data(chart_data)
		    .enter().append("g")
		    .attr("class", "days")
		    .attr("transform", function(d) { return "translate(" + scaleDays(d[0].day) + ")"; });

	chart.append("g")
		.attr("class", "y axis")
		.call(yAxis)
		.append("text")
		.attr("transform", "rotate(-90)")
		.attr("y", 6)
		.attr("dy", "-3.71em")
		.style("text-anchor", "end")
		.text("Students");

	chart.append("g")
		.attr("class", "grid")
		.call(yAxis
		      .tickSize(-width, 0, 0)
		      .tickFormat(""));

	var slots = days.selectAll("rect")
		    .data(function(d) { return d; })
		    .enter().append("rect")
		    .attr("class", "bar")
		    .attr("x", function(d) { return scaleTimeslots(d.timeslot); })
		    .attr("y", function(d) { return y(d.students); })
		    .attr("width", scaleTimeslots.rangeBand() - 2)
		    .attr("height", function(d) {
			    // if (d.students > 0) {
				 //    console.log(d.students);
			    // }
			    return height - y(d.students);
		    });

	days.append("g")
		.attr("class", "x axis")
		.attr("transform", function(d, i) { return "translate(0," + height + ")"; })
		.each(function(d, i) {
			var scale = d3.scale.ordinal()
				    .domain(d.map(function(slot) { return slot.timeslot; }))
				    .rangeRoundBands([0, scaleDays.rangeBand()]);

			var xAxis = d3.svg.axis()
				    .scale(scale)
				    .orient("bottom");
			
			d3.select(this).call(xAxis);
		});
}
