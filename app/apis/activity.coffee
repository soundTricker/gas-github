do(global=@)->
    ApiBase = global.ApiBase
    class ActivityApi extends ApiBase
        constructor:(accessToken)->
            super(accessToken)
        list:(options)->
            req = @request("get", "/events", if options? options else null)
            return JSON.parse(req.getContentText())
        repositoryEvents:(userLogin, repoName, options)->
            req = @request("get", "/repos/#{userLogin}/#{repoName}/events", if options? options else null)
            return JSON.parse(req.getContentText())
        issueEvents:(userLogin, repoName, options)->
            req = @request("get", "/repos/#{userLogin}/#{repoName}/issues/events", if options? options else null)
            return JSON.parse(req.getContentText())
        networkEvents:(userLogin, repoName, options)->
            req = @request("get", "/networks/#{userLogin}/#{repoName}/events", if options? options else null)
            return JSON.parse(req.getContentText())
        organizationEvents:(orgsName, options)->
            req = @request("get", "/orgs/#{orgsName}/events", if options? options else null)
            return JSON.parse(req.getContentText())
        receivedEvents:(userLogin, options)->
            req = @request("get", "/users/#{userLogin}/received_events", if options? options else null)
            return JSON.parse(req.getContentText())
        publicReceivedEvents:(userLogin, options)->
            req = @request("get", "/users/#{userLogin}/received_events/public", if options? options else null)
            return JSON.parse(req.getContentText())
        userEvents:(userLogin, options)->
            req = @request("get", "/users/#{userLogin}/events", if options? options else null)
            return JSON.parse(req.getContentText())
        userPublicEvents:(userLogin, options)->
            req = @request("get", "/users/#{userLogin}/events/public", if options? options else null)
            return JSON.parse(req.getContentText())
        userOrgEvents:(userLogin, orgsName, options)->
            req = @request("get", "/users/#{userLogin}/events/orgs/#{orgsName}", if options? options else null)
            return JSON.parse(req.getContentText())







