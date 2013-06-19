describe "The NotificationApi class", ()->
    api = null
    apiKey = null
    beforeEach ()->
        apiKey = UserProperties.getProperty("githubApiKey")
        api = Github.create(apiKey).notifications()
        @

    it 'should has accessToken', ()->
        expect(api.accessToken).toBe(apiKey)
        @
    
    describe "The 'list' method", ()->

        it "should return array",()->
            expect(Array.isArray(api.list())).toBe(true)
            @

        it "should support pagination parameter", ()->
            expect(Array.isArray(api.list( page:2 ))).toBe(true)
            etag = api.getLastResponse().getHeaders().ETag
            expect(Array.isArray(api.list( "header-ETag":etag ))).toBe(true)
            @
        @

    ###*
     *  api's all list retrive method support pagination parameter
    *###
    describe "The 'repoNotifications' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.repoNotifications("soundTricker", "gas-github"))).toBe(true)
            @
        @

    describe "The 'markAsRead' method", ()->

        it "should support last_read_at parameter", ()->
            api.markAsRead(Utilities.formatDate(new Date(), 'Asia/Tokyo', "yyyy-MM-dd'T'HH:mm:ssZ"))
            expect(api.list().map((notification)->notification.unread)).not.toContain(true)
            @
        @

    describe "The 'markAsReadInRepo' method", ()->

        it "should support last_read_at parameter", ()->
            api.markAsReadInRepo('soundTricker', 'gas-github', new Date())
            expect(api.list().map((notification)->notification.unread)).not.toContain(true)
            @
        @

    describe "The 'getThread' method", ()->

        it "should get thread", ()->
            original = api.list()[0]

            return if !original
            thread = api.getThread(original.id)
            expect(thread.id).toBe(original.id)
            @
        @

    describe "The 'getThreadSubscription' method", ()->

        it "should get thread subscription", ()->
            original = api.list()[0]

            return if !original
            expect(api.getThreadSubscription(original.id).thread_url).toBe(original.url)
            @
        @

    describe "The 'setThreadSubscripion' method", ()->

        it "should update thread subscription", ()->
            original = api.list()[0]
            return if !original
            api.setThreadSubscripion(original.id, true, true)
            subscription = api.getThreadSubscription(original.id)
            expect(subscription.subscribed).toBe(true)
            expect(subscription.ignored).toBe(true)
            @
        @

    describe "The 'deleteThreadSubscription' method", ()->

        it "should delete thread subscription", ()->
            original = api.list()[0]
            return if !original
            api.deleteThreadSubscription(original.id)
            @
        @
    @


