$(document).on('change', '.attendance-toggle', function() {
	 update_record({student_id: $(this).data('student-id')
						 , start_time: $(this).data('start-time')
						 , end_time: $(this).data('end-time')
						 , attending: $(this).is(':checked')});
});

function update_record(record_data)
{
	 $.ajax({
		  url: '/attendance'
		  , type: 'POST'
		  , data: record_data
	 });
}
