
Template.projectsItem.helpers
    tasksList: () ->
        Tasks.find()

Template.projectsItemSub.helpers
    project: () ->
        Projects.findOne()

    isCreator: () ->
        Meteor.userId() == @userId
