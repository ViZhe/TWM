
# Только root может создавать других пользователей
Accounts.validateNewUser ->
    isFirstUser = !Meteor.users.find().count()
    isRootUser = false

    rootUsers = Meteor.users.find({}, {'profile.root': true})
    rootUsers.forEach (rootUser) ->
        if Meteor.userId() == rootUser._id
            isRootUser = true

    return isFirstUser || isRootUser
