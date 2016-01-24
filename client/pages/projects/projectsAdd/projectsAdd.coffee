
Template.projectsAdd.onCreated ->
    Session.set 'projectsAddErrors', {}
    return

Template.projectsAdd.rendered = ->
    membersList = $('.js-sumoselect__members').SumoSelect(
        placeholder: 'Участники не выбраны.'
        selectAll: true
    )
    Meteor.users.find(_id: $ne: Meteor.userId()).forEach (user) ->
        membersList.sumo.add(user._id, user.username)
    membersList.sumo.unSelectAll()
    return

Template.projectsAdd.helpers
    errorMessage: (field) ->
        Session.get('projectsAddErrors')[field]

    errorClass: (field) ->
        if !!Session.get('projectsAddErrors')[field] then 'c-form__field_invalid'


Template.projectsAdd.events
    'submit form': (e, template) ->
        e.preventDefault()

        project =
            title: template.find('[name=title]').value
            description: template.find('[name=description]').value
            members: template.findAll('[name=members] :selected').map (item) -> $(item).val()

        Meteor.call 'projectInsert', project, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('projectsAddErrors', result.errors)

            if result._id
                FlowRouter.go 'projectsItem', _id: result._id
