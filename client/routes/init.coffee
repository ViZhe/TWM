
BlazeLayout.setRoot 'body'


FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'notFound'


FlowRouter.triggers.enter [ (context, redirect) ->
    if !Meteor.userId()
        Session.set('lastUrl', context.path)
        redirect('/login')
], except: ['login']

FlowRouter.triggers.enter [ (context, redirect) ->
    if Meteor.userId()
        redirect('/')
], only: ['login']
