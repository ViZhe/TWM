
Template.tasksAdd.onCreated ->
    Session.set 'tasksAddErrors', {}
    return


Template.tasksAdd.helpers
    errorMessage: (field) ->
        Session.get('tasksAddErrors')[field]

    errorClass: (field) ->
        if !!Session.get('tasksAddErrors')[field] then 'c-form__field_invalid'


Template.tasksAdd.events
    'submit form': (e, template) ->
        e.preventDefault()

        task =
            title: template.find('[name=title]').value
            description: template.find('[name=description]').value
            priority: template.find('[name=priority]').value
            executorId: template.find('[name=executorId]').value
            coExecutor: template.find('[name=coExecutor]').value
            deadline: template.find('[name=deadline]').value
            projectId: template.find('[name=projectId]').value

        Meteor.call 'taskInsert', task, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('tasksAddErrors', result.errors)

            if result._id
                FlowRouter.go 'tasksItem', _id: result._id
