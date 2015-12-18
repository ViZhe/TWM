
Meteor.publish 'tasksAll', () ->
    Tasks.find()

Meteor.publish 'tasksAdd', (userId) ->
    [
        Projects.find() # вывести те проекты в которых состоит пользователь userId
        Meteor.users.find {},
            fields:
                'profile.username': 1
    ]

Meteor.publish 'tasksItem', (taskId) ->
    [
        Tasks.find(taskId)
        Projects.find()

        # Ограничить только юзернеймом
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

Meteor.publish 'projectsItem', (projectId) ->
    [
        Projects.find(projectId)

        # Ограничить только юзернеймом
        Meteor.users.find {},
            fields:
                profile: 1
    ]
