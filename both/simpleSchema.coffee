SimpleSchema.messages
    required: '[label] обязательно для заполнения'
    minString: '[label] не может быть меньше [min] символов'
    maxString: '[label] не может быть больше [max] символов'
    minNumber: '[label] должны быть, по крайней мере [min]'
    maxNumber: '[label] не может превышать [max]'
    minDate: '[label] должно быть больше и равно [min]'
    maxDate: '[label] не может быть после [max]'
    badDate: '[label] не является доступной датой'
    minCount: 'Вы должны указать по крайней мере [minCount] значение'
    maxCount: 'Вы не можете указать больше, чем [maxCount] значение'
    noDecimal: '[label] должно быть целым числом'
    notAllowed: '[value] это не допустимое значение'
    expectedString: '[label] должно быть строкой'
    expectedNumber: '[label] должно быть числом'
    expectedBoolean: '[label] должно быть булево'
    expectedArray: '[label] должен быть массивом'
    expectedObject: '[label] должен быть объект'
    expectedConstructor: '[label] должно быть [Тип]'
    regEx: [
        {
            msg: '[label] сбой валидации регулярного выражения'
        }
        {
            exp: SimpleSchema.RegEx.Email
            msg: '[label] должено быть действительным адресом электронной почты'
        }
        {
            exp: SimpleSchema.RegEx.WeakEmail
            msg: '[label] должено быть действительным адресом электронной почты'
        }
        {
            exp: SimpleSchema.RegEx.Domain
            msg: '[label] должно быть допустимым доменом'
        }
        {
            exp: SimpleSchema.RegEx.WeakDomain
            msg: '[label] должно быть допустимым доменом'
        }
        {
            exp: SimpleSchema.RegEx.IP
            msg: '[label] должно быть допустимым адресом IPv4 или IPv6'
        }
        {
            exp: SimpleSchema.RegEx.IPv4
            msg: '[label] должно быть допустимым адресом IPv4'
        }
        {
            exp: SimpleSchema.RegEx.IPv6
            msg: '[label] должно быть допустимым адресом IPv6'
        }
        {
            exp: SimpleSchema.RegEx.Url
            msg: '[label] должно быть допустимым URL-адресом'
        }
        {
            exp: SimpleSchema.RegEx.Id
            msg: '[label] должено быть действительным буквенно-цифровым идентификатором'
        }
    ]
    keyNotInSchema: '[key] не разрешенный схемой'
