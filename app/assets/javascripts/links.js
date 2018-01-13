$(function(){
	$(".upvote, .downvote").on("ajax:success", function(){
		var elt = $(this);
		if ($(this).hasClass('upvote')){
			handleUpvote(elt);
		} else {
			handleDownvote(elt);
		}
	});

	function handleUpvote(btn){
		var voteCount = parseInt(btn.find('span').html()) + 1;

		btn.empty();
		btn.html('<i class="fa fa-check" style="color: green;" aria-hidden="true"></i><span>'+ voteCount + '</span>');
		btn.addClass('downvote');
		btn.removeClass('upvote');
	}

	function handleDownvote(btn){
		var voteCount = parseInt(btn.find('span').html()) - 1;

		btn.empty();
		btn.html('<i class="fa fa-arrow-up" aria-hidden="true"></i><span>'+ voteCount + '</span>');
		btn.addClass('upvote');
		btn.removeClass('downvote');
	}

	$("#aa-search-input").on("keypress", function(e){

		if(e.which == 13) {
		 var query_params = $(this).val();
		 window.location.href = "/search?query="+query_params;
		}

	})
})

