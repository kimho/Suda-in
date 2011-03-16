// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
	$('#suda_message').keyup(function() {
		detect_message();
	});

	$('#suda_submit_button').click(function() {
		$(this).closest('form').submit();
	})	

	$('#search_submit_button').click(function() {
		if($('#q').val().length < 1) {
			alert('Please insert a search word.');
			$('#q').focus();
			return false;
		}
		$(this).closest('form').submit();
	})	
	
	detect_message();
	detect_opt();
	
	var keyFix = new beta.fix('suda_message')
})
var detect_opt = function() {
	$("li[id^='sudas_id_']").mouseover(function() {
	  	var id = parseInt(this.id.replace("sudas_id_", ""));
		$('#opt_ul_id_'+id).addClass('visible')
	});

	$("li[id^='sudas_id_']").mouseout(function() {
	  	var id = parseInt(this.id.replace("sudas_id_", ""));
		$('#opt_ul_id_'+id).removeClass('visible')
	});
}
var detect_message = function() {
	try {
		var content_length = $('#suda_message').val().length;
		var remaining = 140 - content_length;
		$('#char_count').html(remaining);
		
		if(remaining < 140 && remaining >= 0) {
			$('#update_button').removeClass('button-disabled');
			$('#update_button').removeAttr("disabled");
		} else {
			$('#update_button').addClass('button-disabled');
			$('#update_button').attr("disabled", "disabled");
		}

		if(remaining < 21 && remaining > 9) {
			$('#char_count').removeClass('red');
			$('#char_count').addClass('dark_red');
		} else if (remaining <= 9) {
			$('#char_count').removeClass('dark_red');
			$('#char_count').addClass('red');
		} else {
			$('#char_count').removeClass('dark_red').removeClass('red');
		}
	} catch(e) {
	}
}

var reply = function(username) {
	$('#suda_message').val($('#suda_message').val() + '@'+username+' ');
	$('#suda_message').focus();
	detect_message();
}

var resuda = function(suda_id) {
	$('#suda_message').val('RS @'+$('#suda_user_id_'+suda_id).text()+': '+$('#suda_message_id_'+suda_id).text());
	$('#suda_message').focus();
	detect_message();
}

var delsuda = function(suda_id) {
	$.getJSON(
		"/del_suda/" + suda_id, 
		function(json){
			if(json.code!='success') {
				alert(json.msg);
			} else {
				setTimeout(function(){$('#sudas_id_'+ json.id).slideUp('slow');},300);
			}
		}
	);
}

var current_page = 2;
var more_suda = function() {
	$.ajax({
		type: "GET",
		url: "/more_suda/" + current_page,
		success: function(result) {
			$('#sudas_list').append(result);
			current_page = current_page + 1;
			detect_opt();
		}
	});
}
var more_all_suda = function() {
	$.ajax({
		type: "GET",
		url: "/more_all_suda/" + current_page,
		success: function(result) {
			$('#sudas_list').append(result);
			current_page = current_page + 1;
			detect_opt();
		}
	});
}
var more_show_suda = function(username) {
	$.ajax({
		type: "GET",
		url: "/more_suda/" + username + "/" + current_page,
		success: function(result) {
			$('#sudas_list').append(result);
			current_page = current_page + 1;
			detect_opt();
		}
	});
}

var more_search_suda = function(q) {
	$.ajax({
		type: "GET",
		url: "/more_search_suda/" + current_page + "?q=" + q,
		success: function(result) {
			$('#sudas_list').append(result);
			current_page = current_page + 1;
			detect_opt();
		}
	});
}

var remove_friend = function(name) {
	$.ajax({
		type: "POST",
		url: "/remove_friend/" + name,
		success: function(id) {
			alert('#btn_follow_'+ id);
			elm = $('#btn_follow_'+ id);
			elm.slideup('slow');
		}
	});
}

var toggle_follow_ajax = function(name) {
	$.ajax({
		type: "POST",
		url: "/" + name + "/toggle_follow_via_ajax",
		success: function(id) {
			elm = $('#btn_follow_'+ id);
			if(elm.val()=="You are Following!") {
				elm.val("Follow");
			} else {
				elm.val("You are Following!");
			}
		}
	});
}