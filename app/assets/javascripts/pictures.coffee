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
      # 今は決め打ち
      img.drawWidth = img.width
      img.drawHeight = img.height
      img.drawOffsetX = e.offsetX
      img.drawOffsetY = e.offsetY

      @images[@image_count] = img
      @clicked_index = @image_count
      @image_count++

      img.onload = ()->
        ctx.drawImage(img, e.offsetX, e.offsetY)

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
  #$("#move-rotate").click ->
  #  moveRotate()

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

  moveRotate = () ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())
    for image, i in images
      if i is @clicked_index
        ctx.translate(0,0)
        ctx.rotate(90)
        ctx.translate(0,0)
        ctx.drawImage(image, image.drawOffsetX, image.drawOffsetY)
        ctx.rotate(0)
      else
        ctx.drawImage(image, image.drawOffsetX, image.drawOffsetY)

  redraw = () ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())
    dress_img = new Image()
    dress_img.src = @dress_src
    ctx.drawImage(dress_img, 0, 0)
    
    for image, i in images
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
