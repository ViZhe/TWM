
Meteor.publish 'tasksAll', (taskId) ->
    Tasks.find()

Meteor.publish 'tasksItem', (taskId) ->
    Tasks.find(taskId)

# Ограничить только юзернеймом
Meteor.publish 'nameUsers', ->
    Meteor.users.find {},
        fields:
            profile: 1
