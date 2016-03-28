
# Создаем тестового root юзера
if Meteor.users.find().count() == 0
    Meteor.call('sendInvite', 'invite@test.ru')
    Accounts.createUser
        email: 'test@test.ru'
        password: 'test'
        username: 'Железцов Виктор'
        root: true # переделать на роли
