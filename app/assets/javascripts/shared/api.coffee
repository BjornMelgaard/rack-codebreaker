class Ajaxor
  hint: ({ success, error })->
    $.ajax
      url: 'api/hint'
      success: (resp) -> success(resp)
      error:   (resp) -> error(resp.responseJSON)

  restart: ({ success, error })->
    $.ajax
      url: 'api/restart'
      success: (resp) -> success(resp)
      error:   (resp) -> error(resp.responseJSON)

  guess: ({ data, success, error })->
    $.ajax
      type: 'post'
      url: 'api/guess'
      data: { guess: data }
      success: (resp) -> success(resp)
      error:   (resp) -> error(resp.responseJSON)

window.api = new Ajaxor