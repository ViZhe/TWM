
Template.header.helpers
    getTitle: () ->
        groupName = FlowRouter.current().route.group.name
        test = FlowRouter.getRouteName() # без этого плохо обновляется блок - решить
        if groupName
            switch groupName
                when 'homeGroup'
                    result = 'Рабочий стол'
                when 'tasksGroup'
                    result = 'Задачи'
                when 'usersGroup'
                    result = 'Пользователи'
                when 'projectsGroup'
                    result = 'Проекты'
                else
                    result = 'TWM'
        else
            'TWM'
