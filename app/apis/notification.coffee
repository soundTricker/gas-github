do(global=@)->
    ApiBase = global.ApiBase
    class NotificationApi extends ApiBase
        constructor:(accessToken)->
            super(accessToken)

        list:(options)->
            req = @request("get", "/notifications", options)
            notifications = JSON.parse(req.getContentText())
            return (new GithubNotification(@accessToken, v) for v in notifications)

        repoNotifications:(userLogin, repoName, options)->
            req = @request("get", "/repos/#{userLogin}/#{repoName}/notifications", options)
            notifications = JSON.parse(req.getContentText())
            return (new GithubNotification(@accessToken, v) for v in notifications)
        markAsRead:(optLastReadAt)->
            req = @request("put", "/notifications", if optLastReadAt? then "last_read_at": optLastReadAt else null)
        markAsReadInRepo:(userLogin, repoName, optLastReadAt)->
            req = @request("pub", "/repos/#{userLogin}/#{repoName}/notifications", if optLastReadAt? then "last_read_at": optLastReadAt else null)
        getThread:(threadId)->
            req = @request("get", "/notifications/threads/#{threadId}")
            notification = JSON.parse(req.getContentText())
            return new GithubNotification(@accessToken, notification)
        getThreadSubscription:(threadId)->
            req = @request("get", "/notifications/threads/#{threadId}/subscription")
            JSON.parse(req.getContentText())

        setThreadSubscripion:(threadId, subscribed, ignored)->
            req = @request("put", "/notifications/threads/#{threadId}/subscription", {subscribed:subscribed, ignored:ignored})
            JSON.parse(req.getContentText())

        deleteThreadSubscription:(threadId)->
            req = @request("delete", "/notifications/threads/#{threadId}/subscription")

    class GithubNotification extends ApiBase
        constructor:(accessToken, object={})->
            super(accessToken)
            @[k] = v for k, v of object
            @api = new NotificationApi(accessToken)
        getSubscription:()->
            @api.getThreadSubscription(@id)
        setSubscription:(subscribed, ignored)->
            @api.setSubscription(@id, subscribed, ignored)
        deleteSubscription:()->
            @api.deleteThreadSubscription(@id)
