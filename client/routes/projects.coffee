
projectsRoutes = FlowRouter.group
    name: 'projectsGroup'
    prefix: '/projects'


projectsRoutes.route '/',
    name: 'projects'

    subscriptions: (params, queryParams) ->
        @register 'projectsAll', Meteor.subscribe('projectsAll')

    action: () ->
        FlowRouter.subsReady 'projectsAll', ->
            BlazeLayout.render 'application',
                main: 'projects'




projectsRoutes.route '/add',
    name: 'projectsAdd'

    subscriptions: () ->
        @register 'projectsAdd', Meteor.subscribe('projectsAdd')

    action: () ->
        FlowRouter.subsReady 'projectsAdd', ->
            BlazeLayout.render 'application',
                main: 'projectsAdd'


projectsRoutes.route '/:_id',
    name: 'projectsItem'

    subscriptions: (params, queryParams) ->
        @register 'projectsItem', Meteor.subscribe('projectsItem', params._id)

    action: (params) ->
        FlowRouter.subsReady 'projectsItem', ->
            if project = Projects.findOne()
                BlazeLayout.render 'application',
                    main: 'projectsItem'
                    mainParams: project
                    sub: 'projectsItemSub'
                    subParams: project
            else
                BlazeLayout.render 'notFound'
