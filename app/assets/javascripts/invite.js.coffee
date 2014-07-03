# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#invite").click ->
    $("#loading").fadeIn()
    $.post "/invite",
      $("form").serialize(),
      (response) ->
        $("#loading h1").html("Friends invited.")
        window.setTimeout ->
          $("#loading").fadeOut ->
            $("#loading h1").html("Loading...")
        , 1500
      'json'