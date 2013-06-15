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

        # Right now(2013/06/15), google apps script does not support 'patch' method, see https://code.google.com/p/google-apps-script-issues/issues/detail?can=2&start=0&num=100&q=urlfetchapp%20patch&colspec=Stars%20Opened%20ID%20Type%20Status%20Summary%20Component%20Owner&groupby=&sort=&id=1224
        # update:(gistId , input)->
        #     req = @request('patch', "/gists/#{gistId}" , input)
        #     gist = JSON.parse(req.getContentText())
        #     return new Gist(@accessToken, gist)
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
            
        # Right now(2013/06/15), google apps script does not support 'patch' method, see https://code.google.com/p/google-apps-script-issues/issues/detail?can=2&start=0&num=100&q=urlfetchapp%20patch&colspec=Stars%20Opened%20ID%20Type%20Status%20Summary%20Component%20Owner&groupby=&sort=&id=1224
        # editComment:(gistId, commentId, comment)->
        #     req = @request('patch', "/gists/#{gistId}/comments/#{commentId}", body : comment)
        #     JSON.parse(req.getContentText())
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
        update:()->

            object = "description": @description
                "files" : {}

            object.files[k] = v for k, v of @files when v.content

            result = @api.update(@id, object)
            @[k] = v for k, v of result
            for k, v of @files
                v.getContent = ()->
                    return v.content if v.content ?
                    content = UrlFetchApp.fetch(v.row_url).getContentText()
                    v["content"] = content
                    return content
                @files[k] = v
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





