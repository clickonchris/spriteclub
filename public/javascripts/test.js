var onload = [];
onload.push(function() {Facebook.streamPublish();});
function promptPublish(contest_id, contestant_id, photo_url, post_to_user_id) {
	var attachment = { 
    'name': 'Sprite Club Challenge', 
    'href': '/spriteclub-dev/contests/67/'+contest_id, 
    'caption': '{*actor*} Thinks their kid is cuter than your kid', 
    'description': 'Sprite Club is a social application where users children(sprites) ' +
					'compete for rank as the best sprite on the internet', 
    'properties': {}, 
    'media': [{ 
        'type': 'image', 
        'src': 'photo_url', 
        'href': '/spriteclub-dev/contestants/67/'+contestant_id }] 
	}; 
	Facebook.streamPublish("I have the cutest kid",attachment,null,post_to_user_id);
}

// if the prompt_publish contestant exists, prompt the user to publish

	//alert ("hey");
	//new Dialog().showMessage("sup");
	promptPublish(67
					,30,'/assets/contestants/30/small/horse.gif?1268023809',3);



//the very last thing on the page
for(var a = 0;a < onload.length;a++) {onload[a]();}
//-->
