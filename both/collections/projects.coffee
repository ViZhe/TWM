
@Projects = new Mongo.Collection 'projects'

validateProjectAttr = (attr) ->
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
    projectInsert: (attr) ->
        check(Meteor.userId(), String)
        check(attr,
            title: String
            description: String
            members: Match.Optional Match.Where (x) ->
                check(x, Array)
                x.forEach (id) ->
                    check(id, String)
                    return
                return true
        )

        errors = validateProjectAttr attr
        if errors.countErrors
            return {
                errors: errors
            }


        project = _.extend(attr,
            userId: Meteor.userId()
            createdAt: new Date
        )
        projectId = Projects.insert(project)

        return {
            _id: projectId
        }

    projectUpdate: (attr) ->
        console.log attr
