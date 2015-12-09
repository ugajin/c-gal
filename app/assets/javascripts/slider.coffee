$ ->
  $('#slider-left').each ->
    loopsliderWidth = $(this).width()
    loopsliderHeight = $(this).height()
    time = 50 * loopsliderWidth

    loopsliderLeft = ->
      $('#slider-left-wrap').css left: '0'
      $('#slider-left-wrap').stop().animate { left: '-' + loopWidth + 'px' }, time, 'linear'
      setTimeout (->
        loopsliderLeft()
        return
      ), time
      return

    $(this).children('ul').wrapAll('<div id="slider-left-wrap"></div>')
    listWidth = $('#slider-left-wrap').children('ul').children('li').width()
    listCount = $('#slider-left-wrap').children('ul').children('li').length
    loopWidth = listWidth * listCount
    $('#slider-left-wrap').css
      top: '0'
      left: '0'
      width: loopWidth * 2
      height: loopsliderHeight
      overflow: 'hidden'
      position: 'absolute'
    $('#slider-left-wrap ul').css width: loopWidth
    loopsliderLeft()
    $('#slider-left-wrap ul').clone().appendTo '#slider-left-wrap'
    return



  $('#slider-right').each ->
    loopsliderWidth = $(this).width()
    loopsliderHeight = $(this).height()
    time = 50 * loopsliderWidth

    loopsliderRight = ->
      $('#slider-right-wrap').css right: '0'
      $('#slider-right-wrap').stop().animate { right: '-' + loopWidth + 'px' }, time, 'linear'
      setTimeout (->
        loopsliderRight()
        return
      ), time
      return

    $(this).children('ul').wrapAll('<div id="slider-right-wrap"></div>')
    listWidth = $('#slider-right-wrap').children('ul').children('li').width()
    listCount = $('#slider-right-wrap').children('ul').children('li').length
    loopWidth = listWidth * listCount
    $('#slider-right-wrap').css
      top: '0'
      right: '0'
      width: loopWidth * 2
      height: loopsliderHeight
      overflow: 'hidden'
      position: 'absolute'
    $('#slider-right-wrap ul').css width: loopWidth
    loopsliderRight()
    $('#slider-right-wrap ul').clone().appendTo '#slider-right-wrap'
    return
  return
