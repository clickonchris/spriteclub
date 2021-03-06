// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/*
 * The following two methods will continuously compute the time between now and the end date.
 * The dates are normalized to UTC.
 * 
 * The following values should be in UTC/GMT, not the users local time
 * year - year which the contest ends
 * month - the month which the contest ends (1-12)
 * day - day of the month which the contest ends
 * hour - hour of the day which the contest ends in 24h format
 * minute - minute of the hour which the contest ends.
 * second - second of the minute which the contest ends
 * 
 */
function countdown_clock(year, month, day, hour, minute,second){
	//This is a proxy function so that countdown can recursively call itself
    countdown(year, month, day, hour, minute,second);                
}
         
function countdown(year, month, day, hour, minute, second)
{
		Today = new Date();
		Todays_Year = Today.getUTCFullYear();
		Todays_Month = Today.getUTCMonth();                  
		
		//Convert both today's date and the target date into miliseconds.                           
		Todays_Date = new Date(Todays_Year, Todays_Month, Today.getUTCDate());  
		Todays_Date.setHours(Today.getUTCHours());
		Todays_Date.setMinutes(Today.getUTCMinutes());
		Todays_Date.setSeconds(Today.getUTCSeconds());
		Todays_DateTS = Todays_Date.getTime();
		Target_Date = new Date(year, month - 1, day, hour, minute, 00)
		Target_Date.setHours(hour);
		Target_Date.setMinutes(minute);
		Target_Date.setSeconds(second);   
		Target_DateTS = Target_Date.getTime();               
		
		//Find their difference, and convert that into seconds.                  
		Time_Left = Math.round((Target_DateTS - Todays_DateTS) / 1000);
		
		if (Time_Left <= 0) {
			$("#countdown")[0].innerHTML = "Time Expired";
		return;
		}
         
        //More datailed.
        days = Math.floor(Time_Left / (60 * 60 * 24));
        Time_Left %= (60 * 60 * 24);
        hours = Math.floor(Time_Left / (60 * 60));
        Time_Left %= (60 * 60);
        minutes = Math.floor(Time_Left / 60);
        Time_Left %= 60;
        seconds = Time_Left;
        
        dps = 's'; hps = 's'; mps = 's'; sps = 's';
        //ps is short for plural suffix.
        if(days == 1) dps ='';
        if(hours == 1) hps ='';
        if(minutes == 1) mps ='';
        if(seconds == 1) sps ='';
		
		//assign leading zeros
		//var zero = '0';
		var zero = '';
		sHours = hours; sMinutes = minutes; sSeconds = seconds;
		if (hours < 10) {sHours = zero + hours;}
		if (minutes <10) {sMinutes = zero + minutes;}
		if (seconds <10) {sSeconds = zero + seconds;	}
		
		var countdown = '';
        if (days >0) {
			countdown = days + ' day' + dps + ' ';
		}
		if (hours >0 || days >0) {
	        countdown += sHours + ' hour' + hps+' ';
		}
		if (minutes >0 || hours >0 || days >0) {
	        countdown += sMinutes + ' minute'+mps+' ';
		}

        countdown += sSeconds + ' second'+sps+' ';
		countdown = 'Time Remaining: ' + countdown;
		$('#countdown')[0].innerHTML = countdown;
               
         //Recursive call, keeps the clock ticking.
         setTimeout(function(){
		 	//new Dialog().showMessage("hey");
		 	countdown_clock(year,month,day,hour,minute,second);
		 	}, 1000);
}

/*
 * This method shows a popup window to prompt the user to post something to their own wall or a friend's wall
 */
function promptPublish(contest_url,photo_url,post_to_user_id) {
	//if FB api is not initialized, keep retrying until it is
	if (FB == undefined) {
		setTimeout(function() {
			promptPublish(contest_url,photo_url,post_to_user_id);
		},200);
		return;
	}
	var publish = {
		method: 'stream.publish',
		target_id: post_to_user_id,
		//display: 'iframe',
		message: 'Think your little one is pretty cute?  You are invited you to take the Sprite Club challenge.  Accept the invite and find if you are right.', 
		attachment: { 
		    name: 'Sprite Club', 
		    caption: '{*actor*} has issued you a challenge.  Click here to accept.', 
		    description: ('Sprite Club is a social network where your little ones (Sprites) compete for rank as the most celebrated Sprite on the web.'),
			href: contest_url +'/',		
		    media: [{ 
		        'type': 'image', 
				'src': photo_url,
				'href': contest_url+'/' }]
		}
	}; 
	//put another 200ms delay on this call since the box often just spins
	setTimeout(function() {
		FB.ui(publish, callback());	
	},200);
	
}



function callback() { /*alert("whats up");*/ }


