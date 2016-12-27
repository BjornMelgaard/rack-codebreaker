class window.Application
  @_controllers: {}
  @_widgets: {}

  @add_controller: (name, controller)->
    @_controllers[name] = controller

  @get_controller: (name)->
    @_controllers[name]

  @add_widget: (name, widget)->
    @_widgets[name] = widget

  @get_widget: (name)->
    @_widgets[name]

  constructor: () ->
    page_controller = $('body').data('page-name')
    @use_controller("layout")
    @use_controller(page_controller)

  use_controller: (name) ->
    controller = @constructor.get_controller(name)
    throw { message: "Wrong controller name", name: name } unless controller
    new controller()

class window.Controller
  use_widget: (name) ->
    widget = window.Application.get_widget(name)
    throw { message: "Wrong widget name", name: name } unless widget
    new widget(this)

$ ->
  new window.Application()
