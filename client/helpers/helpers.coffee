
findUser = (id) ->
    user = Meteor.users.findOne(id)
    if user
        '<a href="/users/' + id + '">' + user.profile.username + '</a>'
    else
        'Не найден'

Template.registerHelper 'getUserLInk', (userId) ->
    result = ''
    if userId instanceof Array
        _.each userId, (user) ->
            if !!result
                result += ', '
            result += findUser user

    else
        result = findUser userId
    new Handlebars.SafeString result


Template.registerHelper 'getProjectLink', (projectId) ->
    project = Projects.findOne(projectId)
    if project
        result = '<a href="/projects/' + projectId + '">' + project.title + '</a>'
    else
        result = 'Не найден'

    new Handlebars.SafeString result



Template.registerHelper 'getDateText', (time) ->
    if time then moment(time).format('L')

Template.registerHelper 'getDateFullText', (time) ->
    if time then moment(time).format('L [в] HH:mm')
