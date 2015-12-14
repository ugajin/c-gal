@images = []
@roll = []
@roll_index = -1
@clicked_index = 0
@image_count = 0
@src_id = "mixi"
@dress_id
$ ->
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

      recordAction("draw", img)

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
  $("#rollback").click ->
    rollback()
  $("#forward").click ->
    rollForward()
  $(".control-button").click ->
    id = $(this).attr("id")
    recordAction(id)
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

  moveLeft = (index = null) ->
    index = @clicked_index if !index
    @images[index].drawOffsetX -= 5
    redraw()

  moveRight = (index = null) ->
    index = @clicked_index if !index
    @images[index].drawOffsetX += 5
    redraw()

  moveUp = (index = null) ->
    index = @clicked_index if !index
    @images[index].drawOffsetY -= 5
    redraw()

  moveDown = (index = null) ->
    index = @clicked_index if !index
    @images[index].drawOffsetY += 5
    redraw()

  drawUp = (index = null) ->
    index = @clicked_index if !index
    @images[index].drawWidth *= 1.1
    @images[index].drawHeight *= 1.1
    redraw()

  drawDown = (index = null) ->
    index = @clicked_index if !index
    @images[index].drawWidth /= 1.1
    @images[index].drawHeight /= 1.1
    redraw()

  rotateRight = (index = null) ->
    index = @clicked_index if !index
    @images[@clicked_index].radian += 10
    redraw()

  rotateLeft = (index = null) ->
    index = @clicked_index if !index
    @images[@clicked_index].radian -= 10
    redraw()

  recordAction = (id, img = null) ->
    @roll_index++
    @roll[@roll_index] = new roll()
    @roll[@roll_index].action = id
    @roll[@roll_index].index = @clicked_index
    @roll[@roll_index].image = img

  # 戻るボタン
  rollback = () ->
    if @roll_index > -1
      switch @roll[@roll_index].action
        when "move-left"
          moveRight(@roll[@roll_index].index)
        when "move-right"
          moveLeft(@roll[@roll_index].index)
        when "move-up"
          moveDown(@roll[@roll_index].index)
        when "move-down"
          moveUp(@roll[@roll_index].index)
        when "draw-up"
          drawDown(@roll[@roll_index].index)
        when "draw-down"
          drawUp(@roll[@roll_index].index)
        when "rotate-left"
          rotateRight(@roll[@roll_index].index)
        when "rotate-right"
          rotateLeft(@roll[@roll_index].index)
        when "draw"
          target = @image_count
          target--
          @images.splice target, 1
          @clicked_index-- if target is @clicked_index
          @image_count--
          redraw()
          

      @roll_index--

  rollForward = () ->
    if @roll_index
      switch @roll[@roll_index].action
        when "move-left"
          moveLeft(@roll[@roll_index].index)
        when "move-right"
          moveRight(@roll[@roll_index].index)
        when "move-up"
          moveUp(@roll[@roll_index].index)
        when "move-down"
          moveDown(@roll[@roll_index].index)
        when "draw-up"
          drawUp(@roll[@roll_index].index)
        when "draw-down"
          drawDown(@roll[@roll_index].index)
        when "rotate-left"
          rotateLeft(@roll[@roll_index].index)
        when "rotate-right"
          rotateRight(@roll[@roll_index].index)
      @roll_index++

  deleteClicked = () ->
    if @images.length > 0
      @images.splice @clicked_index, 1
      @clicked_index--
      @image_count--
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


class roll
  index: 0
  image: 0
  action: ""
