describe "GAS Github Library", ()-> 
    it 'should have create method, that generate Github.Github class', ()->
        expect(Github.create).toBeDefined()
        expect(Github.create('test')).toEqual(jasmine.any(Github.Github))

        @

    it 'should have dummy method for code assist , if run it,it should be throw error', ()->
        msg = "it's a mock function for code assitant, please run this by created instance by create function."
        expect(Github.users).toBeDefined()
        expect(Github.users).toThrow(msg)

        expect(Github.gists).toBeDefined()
        expect(Github.gists).toThrow(msg)

        @

describe "Github API class", ()->

    githubApi = null
    apiKey = null

    beforeEach ()->
        apiKey = UserProperties.getProperty("githubApiKey")
        githubApi = Github.create(apiKey)

        spyOn(Github, "UsersApi")
        spyOn(Github, "GistsApi")
        @

    it "should have api key as a property", ()->
        expect(githubApi.accessToken).toBe(apiKey)
        @

    it "should have method to create api classes", ()->
        expect(githubApi.users).toBeDefined()
        expect(githubApi.users()).toEqual(jasmine.any(Github.UsersApi))
        expect(Github.UsersApi).toHaveBeenCalledWith(apiKey)

        expect(githubApi.gists).toBeDefined()
        expect(githubApi.gists()).toEqual(jasmine.any(Github.GistsApi))
        expect(Github.GistsApi).toHaveBeenCalledWith(apiKey)
        @

describe "ApiBase class", ()->

    apiBase = null
    apiKey = null

    beforeEach ()->

        apiKey = UserProperties.getProperty("githubApiKey")
        apiBase = new Github.ApiBase apiKey

    
    it "should have api key as a property", ()->
        expect(apiBase.accessToken).toBe(apiKey)

    describe "The 'request' method:", ()->

        describe "About calling with GET http method", ()->

            originalUrlFetchApp = UrlFetchApp

            beforeEach ()->
                Github.UrlFetchApp = jasmine.createSpyObj('UrlFetchApp', ['fetch'])

            afterEach ()->
                Github.UrlFetchApp = originalUrlFetchApp

            it "should call UrlFetchApp.fetch method with options ", ()->

                apiBase.request("get", "/user")

                expect(Github.UrlFetchApp.fetch.calls[0].args[0]).toBe("https://api.github.com/user?")

                options = Github.UrlFetchApp.fetch.calls[0].args[1]
                
                expect(options.method).toBe("get")
                expect(options.headers.Authorization).toBe("token #{apiKey}")

                expect(options.payload).toBeUndefined()
                @

            it "should call UrlFetchApp.fetch method with url parameter, if set parameter object", ()->

                apiBase.request("get", "/user", {a : "b"})

                expect(Github.UrlFetchApp.fetch.calls[0].args[0]).toBe("https://api.github.com/user?a=b&")

                options = Github.UrlFetchApp.fetch.calls[0].args[1]

                expect(options.method).toBe("get")
                expect(options.headers.Authorization).toBe("token #{apiKey}")
                @

            it "should call UrlFetchApp.fetch method with headers, if parameter has headers prefix property", ()->
                apiBase.request("get", "/user", {"header-a" : "c"})

                expect(Github.UrlFetchApp.fetch.calls[0].args[0]).toBe("https://api.github.com/user?")

                options = Github.UrlFetchApp.fetch.calls[0].args[1]

                expect(options.method).toBe("get")
                expect(options.headers.Authorization).toBe("token #{apiKey}")
                expect(options.headers.a).toBe("c")
                @

            it "should call UrlFetchApp.fetch method without Authorization header, if apiBase does not have accessToken", ()->
                apiBase.accessToken = null
                apiBase.request("get", "/user", {a : "b", c : "d"})

                expect(Github.UrlFetchApp.fetch.calls[0].args[0]).toBe("https://api.github.com/user?a=b&c=d&")
                
                options = Github.UrlFetchApp.fetch.calls[0].args[1]

                expect(options.method).toBe("get")
                expect(options.headers.Authorization).toBeUndefined()
                @

        describe "About calling without GET http method", ()->

            originalUrlFetchApp = UrlFetchApp

            beforeEach ()->
                Github.UrlFetchApp = jasmine.createSpyObj('UrlFetchApp', ['fetch'])

            afterEach ()->
                Github.UrlFetchApp = originalUrlFetchApp

            it "should call UrlFetchApp.fetch method with options ", ()->

                apiBase.request("post", "/user")

                expect(Github.UrlFetchApp.fetch.calls[0].args[0]).toBe("https://api.github.com/user")

                options = Github.UrlFetchApp.fetch.calls[0].args[1]
                
                expect(options.method).toBe("post")
                expect(options.headers.Authorization).toBe("token #{apiKey}")

                expect(options.payload).toBeUndefined()
                @

            it "should call UrlFetchApp.fetch method with payload, if set parameter object", ()->

                apiBase.request("post", "/user", {a : "b"})

                expect(Github.UrlFetchApp.fetch.calls[0].args[0]).toBe("https://api.github.com/user")

                options = Github.UrlFetchApp.fetch.calls[0].args[1]

                expect(options.method).toBe("post")
                expect(options.headers.Authorization).toBe("token #{apiKey}")
                expect(options.payload).toEqual(JSON.stringify({a:"b"}))
                @

            it "should call UrlFetchApp.fetch method with headers, if parameter has headers prefix property", ()->
                apiBase.request("post", "/user", {"header-a" : "c"})

                expect(Github.UrlFetchApp.fetch.calls[0].args[0]).toBe("https://api.github.com/user")

                options = Github.UrlFetchApp.fetch.calls[0].args[1]

                expect(options.method).toBe("post")
                expect(options.headers.Authorization).toBe("token #{apiKey}")
                expect(options.headers.a).toBe("c")
                @

            it "should call UrlFetchApp.fetch method without Authorization header, if apiBase does not have accessToken", ()->
                apiBase.accessToken = null
                apiBase.request("patch", "/user", {a : "b", c : "d"})

                expect(Github.UrlFetchApp.fetch.calls[0].args[0]).toBe("https://api.github.com/user")
                
                options = Github.UrlFetchApp.fetch.calls[0].args[1]

                expect(options.method).toBe("patch")
                expect(options.headers.Authorization).toBeUndefined()
                expect(options.payload).toEqual(JSON.stringify({a : "b", c : "d"}))
                @

