
Template.projectsEdit.onCreated ->
    Session.set 'projectsEditErrors', {}
    return

Template.projectsEdit.rendered = ->
    thisProject = Projects.findOne()
    membersList = $('.js-sumoselect__members').SumoSelect(
        placeholder: 'Участники не выбраны.'
        selectAll: true
    )
    count = 1
    membersIdSelected = false
    Meteor.users.find(_id: $ne: Meteor.userId()).forEach (user) ->
        membersList.sumo.add(user._id, user.profile.username)
        if user._id in thisProject.members
            membersList.sumo.selectItem(count - 1)
            membersIdSelected = true
        count++
    if !membersIdSelected
        membersList.sumo.unSelectAll()
    return

Template.projectsEdit.helpers
    errorMessage: (field) ->
        Session.get('projectsEditErrors')[field]

    errorClass: (field) ->
        if !!Session.get('projectsEditErrors')[field] then 'c-form__field_invalid'

    project: () ->
        Projects.findOne()


Template.projectsEdit.events
    'submit form': (e, template) ->
        e.preventDefault()

        project =
            title: template.find('[name=title]').value
            description: template.find('[name=description]').value
            members: template.findAll('[name=members] :selected').map (item) -> $(item).val()

        Meteor.call 'projectUpdate', @_id, project, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('projectsEditErrors', result.errors)

            if result._id
                FlowRouter.go 'projectsItem', _id: result._id
