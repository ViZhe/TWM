
UserProfile = new SimpleSchema
    name:
        type: String
        label: 'Имя'
        regEx: /^[a-zA-Z- ]{2,35}$/

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
        type: UserProfile

Meteor.users.attachSchema UserSchema
