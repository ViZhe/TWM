
Template.tasksAdd.onCreated ->
    Session.set 'tasksAddErrors', {}
    return

Template.tasksAdd.rendered = ->
    $('.js-datepicker').datepicker(
        minDate: new Date()
        autoClose: true
    )
    return

Template.tasksAdd.helpers
    errorMessage: (field) ->
        Session.get('tasksAddErrors')[field]

    errorClass: (field) ->
        if !!Session.get('tasksAddErrors')[field] then 'c-form__field_invalid'

    projectsList: () ->
        Projects.find()

    usersList: () ->
        Meteor.users.find()

Template.tasksAdd.events
    'click .c-typeahead__btn': (e, template) ->
        e.preventDefault()
        parent = $(e.target).parent()
        if !parent.hasClass 'c-typeahead_open'
            $('.c-typeahead_open').removeClass 'c-typeahead_open'

        parent.toggleClass 'c-typeahead_open'

    'click .js-typeahead__item': (e, template) ->
        $('.c-typeahead_open').removeClass 'c-typeahead_open'

    'click .js-typeahead__input': (e, template) ->
        # e.preventDefault()
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

    'click .js-tasks-add__btn': (e, template) ->

        executorIdCall = template.find('[name=executorId]:checked')
        projectIdCall = template.find('[name=projectId]:checked')
        task =
            title: template.find('[name=title]').value
            description: template.find('[name=description]').value
            priority: template.find('[name=priority]').value
            executorId: executorIdCall && executorIdCall.value || ''
            coExecutor: template.findAll('[name=coExecutor]:checked').map (item) -> $(item).val()
            deadline: template.find('[name=deadline]').value
            projectId: projectIdCall && projectIdCall.value || ''


        Meteor.call 'taskInsert', task, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('tasksAddErrors', result.errors)

            if result._id
                FlowRouter.go 'tasksItem', _id: result._id
