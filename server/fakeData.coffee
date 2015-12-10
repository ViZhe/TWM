
# Создаем тестового root юзера
if Meteor.users.find().count() == 0
    Accounts.createUser
        email: 'test@test.ru'
        password: 'test'
        profile:
            username: 'Железцов Виктор'
        root: true
