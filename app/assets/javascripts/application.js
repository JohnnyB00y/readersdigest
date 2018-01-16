// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require_tree .


$(function(){
	$(".follow-button, .unfollow-button").on("ajax:success", function(){
		var elt = $(this);
		if ($(this).hasClass('follow-button')){
			handleFollow(elt);
		} else {
			handleUnfollow(elt);
		}
	});

	function handleFollow(btn){
		var followscount = parseInt($("#followerscount").text()) + 1;
		console.log(followscount)
		$("#followerscount").text(followscount)
		var followurl = btn.attr('href').replace("follow", "unfollow")
		btn.empty();
		btn.attr('href', followurl);
		btn.html('Unfollow');
		btn.addClass('unfollow-button');
		btn.removeClass('follow-button');
	}

	function handleUnfollow(btn){
		var followscount = parseInt($("#followerscount").text()) - 1;
		console.log(followscount)

		$("#followerscount").text(followscount)
		var unfollowurl = btn.attr('href').replace("unfollow", "follow")

		btn.empty();
		btn.attr('href', unfollowurl);
		btn.html('Follow');
		btn.addClass('follow-button');
		btn.removeClass('unfollow-button');
	}

})

