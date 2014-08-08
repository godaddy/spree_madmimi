class Mimi.Integration

  constructor: (element) ->
    @element = element || $('body')
    @initDom()
    @initObservers()

  initDom: ->
    @dom = Mimi.Utils.findElements(Mimi.Integration.DOM)

  initObservers: ->
    @dom.buttons.connect_account.on    'click', @onConnectAccountClicked.bind(@)
    @dom.buttons.create_account.on     'click', @onCreateAccountClicked.bind(@)
    @dom.buttons.disconnect_account.on 'click', @onDisconnectAccountClicked.bind(@)

  onConnectAccountClicked: (e) ->
    e.preventDefault()
    @openWindow(Mimi.Routes.connectAccountPath)

  onCreateAccountClicked: (e) ->
    e.preventDefault()
    @openWindow(Mimi.Routes.createAccountUrl.replace('%{redirect_url}', @createAccountRedirectUrl()))

  onDisconnectAccountClicked: (e) ->
    e.preventDefault()
    $.ajax(
      'type':    'DELETE'
      'url':     Mimi.Routes.disconnectAccountUrl
      'success': @onDisconnectAccountSuccess.bind(@)
      'error':   @onDisconnectAccountFailure.bind(@)
    )

  onDisconnectAccountSuccess: (response) ->
    window.location.reload()

  onDisconnectAccountFailure: (response) ->
    window.location.reload()

  openWindow: (url) ->
    window.open(
      url,
      'newWindow',
      'width=750,height=750,top=50,left=200'
    )

  createAccountRedirectUrl: ->
    l = window.document.location
    "#{ l.protocol }://#{ l.hostname }#{ ':' + l.port if l.port && l.port != 80 }#{ Mimi.Routes.connectAccountPath }"

Mimi.Integration.DOM =
  buttons:
    connect_account: '.connect_account, #connect_account'
    create_account:  '.create_account, #create_account'
    disconnect_account:  '.disconnect_account, #disconnect_account'
