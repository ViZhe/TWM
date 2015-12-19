


Template.tasksItem.helpers
    isCreator: () ->
        Meteor.userId() == @userId

    isExecutor: () ->
        Meteor.userId() == @executorId && Meteor.userId() != @userId

Template.tasksItemSub.helpers
    getPriorityText: (priority) ->
        switch
            when 'high'
                'Высокий'
            when 'medium'
                'Средний'
            when 'low'
                'Низкий'



# Template.tasksItem.helpers
#     getUsername: (userId) ->
#         user = Meteor.users.findOne(userId)
#         if user
#             user.profile.username
#         else
#             'Не найден'
