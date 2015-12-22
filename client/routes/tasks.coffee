
tasksRoutes = FlowRouter.group
    name: 'tasksGroup'
    prefix: '/tasks'


tasksRoutes.route '/',
    name: 'tasks'

    subscriptions: (params, queryParams) ->
        @register 'tasks', Meteor.subscribe('tasks')

    action: () ->
        FlowRouter.subsReady 'tasks', ->
            BlazeLayout.render 'application',
                main: 'tasks'
                sub: 'tasksSub'



tasksRoutes.route '/add',
    name: 'tasksAdd'

    subscriptions: () ->
        @register 'tasksAdd', Meteor.subscribe('tasksAdd')

    action: () ->
        FlowRouter.subsReady 'tasksAdd', ->
            BlazeLayout.render 'application',
                main: 'tasksAdd'



tasksRoutes.route '/edit/:_id',
    name: 'tasksEdit'

    subscriptions: (params, queryParams) ->
        @register 'tasksEdit', Meteor.subscribe('tasksEdit', params._id)

    action: (params) ->
        FlowRouter.subsReady 'tasksEdit', ->
            if Tasks.findOne()
                BlazeLayout.render 'application',
                    main: 'tasksEdit'
                    sub: 'tasksEditSub'
            else
                BlazeLayout.render 'notFound'



tasksRoutes.route '/:_id',
    name: 'tasksItem'

    subscriptions: (params, queryParams) ->
        @register 'tasksItem', Meteor.subscribe('tasksItem', params._id)

    action: (params) ->
        FlowRouter.subsReady 'tasksItem', ->
            if Tasks.findOne()
                BlazeLayout.render 'application',
                    main: 'tasksItem'
                    sub: 'tasksItemSub'
            else
                BlazeLayout.render 'notFound'
