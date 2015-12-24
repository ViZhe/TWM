
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
    coExecutorsIdList = $('.js-sumoselect__coExecutorsId').SumoSelect(
        placeholder: 'Соисполнители не выбраны.'
        selectAll: true
    )
    executorList.sumo.add('', 'Исполнитель не выбран.')
    count = 1
    coExecutorsIdSelected = false
    Meteor.users.find().forEach (user) ->
        executorList.sumo.add(user._id, user.profile.username)
        coExecutorsIdList.sumo.add(user._id, user.profile.username)
        if user._id == thisTask.executorId
            executorList.sumo.selectItem(count)
        if user._id in thisTask.coExecutorsId
            coExecutorsIdList.sumo.selectItem(count - 1)
            coExecutorsIdSelected = true
        count++
    if !coExecutorsIdSelected
        coExecutorsIdList.sumo.unSelectAll()

    return

Template.tasksEdit.helpers
    errorMessage: (field) ->
        Session.get('tasksEditErrors')[field]

    errorClass: (field) ->
        if !!Session.get('tasksEditErrors')[field] then 'c-form__field_invalid'

    task: () ->
        Tasks.findOne()

    activePriority: (name) ->
        if ~~name == @priority then 'selected'


Template.tasksEdit.events
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

        if deadline = task.deadline
            date = deadline.split('.')
            task.deadline = new Date date[2], (date[1] - 1), date[0], 3

        Meteor.call 'taskUpdate', @_id, task, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('tasksEditErrors', result.errors)

            if result._id
                FlowRouter.go 'tasksItem', _id: result._id
