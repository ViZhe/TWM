
Template.tasksAdd.onCreated ->
    Session.set 'tasksAddErrors', {}
    return

Template.tasksAdd.rendered = ->
    $('.js-datepicker').datepicker(
        minDate: new Date()
        autoClose: true
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
    coexecutorList = $('.js-sumoselect__coExecutor').SumoSelect(
        placeholder: 'Соисполнители не выбраны.'
        selectAll: true
    )
    executorList.sumo.add('', 'Исполнитель не выбран.')
    Meteor.users.find().forEach (user) ->
        executorList.sumo.add(user._id, user.profile.username)
        coexecutorList.sumo.add(user._id, user.profile.username)
    coexecutorList.sumo.unSelectAll()
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
            coExecutor: template.findAll('[name=coExecutor] :selected').map (item) -> $(item).val()
            deadline: template.find('[name=deadline]').value
            projectId: template.find('[name=projectId]').value

        Meteor.call 'taskInsert', task, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('tasksAddErrors', result.errors)

            if result._id
                FlowRouter.go 'tasksItem', _id: result._id
