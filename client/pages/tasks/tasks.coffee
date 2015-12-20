
Template.tasks.helpers
    tasksList: () ->
        Tasks.find {},
            sort:
                createdAt: -1
                _id: -1
