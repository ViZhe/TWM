
Template.aside.events
    'click .js-aside-user__logout': (e, template) ->
        e.preventDefault()
        Meteor.logout ->
            FlowRouter.go('/login')


    'click .b-aside-btn__add': (e, template) ->
        e.preventDefault()

    'focus .b-aside-btn__add': (e, template) ->
        $('.b-aside-btn__add').addClass 'b-aside-btn__add_open'

    'focusout .b-aside-btn__add': (e, template) ->
        $('.b-aside-btn__add_open').removeClass 'b-aside-btn__add_open'

    'focus .b-aside-btn__link': (e, template) ->
        $('.b-aside-btn__add').addClass 'b-aside-btn__add_open'

    'focusout .b-aside-btn__link': (e, template) ->
        $('.b-aside-btn__add_open').removeClass 'b-aside-btn__add_open'
