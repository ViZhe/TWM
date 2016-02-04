
homeRoutes = FlowRouter.group
    name: 'homeGroup'

homeRoutes.route '/',
    name: 'home'
    action: ->
        FlowRouter.go('/tasks')
        # BlazeLayout.render 'application',
        #     main: 'home'
        #     sub: 'homeSub'
