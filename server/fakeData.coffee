
# Создаем тестового root юзера
if Meteor.users.find().count() == 0
    Accounts.createUser
        email: 'test@test.ru'
        password: 'test'
        profile:
            root: true
