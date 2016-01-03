
settingsRoutes = FlowRouter.group
    name: 'settingsGroup'
    prefix: '/settings'


settingsRoutes.route '/',
    name: 'settings'

    subscriptions: (params, queryParams) ->
        @register 'settings', Meteor.subscribe('settings')

    action: () ->
        FlowRouter.subsReady 'settings', ->
            BlazeLayout.render 'application',
                main: 'settings'
                sub: 'settingsSub'
