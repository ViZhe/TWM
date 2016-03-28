
@Invites = new Mongo.Collection 'invites'

Invites.attachSchema new SimpleSchema
    'email':
        label: 'Почта'
        type: String

        regEx: SimpleSchema.RegEx.Email
        custom: ->
            if !!Accounts.findUserByEmail(@value)
                return 'accountAlreadyExists'
            if !!Invites.findOne({email: @value})
                return 'emailAlreadyInvited'



Invites.deny
    insert: -> true
    update: -> true
    remove: -> true

Meteor.methods
    addInvite: (email) ->
        # юзер админ

        console.log !!Invites.findOne({}, {email: email})

        invite = if email then {email: email} else {}

        errors =
            countErrors: 0
        inviteId = Invites.insert invite, (error, result) ->
            if error
                context = Invites.simpleSchema().namedContext()
                context.invalidKeys().map (key) ->
                    errors[key.name] = context.keyErrorMessage(key.name)
                    errors.countErrors++

        if errors.countErrors
            return {
                errors: errors
            }

        return {
            _id: inviteId
        }

    delInvite: (email) ->
        console.log email
        return false
