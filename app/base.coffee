do(global=@)->
    global.Util =
        hasProp : {}.hasOwnProperty
        extend : (child, parent)->
            child[key] = parent[key] for key of parent when Util.hasProp.call(parent, key)
            
            ctor =()-> this.constructor = child
            ctor.prototype = parent.prototype
            child.prototype = new ctor
            child.__super__ = parent.prototype
            return child    
        copy : (src , dest, override)->
            for key of parent when Util.hasProp.call(parent, key)
                if override
                    Util.hasPorp.call(child , key) || child[key] = parent[key] 
                else
                    child[key] = parent[key] 

    class Github
        constructor:(@accessToken)->
            
        users:()=>
            new UsersApi @accessToken

        gists:()=>
            new GistsApi @accessToken

    global.Github = Github

    class ApiBase

        baseUrl = 'https://api.github.com' 

        constructor:(@accessToken)->
            
        request : (method , endPoint , params={} , muteHttpExceptions=false)=>
            
            endPoint = endPoint.replace(":#{k}" , v) for k,v of params 
            headers = {}
            headers[k] = v for k,v of params when /^header-/.test(k)
            
            if @accessToken?
                headers.Authorization = "token #{@accessToken}"
            
            payload = null
            if method.toLowerCase() is 'get'
                if endPoint.indexOf('?') != -1 then endPoint += '&' else endPoint += '?' 
                for k,v of params when not /^header-/.test(k)
                    endPoint += "#{k}=#{v}&"
            else
                payload = {}
                for k,v of params when not /^header-/.test(k)
                    payload[k] =  v
            
            url = baseUrl + endPoint;
            
            option = 
                method : method
                headers : headers
                muteHttpExceptions : muteHttpExceptions
                
            (payload? && Object.keys(payload).length > 0) && option.payload = JSON.stringify(payload)
            Logger.log option
            return UrlFetchApp.fetch(url, option)
    global.ApiBase = ApiBase