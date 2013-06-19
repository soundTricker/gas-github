describe "The ActivityApi class", ()->
    api = null
    apiKey = null
    beforeEach ()->
        apiKey = UserProperties.getProperty("githubApiKey")
        api = Github.create(apiKey).activity()
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
     * activity api's all method support pagination parameter
    *###

    describe "The 'repositoryEvents' method", ()->

        it "should return array",()->
            expect(Array.isArray(api.repositoryEvents("soundTricker", "gas-github"))).toBe(true)
            @

    describe "The 'issueEvents' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.issueEvents("soundTricker", "gas-github"))).toBe(true)
            @
        @

    describe "The 'networkEvents' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.networkEvents("soundTricker", "gas-github"))).toBe(true)
            @
        @

    describe "The 'organizationEvents' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.organizationEvents('gwtbootstrap'))).toBe(true)
            @
        @

    describe "The 'receivedEvents' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.receivedEvents('soundTricker'))).toBe(true)
            @
        @

    describe "The 'publicReceivedEvents' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.publicReceivedEvents('soundTricker'))).toBe(true)
            @
        @

    describe "The 'userEvents' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.userEvents('soundTricker'))).toBe(true)
            @
        @

    describe "The 'userPublicEvents' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.userPublicEvents('soundTricker'))).toBe(true)
            @
        @

    describe "The 'userOrgEvents' method", ()->
        it "should return array",()->
            expect(Array.isArray(api.userOrgEvents('soundTricker', "gwtbootstrap"))).toBe(true)
            @
        @
    @

