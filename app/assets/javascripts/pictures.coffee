@images = []
@clicked_index = 0
@image_count = 0
@src = "/sources/draw/mixi.png"
@dress_src
$ ->
  # 初期設定
  canvas = $('#draw-area')
  if canvas[0]
    ctx = canvas[0].getContext('2d')

  # canvasクリック時処理
  canvas.mousedown (e)->
    mouseDown(e)

  mouseDown = (e) ->
    # 当たり判定
    on_image = false
    if @images
      for image, i in @images by -1
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
    redraw()

  # 各ボタンの処理
  $(".dress-btn").click ->
    $(".dress-btn").removeClass("selected-control")
    $(this).addClass("selected-control")
    id = $(this).attr("id")
    src = "/dresses/draw/#{id}.png"
    selectDress(src)

  $(".src-btn").click ->
    $(".src-btn").removeClass("selected-control")
    $(this).addClass("selected-control")
    id = $(this).attr("id")
    src = "/sources/draw/#{id}.png"
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
  $("#rotate-right").click ->
    rotateRight()
  $("#rotate-left").click ->
    rotateLeft()
  $("#clear-button").click ->
    clearCanvas()

  selectDress = (src) ->
    @dress_src = src
    redraw()

  switchSource = (src) ->
    @src = src
    # 初期位置がずれるので一回書いておく
    img = new Image()
    img.src = @src
    img.onload = ()->
      ctx.drawImage(img, 0, 0)
      redraw()

  moveLeft = () ->
    @images[@clicked_index].drawOffsetX -= 5
    redraw()

  moveRight = () ->
    @images[@clicked_index].drawOffsetX += 5
    redraw()

  moveUp = () ->
    @images[@clicked_index].drawOffsetY -= 5
    redraw()

  moveDown = () ->
    @images[@clicked_index].drawOffsetY += 5
    redraw()

  drawUp = () ->
    @images[@clicked_index].drawWidth *= 1.1
    @images[@clicked_index].drawHeight *= 1.1
    redraw()

  drawDown = () ->
    @images[@clicked_index].drawWidth /= 1.1
    @images[@clicked_index].drawHeight /= 1.1
    redraw()

  deleteClicked = () ->
    if images.length > 0
      images.splice @clicked_index, 1
      @clicked_index -= 1
      @image_count--
      redraw()

  rotateRight = () ->
    @images[@clicked_index].radian += 10
    redraw()

  rotateLeft = () ->
    @images[@clicked_index].radian -= 10
    redraw()

  clearCanvas = () ->
    if confirm "最初からやり直しますか？"
      ctx.clearRect(0, 0, canvas.width(), canvas.height())  
      @clicked_index = 0
      @image_count = 0
      @images = []


  redraw = () ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())
    dress_img = new Image()
    dress_img.src = @dress_src
    dress_img.onload = () ->
      ctx.drawImage(dress_img, 0, 0)
      drawSources()
    
  drawSources = () ->
    for image, i in @images
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

      if i == @clicked_index
        ctx.beginPath()
        ctx.rect(image.drawOffsetX, image.drawOffsetY, image.drawWidth, image.drawHeight)
        ctx.strokeStyle = '#92c5ce'
        ctx.lineWidth = 2
        ctx.stroke()


  # 保存ボタン
  $("#save-button").click ->
    url = canvas[0].toDataURL()
    $.post '/pictures/', {data: url}, (data) ->
      location.href="/"

  # color-switcher
  $(".color-button").click ->
    id = $(this).attr("id")
    selector = ".parts-#{id}"
    $(".color-part").css("display", "none")
    $("#{selector}").css("display", "block")
