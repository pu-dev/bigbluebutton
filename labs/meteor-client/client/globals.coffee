# Allow access through all templates
Handlebars.registerHelper "setInSession", (k, v) -> Session.set k, v
Handlebars.registerHelper "getInSession", (k) -> Session.get k
# Allow access throughout all coffeescript/js files
@setInSession = (k, v) -> Session.set k, v
@getInSession = (k) -> Session.get k

# retrieve account for selected user, or the first mod account if nothing is selected
# global function
@getCurrentUserFromSession = ->
  id = Session.get("userId")
  u = Meteor.Users.findOne("userId": id)
  #console.log Meteor.Users
  u

# retrieve account for selected user
Handlebars.registerHelper "getCurrentUser", =>
	@window.getCurrentUserFromSession()

# toggle state of field in the database
@toggleCam = (context) ->
	Meteor.Users.update {_id: context._id} , {$set:{"user.sharingVideo": !context.sharingVideo}}

@toggleMic = (context) -> 
	Meteor.Users.update {_id: context._id} , {$set:{"user.sharingAudio": !context.sharingAudio}}

# toggle state of session variable
@toggleUsersList = ->
	setInSession "display_usersList", !getInSession "display_usersList"

@toggleNavbar = ->
	setInSession "display_navbar", !getInSession "display_navbar"

@toggleChatbar = ->
	setInSession "display_chatbar", !getInSession "display_chatbar"

Meteor.methods
  sendMeetingInfoToClient: (meetingId, userId) ->
    Session.set("userId", userId)
    Session.set("meetingId", meetingId)

Handlebars.registerHelper "isUserSharingAudio", (u) ->
  u.voiceUser.talking

Handlebars.registerHelper "isUserSharingVideo", (u) ->
  u.webcam_stream.length isnt 0

