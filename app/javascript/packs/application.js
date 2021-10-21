// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

//import  "/Users/jiataowu/Document/pm_MongoDB/app/javascript/stylesheets/application.scss"

require("stylesheets/application.scss")

//import "chartkick/chart.js"
//import "chartkick"
require("chartkick/chart.js")
//= require jquery
//= require jquery_ujs

$(document).ready(function() {
	
	$('.load-ajax').hide();
    $(document).ajaxStart(function() {
        $('.load-ajax').show();
   });
   $(document).ajaxStop(function() {
        $('.load-ajax').hide();
   });
	
	// Delay function for type in
	function delay(callback, ms) {
	  var timer = 0;
	  return function() {
	    var context = this, args = arguments;
	    clearTimeout(timer);
	    timer = setTimeout(function () {
	      callback.apply(context, args);
	    }, ms || 0);
	  };
	}

	// Select tag change will requery the table
	// $("#papuas_search #papuas_table select").change(function() {
 //    	$.get($("#papuas_search").attr("action"), $("#papuas_search").serialize(), null, "script");
 //    	return false;
 //  	});

	// Any input will requery the table
  	// $("#papuas_search #papuas_table input").keyup(delay(function(e) {
   //  	$.get($("#papuas_search").attr("action"), $("#papuas_search").serialize(), null, "script");
   //  	return false;
  	// }, 500));

  //sort table
  $(function() {
  	$("#myTable").tablesorter();
	});
  
    
});