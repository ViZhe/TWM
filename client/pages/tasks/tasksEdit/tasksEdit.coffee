
Template.tasksEdit.onCreated ->
    Session.set 'tasksEditErrors', {}
    return

Template.tasksEdit.rendered = ->
    datepick = $('.js-datepicker').datepicker(
        minDate: new Date()
        autoClose: true
    ).data('datepicker')
    if deadlineDate = $('[name=deadline]').data('activedate')
        datepick.selectDate(new Date(deadlineDate))

    thisTask = Tasks.findOne()
    projectsList = $('.js-sumoselect__projectId').SumoSelect(
        placeholder: 'Проект не выбран.'
    )
    projectsList.sumo.add('', 'Проект не выбран.')
    count = 1
    Projects.find().forEach (project) ->
        projectsList.sumo.add(project._id, project.title)
        if project._id == thisTask.projectId
            projectsList.sumo.selectItem(count)
        count++

    $('.js-sumoselect__priority').SumoSelect()
    executorList = $('.js-sumoselect__executorId').SumoSelect(
        placeholder: 'Исполнитель не выбран.'
    )
    coexecutorList = $('.js-sumoselect__coExecutor').SumoSelect(
        placeholder: 'Соисполнители не выбраны.'
        selectAll: true
    )
    executorList.sumo.add('', 'Исполнитель не выбран.')
    count = 1
    coexecutorSelected = false
    Meteor.users.find().forEach (user) ->
        executorList.sumo.add(user._id, user.profile.username)
        coexecutorList.sumo.add(user._id, user.profile.username)
        if user._id == thisTask.executorId
            executorList.sumo.selectItem(count)
        if user._id in thisTask.coExecutor
            coexecutorList.sumo.selectItem(count - 1)
            coexecutorSelected = true
        count++
    if !coexecutorSelected
        coexecutorList.sumo.unSelectAll()

    return

Template.tasksEdit.helpers
    errorMessage: (field) ->
        Session.get('tasksEditErrors')[field]
        ''

    errorClass: (field) ->
        if !!Session.get('tasksEditErrors')[field] then 'c-form__field_invalid'

    activePriority: (name) ->
        if name == @priority then 'selected'


# Template.tasksEdit.events
    # TODO: доделать отправку
