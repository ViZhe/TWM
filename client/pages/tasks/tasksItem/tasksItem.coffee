
Template.tasksItem.helpers
    getUsername: (userId) ->
        user = Meteor.users.findOne(userId)
        if user
            user.profile.username
        else
            'Не найден'
