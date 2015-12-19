
Template.projectsAdd.onCreated ->
    Session.set 'projectsAddErrors', {}
    return


Template.projectsAdd.helpers
    errorMessage: (field) ->
        Session.get('projectsAddErrors')[field]

    errorClass: (field) ->
        if !!Session.get('projectsAddErrors')[field] then 'c-form__field_invalid'

    usersList: () ->
        Meteor.users.find()


Template.projectsAdd.events
    'click .c-typeahead__btn': (e, template) ->
        e.preventDefault()
        parent = $(e.target).parent()
        if !parent.hasClass 'c-typeahead_open'
            $('.c-typeahead_open').removeClass 'c-typeahead_open'

        parent.toggleClass 'c-typeahead_open'

    'click .js-typeahead__item': (e, template) ->
        $('.c-typeahead_open').removeClass 'c-typeahead_open'

    'click .js-typeahead__input': (e, template) ->
        name = ''
        $(e.target).parentsUntil('.c-typeahead').find(':checked').map (i, it) ->
            if !!name
                name += ', '
            name += $(it).next().text()

        $(e.target).parentsUntil('.c-form__label')
            .find('.js-typeahead__result').val name
        $(e.target).attr('checked', true)

    'submit form': (e, template) ->
        e.preventDefault()

        task =
            title: template.find('[name=title]').value
            description: template.find('[name=description]').value
            members: template.findAll('[name=members]:checked').map (item) -> $(item).val()

        Meteor.call 'projectInsert', task, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('projectsAddErrors', result.errors)

            if result._id
                FlowRouter.go 'projectsItem', _id: result._id
