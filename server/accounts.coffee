
Accounts.validateNewUser( () ->
    # Проверять разрешено ли пользователю создавать других пользователей
    return Meteor.user()._id == '2xkms5zv5S3G7F42c'
)
