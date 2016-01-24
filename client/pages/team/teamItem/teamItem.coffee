
Template.teamItem.helpers
    user: () ->
        Meteor.users.findOne(FlowRouter.getParam('_id'))

    getGender: () ->
        if @profile.gender == 'male'
            result = 'мужской'
        else
            result = 'женский'
        result

    getAge: () ->
        moment(@profile.birthday).fromNow(true)

    getWorkTime: () ->
        moment(@createdAt).format('LL')
