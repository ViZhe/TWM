
Template.projects.helpers
    projectsList: () ->
        Projects.find {},
            sort:
                title: 1
                createdAt: -1

    getCounter: (num) ->
        num = if num then num else 0
