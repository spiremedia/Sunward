$(document).ready(function(){
$curImg = 0; // define current value

// Keyboard navigation using left and right arrows and space bar
$(document).keydown(function(event) {
	if (event.keyCode == 37) {
		// User pressed left arrow
		prevImg();
		stopSlideShow($slideShow);
		$('#play').show();
		$('#pause').hide();
	} else if (event.keyCode == 39) {
		// User pressed right arrow
		nextImg();
		stopSlideShow($slideShow);
		$('#play').show();
		$('#pause').hide();
	}
});	

// Show the preview thumb
function showPreview(imagePreviewBlock, imageWidth, imageHeight, imageUrl, imageTitle, imageAlt) {
	$(imagePreviewBlock).html("<img src=\"" + imageUrl + "\" title=\"" + imageTitle + "\" alt=\"" + imageAlt + "\" />").fadeIn();
}
// Hide the preview thumb
function hidePreview(imagePreviewBlock) {
	$(imagePreviewBlock).hide();
	$(imagePreviewBlock + ' img').remove();
}
// Update the image src and image title
function switchImg(imageElement, imageTitleElement, imageDescElement, imageUrl, imageTitle, imageDesc) {
	//$(imageElement).hide();
	$(imageElement).hide().attr({'src': imageUrl, 'title': imageTitle});
	//$(imageElement).fadeIn('slow');
	// Update header with title of image
	$(imageTitleElement).html(imageTitle);
	$(imageDescElement).html(imageDesc);
	// Hide the preview once element is clicked
	hidePreview('#previewBlock');
}
// Update image src based on current image
function switchCurImg(imageUrl) {
	// Update image src based on current image
	switchImg('#largeBlock img', '#largeBlock h2', '#largeBlock p', $arrayImages[imageUrl], 'imageTitleHere', 'imageDescriptionHere');
	//alert ($arrayLinks.length);
	activateClass('#thumbnailBlock ul li a', 'selected', $arrayLinks[imageUrl]);
}
// Update current image class
function activateClass(removeElement, className, addElement) {
	// Activate target link and deactivate others
 	$(removeElement).removeClass(className);
	$(addElement).addClass(className);
}
// Switch to next image
function nextImg() {
	if ($curImg >= $arrayImagesLength - 1) {
		var $thisCurImg = $curImg;
		stopSlideShow($slideShow);
	} else {
		var $thisCurImg = $curImg += 1;
	}
	if($slideShow) {
		stopSlideShow($slideShow);
	}
	if ($playSlideShowGo) {
		//$slideShow = setTimeout('nextImg()', $slideShowSpeed);
	}
	switchCurImg($thisCurImg);
	// Add 1 to current image
	$thisNewCurImg = $thisCurImg += 1;
	// Get the value of the rel attribute
	$thisCurImgLinkRel = $('#'+$thisNewCurImg).attr('rel');
	// Update image link
	$('#photo_link').val("?album_id=&picture_id="+$thisCurImgLinkRel);
}
// Switch to previous image
function prevImg() {
	if ($curImg < 1) {
		$thisCurImg = $curImg;
	} else {
		$thisCurImg = $curImg - 1;
	}
	if($playSlideShowGo) {
		stopSlideShow($slideShow);
		$('#play').show();
		$('#pause').hide();
	}
	switchCurImg($thisCurImg);
	// Add 1 to current image
	$thisNewCurImg = $thisCurImg + 1;
	// Get the value of the rel attribute
	$thisCurImgLinkRel = $('#'+$thisNewCurImg).attr('rel');
	// Update image link
	//$('#photo_link').val("?album_id=&picture_id="+$thisCurImgLinkRel);
}
// Play slideshow
function playSlideShow() {
	$slideShow = setTimeout('nextImg()', $slideShowSpeed);
}
// Stop slideshow
function stopSlideShow(slideShow) {
	clearTimeout(slideShow);
}

function displayResponse() {
	$('#responseMessage').fadeIn(1000);
	$('#submitItems').fadeIn(1500);
}
function bringBack() {
	$('#formContainer').slideDown();
}


// Do preview thumbnail
/* $('#thumbnailBlock ul li a').hover(function() {
	// Assign value of the link target
 	$thisImageUrl = $('> img', this).attr('rel');
	// Assign value of the image title
 	$thisImageTitle = $('> img', this).attr('title');
	// Assign value of the image title
 	$thisImageAlt = $('> img', this).attr('alt');
	// Assign width
 	$thisImageWidth = $($thisImageUrl).width();
	// Assign height
 	$thisImageHeight = $($thisImageUrl).height();
	// Update image src
	showPreview('#previewBlock', $thisImageWidth, $thisImageHeight, $thisImageUrl, $thisImageTitle, $thisImageAlt);
}, function() {
	hidePreview()
}); */

// Thumbnail links
$('#thumbnailBlock ul li a').click(function() {
	// Assign value of the link target
 	$thisLink = $(this);
	// Get the value of the rel attribute
	$thisLinkRel = $(this).attr('rel');
	// Assign value of the link target
 	$thisImageUrl = $(this).attr('href');
	// Assign value of the image title
 	$thisImageTitle = $('> img', this).attr('title');
 	$thisImageDesc = $('> img', this).attr('alt');
	$curImg = parseInt($(this).attr('id')) - 1;
	stopSlideShow($slideShow);
	$('#play').show();
	$('#pause').hide();
	// Show target link and hide others
	//updateClass('#thumbnailBlock ul li a', 'selected', this.addElement);
	$('#thumbnailBlock ul li a').removeClass('selected');
	$(this).addClass('selected');
	// Add the vale to the image link field
	$('#photo_link').val("?album_id=&picture_id="+$thisLinkRel);
	//$('#photo_link').val($thisLinkRel);
	// Update image src
	switchImg('#largeBlock img', '#largeBlock h2', '#largeBlock p', $thisImageUrl, $thisImageTitle, $thisImageDesc);
	return false;
});
// Loads updated image
$('#largeBlock img').load(function() {
	$('#largeBlock img:hidden').fadeIn('medium', function() {
		if($slideShow) {
			stopSlideShow($slideShow);
		}
		if ($playSlideShowGo) {
			$slideShow = setTimeout('nextImg()', $slideShowSpeed);
		}
	});
});

// Link events
$('#next').click(function() {
	nextImg(); 
	if ($slideShow) {
		stopSlideShow($slideShow);
		$('#play').show();
		$('#pause').hide();
	}
	return false;
});
$('#previous').click(function() {
	prevImg();
	if ($slideShow) {
		stopSlideShow($slideShow);
		$('#play').show();
		$('#pause').hide();
	}
	return false;
});
$('#play').click(function() {
	$playSlideShowGo = true;
	nextImg();
	$('#pause').show();
	$('#play').hide();
	return false;
});
$('#pause').click(function() {
	stopSlideShow($slideShow);
	$('#play').show();
	$('#pause').hide();
	return false;
});

// Send to friend form
$('#sendToFriendLink').click(function() {
	$('#sendToFriendForm').slideDown();
	stopSlideShow($slideShow);
	$('#play').show();
	$('#pause').hide();
	return false;
});
// Send to friend form
$('#cancelSend').click(function() {
	$('#sendToFriendForm').slideUp();
	$('#responseMessage').fadeOut();
	setTimeout("bringBack()", 400);
	return false;
});
// Send to friend form
$('#closeSend').click(function() {
	$('#sendToFriendForm').slideUp();
	$('#responseMessage').fadeOut();
	setTimeout("bringBack()", 400);
	return false;
});
// Send to friend form
$('#closeSuccess').click(function() {
	$('#sendToFriendForm').slideUp();
	$('#responseMessage').fadeOut();
	setTimeout("bringBack()", 400);
	return false;
});
// Send to friend form
$('#tryAgainLink').click(function() {
	$('#sendToFriendForm').slideDown();
	$('#responseMessage').fadeOut();
	setTimeout("bringBack()", 400);
	return false;
});


	// Set slideShowSpeed (milliseconds)
	$slideShowSpeed = 3500;
	$playSlideShowGo = false;
	$slideShow = false;
	//$curImg = 0; // define current value
	
	$('#sendToFriendForm').hide();
	//$('##play').show();
	$('#pause').hide();
	
	$('#loadingMessage').hide();
	$('#responseMessage').hide();
	
	
	$arrayLinks = $('#thumbnailBlock ul li a'); // Create an array of the links
	$arrayImages = $arrayLinks.get(); // Create an array of the image urls
	$arrayImagesLength = $arrayImages.length; // Total number of elements in array $arrayImages
	
	// Assign first thumbnail a class of selected on document load
	$('#thumbnailBlock ul li a:first').addClass('selected'); 

// Ajax response
function finishAjax(id, response) {
	$('#loadingMessage').hide();
	$('#formContainer').slideUp();
	setTimeout("displayResponse()", 400);
	$('#'+id).html(unescape(response));
	$('#'+id).fadeIn();
} //finishAjax

	$('#sendToFriendForm form').bind('submit',function(){
		var params = $(this).serialize();
		$('#loadingMessage').fadeIn('slow');
		$('#submitItems').hide();
		$.ajax({
			type: "POST",
			url: "/submit.cfm",
			data: params,
			//data: ,
			error: function(response){
					$('#addResult').html(unescape(response));
			},
			success: function(response){
					$('#loadingMessage').hide();
					$('#formContainer').slideUp();
					$('#responseMessage').fadeIn(1000);
					$('#submitItems').fadeIn(1500);
					$('#addResult').html(unescape(response));
					$('#addResult').fadeIn();
			}
		});
		return false;
	});
});