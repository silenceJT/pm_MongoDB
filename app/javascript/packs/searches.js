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

	$(function (){
		var stop = false;
		$.ajax({
			url: '/segments',
			type: 'GET',
			async: false,
			cache: 'true',
			dataType: 'json',
			//data: {json},
			success: function(segments) { 
				var no = 0;
				$.each(segments, function(no, segment) {
					no = no + 1;
					var $rows = $('#myTable5 tbody tr');
					for(i = 1; i <= 17; i++) {
						var colText = $(`#myTable5 tr:eq(0) td:eq(${i})`).text().toLowerCase(); // First row, find which column
						if ( colText  === segment.place.toLowerCase()) {
							var colNo = i;
							break;
						}
					}

					for(j = 1; j <= 15; j++) {
						var rowText = $(`#myTable5 tr:eq(${j}) td:eq(0)`).text().toLowerCase(); // First column, find which row
						if ( rowText  === segment.manner.toLowerCase()) {
							var rowNo = j;
							break;
						}
					}

					
					if(segment.number == 0){
						$(`#myTable5 tr:eq(${rowNo}) td:eq(${colNo})`).append('<span class="zero">' + segment.ipa + '</span>');
					}
					else{
						$(`#myTable5 tr:eq(${rowNo}) td:eq(${colNo})`).append('<span>' + segment.ipa + '</span>');
					}

					if(no == segments.length){
						stop = true;
					}
				});
			},
		});
		if(stop){
			//console.log("stoped");
			$('#chooser span').click(function(e) {
				handle_click(this);
			});
		}
	});

	//fillTable();

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
			data: `inv=${query_string}`,
			success: function(data) { 

				//console.log(data);
			}
		});
	};

	// $('#chooser span').click(function(e) {
	// 	handle_click(this);
	// });

	//handle_click(null);

	


})