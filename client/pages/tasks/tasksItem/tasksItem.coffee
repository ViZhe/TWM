
Template.tasksItem.helpers
    task: () ->
        Tasks.findOne()


# Поменять хелперы на объекты langStatus.high = Высокий
Template.tasksItemSub.helpers
    task: () ->
        Tasks.findOne()

    getPriorityText: (priority) ->
        switch priority
            when 1
                'Высокий'
            when 2
                'Средний'
            when 3
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

    isStatusControl: () ->
        allow = Meteor.userId() == @userId || Meteor.userId() == @executorId
        statuses = @status in ['complete', 'cancel']
        allow && !statuses

    isStatus: (statuses...) ->
        result = false
        status = @status
        statuses.forEach (item) ->
            if typeof item == 'string' && item == status
                result = true

        result

Template.tasksItemSub.events
    'click .js-task-item__status-control': (e, template) ->

        options =
            status: e.target.dataset.status
            taskId: @_id

        Meteor.call 'taskUpateStatus', options, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                console.error result.errors.error
                # Session.set('tasksAddErrors', result.errors)
