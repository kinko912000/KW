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
