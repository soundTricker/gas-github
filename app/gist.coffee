do(global=@)->
	ApiBase = global.ApiBase
	class GistsApi extends ApiBase
		constructor:(accessToken)->
			super(accessToken)
		mine:(optSince)->
			req = @request('get' , '/gists', if optSince then 'since' : optSince else null)
			gists = JSON.parse(req.getContentText())
			return (new Gist(@accessToken , g) for g in gists)
		starred:(optSince)->
			req = @request('get' , '/gists/starred', if optSince then 'since' : optSince else null)
			gists = JSON.parse(req.getContentText())
			return (new Gist(@accessToken , g) for g in gists)
		user:(userId,optSince)->
			req = @request('get' , "/users/#{userId}/gists", if optSince then 'since' : optSince else null)
			gists = JSON.parse(req.getContentText())
			return (new Gist(@accessToken , g) for g in gists)
		public:(optSince)->
			req = @request('get', "/gists/public", if optSince then 'since' : optSince else null)
			gists = JSON.parse(req.getContentText())
			return (new Gist(@accessToken , g) for g in gists)
		get:(gistId)->
			req = @request('get', "/gists/#{gistId}", if optSince then 'since' : optSince else null)
			gist = JSON.parse(req.getContentText())
			return new Gist(@accessToken , gist)
		create:(input)->
			req = @request('post', "/gists" , input)
			gist = JSON.parse(req.getContentText())
			return new Gist(@accessToken, gist)
		update:(gistId , input)->
			req = @request('patch', "/gists/#{gistId}" , input)
			gist = JSON.parse(req.getContentText())
			return new Gist(@accessToken, gist)
		setStar:(gistId)->
			req = @request('put' , "/gists/#{gistId}/star")
		unStar:(gistId)->
			req = @request('delete' , "/gists/#{gistId}/star")
		isStarred:(gistId)->
			req = @request('get' , "/gists/#{gistId}/star" , null, true)
			return req.getResponceCode() is 204
		fork:(gistId)->
			req = @request('get' , "/gists/#{gistId}/forks")
			gist = JSON.parse(req.getContentText())
			return new Gist(@accessToken, gist)
		del:(gistId)->
			req = @request('DELETE' , "/gists/#{gistId}")

	global.GistsApi = GistsApi

	class Gist extends ApiBase
		constructor: (accessToken, object) ->
			super(accessToken)
			@[k] = v for k, v of object
			for k, v of @files
				v.getContent = ()->
					return v.content if v.content ?
					content = UrlFetchApp.fetch(v.row_url).getContentText()
					v["content"] = content
					return content
				@files[k] = v

		setStar:()->
			new GistsApi(@accessToken).setStar(@id)
		unStar:()->
			new GistsApi(@accessToken).unStar(@id)
		isStarred:()->
			new GistsApi(@accessToken).isStarred(@id)
		fork:()->
			new GistsApi(@accessToken).fork(@id)
		del:()->
			new GistsApi(@accessToken).del(@id)
		update:()->

			object = "description": @description
				"files" : {}

			object.files[k] = v for k, v of @files when v.content

			result = new GistsApi(@accessToken).update(@id, object)
			@[k] = v for k, v of result
			for k, v of @files
				v.getContent = ()->
					return v.content if v.content ?
					content = UrlFetchApp.fetch(v.row_url).getContentText()
					v["content"] = content
					return content
				@files[k] = v





