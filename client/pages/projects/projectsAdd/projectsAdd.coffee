
Template.projectsAdd.onCreated ->
    Session.set 'projectsAddErrors', {}
    return


Template.projectsAdd.helpers
    errorMessage: (field) ->
        Session.get('projectsAddErrors')[field]

    errorClass: (field) ->
        if !!Session.get('projectsAddErrors')[field] then 'c-form__field_invalid'


Template.projectsAdd.events
    'submit form': (e, template) ->
        e.preventDefault()

        task =
            title: template.find('[name=title]').value
            description: template.find('[name=description]').value

        Meteor.call 'projectInsert', task, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('projectsAddErrors', result.errors)

            if result._id
                FlowRouter.go 'projectsItem', _id: result._id
