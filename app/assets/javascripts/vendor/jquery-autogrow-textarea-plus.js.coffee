# AutogrowPlus
# Based off https://code.google.com/p/gaequery/source/browse/trunk/src/static/scripts/jquery.autogrow-textarea.js?r=2
# Modified by David Beck
# Modified by Sherwin Yu

(($) ->
  ###
  autogrowVerticallyIE8 = ->
    @each ->
      
      # Variables
      colsDefault = @cols
      rowsDefault = @rows
      
      #Functions
      grow = ->
        growByRef this

      growByRef = (obj) ->
        linesCount = 0
        lines = obj.value.split("\n")
        i = lines.length - 1

        while i >= 0
          linesCount += Math.floor((lines[i].length / colsDefault / 2) + 1)
          --i
        if linesCount >= rowsDefault
          obj.rows = linesCount + 1
        else
          obj.rows = rowsDefault

      characterWidth = (obj) ->
        characterWidth = 0
        temp1 = 0
        temp2 = 0
        tempCols = obj.cols
        obj.cols = 1
        temp1 = obj.offsetWidth
        obj.cols = 2
        temp2 = obj.offsetWidth
        characterWidth = temp2 - temp1
        obj.cols = tempCols
        characterWidth

      @style.height = "auto"
      @style.overflow = "hidden"
      @onkeyup = grow
      @onfocus = grow
      @onblur = grow
      growByRef this
    ###


  
  #
  #     * Auto-growing textareas; technique ripped from Facebook
  #     

  $.fn.autogrowplus = (options) ->
    options = $.extend(
      vertical: true
      horizontal: false
    , options)

    @filter("textarea").each ->
      $el = $(this)
      minHeight = $el.height()
      maxHeight = $el.attr("maxHeight")
      lineHeight = $el.css("lineHeight")
      minWidth = (if typeof ($el.attr("minWidth")) is "undefined" then 0 else $el.attr("minWidth"))
      maxHeight = 1000000  if typeof (maxHeight) is "undefined"

      shadow = $('<div class="autogrowplus-shadow"></div>').css(
        position: "absolute"
        bottom: 400
        left: 400
        fontSize: $el.css("fontSize")
        fontFamily: $el.css("fontFamily")
        fontWeight: $el.css("fontWeight")
        lineHeight: $el.css("lineHeight")
        border: $el.css('border')
        padding: $el.css('padding')
        margin: $el.css('margin')
        resize: "none"
      ).appendTo(document.body)

      update = ->
        times = (string, number) ->
          i = 0
          r = ""

          while i < number
            r += string
            i++
          r

        val = @value
        if options.vertical
          debugger
          val = val.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/&/g, "&amp;").replace(/\n$/, "<br/>&nbsp;").replace(/\n/g, "<br/>").replace(RegExp(" {2,}", "g"), (space) ->
            times("&nbsp;", space.length - 1) + " "
          )
        
        #if( options.horizontal )
        #      val = $.trim( val );

        # set the shadow's internal shit
        shadow.html(val).css "width", "auto"
        if options.horizontal and shadow.parent().length
          maxWidth = options.maxWidth
          maxWidth = $el.parent().width() - 12  if typeof (maxWidth) is "undefined"
          otherWidth = parseInt($el.css('width')) - $el.width() + 12
          width = Math.min(Math.max(shadow.width() + otherWidth, minWidth), maxWidth)
          console.log "setting ##{$el.attr 'id'}.width=#{width}"
          $(@).css "width", width

        ###
        if options.vertical
          shadow.css "width", $(this).width() - parseInt($el.css("paddingLeft"), 10) - parseInt($el.css("paddingRight"), 10)
          shadowHeight = shadow.height()
          newHeight = Math.min(Math.max(shadowHeight, minHeight), maxHeight)
          $(this).css "height", newHeight
          $(this).css "overflow", (if newHeight is maxHeight then "auto" else "hidden")
        ###

      #### set it up
      $(@).on 'remove.autogrowplus', (e)->
        e.preventDefault()
        $(this).off '.autogrowplus'
        console.log('removing')
        shadow.remove()
      $(this).on 'change.autogrowplus', update
      $(this).on 'keyup.autogrowplus', update
      $(this).on 'keydown.autogrowplus', update
      # change(update).keyup(update).keydown(update).bind "remove.autogrowplus", (e) ->

      update.apply this

    this
) jQuery
