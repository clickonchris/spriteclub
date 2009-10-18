class ChallengePublisher < Facebooker::Rails::Publisher
  
  
  helper :application

  def challenge_notification(challenge)
    send_as :notification
    recipients  challenge.sent_to_user
    from challenge.initiated_by_user.facebook_session.user
    fbml  <<-MESSAGE  
      <fb:fbml>
      #{challenge_info(challenge) }
      #{challenge.sent_to_user} with a spriteclub challenge.
      #{link_to "Respond to the challenge", new_challenge_url}
      </fb:fbml>
    MESSAGE
    
  end
  
  
  
#  def challenge_notification_email(challenge)
#    send_as :email
#    recipients  challenge.defending_user
#    from challenge.attacking_user.facebook_session.user
#    title "You've been challenged!"
#    fbml  <<-MESSAGE
#      <fb:fbml> 
#      #{challenge_info(challenge) }
#      #{name challenge.sent_to_user} with a spriteclub challenge.
#      #{link_to "Challenge them back", new_challenge_url}
#      </fb:fbml>
#    MESSAGE
#    
#  end
#  
#  
#
#  
#  def attack_feed_template
#    attack_back=link_to("Join the Battle!",new_attack_url)
#    one_line_story_template "{*actor*} {*result*} {*defender*} with a {*move*}. #{attack_back}"
#    one_line_story_template "{*actor*} are doing battle using Karate Poke. #{attack_back}"
#    short_story_template "{*actor*} engaged in battle.",
#     "{*actor*} {*result*} {*defender*} with a {*move*}."
#    short_story_template "{*actor*} are doing battle using Karate Poke..","#{attack_back}"
#  end
  

  
#  def attack_feed(attack)
#    send_as :user_action
#    from attack.attacking_user.facebook_session.user
#    data :result=>attack_result(attack),
#         :move=>attack.move.name,
#         :defender=>name(attack.defending_user),
#         :belt=>attack.attacking_user.belt.name,
#         :images=>[image(attack.move.image_name,new_attack_url)]
#  end
    

  def profile_update(user)
    send_as :profile
    recipients user
#    @battles=user.battles
#    profile render(:partial=>"profile",
#      :assigns=>{:battles=>@battles})
#    profile_main render(:partial=>"profile_narrow",
#      :assigns=>{:battles=>@battles[0..3]})
  end
  

  
  
end