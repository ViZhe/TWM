

Template.tasksItem.helpers
    task: () ->
        Tasks.findOne()

# Template.tasksItem.helpers

        # if statuses.length == 1
        #     statuses = []
        #     statuses.push operator
        #     operator = 'and'
        #
        # status = @status
        #
        # switch operator
        #     when 'and'
        #         result = true
        #         statuses.forEach (item) ->
        #             if typeof item == 'string' && item == status
        #                 result = false
        #
        #     when 'or'
        #         result = false
        #         statuses.forEach (item) ->
        #             if typeof item == 'string' && item == status
        #                 result = true
        #
        # result
# Поменять хелперы на объекты langStatus.high = Высокий
Template.tasksItemSub.helpers
    task: () ->
        Tasks.findOne()

    getPriorityText: (priority) ->
        switch priority
            when 'high'
                'Высокий'
            when 'medium'
                'Средний'
            when 'low'
                'Низкий'

    getStatusText: (status) ->
        switch status
            when 'new'
                'Новая'
            when 'work'
                'В работе'
            when 'done'
                'Выполнена'
            when 'complete'
                'Завершена'
            when 'cancel'
                'Отменена'


    isCreator: () ->
        Meteor.userId() == @userId

    isExecutor: () ->
        Meteor.userId() == @executorId

    isCreatorOrExecutor: () ->
        Meteor.userId() == @userId || Meteor.userId() == @executorId


    isStatus: (statuses...) ->
        result = false
        status = @status
        statuses.forEach (item) ->
            if typeof item == 'string' && item == status
                result = true

        result

Template.tasksItemSub.events
    'click .js-task-control_cancel': (e, template) ->

        options =
            status: 'cancel'
            taskId: @_id

        Meteor.call 'taskUpateStatus', options, (error, result) ->
            if error
                console.error error.reason

            # if result.errors
            #     Session.set('tasksAddErrors', result.errors)

            # if result._id
                # console.log result._id
                # FlowRouter.reload()

# Template.tasksItem.helpers
#     getUsername: (userId) ->
#         user = Meteor.users.findOne(userId)
#         if user
#             user.profile.username
#         else
#             'Не найден'
