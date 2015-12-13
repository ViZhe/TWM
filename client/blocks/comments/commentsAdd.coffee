
Template.commentsAdd.onCreated ->
    Session.set 'commentsAddErrors', {}
    return

Template.commentsAdd.helpers
    errorMessage: (field) ->
        Session.get('commentsAddErrors')[field]

    errorClass: (field) ->
        if !!Session.get('commentsAddErrors')[field] then 'c-form__field_invalid'


Template.commentsAdd.events
    'submit form': (e, template) ->
        e.preventDefault()

        comment =
            body: template.find('[name=body]').value
            taskId: @_id

        Meteor.call 'commentInsert', comment, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                console.log result.errors
                Session.set('commentsAddErrors', result.errors)

            if result._id
                # FlowRouter.go 'tasksItem', _id: result._id
                Session.set('commentsAddErrors', {})
                template.find('[name=body]').value = null
