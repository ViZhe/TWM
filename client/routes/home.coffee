
FlowRouter.route '/',
    name: 'home'
    action: ->
        BlazeLayout.render 'application',
            content: 'home'
            data:
                headerBig: true
