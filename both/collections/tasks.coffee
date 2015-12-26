
@Tasks = new Mongo.Collection 'tasks'

Tasks.attachSchema new SimpleSchema
    'title':
        label: 'Название'
        type: String
        min: 0
        max: 100
    'description':
        label: 'Описание'
        type: String
        min: 0

    'priority':
        label: 'Приоритет'
        type: Number
        allowedValues: [1, 2, 3]
        defaultValue: 2
    'status':
        label: 'Статус'
        type: String
        allowedValues: ['new', 'work', 'done', 'complete', 'cancel']
        defaultValue: 'new'
    'deadline':
        label: 'Крайний срок'
        type: Date
        min: -> new Date(moment().format('YYYY-MM-DD'))
        autoValue: -> new Date(@value)
        optional: true

    'projectId':
        label: 'Проект'
        type: String
        regEx: SimpleSchema.RegEx.Id
    'executorId':
        label: 'Исполнитель'
        type: String
        regEx: SimpleSchema.RegEx.Id
    'coExecutorsId':
        label: 'Соисполнители'
        type: [String]
        regEx: SimpleSchema.RegEx.Id
        optional: true

    'userId':
        label: 'Постановщик'
        type: String
        regEx: SimpleSchema.RegEx.Id
        autoValue: -> if @isInsert then Meteor.userId()
        denyUpdate: true

    'createdAt':
        label: 'Дата создания'
        type: Date
        autoValue: -> if @isInsert then moment().toDate()
        denyUpdate: true
    'updatedAt':
        label: 'Дата обновления'
        type: Date
        autoValue: -> if @isUpdate then moment().toDate()
        denyInsert: true
        optional: true



Meteor.methods
    taskInsert: (attr) ->
        check(Meteor.userId(), String)

        if attr.deadline
            attr.deadline = moment(attr.deadline, 'DD.MM.YYYY').format('YYYY-MM-DD')

        task = attr

        errors =
            countErrors: 0
        taskId = Tasks.insert task, (error, result) ->
            if error
                context = Tasks.simpleSchema().namedContext()
                context.invalidKeys().map (key) ->
                    errors[key.name] = context.keyErrorMessage(key.name)
                    errors.countErrors++

        if errors.countErrors
            return {
                errors: errors
            }

        Projects.update {_id: task.projectId}, $inc: 'counters.tasks': 1

        return {
            _id: taskId
        }


    taskUpdate: (taskId, attr) ->
        thisTask = Tasks.findOne(taskId)
        if !thisTask then return

        check(Meteor.userId(), thisTask.userId)

        if attr.deadline
            attr.deadline = moment(attr.deadline, 'DD.MM.YYYY').format('YYYY-MM-DD')

        task = _.extend(attr,
            status: 'new'
        )
        errors =
            countErrors: 0
        Tasks.update {_id: taskId}, $set: task, (error, result) ->
            if error
                context = Tasks.simpleSchema().namedContext()
                context.invalidKeys().map (key) ->
                    errors[key.name] = context.keyErrorMessage(key.name)
                    errors.countErrors++

        if errors.countErrors
            return {
                errors: errors
            }

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
        thisTask = Tasks.findOne(options.taskId)
        if !thisTask then return

        # Вынести проверку в схему?
        # checked start
        errors =
            countErrors: 0

        statusActive = thisTask.status
        status = options.status
        if status == 'complete' || status == 'cancel'
            if thisTask.userId != Meteor.userId()
                errors.error = 'Это действие доступно только постановщику задачи.'
                errors.countErrors++

        if status == 'work' || status == 'done'
            if thisTask.executorId != Meteor.userId()
                errors.error = 'Это действие доступно только исполнителю задачи.'
                errors.countErrors++

        # Упростить
        if (statusActive == 'new' && status != 'work' && status != 'cancel') ||
           (statusActive == 'work' && status != 'done' && status != 'cancel') ||
           (statusActive == 'done' && status != 'work' && status != 'complete') ||
           (statusActive in ['complete', 'cancel'])
            errors.error = 'Недоступный статус задачи.'
            errors.countErrors++
        # checked end

        if errors.countErrors
            return {
                errors: errors
            }

        Tasks.update {_id: options.taskId}, $set: 'status': options.status

        return {
            _id: options.taskId
        }
