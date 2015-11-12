@images = []
@clicked_index = 0
@image_count = 0
@src = "/sources/fb_icon.png"
@dress_src = "/dresses/dress01.png"

$ ->
  # 初期設定
  canvas = $('#draw-area')
  ctx = canvas[0].getContext('2d')

  # canvasクリック時処理
  canvas.mousedown (e)->
    mouseDown(e)

  mouseDown = (e) ->
    # 当たり判定
    on_image = false
    if @images
      for image, i in images
        if e.offsetX >= images[i].drawOffsetX && e.offsetX <= (images[i].drawOffsetX + images[i].drawWidth) &&
           e.offsetY >= images[i].drawOffsetY && e.offsetY <= (images[i].drawOffsetY + images[i].drawHeight)

          @clicked_index = i
          on_image = true
          break

    if not on_image
      img = new Image()
      img.src = @src
      img.drawWidth = img.width
      img.drawHeight = img.height
      img.drawOffsetX = e.offsetX - img.width / 2
      img.drawOffsetY = e.offsetY - img.height / 2
      img.radian = 0

      @images[@image_count] = img
      @clicked_index = @image_count
      @image_count++

      img.onload = ()->
        ctx.drawImage(img, img.drawOffsetX, img.drawOffsetY)

  # 各ボタンの処理
  $(".dress-btn").click ->
    id = $(this).attr("id")
    src = "/dresses/#{id}.png"
    selectDress(src)

  $(".src-btn").click ->
    id = $(this).attr("id")
    src = "/sources/#{id}.png"
    switchSource(src)

  $("#move-left").click ->
     moveLeft()
  $("#move-right").click ->
     moveRight()
  $("#move-up").click ->
     moveUp()
  $("#move-down").click ->
     moveDown()
  $("#draw-up").click ->
    drawUp()
  $("#draw-down").click ->
    drawDown()
  $("#delete-clicked").click ->
    deleteClicked()
  $("#rotateRight").click ->
    rotateRight()
  $("#rotateLeft").click ->
    rotateLeft()

  selectDress = (src) ->
    @dress_src = src
    redraw()

  switchSource = (src) ->
    @src = src

  moveLeft = () ->
    images[@clicked_index].drawOffsetX -= 10
    redraw()

  moveRight = () ->
    images[@clicked_index].drawOffsetX += 10
    redraw()

  moveUp = () ->
    images[@clicked_index].drawOffsetY -= 10
    redraw()

  moveDown = () ->
    images[@clicked_index].drawOffsetY += 10
    redraw()

  drawUp = () ->
    images[@clicked_index].drawWidth *= 1.1
    images[@clicked_index].drawHeight *= 1.1
    redraw()

  drawDown = () ->
    images[@clicked_index].drawWidth *= 0.9
    images[@clicked_index].drawHeight *= 0.9
    redraw()

  deleteClicked = () ->
    images.splice @clicked_index, 1
    @clicked_index = 0
    @image_count--
    redraw()

  rotateRight = () ->
    images[@clicked_index].radian += 10
    redraw()

  rotateLeft = () ->
    images[@clicked_index].radian -= 10
    redraw()

  redraw = () ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())
    dress_img = new Image()
    dress_img.src = @dress_src
    ctx.drawImage(dress_img, 0, 0)
    
    for image, i in images
      if image.radian
        drawX = image.drawOffsetX + image.drawWidth / 2
        drawY = image.drawOffsetY + image.drawHeight / 2
        radian = image.radian * Math.PI / 180
        ctx.save()
        ctx.translate(drawX, drawY)
        ctx.rotate(radian)
        ctx.translate(-1 * drawX, -1 * drawY)
        ctx.drawImage(image, image.drawOffsetX, image.drawOffsetY, image.drawWidth, image.drawHeight)
        ctx.restore()
      else
        ctx.drawImage(image, image.drawOffsetX, image.drawOffsetY, image.drawWidth, image.drawHeight)



  # 消去ボタン
  $("#clear-button").click ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())  
    @clicked_index = 0
    @image_count = 0

  # 保存ボタン
  $("#save-button").click ->
    url = canvas[0].toDataURL()
    $.post '/pictures/', {data: url}, (data) ->
      console.log "image saved"
