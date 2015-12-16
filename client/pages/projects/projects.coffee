
Template.projects.helpers
    projectsList: () ->
        Projects.find()

    getCounter: (num) ->
        num = if num then num else 0
