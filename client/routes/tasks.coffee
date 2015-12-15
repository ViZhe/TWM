
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

    action: () ->
        BlazeLayout.render 'application',
            main: 'tasksAdd'



tasksRoutes.route '/:_id',
    name: 'tasksItem'

    subscriptions: (params, queryParams) ->
        @register 'tasksItem', Meteor.subscribe('tasksItem', params._id)
        @register 'comments', Meteor.subscribe('comments', params._id)
        @register 'nameUsers', Meteor.subscribe('nameUsers')

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
