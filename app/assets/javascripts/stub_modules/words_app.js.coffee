$ ->
  $('.js-unneed-word').on 'click', (e) ->
    $target = $(e.target)
    wordId = $target.data('id')
    url = "/api/words/#{wordId}"
    $.ajax
      url: url
      type: 'delete'
      data:
        id: wordId
      dataType: 'json'
      success: ->
        $('#notice').showNotice('不要単語登録を行いました')
      error: ->
        $('#notice').showNotice('不要単語登録に失敗しました')
