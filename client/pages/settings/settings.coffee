
Template.settings.onCreated ->
    Session.set 'settingsErrors', {}
    return

Template.settings.rendered = ->
    datepick = $('.js-datepicker').datepicker(
        autoClose: true
        dateFormat: 'dd.mm.yyyy'
        view: 'years'

    ).data('datepicker')

    thisTask =
    if birthday = Meteor.users.findOne().profile.birthday
        datepick.selectDate(birthday)


Template.settings.helpers
    user: () ->
        Meteor.users.findOne()

    errorMessage: (field) ->
        Session.get('settingsErrors')[field]

    errorClass: (field) ->
        if !!Session.get('settingsErrors')[field] then 'c-form__field_invalid'

    activeGender: (gender) ->
        if gender == @profile.gender then 'selected'

# Template.settingsSub.helpers
#     user: () ->
#         Meteor.users.findOne()



Template.settings.events
    'submit form#changeEmail': (e, template) ->
        e.preventDefault()

        loginNew = template.find('[name=login]').value

        Meteor.call 'changeEmail', loginNew, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('settingsErrors', result.errors)

            if result._id
                Session.set('settingsErrors', {})
                $('[name=login]').val('')
                console.log 'Логин обновлен.'


    'submit form#changePassword': (e, template) ->
        e.preventDefault()

        passwordOld = template.find('[name=passwordOld]').value

        data =
            passwordOld: if passwordOld then passwordOld
            passwordNew: template.find('[name=passwordNew]').value
            passwordNewConfirm: template.find('[name=passwordNewConfirm]').value

        context = UserSchemaChangePassword.namedContext()
        context.validate(data)

        errors =
            countErrors: 0
        context.invalidKeys().map (key) ->
            errors[key.name] = context.keyErrorMessage(key.name)
            errors.countErrors++

        Session.set('settingsErrors', errors)
        if errors.countErrors
            return

        Accounts.changePassword data.passwordOld, data.passwordNew, (error) ->
            if error
                if error.reason == 'Incorrect password'
                    errors.passwordOld = 'Неверный пароль'
                else
                    console.log error
            else
                $('[name=passwordOld]').val('')
                $('[name=passwordNew]').val('')
                $('[name=passwordNewConfirm]').val('')
                console.log 'Пароль изменен.'
                # TODO: сообщение что пароль успешно сменился

            Session.set('settingsErrors', errors)


    'submit form#updateProfile': (e, template) ->
        e.preventDefault()

        profile =
            lastName: template.find('[name=lastName]').value
            firstName: template.find('[name=firstName]').value
            middleName: template.find('[name=middleName]').value
            gender: template.find('[name=gender]').value
            birthday: template.find('[name=birthday]').value
            phoneMobile: template.find('[name=phoneMobile]').value
            phoneWork: template.find('[name=phoneWork]').value
            email: template.find('[name=email]').value

        Meteor.call 'updateProfile', profile, (error, result) ->
            if error
                console.error error.reason

            if result.errors
                Session.set('settingsErrors', result.errors)

            if result._id
                Session.set('settingsErrors', {})
                console.log 'Профиль обновлен.'
