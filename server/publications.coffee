
Meteor.publish 'tasksItem', (taskId) ->
    Tasks.find(taskId)
