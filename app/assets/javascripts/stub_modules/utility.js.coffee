jQuery.fn.extend
  showNotice: (text) ->
    notice = @
    notice.html(text)
    notice.addClass('is-show')
    setTimeout ->
      notice.removeClass('is-show')
    , 800
    return notice
