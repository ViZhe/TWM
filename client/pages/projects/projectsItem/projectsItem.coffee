
Template.projectsItem.helpers
    project: () ->
        Projects.findOne()

Template.projectsItemSub.helpers
    project: () ->
        Projects.findOne()

    isCreator: () ->
        Meteor.userId() == @userId
