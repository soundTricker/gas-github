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

        activity:()=>
            new ActivityApi @accessToken

        notifications:()=>
            new NotificationApi @accessToken

    global.Github = Github

    class ApiBase

        baseUrl = 'https://api.github.com' 

        constructor:(@accessToken)->
            
        request : (method , endPoint , params={} , muteHttpExceptions=false)=>
            
            headers = {}
            headers[k.replace(/^header-/, "")] = v for k,v of params when /^header-/.test(k)
            
            if @accessToken?
                headers.Authorization = "token #{@accessToken}"
            
            option = 
                method : method
                headers : headers
                muteHttpExceptions : muteHttpExceptions

            payload = null
            if method.toLowerCase() is 'get'
                if endPoint.indexOf('?') != -1 then endPoint += '&' else endPoint += '?' 
                for k,v of params when not /^header-/.test(k)
                    endPoint += "#{k}=#{v}&"
            else
                payload = null

                if typeof params == 'string'
                    payload = params
                else if Array.isArray(params)
                    payload = JSON.stringify(params)
                else
                    tmpPayload = {}
                    for k,v of params when not /^header-/.test(k)
                        tmpPayload[k] =  v
                    if Object.keys(tmpPayload).length > 0 then payload = JSON.stringify(tmpPayload)

                payload? && option.payload = payload
            
            url = baseUrl + endPoint;
            
            @lastResponse = UrlFetchApp.fetch(url, option)
            return @lastResponse
        getLastResponse : ()-> @lastResponse

    global.ApiBase = ApiBase