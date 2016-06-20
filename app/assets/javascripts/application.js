// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.turbolinks
//= require semantic-ui
//= require_tree .
//= require Chart.bundle
//= require chartkick

$(document).ready(function() {
	$('.toggle_orange').click(function() {
		var has = $(this).hasClass("orange");
		var c = $(this).parent().parent().find(".rating");

		if (c[0] == undefined)
			$(this).parent().find(".toggle_orange").each(function(){$(this).removeClass("orange");});
		else {
			$(this).parent().parent().find(".toggle_orange").each(function(){$(this).removeClass("orange");});

			if (!has)
				c[0].innerText = parseFloat($(c[0]).attr('data-w')) + parseFloat($(this).attr('data-w'));
			else
				c[0].innerText = parseFloat($(c[0]).attr('data-w'));
		}

		if (!has)
			$(this).addClass("orange");
	});


	$('.message .close').click(function() {
		console.log('asdasdasdasd');
    	$(this).closest('.message').transition('fade');
    });
});