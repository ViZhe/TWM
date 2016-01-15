
UserSchemaChangeProfile = new SimpleSchema
    'lastName':
        label: 'Фамилия'
        type: String
        min: 0
        max: 30
    'firstName':
        label: 'Имя'
        type: String
        min: 0
        max: 30
    'middleName':
        label: 'Отчество'
        type: String
        optional: true
    'gender':
        label: 'Пол'
        type: String
        allowedValues: ['male', 'female']
    'birthday':
        label: 'День рождения'
        type: Date
        autoValue: -> new Date(@value)
    'phoneMobile':
        label: 'Мобильный телефон'
        type: String
        regEx: /[0-9\+\(\)\-\s]+/
        optional: true
    'phoneWork':
        label: 'Рабочий телефон'
        type: String
        regEx: /[0-9\+\(\)\-\s]+/
        optional: true

UserSchema = new SimpleSchema
    _id:
        type: String
        regEx: SimpleSchema.RegEx.Id

    emails:
        type: [Object]
    'emails.$.address':
        type: String
        regEx: SimpleSchema.RegEx.Email
    'emails.$.verified':
        type: Boolean

    createdAt:
        type: Date
    services:
        type: Object
        blackbox: true
    profile:
        type: UserSchemaChangeProfile

Meteor.users.attachSchema UserSchema



@UserSchemaChangePassword = new SimpleSchema
    'passwordOld':
        label: 'Текущий пароль'
        type: String
        min: 0
        max: 30
    'passwordNew':
        label: 'Новый пароль'
        type: String
        min: 10
        max: 30
    'passwordNewConfirm':
        label: 'Подтверждение нового пароля'
        type: String
        min: 10
        max: 30
        custom: ->
            if @value != @field('passwordNew').value
                return 'passwordMismatch'


Meteor.methods
    updateProfile: (profile) ->
        check(Meteor.userId(), String)

        # console.log profile.birthday
        if profile.birthday
            profile.birthday = moment(profile.birthday, 'DD.MM.YYYY').format('YYYY-MM-DD')
        # console.log profile.birthday
        errors =
            countErrors: 0
        Meteor.users.update {_id: Meteor.userId()}, $set: {profile: profile}, (error, result) ->
            if error
                context = Meteor.users.simpleSchema().namedContext()
                context.invalidKeys().map (key) ->
                    errors[key.name] = context.keyErrorMessage(key.name)
                    errors.countErrors++

        if errors.countErrors
            return {
                errors: errors
            }

        return {
            _id: Meteor.userId()
        }

    #  return Meteor.users.update(Meteor.userId(), {$set: {profile: profile}});
    # updateProfile: (profile) ->
    #     console.log profile
    #     console.log Meteor.userId()
    #     profile
    #     return {
    #         _id: Meteor.userId()
    #     }
