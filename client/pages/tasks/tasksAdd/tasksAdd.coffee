
Template.tasksAdd.onCreated ->
    Session.set 'tasksAddErrors', {}
    return


Template.tasksAdd.helpers
    errorMessage: (field) ->
        Session.get('tasksAddErrors')[field]

    errorClass: (field) ->
        if !!Session.get('tasksAddErrors')[field] then 'error'


Template.tasksAdd.events
    'submit form': (e, template) ->
        e.preventDefault()

        console.log 'event: submit form'

        task =
            title: template.find('[name=title]').value
            description: template.find('[name=description]').value
            priority: template.find('[name=priority]').value
            executorId: template.find('[name=executorId]').value
            coExecutor: template.find('[name=coExecutor]').value
            deadline: template.find('[name=deadline]').value
            projectId: template.find('[name=projectId]').value

        Meteor.call 'taskInsert', task, (error, result) ->
            console.log 'metod'
            if error
                console.error error.reason

            if result.errors
                Session.set('tasksAddErrors', result.errors)

            console.log "asdasdasd" + result._id
            if result._id
                # Почему то при автомереходе не прогружается
                FlowRouter.go(FlowRouter.path 'tasks/:taskId', 'taskId': result._id)
