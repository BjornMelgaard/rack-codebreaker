class LoginFormWidget
  constructor: ->
    @_connectElements()
    @_bindEvents()

  _connectElements: ->
    @loginForm = $(".login-form")
    @nameInput = @loginForm.find('input[name="player_name"]')

  _bindEvents: ->
    @loginForm.submit @onSubmit

  onSubmit: (event) =>
    player_name = @nameInput.val()
    console.log player_name
    window.authorizator.authorize(player_name)

window.Application.add_widget("login_form", LoginFormWidget)
