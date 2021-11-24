$(document).ready(function() {

	//$('#myTable1 thead tr').eq(1).hide();	//hide second row

	function arrayRemove(arr, value) { 
		return arr.filter(function(ele){ 
			return ele != value; 
		});
	}

	var inc = [];
	var exc = [];
	var query = [];
	var query_string = "";

	function handle_click(span) {
		var text = $(span).text();
		if (span != null) {
			var o = $(span);
			var oi = o.attr('f');
			if( oi == '-1'){
				$('#chooser span').each( function() {
          $(this).removeClass("yes no");
        });
        inc = [];
        exc = [];
        query = [];
			}
			else if(o.hasClass('yes')){
				exc.push(text);
				inc = arrayRemove(inc, text);
				minus_text = '-' + text;
				query.push(minus_text);
				query = arrayRemove(query, text);

				o.removeClass('yes');
				o.addClass('no');
				//console.log("inc: " + inc + " | exc: " + exc);
				//console.log("query: " + query);
			}
			else if (o.hasClass('no')){
				exc = arrayRemove(exc, text);
				minus_text = '-'+ text;
				query = arrayRemove(query, minus_text);
				o.removeClass('no');
				//console.log("inc: " + inc + " | exc: " + exc);
				//console.log("query: " + query);
			}
			else {
				inc.push(text);
				query.push(text);
				//console.log("inc: " + inc + " | exc: " + exc);
				//console.log("query: " + query);
				o.addClass('yes');
			}
		}
		console.log(query);
		query_string = query.join(" ");
		console.log(query_string);

		$("#query").val(query.join(" "));

		$.ajax({
			url: '/papuas',
			type: 'GET',
			cache: 'true',
			dataType: 'script',
			data: `language_name=&language_family=&iso=&country=&inv=${query_string}&c_compare=%3E%3D&c_size=&v_compare=%3E%3D&v_size=&total_compare=%3E%3D&total_size=`,
			success: function(data) { 

				console.log(data);
			}
		});
	}

	$('#chooser span').click(function(e) {
		handle_click(this);
	});

	//handle_click(null);

	


})