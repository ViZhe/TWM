
@Tasks = new Mongo.Collection 'tasks'


taskCheck = (attr) ->
    check(Meteor.userId(), String)
    check(attr,
        title: String
        description: String
        priority: Match.OneOf('1', '2', '3')

        executorId: String
        coExecutor: Match.Optional Match.Where (x) ->
            check(x, Array)
            x.forEach (id) ->
                check(id, String)
                return
            return true

        # checklist
        deadline: Match.Optional String
        projectId: String
    )
    return


validateTaskAttr = (attr) ->
    errors =
        countErrors: 0

    if !attr.title
        errors.title = 'Это обязательное поле'
        errors.countErrors++

    if !attr.description
        errors.description = 'Это обязательное поле'
        errors.countErrors++

    if !attr.projectId
        errors.projectId = 'Это обязательное поле'
        errors.countErrors++

    if !!attr.projectId && !Projects.findOne(attr.projectId)
        errors.projectId = 'Проект не найден.'
        errors.countErrors++

    if !attr.executorId
        errors.executorId = 'Это обязательное поле'
        errors.countErrors++

    errors

validateTaskUpateStatus = (options) ->
    errors =
        countErrors: 0

    task = Tasks.findOne(options.taskId)
    if !task
        errors.error = 'Задача не найдена.'
        errors.countErrors++
        return errors

    statusActive = task.status
    status = options.status
    if status == 'complete' || status == 'cancel'
        if task.userId != Meteor.userId()
            errors.error = 'Это действие доступно только постановщику задачи.'
            errors.countErrors++

    if status == 'work' || status == 'done'
        if task.executorId != Meteor.userId()
            errors.error = 'Это действие доступно только исполнителю задачи.'
            errors.countErrors++

    # Упростить
    if (statusActive == 'new' && status != 'work' && status != 'cancel') ||
       (statusActive == 'work' && status != 'done' && status != 'cancel') ||
       (statusActive == 'done' && status != 'work' && status != 'complete') ||
       (statusActive in ['complete', 'cancel'])
        errors.error = 'Недоступный статус задачи.'
        errors.countErrors++

    errors

Meteor.methods
    taskInsert: (attr) ->
        taskCheck attr

        errors = validateTaskAttr attr
        if errors.countErrors
            return {
                errors: errors
            }
        if deadline = attr.deadline
            date = deadline.split('.')
            attr.deadline = new Date date[2], date[1] - 1, date[0]

        task = _.extend(attr,
            userId: Meteor.userId()
            createdAt: new Date
            status: 'new'
        )
        taskId = Tasks.insert(task)

        Projects.update {_id: task.projectId}, $inc: 'counters.tasks': 1

        return {
            _id: taskId
        }

    taskUpdate: (taskId, attr) ->
        taskCheck attr
        thisTask = Tasks.findOne(taskId)
        check(Meteor.userId(), thisTask.userId)

        errors = validateTaskAttr attr
        if errors.countErrors
            return {
                errors: errors
            }
        if deadline = attr.deadline
            date = deadline.split('.')
            attr.deadline = new Date date[2], date[1] - 1, date[0]

        task = _.extend(attr,
            status: 'new'
        )

        Tasks.update {_id: taskId}, $set: task

        if thisTask.projectId != task.projectId
            Projects.update {_id: thisTask.projectId}, $inc: 'counters.tasks': -1
            Projects.update {_id: task.projectId}, $inc: 'counters.tasks': 1

        return {
            _id: taskId
        }

    taskUpateStatus: (options) ->
        check(options,
            taskId: String
            status: String
        )

        errors = validateTaskUpateStatus options
        if errors.countErrors
            return {
                errors: errors
            }

        Tasks.update {_id: options.taskId}, $set: 'status': options.status

        return {
            _id: options.taskId
        }
