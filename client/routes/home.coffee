
homeRoutes = FlowRouter.group
    name: 'homeGroup'

homeRoutes.route '/',
    name: 'home'
    action: ->
        BlazeLayout.render 'application',
            main: 'home'
