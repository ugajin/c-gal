@images = []
@clicked = 0
@image_count = 0

$ ->
  # 初期設定
  canvas = $('#draw-area')
  ctx = canvas[0].getContext('2d')

  # クリック時処理
  canvas.mousedown (e)->
    mouseDown(e)

  mouseDown = (e) ->
    # 当たり判定
    on_image = false
    
    if @images
      for image, i in images
        if e.offsetX >= images[i].drawOffsetX && e.offsetX <= (images[i].drawOffsetX + images[i].drawWidth) &&
           e.offsetY >= images[i].drawOffsetY && e.offsetY <= (images[i].drawOffsetY + images[i].drawHeight)

          @clicked = i
          on_image = true


    if on_image
      console.log "on_image"
    else
      img = new Image()
      img.src = "/images/fb_icon.png"
      # 今は決め打ち
      img.drawWidth = 30
      img.drawHeight = 30
      img.drawOffsetX = e.offsetX
      img.drawOffsetY = e.offsetY

      @images[@image_count] = img
      @image_count++

      img.onload = ()->
        ctx.drawImage(img, e.offsetX, e.offsetY)


  # 消去ボタン
  $("#clear-button").click ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())  

  # 保存ボタン
  $("#save-button").click ->
    url = canvas[0].toDataURL()
    $.post '/pictures/', {data: url}, (data) ->
      console.log "image saved"
