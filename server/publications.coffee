
Meteor.publish 'tasks', () ->
    [
        Tasks.find {$or: [
            {coExecutorsId: $all: [@userId]}
            {executorId: @userId}
            {userId: @userId}
        ]}, sort:
            createdAt: -1
            _id: -1

        Meteor.users.find {},
            fields:
                'username': 1
    ]

Meteor.publish 'tasksAdd', () ->
    [
        Projects.find $or: [
            {members: $all: [@userId]}
            {userId: @userId}
        ]

        Meteor.users.find {},
            fields:
                'username': 1
    ]

Meteor.publish 'tasksEdit', (taskId) ->
    [
        Tasks.find $and: [
            {_id: taskId}
            {userId: @userId}
        ]

        Projects.find $or: [
            {members: $all: [@userId]}
            {userId: @userId}
        ]

        Meteor.users.find {},
            fields:
                'username': 1
    ]

Meteor.publish 'tasksItem', (taskId) ->
    task = Tasks.findOne({_id: taskId})

    [
        Tasks.find(taskId)
        Projects.find(task.projectId)

        Meteor.users.find {},
            fields:
                'username': 1

        Comments.find {taskId: taskId},
            sort:
                createdAt: -1
                _id: -1
    ]


Meteor.publish 'projectsAll', () ->
    Projects.find {$or: [
        {members: $all: [@userId]}
        {userId: @userId}
    ]}, sort:
        title: 1
        createdAt: -1

Meteor.publish 'projectsAdd', (userId) ->
    Meteor.users.find {},
        fields:
            'username': 1

Meteor.publish 'projectsEdit', (projectId) ->
    [
        Projects.find $and: [
            {_id: projectId}
            {userId: @userId}
        ]

        Meteor.users.find {},
            fields:
                'username': 1
    ]

Meteor.publish 'projectsItem', (projectId) ->
    [
        Projects.find(projectId)


        Tasks.find {
            projectId: projectId
            $or: [
                {coExecutorsId: $all: [@userId]}
                {executorId: @userId}
                {userId: @userId}
            ]
        }, sort:
            createdAt: -1
            _id: -1

        Meteor.users.find {},
            fields:
                'username': 1
    ]


Meteor.publish 'teamAll', () ->
    Meteor.users.find {},
        fields:
            'username': 1
            'profile.position': 1

Meteor.publish 'teamItem', (userId) ->
    Meteor.users.find {_id: userId},
        fields:
            'username': 1
            'createdAt': 1
            'profile': 1


Meteor.publish 'settings', () ->
    Meteor.users.find {_id: @userId},
        fields:
            emails: 1
            profile: 1
            createdAt: 1
