do(global=@)->
    ApiBase = global.ApiBase
    class GistsApi extends ApiBase
        constructor:(accessToken)->
            super(accessToken)
        mine:(options)->
            req = @request('get' , '/gists', if options then options else null)
            gists = JSON.parse(req.getContentText())
            return (new Gist(@accessToken , g) for g in gists)
        starred:(options)->
            req = @request('get' , '/gists/starred', if options then options else null)
            gists = JSON.parse(req.getContentText())
            return (new Gist(@accessToken , g) for g in gists)
        user:(userLogin,options)->
            req = @request('get' , "/users/#{userLogin}/gists", if options then options else null)
            gists = JSON.parse(req.getContentText())
            return (new Gist(@accessToken , g) for g in gists)
        public:(options)->
            req = @request('get', "/gists/public", if options then options else null)
            gists = JSON.parse(req.getContentText())
            return (new Gist(@accessToken , g) for g in gists)
        get:(gistId)->
            req = @request('get', "/gists/#{gistId}")
            gist = JSON.parse(req.getContentText())
            return new Gist(@accessToken , gist)
        create:(description, publicGist, files)->
            req = @request('post', "/gists" , {description : description, public : publicGist , files : files})
            gist = JSON.parse(req.getContentText())
            return new Gist(@accessToken, gist)
        update:(gistId , description, files)->
            req = @request('post', "/gists/#{gistId}" , {description : description, files : files})
            gist = JSON.parse(req.getContentText())
            return new Gist(@accessToken, gist)
        setStar:(gistId)->
            req = @request('put' , "/gists/#{gistId}/star")
        unStar:(gistId)->
            req = @request('delete' , "/gists/#{gistId}/star")
        isStarred:(gistId)->
            req = @request('get' , "/gists/#{gistId}/star" , null, true)
            if req.getResponseCode?
                return req.getResponseCode() is 204
            else
                return false
        fork:(gistId)->
            req = @request('get' , "/gists/#{gistId}/forks")
            gist = JSON.parse(req.getContentText())
            return new Gist(@accessToken, gist)
        del:(gistId)->
            req = @request('delete' , "/gists/#{gistId}")
        comments:(gistId)->
            req = @request('get' , "/gists/#{gistId}/comments")
            JSON.parse(req.getContentText())
        comment:(gistId,commentId)->
            req = @request('get' , "/gists/#{gistId}/comments/#{commentId}")
            JSON.parse(req.getContentText())
        addComment:(gistId, comment)->
            req = @request('post', "/gists/#{gistId}/comments", body : comment)
            JSON.parse(req.getContentText())
        editComment:(gistId, commentId, comment)->
            req = @request('post', "/gists/#{gistId}/comments/#{commentId}", body : comment)
            JSON.parse(req.getContentText())
        deleteComment:(gistId, commentId)->
            req = @request('delete', "/gists/#{gistId}/comments/#{commentId}")

    global.GistsApi = GistsApi

    class Gist extends ApiBase
        constructor: (accessToken, object) ->
            super(accessToken)
            @api = new GistsApi(@accessToken)
            @[k] = v for k, v of object
            for k, v of @files
                v.getContent = ()->
                    return v.content if v.content ?
                    content = UrlFetchApp.fetch(v.row_url).getContentText()
                    v["content"] = content
                    return content
                @files[k] = v

        setStar:()->
            @api.setStar(@id)
        unStar:()->
            @api.unStar(@id)
        isStarred:()->
            @api.isStarred(@id)
        fork:()->
            @api.fork(@id)
        del:()->
            @api.del(@id)
        update:(description, files)->
            @api.update(@id, description, files)
        getComments:()->
            @api.comments(@id)
        getComment:(commentId)->
            @api.comment(@id, commentId)
        addComment:(comment)->
            @api.addComment(@id, comment)
        editComment:(commentId, comment)->
            @api.editComment(@id, commentId, comment)
        deleteComment:(commentId)->
            @api.deleteComment(@id, commentId)





