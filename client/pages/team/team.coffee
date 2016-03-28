
Template.team.helpers
    teamList: () ->
        Meteor.users.find()


Template.teamSub.onCreated ->
    Session.set 'teamSubErrors', {}
    return

Template.teamSub.helpers
    errorMessage: (field) ->
        Session.get('teamSubErrors')[field]

    errorClass: (field) ->
        if !!Session.get('teamSubErrors')[field] then 'c-form__field_invalid'

    invitesList: () ->
        if Invites.findOne() then Invites.find() else null

Template.teamSub.events
    'submit form#sendInvite': (e, template) ->
        e.preventDefault()

        email = template.find('[name=email]').value

        Meteor.call 'addInvite', email, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('teamSubErrors', result.errors)

            if result._id
                console.log result._id
