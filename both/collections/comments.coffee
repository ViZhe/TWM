
@Comments = new Mongo.Collection 'comments'

validateCommentAttr = (attr) ->
    errors =
        countErrors: 0

    if !attr.body
        errors.body = 'Это обязательное поле'
        errors.countErrors++

    errors


Meteor.methods
    commentInsert: (attr) ->
        check(Meteor.userId(), String)
        check(attr,
            taskId: String
            body: String
        )

        errors = validateCommentAttr attr
        if errors.countErrors
            return {
                errors: errors
            }


        comment = _.extend(attr,
            userId: Meteor.userId()
            createdAt: new Date
        )
        commentId = Comments.insert(attr)

        return {
            _id: commentId
        }
