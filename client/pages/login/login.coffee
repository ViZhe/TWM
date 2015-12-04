


Template.login.onCreated ->
    Session.set 'loginErrors', {}


Template.login.events
    'submit form': (e, template) ->
        e.preventDefault()

        email = template.find('[name=username]').value
        password = template.find('[name=password]').value

        errors = {}
        if !email
            errors.email = 'Email is required'
        if !password
            errors.password = 'Password is required'
        Session.set 'loginErrors', errors

        Meteor.loginWithPassword email, password, (error) ->
            if error
                return Session.set('loginErrors', 'none': error.reason)
            sessionPath = Session.get('lastUrl')
            comeBackPath = if sessionPath then sessionPath else '/'
            FlowRouter.go(comeBackPath)
