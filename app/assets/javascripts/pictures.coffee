$ ->
  canvas = $('#draw-area')
  ctx = canvas[0].getContext('2d')
  ctx.lineWidth = 1

  canvas.mousedown (e)->
    img = new Image()
    fill_x = $('.fill-x').val()
    fill_y = $('.fill-y').val()

    # ctx.strokeRect(e.clientX, e.clientY, fill_x, fill_y)
    img.onload = ()->
      ctx.drawImage(img, e.clientX, e.clientY)
    img.src = "/images/fb_icon.png"
    console.log ctx
  $("#clear-button").click ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())  

  ctx.savePrevData = ->
    @.prevImageData = @.getImageData(0, 0, canvas.width(), canvas.height()) 

  $("#return-button").click ->
        ctx.putImageData(ctx.prevImageData, 0, 0) 

  $("#save-button").click ->
    url = canvas[0].toDataURL()
    $.post '/pictures/', {data: url}, (data) ->
      reloadPictures()  
  

  reloadPictures = ->
      $.get '/pictures/', (result)->
        ids = result.split(',')
        pictures = $("#pictures")
        pictures.empty()
        ids.forEach (id, i)->
          if parseInt(id) > 0
            pictures.append("<img src=\"/images/#{id}.png\" class=\"thumbnail\" />")
        # ここからコピー処理
        thumb_pics = $("#pictures .thumbnail")
        thumb_pics.click ->
          image = new Image()
          image.src = $(@).attr('src')
          image.onload = ->
            ctx.clearRect(0, 0, canvas.width(), canvas.height())
            ctx.drawImage(image, 0, 0)
    reloadPictures()

  getPointPosition = (e) ->
      x: e.clientX
      y: e.clientY
