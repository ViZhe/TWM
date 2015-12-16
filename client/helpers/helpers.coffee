
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



addZero = (num) ->
    i = if num < 10 then '0' + num else num

Template.registerHelper 'getTimeText', (time) ->
    fullDate = new Date(time)

    Year = fullDate.getFullYear()
    Month = fullDate.getMonth() + 1
    Day = fullDate.getDate()
    Hours = fullDate.getHours()
    Minutes = fullDate.getMinutes()

    date = addZero(Day) + '.' + addZero(Month) + '.' + Year
    time = addZero(Hours) + ':' + addZero(Minutes)

    date + ' ' + time

    # Человеко-понятные даты: 2 дня назад, через 21 день, через 2 часа.
    # now = new Date().getTime()
    # time = new Date(time).getTime()
    # diff = now - time
    # console.log now
    # console.log time
    # console.log diff
    # timeIt = Math.abs(diff) / 1000 / 60 / 60 / 24
    # timeHour = Math.floor(timeIt)
    # if diff > 0
    #     timeHour + ' дней' + ' назад'
    # else
    #     'через' + timeHour + ' дней'
