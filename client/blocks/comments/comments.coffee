
Template.comments.helpers
    commentsList: () ->
        # Comments.find taskId: @_id
        Comments.find {taskId: @_id},
            sort:
                createdAt: -1
                _id: -1
