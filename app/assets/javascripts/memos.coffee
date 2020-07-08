# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
	if $('#memo_text').length
		$('#memo_text').on 'paste', (event) ->
			items = event.originalEvent.clipboardData.items
			for item in items
				if item.type.indexOf("image") != -1
					file = item.getAsFile()
					upload_file_with_ajax(file, '/upload')
					true

		upload_file_with_ajax = (file, url) ->
			formData = new FormData()
			formData.append('file', file)
			$.ajax
				type: 'post'
				url: url
				contentType: false,
				processData: false,
				data: formData,
			.done (data) ->
				document.execCommand('insertText', false, "\n[img:"+data+":100%]\n")
				$('#paste_files').append("<dt>"+data+"</dt><dd><img src='"+data+"' width='200px'/></dd>")
			.fail (xhr, status, error) ->
				console.error status, xhr
				throw error
			true

	cur_node = null
	if $('.category_tree').length
		$('.category_tree').on 'click', ->
			if cur_node
				cur_node.css("background-color","")
			cur_node = $(this)
			cur_node.css("background-color","#ffd0d0")
			target = $(this).text()
			if target == '(all)'
				$("table#memos_table tr").css("display", "")
			else
				$("table#memos_table tr").each (index, elm) ->
					td = elm.children[0]
					if td && td.nodeName.toUpperCase() =="TD"
						if $(td).text().indexOf(target) != -1
							$(elm).css("display", "")
						else
							$(elm).css("display", "none")
			false
	if $('#new_memo_category').length
		$('#new_memo_category').on 'click', ->
			if cur_node
				window.location.href = $(this).attr("href")+"?category_id="+cur_node.attr("id").replace("category_tree_","")
				false
			true

	true
