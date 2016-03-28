
@Projects = new Mongo.Collection 'projects'

Projects.attachSchema new SimpleSchema
    'title':
        label: 'Название'
        type: String
        min: 0
        max: 100
    'description':
        label: 'Описание'
        type: String
        min: 0
    'members':
        label: 'Участники'
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



Projects.deny
    insert: -> true
    update: -> true
    remove: -> true

Meteor.methods
    projectInsert: (attr) ->
        check(Meteor.userId(), String)

        errors =
            countErrors: 0
        projectId = Projects.insert project, (error, result) ->
            if error
                context = Projects.simpleSchema().namedContext()
                context.invalidKeys().map (key) ->
                    errors[key.name] = context.keyErrorMessage(key.name)
                    errors.countErrors++

        if errors.countErrors
            return {
                errors: errors
            }

        return {
            _id: projectId
        }


    projectUpdate: (projectId, attr) ->
        thisProject = Projects.findOne(projectId)
        if !thisProject then return

        check(Meteor.userId(), thisProject.userId)

        project = attr

        errors =
            countErrors: 0
        Projects.update {_id: projectId}, $set: project, (error, result) ->
            if error
                context = Projects.simpleSchema().namedContext()
                context.invalidKeys().map (key) ->
                    errors[key.name] = context.keyErrorMessage(key.name)
                    errors.countErrors++

        if errors.countErrors
            return {
                errors: errors
            }

        return {
            _id: projectId
        }
