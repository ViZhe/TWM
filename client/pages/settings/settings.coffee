
Template.settings.onCreated ->
    Session.set 'settingsErrors', {}
    return

Template.settings.rendered = ->
    datepick = $('.js-datepicker').datepicker(
        autoClose: true
        dateFormat: 'dd.mm.yyyy'
        view: 'years'

    ).data('datepicker')
    if deadlineDate = 0
        datepick.selectDate(new Date(deadlineDate))


Template.settings.helpers
    user: () ->
        Meteor.users.findOne()

    errorMessage: (field) ->
        Session.get('settingsErrors')[field]

    errorClass: (field) ->
        if !!Session.get('settingsErrors')[field] then 'c-form__field_invalid'

# Template.settingsSub.helpers
#     user: () ->
#         Meteor.users.findOne()


Template.settings.events
    'submit form#changePassword': (e, template) ->
        e.preventDefault()

        passwordOld = template.find('[name=passwordOld]').value
        passwordNew = template.find('[name=passwordNew]').value
        passwordNewConfirm = template.find('[name=passwordNewConfirm]').value

        errors =
            countErrors: 0

        if !passwordOld
            errors.passwordOld = 'Обязательное поле'
            errors.countErrors++

        if !passwordNew
            errors.passwordNew = 'Обязательное поле'
            errors.countErrors++

        if !passwordNewConfirm
            errors.passwordNewConfirm = 'Обязательное поле'
            errors.countErrors++

        if passwordNew != passwordNewConfirm
            errors.passwordNew = 'Пароли не совпадают.'
            errors.passwordNewConfirm = 'Пароли не совпадают.'
            errors.countErrors++


        Session.set('settingsErrors', errors)
        if errors.countErrors
            return

        Accounts.changePassword passwordOld, passwordNew, (error) ->
            if error
                if error.reason == 'Incorrect password'
                    errors.passwordOld = 'Неверный пароль'
                else
                    console.log error
            else
                $('[name=passwordOld]').val('')
                $('[name=passwordNew]').val('')
                $('[name=passwordNewConfirm]').val('')
                # TODO: сообщение что пароль успешно сменился

            Session.set('settingsErrors', errors)
