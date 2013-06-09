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
	        
	    isFollowing : (fromUserId , targetUserId)->
	        req = @request('get' ,"/users/#{formUserId}/following/#{targetUserId}", null , true) 
	        return req.getResponceCode is 204
	        
	    getKeys:(userId)->
	        req = @request('get' ,"/users/#{userId}/keys") 
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
	        req = @request('post' , '/user/emails', emails) 
	        return JSON.parse(req.getContentText())
	        
	    getEmails:()->
	        req = @request('get' , '/user/emails') 
	        return JSON.parse(req.getContentText())
	        
	    deleteEmails:(emails)->
	    	req = @request('delete' , '/user/emails', emails) 
	    
	    getFollowers:()->
	        req = @request('get' , "/user/followers")
	        users = JSON.parse(req.getContentText())
	        return (new GithubUser(@accessToken , u) for u in users)
	        
	    getFollowing:()->
	        req = @request('get' , "/user/following")
	        users = JSON.parse(req.getContentText())
	        return (new GithubUser(@accessToken , u) for u in users)
	        
	    update:(object)->
	        req = @request('patch' ,"/user", object) 
	        json = JSON.parse(req.getContentText())
	        @[k] = v for k, v of json
	        return @
	        
	    isFollowing:(userId)->
	        req = @request('get' ,"/user/following/#{userId}", null , true) 
	        return req.getResponceCode is 204
	        
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
	        
	    updateKey:(keyId, title, key)->
	        req = @request('patch' ,"/user/keys/#{keyId}", {title:title,key:key}) 
	        return JSON.parse(req.getContentText())
	        
	    deleteKey:(keyId)->
	        req = @request('delete' ,"/user/keys/#{keyId}") 
