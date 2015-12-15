
Meteor.publish 'tasksAll', () ->
    Tasks.find()

Meteor.publish 'tasksItem', (taskId) ->
    Tasks.find(taskId)


Meteor.publish 'projectsAll', () ->
    Projects.find()

Meteor.publish 'projectsItem', (projectId) ->
    Projects.find(projectId)


# Ограничить только юзернеймом
Meteor.publish 'nameUsers', ->
    Meteor.users.find {},
        fields:
            profile: 1

Meteor.publish 'comments', (taskId) ->
    Comments.find {taskId: taskId},
        sort:
            createdAt: -1
            _id: -1
