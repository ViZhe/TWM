
# нужна ли собака
@Tasks = new Mongo.Collection 'tasks'

validateAttr = (attr) ->
    errors =
        countErrors: 0

    if !attr.title
        errors.title = 'Это обязательное поле'
        errors.countErrors++
        
    if !attr.description
        errors.description = 'Это обязательное поле'
        errors.countErrors++

    errors


Meteor.methods
    taskInsert: (attr) ->
        check(Meteor.userId(), String)
        check(attr,
            title: String
            description: String
            priority: Match.OneOf('high', 'medium', 'low')

            executorId: String
            coExecutor: Match.Optional Match.Where (x) ->
                check(x, String)
                x.split(', ').forEach (id) ->
                    check(id, String)
                    return
                return true

            # checklist
            deadline: Match.Optional String
            projectId: Match.Optional String
        )

        errors = validateAttr attr
        if errors.countErrors
            return {
                errors: errors
            }


        task = _.extend(attr,
            userId: Meteor.userId()
            createdAt: new Date
        )
        taskId = Tasks.insert(attr)

        return {
            _id: taskId
        }

    taskUpdate: (attr) ->
        console.log attr
