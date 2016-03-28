
Template.projectsItem.helpers
    tasksList: () ->
        if Tasks.findOne() then Tasks.find() else null

Template.projectsItemSub.helpers
    project: () ->
        Projects.findOne()

    isCreator: () ->
        Meteor.userId() == @userId
