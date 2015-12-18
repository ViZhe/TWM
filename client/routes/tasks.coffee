
tasksRoutes = FlowRouter.group
    name: 'tasksGroup'
    prefix: '/tasks'


tasksRoutes.route '/',
    name: 'tasks'

    subscriptions: (params, queryParams) ->
        @register 'tasksAll', Meteor.subscribe('tasksAll')

    action: () ->
        FlowRouter.subsReady 'tasksAll', ->
            BlazeLayout.render 'application',
                main: 'tasks'
                sub: 'tasksSub'



tasksRoutes.route '/add',
    name: 'tasksAdd'

    subscriptions: () ->
        @register 'tasksAdd', Meteor.subscribe('tasksAdd', Meteor.userId())

    action: () ->
        FlowRouter.subsReady 'tasksAdd', ->
            BlazeLayout.render 'application',
                main: 'tasksAdd'



tasksRoutes.route '/:_id',
    name: 'tasksItem'

    subscriptions: (params, queryParams) ->
        @register 'tasksItem', Meteor.subscribe('tasksItem', params._id)

    action: (params) ->
        FlowRouter.subsReady 'tasksItem', ->
            if task = Tasks.findOne()
                BlazeLayout.render 'application',
                    main: 'tasksItem'
                    mainParams: task
                    sub: 'tasksItemSub'
                    subParams: task
            else
                BlazeLayout.render 'notFound'
