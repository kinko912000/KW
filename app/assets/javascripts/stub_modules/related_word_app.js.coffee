$ ->
  $('.js-related-word').on 'change', (e) ->
    $target = $(e.target)
    parentId = $('#js-related-word-parent-id').data('id')
    childId = $target.attr('name').split('_').pop()
    value = $target.attr('value')
    url = "/api/related_words"
    $.ajax
      url: url
      type: 'post'
      data:
        parent_id: parentId
        child_id: childId
        same: value
      dataType: 'json'
      success: ->
        $('#notice').showNotice('類似ワードチェック登録を行いました')
      error: ->
        $('#notice').showNotice('類似ワードチェック登録に失敗しました')

  $('.js-selected-word').on 'click', (e) ->
    $target = $(e.target)
    id = $target.data('id')
    selected = $target.hasClass('inactive')
    url = "/api/words/#{id}"
    $.ajax
      url: url
      type: 'patch'
      data:
        id: id
        selected: selected
      dataType: 'json'
      success: ->
        if selected
          $('#notice').showNotice('執筆対象に変更しました')
          $target.removeClass('inactive')
          $target.addClass('active')
          $target.text('執筆対象です')
        else
          $('#notice').showNotice('執筆対象から外しました')
          $target.removeClass('active')
          $target.addClass('inactive')
          $target.text('対象外です')
      error: ->
        $('#notice').showNotice('類似ワードチェック登録に失敗しました')
