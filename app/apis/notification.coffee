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
        markAsRead:(lastReadAt)->
            req = @request("put", "/notifications", "last_read_at": lastReadAt)
        markAsReadInRepo:(userLogin, repoName, lastReadAt)->
            req = @request("put", "/repos/#{userLogin}/#{repoName}/notifications","last_read_at": lastReadAt)
        getThread:(threadId)->
            req = @request("get", "/notifications/threads/#{threadId}")
            notification = JSON.parse(req.getContentText())
            return new GithubNotification(@accessToken, notification)
        markThreadAsRead:(threadId)->
            req = @request("post", "/notifications/threads/#{threadId}")
        getThreadSubscription:(threadId)->
            req = @request("get", "/notifications/threads/#{threadId}/subscription")
            JSON.parse(req.getContentText())
        setThreadSubscripion:(threadId, subscribed, ignored)->
            req = @request("put", "/notifications/threads/#{threadId}/subscription", {subscribed:subscribed, ignored:ignored})
            JSON.parse(req.getContentText())
        deleteThreadSubscription:(threadId)->
            req = @request("delete", "/notifications/threads/#{threadId}/subscription")
    global.NotificationApi = NotificationApi

    class GithubNotification extends ApiBase
        constructor:(accessToken, object={})->
            super(accessToken)
            @[k] = v for k, v of object
            @api = new NotificationApi(accessToken)
        markAsRead:()->
            @api.markThreadAsRead(@id)
        getSubscription:()->
            @api.getThreadSubscription(@id)
        setSubscription:(subscribed, ignored)->
            @api.setSubscription(@id, subscribed, ignored)
        deleteSubscription:()->
            @api.deleteThreadSubscription(@id)
