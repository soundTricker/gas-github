describe "The UsersApi class", ()-> 

    usersApi = null

    apiKey = null

    beforeEach ()->
        apiKey = UserProperties.getProperty("githubApiKey")
        usersApi = Github.create(apiKey).users()
        apiBase = new Github.ApiBase apiKey

        @

    it 'should have accessToken', ()->
        expect(usersApi.accessToken).toBe(apiKey)
        @

    describe "The 'me' method" , ()->

        beforeEach ()->
            spyOn(usersApi, "request").andCallThrough()

        it "should return AuthenticatedGithubUser with calling api", ()->
            me = usersApi.me()
            expect(me.constructor.name).toBe("AuthenticatedGithubUser")

            expect(usersApi.request).toHaveBeenCalledWith('get', '/user')

            expect(me.id).toBeDefined()
            @

        it "should return AuthenticatedGithubUser without calling api , when calling with false", ()->
            me = usersApi.me(false)
            expect(me.constructor.name).toBe("AuthenticatedGithubUser")

            expect(usersApi.request).not.toHaveBeenCalled()

            expect(me.id).toBeUndefined()
            @

        describe "The AuthenticatedGithubUser class", ()->
            me = null

            beforeEach ()->
                me = usersApi.me()
            
            it "should have accessToken", ()->
                expect(me.accessToken).toBe(apiKey)

            describe "The 'addEmails' method",()->

                beforeEach ()->
                    spyOn(me, "request").andCallThrough()
                    me.addEmails "keisuke.oohashi+test@gmail.com"

                it "should added email to me", ()->
                    emails = me.getEmails()
                    expect(emails).toContain("keisuke.oohashi+test@gmail.com")

                afterEach ()->
                    try
                        me.deleteEmails "keisuke.oohashi+test@gmail.com"
                    catch e
                        # right now(2013/06/15), it throw error, see https://code.google.com/p/google-apps-script-issues/issues/detail?id=2888

            describe "The 'getEmails' method",()->

                beforeEach ()->
                    spyOn(me, "request").andCallThrough()
                    me.addEmails "keisuke.oohashi+test@gmail.com"

                it "should get emails of me", ()->
                    emails = me.getEmails()
                    expect(emails).toContain("keisuke.oohashi+test@gmail.com")
                afterEach ()->
                    try
                        me.deleteEmails "keisuke.oohashi+test@gmail.com"
                    catch e
                        # right now(2013/06/15), it throw error, see https://code.google.com/p/google-apps-script-issues/issues/detail?id=2888
            describe "The 'deleteEmails' method",()->
                it "should delete emails of me", ()->
                        # right now(2013/06/15), it throw error, see https://code.google.com/p/google-apps-script-issues/issues/detail?id=2888

            describe "The 'getFollowers' method",()->
                followers = null
                beforeEach ()->
                    followers = me.getFollowers()

                it "should return Array", ()->
                    expect(Array.isArray(followers)).toBe(true)

                it "should return same count Array as me.followers", ()->
                    if me.followers > 30
                        expect(followers.length).toBeLessThan(me.followers)
                    else
                        expect(followers.length).toBe(me.followers)

                it "should support per_page parameter", ()->
                    return if me.followers <= 30

                    followers = me.getFollowers({per_page : 100})

                    if me.followers > 100
                        expect(followers.length).toBeLessThan(me.followers)
                    else
                        expect(followers.length).toBe(me.followers)
                it "should support page parameter", ()->
                    return if me.followers <= 30

                    followers = me.getFollowers({page : 2})

                    if me.followers > 60
                        expect(followers.length).toBeLessThan(me.followers)
                    else
                        expect(followers.length).toBe(me.followers - 30)

            describe "The 'getFollowing' method",()->
                following = null
                beforeEach ()->
                    following = me.getFollowing()

                it "should return Array", ()->
                    expect(Array.isArray(following)).toBe(true)

                it "should return same count Array as me.following", ()->
                    if me.following > 30
                        expect(following.length).toBeLessThan(me.following)
                    else
                        expect(following.length).toBe(me.following)

                it "should support per_page parameter", ()->
                    return if me.following <= 30

                    following = me.getFollowing(per_page : 100)

                    if me.following > 100
                        expect(following.length).toBeLessThan(me.following)
                    else
                        expect(following.length).toBe(me.following)

                it "should support page parameter", ()->
                    return if me.following <= 30

                    following = me.getFollowing(page : 2)

                    if me.following > 100
                        expect(following.length).toBeLessThan(me.following)
                    else
                        expect(following.length).toBe(me.following - 30)
            describe "The 'isFollowing' method", ()->

                following = null
                beforeEach ()->
                    following = me.getFollowing()

                it "should return boolean", ()->
                    expect(me.isFollowing(following[0].login)).toBe(true)

                it "should return false , if unfollow user",()->
                    expect(me.isFollowing("mojombo")).toBe(false)

            describe "The 'addFollow'", ()->

                beforeEach ()->
                    me.addFollow("mojombo")

                it "should be add following", ()->
                    expect(me.isFollowing("mojombo")).toBe(true)

                afterEach ()->
                    me.unFollow("mojombo")

            describe "The 'unFollow' method", ()->

                beforeEach ()->
                    me.addFollow("mojombo")
                    me.unFollow("mojombo")

                it "should delete following", ()->
                    expect(me.isFollowing("mojombo")).toBe(false)

            describe "The 'getKeys' method", ()->
                keys = null
                beforeEach ()->
                    keys = me.getKeys()

                it "should contain api key",()->
                    expect(keys).toContain apiKey


            # Right now(2013/06/15), google apps script does not support 'patch' method, see https://code.google.com/p/google-apps-script-issues/issues/detail?can=2&start=0&num=100&q=urlfetchapp%20patch&colspec=Stars%20Opened%20ID%20Type%20Status%20Summary%20Component%20Owner&groupby=&sort=&id=1224
            # describe "The 'update' method", ()->

            #     origin = null
            #     updated = null
            #     beforeEach ()->
            #         origin = 
            #             name : me.name
            #             email : me.email
            #             bio : me.bio
            #             company : me.company
            #             location : me.location
            #             hireable : me.hireable
            #             blog : me.blog
            #         Logger.log(origin)

            #         me.update(
            #             name : origin.name + " updated"
            #             email : "keisuke.oohashi+test@gmail.com"
            #             bio : origin.bio + " updated"
            #             company : origin.company + " updated"
            #             location : me.locatoin + " updated"
            #             hireable : !me.hireable
            #             blog : me.blog + " updated"
            #         )
            #         updated = usersApi.me()

            #     afterEach ()->
            #         me.update origin

            #     it "should update instance" , ()->
            #         expect(me.name).toEqual origin.name + " updated"
            #         expect(me.email).toEqual "keisuke.oohashi+test@gmail.com"
            #         expect(me.bio).toEqual origin.bio + " updated"
            #         expect(me.company).toEqual origin.company + " updated"
            #         expect(me.location).toEqual origin.location + " updated"
            #         expect(me.hireable).toBe(!origin.hireable)
            #         expect(me.blog).toEqual origin.blog + " updated"
                # it "should update github data", ()->
                #     expect(updated.name).toEqual origin.name + " updated"
                #     expect(updated.email).toEqual "keisuke.oohashi+test@gmail.com"
                #     expect(updated.bio).toEqual origin.bio + " updated"
                #     expect(updated.company).toEqual origin.company + " updated"
                #     expect(updated.location).toEqual origin.location + " updated"
                #     expect(updated.hireable).toBe(!origin.hireable)
                #     expect(updated.blog).toEqual origin.blog + " updated"




    describe "The 'list' method" , ()->

        list = null
        beforeEach ()->
            spyOn(usersApi, "request").andCallThrough()
            list = usersApi.list()

        it "should return GithubUser array with calling api", ()->
            
            expect(Array.isArray(list)).toBe(true)
            expect(list[0].constructor.name).toBe("GithubUser")
            expect(usersApi.request).toHaveBeenCalled()
            expect(usersApi.request.calls[0].args[0]).toEqual('get')
            expect(usersApi.request.calls[0].args[1]).toEqual('/users')
            expect(usersApi.request.calls[0].args[2]).toEqual(null)

        it "should support since parameter", ()->
            list2 = usersApi.list(list[list.length-1].id)
            expect(Array.isArray(list2)).toBe(true)
            expect(list2[0].constructor.name).toBe("GithubUser")
            expect(usersApi.request).toHaveBeenCalled()
            expect(usersApi.request.calls[1].args[0]).toEqual('get')
            expect(usersApi.request.calls[1].args[1]).toEqual('/users')
            expect(usersApi.request.calls[1].args[2]).toEqual({since: list[list.length - 1].id})

    describe "The 'get' method", ()->

