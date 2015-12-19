
Meteor.publish 'tasks', () ->
    [
        Tasks.find $or: [
            {coExecutor: $all: [@userId]}
            {coExecutor: @userId}
            {userId: @userId}
        ]

        Meteor.users.find {},
            fields:
                'profile.username': 1
    ]

Meteor.publish 'tasksAdd', () ->
    [
        Projects.find $or: [
            {members: $all: [@userId]}
            {userId: @userId}
        ]

        Meteor.users.find {},
            fields:
                'profile.username': 1
    ]

Meteor.publish 'tasksItem', (taskId) ->
    [
        Tasks.find(taskId)
        Projects.find()

        Meteor.users.find {},
            fields:
                'profile.username': 1

        Comments.find {taskId: taskId},
            sort:
                createdAt: -1
                _id: -1
    ]

Meteor.publish 'projectsAll', () ->
    Projects.find()

Meteor.publish 'projectsAdd', (userId) ->
    Meteor.users.find {},
        fields:
            'profile.username': 1

Meteor.publish 'projectsItem', (projectId) ->
    [
        Projects.find(projectId)

        Meteor.users.find {},
            fields:
                'profile.username': 1
    ]
