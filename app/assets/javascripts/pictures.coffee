@images = []
@clicked_index = 0
@image_count = 0
@src_id = "mixi"
@dress_id
setTimeout ->
  $(".loadingWrap").fadeOut()
  # 初期設定
  canvas = $('#draw-area')
  mapping = $('#mapping-area')
  if canvas[0]
    ctx = canvas[0].getContext('2d')
    map_ctx = mapping[0].getContext('2d')

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
      img.src_id = @src_id
      img.src = "/sources/draw/#{@src_id}.png"
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
    selectDress(id)

  $(".src-btn").click ->
    $(".src-btn").removeClass("selected-control")
    $(this).addClass("selected-control")
    id = $(this).attr("id")
    switchSource(id)

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
  $("#save-button").click ->
    $(".loadingWrap").fadeIn()
    save()

  selectDress = (id) ->
    @dress_id = id
    redraw()

  switchSource = (id) ->
    @src_id = id
    # 初期位置がずれるので一回書いておく
    img = new Image()
    img.src = "/sources/draw/#{@src_id}.png"
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
      @clicked_index--
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
    dress_img.src = "/dresses/draw/#{@dress_id}.png"
    dress_img.onload = () ->
      ctx.drawImage(dress_img, 0, 0)
      drawSources()
      fillSelect()
    
  # パーツ描画
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

  # 選択状態描画
  fillSelect = () ->
    for image, i in @images
      if i == @clicked_index
        ctx.beginPath()
        ctx.rect(image.drawOffsetX, image.drawOffsetY, image.drawWidth, image.drawHeight)
        ctx.strokeStyle = '#92c5ce'
        ctx.lineWidth = 2
        ctx.stroke()
        break

  # color-switcher
  $(".color-button").click ->
    id = $(this).attr("id")
    selector = ".parts-#{id}"
    $(".color-part").css("display", "none")
    $("#{selector}").css("display", "block")


  save = () ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())
    dress_img = new Image()
    dress_img.src = "/dresses/draw/#{@dress_id}.png"
    dress_img.onload = () ->
      ctx.drawImage(dress_img, 0, 0)
      drawSources()
      generateMappingDress()

  generateMappingDress = () ->
    # mapping用の画像生成
    map_dress = new Image()
    map_dress.src = "/dresses/mapping/#{@dress_id}.png"
    map_dress.onload = () ->
      map_ctx.drawImage(map_dress, 0, 0)
      generateImage()

  generateImage = () ->
    if @images.length == 0
      sendImage()
      return

    image = @images.shift()
    map_source = new Image()
    map_source.src = "/sources/mapping/#{image.src_id}.png"

    map_offsetX = image.drawOffsetX * 3
    map_offsetY = image.drawOffsetY * 3
    map_drawWidth = image.drawWidth * 3
    map_drawHeight = image.drawHeight * 3

    map_source.onload = () ->
      if image.radian
        drawX = map_offsetX + map_drawWidth / 2
        drawY = map_offsetY + map_drawHeight / 2
        radian = image.radian * Math.PI / 180
        map_ctx.save()
        map_ctx.translate(drawX, drawY)
        map_ctx.rotate(radian)
        map_ctx.translate(-1 * drawX, -1 * drawY)
        map_ctx.drawImage(map_source, map_offsetX, map_offsetY, map_drawWidth, map_drawHeight)
        map_ctx.restore()
      else
        map_ctx.drawImage(map_source, map_offsetX, map_offsetY, map_drawWidth, map_drawHeight)

    setTimeout ->
      generateImage()
    , 500

  sendImage = () ->
    url = canvas[0].toDataURL()
    mapping_url = mapping[0].toDataURL()
    $.post '/pictures/', {data: url}, (data) ->
        location.href="/"
    $.post '/pictures/create_mapping', {data: mapping_url}, (data) ->
        location.href="/"
, 3000
