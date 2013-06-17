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
            etag = api.getLastResponse().getHeader().ETag
            expect(Array.isArray(api.list( "header-ETag":etag ))).toBe(true)
            @
        @
