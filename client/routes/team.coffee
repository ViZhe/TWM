
teamRoutes = FlowRouter.group
    name: 'teamGroup'
    prefix: '/team'

teamRoutes.route '/',
    name: 'team'

    subscriptions: () ->
        @register 'teamAll', Meteor.subscribe('teamAll')

    action: ->
        FlowRouter.subsReady 'teamAll', ->
            BlazeLayout.render 'application',
                main: 'team'
                sub: 'teamSub'

teamRoutes.route '/:_id',
    name: 'teamItem'

    subscriptions: (params, queryParams) ->
        @register 'teamItem', Meteor.subscribe('teamItem', params._id)

    action: (params) ->
        FlowRouter.subsReady 'teamItem', ->
            if Meteor.users.findOne(params._id)
                BlazeLayout.render 'application',
                    main: 'teamItem'
                    # sub: 'teamItemSub'
            else
                BlazeLayout.render 'notFound'
