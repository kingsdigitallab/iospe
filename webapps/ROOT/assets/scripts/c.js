
function generateUrl(path, number, l) {
        n = number.match(/^(\d{1,3})(\.\d)?([a-j])?$/);
    	if (n != null) {
           	var addlang = l == 'ru' ? '-ru' : '';
           	var zeros = '';
           	if (n[1].length == 1) {zeros='00';}
           	else {if (n[1].length == 2) {zeros='0';}}
           		location.href = path + '/byz' + zeros + number + addlang + '.html';
    	}
    	else $('#numTxt').val("Invalid");
    }

$(document).ready(function(){

	$("ul.subnav").parent().append("<span></span>"); //Only shows drop down trigger when js is enabled - Adds empty span tag after ul.subnav
	
	$("#topnav li span").click(function() { //When trigger is clicked...
		
		//Following events are applied to the subnav itself (moving subnav up and down)
		$(this).parent().find("ul.subnav").slideDown('fast').show(); //Drop down the subnav on click

		$(this).parent().hover(function() {
		}, function(){	
			$(this).parent().find("ul.subnav").slideUp('slow'); //When the mouse hovers out of the subnav, move it back up
		});

		//Following events are applied to the trigger (Hover events for the trigger)
		}).hover(function() { 
			$(this).addClass("subhover"); //On hover over, add class "subhover"
		}, function(){	//On Hover Out
			$(this).removeClass("subhover"); //On hover out, remove class "subhover"
	});
	
	 $('ul.nvg').superfish();
	 
    $('div.inscription_text').each(function(){
        var cur_group = this;
        var tabContainers = $(cur_group).children('div');
       	tabContainers.hide().filter(':first').show();
       	
       	$(cur_group).find('ul.tabNav a').click(function () {
       		tabContainers.hide();
       		tabContainers.filter(this.hash).show();
       		$(cur_group).find('ul.tabNav a').removeClass('selected');
       		$(this).addClass('selected');
       		return false;
       	}).filter(':first').click();    
    })
    
   hljs.tabReplace = '<span class="indent">\t</span>';
    
    $('#jumpForm').submit(function(i, e){console.log(generateUrl('.',$('#numTxt').val(),lang)); return false;});
    

});