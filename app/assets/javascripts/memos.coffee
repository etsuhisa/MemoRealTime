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

