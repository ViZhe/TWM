
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



projectsRoutes.route '/edit/:_id',
    name: 'projectsEdit'

    subscriptions: (params, queryParams) ->
        @register 'projectsEdit', Meteor.subscribe('projectsEdit', params._id)

    action: (params) ->
        FlowRouter.subsReady 'projectsEdit', ->
            if Projects.findOne()
                BlazeLayout.render 'application',
                    main: 'projectsEdit'
                    sub: 'projectsEditSub'
            else
                BlazeLayout.render 'notFound'



projectsRoutes.route '/:_id',
    name: 'projectsItem'

    subscriptions: (params, queryParams) ->
        @register 'projectsItem', Meteor.subscribe('projectsItem', params._id)

    action: (params) ->
        FlowRouter.subsReady 'projectsItem', ->
            if Projects.findOne()
                BlazeLayout.render 'application',
                    main: 'projectsItem'
                    sub: 'projectsItemSub'
            else
                BlazeLayout.render 'notFound'
