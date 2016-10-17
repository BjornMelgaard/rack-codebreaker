$ ->
  $("#login_form").submit (event) ->
    player_name = $(this).find('input[name="player_name"]').val()
    document.cookie = "player_name=#{player_name};"

  $(".logout").click (event) ->
    document.cookie = "player_name=;"
    location.reload()
