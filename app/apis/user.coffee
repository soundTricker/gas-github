do(global=@)->
    ApiBase = global.ApiBase
    Util = global.Util

    class UsersApi extends ApiBase
    
        constructor:(accessToken)->
            super(accessToken)
            
        me : (get=true)->
            if get
                req = @request('get' , '/user')
                return new AuthenticatedGithubUser(@accessToken , JSON.parse(req.getContentText()))
            else
                return new AuthenticatedGithubUser(@accessToken)
            
        list : (optSince)->
            req = @request('get' , '/users', if optSince then {since : optSince} else undefined )
            users = JSON.parse(req.getContentText())
            return (new GithubUser(@accessToken , u) for u in users)
        
        get : (userId)->
            req = @request('get' , "/user/#{userId}")
            return new GithubUser(@accessToken , JSON.parse(req.getContentText()))
            
        isFollowing : (fromUserLogin , targetUserLogin)->
            req = @request('get' ,"/users/#{fromUserLogin}/following/#{targetUserLogin}", null , true) 
            if req.getResponseCode?
                return req.getResponseCode() is 204
            else
                return false
            
        getKeys:(userLogin)->
            req = @request('get' ,"/users/#{userLogin}/keys") 
            return JSON.parse(req.getContentText())

    global.UsersApi = UsersApi
    
    class GithubUser extends ApiBase

        constructor:(accessToken, object={})->
            super(accessToken)
            @[k] = v for k, v of object
            
        getFollowers:()->
            req = @request('get' , "/users/#{@id}/followers")
            users = JSON.parse(req.getContentText())
            return (new GithubUser(@accessToken , u) for u in users)
            
        getFollowing:()->
            req = @request('get' , "/users/#{@id}/following")
            users = JSON.parse(req.getContentText())
            return (new GithubUser(@accessToken , u) for u in users)
            
        isFollowing: (userId)->
            new UserApi(@accessToken).isFollowing(@id, userId)
        
        getKeys:()->
            new UserApi(@accessToken).getKeys(@id)
            
    class AuthenticatedGithubUser extends GithubUser
        constructor:(accessToken, object)-> super(accessToken , object)
        
        addEmails:(emails)->

            if typeof emails == 'string' then emails = [emails]
            req = @request('post' , '/user/emails', emails) 
            return JSON.parse(req.getContentText())
            
        getEmails:()->
            req = @request('get' , '/user/emails') 
            return JSON.parse(req.getContentText())
            
        deleteEmails:(emails)->
            if typeof emails == 'string'
                emails = [emails]
            req = @request('delete' , '/user/emails', emails, true) 
        
        getFollowers:(optPaging)->
            req = @request('get' , "/user/followers", optPaging)
            users = JSON.parse(req.getContentText())
            return (new GithubUser(@accessToken , u) for u in users)
            
        getFollowing:(optPaging)->
            req = @request('get' , "/user/following", optPaging)
            users = JSON.parse(req.getContentText())
            return (new GithubUser(@accessToken , u) for u in users)
        
        # Right now(2013/06/15), google apps script does not support 'patch' method, see https://code.google.com/p/google-apps-script-issues/issues/detail?can=2&start=0&num=100&q=urlfetchapp%20patch&colspec=Stars%20Opened%20ID%20Type%20Status%20Summary%20Component%20Owner&groupby=&sort=&id=1224
        # update:(object)->
        #     req = @request('patch' ,"/user", object) 
        #     json = JSON.parse(req.getContentText())
        #     @[k] = v for k, v of json
        #     return @
            
        isFollowing:(userId)->
            req = @request('get' ,"/user/following/#{userId}", null , true) 
            if req.getResponseCode?
                return req.getResponseCode() is 204
            else
                return false
            
        addFollow:(userId)->
            req = @request('put' ,"/user/following/#{userId}") 
        
        unFollow:(userId)->
            req = @request('delete' ,"/user/following/#{userId}") 
        
        getKeys:()->
            req = @request('get' ,"/user/keys") 
            return JSON.parse(req.getContentText())
            
        getKey:(keyId)->
            req = @request('get' ,"/user/keys/#{keyId}") 
            return JSON.parse(req.getContentText())
            
        addKey:(title,key)->
            req = @request('post' ,"/user/keys/", {title:title,key:key}) 
            return JSON.parse(req.getContentText())
            
        # Right now(2013/06/15), google apps script does not support 'patch' method, see https://code.google.com/p/google-apps-script-issues/issues/detail?can=2&start=0&num=100&q=urlfetchapp%20patch&colspec=Stars%20Opened%20ID%20Type%20Status%20Summary%20Component%20Owner&groupby=&sort=&id=1224
        # updateKey:(keyId, title, key)->
        #     req = @request('patch' ,"/user/keys/#{keyId}", {title:title,key:key}) 
        #     return JSON.parse(req.getContentText())
            
        deleteKey:(keyId)->
            req = @request('delete' ,"/user/keys/#{keyId}") 
