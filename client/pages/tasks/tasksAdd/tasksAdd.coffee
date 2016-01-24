
Template.tasksAdd.onCreated ->
    Session.set 'tasksAddErrors', {}
    return

Template.tasksAdd.rendered = ->
    $('.js-datepicker').datepicker(
        minDate: new Date()
        autoClose: true
        dateFormat: 'dd.mm.yyyy'
    )
    projectsList = $('.js-sumoselect__projectId').SumoSelect(
        placeholder: 'Проект не выбран.'
    )
    projectsList.sumo.add('', 'Проект не выбран.')
    Projects.find().forEach (project) ->
        projectsList.sumo.add(project._id, project.title)

    $('.js-sumoselect__priority').SumoSelect(
    )
    executorList = $('.js-sumoselect__executorId').SumoSelect(
        placeholder: 'Исполнитель не выбран.'
    )
    coExecutorsIdList = $('.js-sumoselect__coExecutorsId').SumoSelect(
        placeholder: 'Соисполнители не выбраны.'
        selectAll: true
    )
    executorList.sumo.add('', 'Исполнитель не выбран.')
    Meteor.users.find().forEach (user) ->
        executorList.sumo.add(user._id, user.username)
        if Meteor.userId() == user._id then return
        coExecutorsIdList.sumo.add(user._id, user.username)
    coExecutorsIdList.sumo.unSelectAll()
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
            coExecutorsId: template.findAll('[name=coExecutorsId] :selected').map (item) -> $(item).val()
            deadline: template.find('[name=deadline]').value
            projectId: template.find('[name=projectId]').value

        Meteor.call 'taskInsert', task, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('tasksAddErrors', result.errors)

            if result._id
                FlowRouter.go 'tasksItem', _id: result._id
