class ChallengePublisher < Facebooker::Rails::Publisher
  
  
  helper :application

  ###DOCUMENTATION TIME!!!
# I am overriding some facebooker methods here for publishing to the steam API.
# The code comes from here: http://github.com/rubymerchant/facebooker/blob/master/lib/facebooker/rails/publisher.rb
#
# We don't want to just update our facebooker library in case Mangino actually updates it with some useful stuff.
#
#



#  ## Here we are overriding a method from Facebooker's publish.rb to allow us to send messages properly
#  def send_message(method)
#    @recipients = @recipients.is_a?(Array) ? @recipients : [@recipients]
#    if from.nil? and @recipients.size==1 and requires_from_user?(from,_body)
#      @from = @recipients.first
#    end
#    # notifications can 
#    # omit the from address
#    raise InvalidSender.new("Sender must be a Facebooker::User") unless from.is_a?(Facebooker::User) || !requires_from_user?(from,_body)
#    case _body
#    when Facebooker::Feed::TemplatizedAction,Facebooker::Feed::Action
#      from.publish_action(_body)
#    when Facebooker::Feed::Story
#      @recipients.each {|r| r.publish_story(_body)}
#    when Notification
#      (from.nil? ? Facebooker::Session.create : from.session).send_notification(@recipients,_body.fbml)
#    when Email
#      from.session.send_email(@recipients, 
#                                         _body.title, 
#                                         _body.text, 
#                                         _body.fbml)
#    when Profile
#     # If recipient and from aren't the same person, create a new user object using the
#     # userid from recipient and the session from from
#     @from = Facebooker::User.new(Facebooker::User.cast_to_facebook_id(@recipients.first),Facebooker::Session.create) 
#     @from.set_profile_fbml(_body.profile, _body.mobile_profile, _body.profile_action, _body.profile_main)
#    when Ref
#      Facebooker::Session.create.server_cache.set_ref_handle(_body.handle,_body.fbml)
#    when UserAction
#      @from.session.publish_user_action(_body.template_id,_body.data_hash,_body.target_ids,_body.body_general,_body.story_size)
#    when PublishStream
#     @from.publish_to(_body.target, {:attachment => _body.attachment, :action_links => @action_links, :message => _body.message })
#    else
#      raise UnspecifiedBodyType.new("You must specify a valid send_as")
#    end
#  end
#  
#  ## also overriding a method in facebooker
#  def send_as(option)
#      self._body=case option
#      when :action
#        Facebooker::Feed::Action.new
#      when :story
#        Facebooker::Feed::Story.new
#      when :templatized_action
#        Facebooker::Feed::TemplatizedAction.new
#      when :notification
#        Notification.new
#      when :email
#        Email.new
#      when :profile
#        Profile.new
#      when :ref
#        Ref.new
#      when :user_action
#        UserAction.new
#      when :publish_stream
#        PublishStream.new
#      else
#        raise UnknownBodyType.new("Unknown type to publish")
#      end
#    end
  
  
   #  Publish a post into the stream on the user's Wall and News Feed.
   # This only seems to post to the "initiated by" user's wall.  It would be good to
   # post to the "sent_to_user's wall
   def challenge_notification(contest)
     send_as :publish_stream
     from  contest.initiated_by_user.facebook_session.user #facebooker user
     target contest.sent_to_user.facebook_session.user  #facebooker user
     attachment
     action_links #link_to "Accept the challenge", :controller=>'contests', :action=>'accept', :id=>contest.id
     message <<-MESSAGE  
      #{challenge_info(contest) }.
      Accept the challenge:
      #{url_for :controller=>'contests', :action=>'accept', :id=>contest.id }     
    MESSAGE

   end

#  def challenge_notification(contest)
##    send_as :notification
##    recipients  contest.sent_to_user
##    from contest.initiated_by_user.facebook_session.user
#
#
#    
#    
#  end
#  

  
  
  
#  def contest_notification_email(challenge)
#    send_as :email
#    recipients  contest.defending_user
#    from contest.attacking_user.facebook_session.user
#    title "You've been challenged!"
#    fbml  <<-MESSAGE
#      <fb:fbml> 
#      #{challenge_info(contest) }
#      #{name contest.sent_to_user} with a spriteclub challenge.
#      #{link_to "Challenge them back", new_contest_url}
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