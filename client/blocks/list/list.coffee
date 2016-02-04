

Template.registerHelper 'getListPriorityClass', () ->
    switch @priority
        when 1
            priority = 'high'
        when 2
            priority = 'medium'
        when 3
            priority = 'low'
        else
            priority = 'no'

    'b-list__row_priority b-list__row_priority_' + priority
