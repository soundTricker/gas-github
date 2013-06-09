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

	global.GistsApi = GistsApi

	class Gist extends ApiBase
		constructor: (accessToken, object) ->
			super(accessToken)
			@[k] = v for k, v of object

