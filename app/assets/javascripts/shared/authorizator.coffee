class CookieAuthorizator
  authorize: (player_name) ->
    document.cookie = "player_name=#{player_name};"
  unauthorize: () ->
    document.cookie = "player_name=;"
    location.reload()

window.authorizator = new CookieAuthorizator