
Template.tasks.helpers
    tasksList: () ->
        Tasks.find {},
            sort:
                deadline: -1
                priority: 1
                title: -1

    getPriorityClass: () ->
        switch @priority
            when 1
                priority = 'high'
            when 2
                priority = 'medium'
            when 3
                priority = 'low'
            else
                priority = 'no'

        'p-tasks__row_priority_' + priority
