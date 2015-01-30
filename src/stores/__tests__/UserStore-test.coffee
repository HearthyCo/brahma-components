jest.dontMock '../UserStore'
window.apiServer = ''

describe 'User Store', ->

  it 'handles user:login event by POSTing the user credentials', ->

    Backbone = require 'exoskeleton'
    Backbone.ajax = jest.genMockFunction()
    UserStore = require '../UserStore'
    AppDispatcher = require '../../dispatcher/AppDispatcher'
    handler = AppDispatcher.on.mock.calls[0][1]

    payload = {
      user: {
        login: 'login'
        password: 'password'
      }
    }
    handler('user:login', payload)

    data = Backbone.ajax.mock.calls[0][0]
    expect(data.type).toEqual('POST')
    expect(data.url).toEqual('/v1/user/login')
    datajson = JSON.parse(data.data)
    expect(datajson.login).toEqual('login')
    expect(datajson.password).toEqual('password')

  it 'handles user:register event by POSTing the user info', ->

    Backbone = require 'exoskeleton'
    Backbone.ajax = jest.genMockFunction()
    UserStore = require '../UserStore'
    AppDispatcher = require '../../dispatcher/AppDispatcher'
    handler = AppDispatcher.on.mock.calls[0][1]

    payload = {
      user: {
        login: 'login'
        password: 'password'
        name: 'name'
        email: 'email'
        gender: 'gender'
        birthdate: 'birthdate'
      }
    }
    handler('user:register', payload)

    data = Backbone.ajax.mock.calls[0][0]
    expect(data.type).toEqual('POST')
    expect(data.url).toEqual('/v1/user')
    datajson = JSON.parse(data.data)

    for k,v of payload.user
      expect(datajson[k]).toEqual(v)

