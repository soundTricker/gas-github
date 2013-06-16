describe "The GistsApi class", ()-> 

    gistsApi = null
    usersApi = null
    apiKey = null
    me = null

    beforeEach ()->
        apiKey = UserProperties.getProperty("githubApiKey")
        usersApi = Github.create(apiKey).users()
        gistsApi = Github.create(apiKey).gists()
        apiBase = new Github.ApiBase apiKey
        me = usersApi.me()

        @

    it 'should has accessToken', ()->
        expect(gistsApi.accessToken).toBe(apiKey)
        @

    describe "The 'mine' method",()->
        mine = null
        it "should return array", ()->
            mine = gistsApi.mine()
            expect(Array.isArray(mine)).toBe(true)
            @

        it "should return same count Array as sum of me.public_gists and me.private_gists", ()->
            mine = gistsApi.mine()
            if me.public_gists + me.private_gists > 20
                expect(mine.length).toBeLessThan(me.public_gists + me.private_gists)
            else 
                expect(mine.length).toBe(me.public_gists + me.private_gists)
            @
        it "should support since options" , ()->
            mine = gistsApi.mine()

            next = gistsApi.mine(since : mine[mine.length-2].created_at)
            expect(next[0].id).not.toBe(mine[mine.length-1].id)
            @
        it "should support per_page options" , ()->
            next = gistsApi.mine(per_page : 1)
            expect(next.length).toBe(1)
            @

        it "should support page options", ()->
            next = gistsApi.mine({page : 2, per_page:1})
            mine = gistsApi.mine()

            expect(next[0].id).toEqual(mine[1].id)

            @
        @
    describe "The 'starred' method",()->

        it "should return array", ()->
            starred = gistsApi.starred()
            expect(Array.isArray(starred)).toBe(true)
            @

        it "should support per_page options", ()->
            expect(gistsApi.starred(per_page : 1).length).toBe(1)
            @

        it "should support page options", ()->
            one = gistsApi.starred(per_page : 1)
            two = gistsApi.starred({page : 2 , per_page : 1})
            expect(two[0].id).not.toBe(one[0].id)
            @


    describe "The 'user' method", ()->

        it "should be same as mime , if set my id", ()->
            gists = gistsApi.user(me.login)
            mine = gistsApi.mine()

            expect(gists[0].id).toBe(mine[0].id)
            @

        it "should support per_page, page options", ()->
            gists = gistsApi.user(me.login, {per_page : 1 , page:2})
            expect(gists.length).toBe(1)
            @
        @

    describe "The 'public' method", ()->
        it "should return array", ()->
            expect(Array.isArray(gistsApi.public())).toBe(true)
            @
        it "should support per_page, page options", ()->
            gists = gistsApi.public({per_page : 1 , page:2})
            expect(gists.length).toBe(1)
            @
        @

    describe "The 'get' method" , ()->

        it "should return same as mine", ()->
            mine = gistsApi.mine(per_page:1)[0]
            gists = gistsApi.get(mine.id)
            expect(gists.id).toBe(mine.id)
            @
        @
    describe "The 'create' method" , ()->
        created = null
        beforeEach ()->
            created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            @

        it "should create new gists", ()->
            expect(created.description).toBe("description")
            expect(created.public).toBe(false)
            expect(created.files["code.js"]).toBeDefined()
            expect(created.files["code.js"].filename).toBe("code.js")
            expect(gistsApi.get(created.id)).toBeDefined()
            @

        afterEach ()->
            gistsApi.del(created.id)

        @
    describe "The 'setStar' method", ()->
        created = null
        beforeEach ()->
            created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            gistsApi.setStar(created.id)
            @

        it "should be contain in starred", ()->
            starIds = gistsApi.starred().map((gist)-> gist.id)
            expect(starIds).toContain(created.id)
            @

        afterEach ()->
            gistsApi.del(created.id)
            @

    describe "The 'unStar' method", ()->
        created = null
        beforeEach ()->
            created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            gistsApi.setStar(created.id)
            gistsApi.unStar(created.id)
            @

        it "should be not contain in starred", ()->
            starIds = gistsApi.starred().map((gist)-> gist.id)
            expect(starIds).not.toContain(created.id)
            @

        afterEach ()->
            gistsApi.del(created.id)
            @

    describe "The 'isStarred' method", ()->
        created = null
        beforeEach ()->
            created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            @

        it "should return if is starred", ()->
            gistsApi.setStar(created.id)
            expect(gistsApi.isStarred(created.id)).toBe(true)
            @

        it "should return if is not starred", ()->
            expect(gistsApi.isStarred(created.id)).toBe(false)
            @

        afterEach ()->
            gistsApi.del(created.id)
            @
        @

    # uups,,, if i call another gist , it is ok 
    # describe "The 'fork' method" , ()->
    #     created = null
    #     forks = null
    #     beforeEach ()->
    #         created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
    #         forks = gistsApi.fork(created.id)
    #         @

    #     it "should create new gist object, but created gist has same contents", ()->
    #         expect(forks.id).not.toBe(created.id)
    #         expect(forks.description).toBe(created.description)
    #         @

    #     afterEach ()->
    #         gistsApi.del(created.id)
    #         gistsApi.del(forks.id)
    #         @
    #     @

    describe "The 'del' method" , ()->
        # it already tested on another spec
        @

    describe "The 'comments' method" , ()->
        created = null
        comments = null

        beforeEach ()->
            created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            created.addComment("comment")
            comments = gistsApi.comments(created.id)
            @

        it "should return array, and its length is 1", ()->
            expect(Array.isArray(comments)).toBe(true)
            expect(comments.length).toBe(1)
            @

        afterEach ()->
            gistsApi.del(created.id)
            @
        @
    describe "The 'comment' method", ()->
        created = null
        comments = null
        originComment = null
        comment = null

        beforeEach ()->
            created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            originComment = created.addComment("comment")
            comment = gistsApi.comment(created.id , originComment.id)

            @

        it "should return same comment", ()->
            expect(comment.id).toBe(originComment.id)
            @

        afterEach ()->
            gistsApi.del(created.id)
            @
        @
    describe "The 'addComment' method",()->
        created = null
        comment = null

        beforeEach ()->
            created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            comment = gistsApi.addComment(created.id , "comment")
            @

        it "should create new comment", ()->
            expect(comment.body).toBe("comment")
            expect(gistsApi.comment(created.id, comment.id).id).toBe(comment.id)
            @

        afterEach ()->
            gistsApi.del(created.id)
            @
        @

    describe "The 'deleteComment' method", ()->
        created = null
        comment = null

        beforeEach ()->
            created = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            comment = gistsApi.addComment(created.id , "comment")
            gistsApi.deleteComment(created.id , comment.id)
            @

        it "should delete comment", ()->
            expect(created.getComments().map((c)->c.id)).not.toContain(comment.id)
            @

        afterEach ()->
            gistsApi.del(created.id)
            @
        @

    describe "The Gist class", ()->
        gist = null

        beforeEach ()->
            gist = gistsApi.create("description" , false, "code.js" : {content : ScriptApp.getResource("gistsSpec").getDataAsString()})
            @

        afterEach ()->
            gist.del()
            @

        it "should has accessToken", ()->
            expect(gist.accessToken).toBe(apiKey)
            @

        describe "The 'setStar' method", ()->

            beforeEach ()->
                gist.setStar()
                @

            it "should contain in starred", ()->
                expect(gistsApi.starred().map((g)->g.id)).toContain(gist.id)
                @

            afterEach ()->
                gist.unStar()
                @
            @
        describe "The 'unStar' method" , ()->
            it "should not contain in starred", ()->
                expect(gistsApi.starred().map((g)->g.id)).not.toContain(gist.id)
                @
            @

        describe "The 'isStarred' method", ()->
            it "should return false , if gist is not starred", ()->
                expect(gist.isStarred()).toBe(false)
                @
            it "should return true , if gist is starred", ()->
                gist.setStar()
                expect(gist.isStarred()).toBe(true)
                gist.unStar()
                @
            @
        describe "The 'getComments' method", ()->

            comment = null

            beforeEach ()->
                comment = gist.addComment("hoge")
                @

            it "should contain added comment", ()->
                expect(gist.getComments().map((c)->c.id)).toContain(comment.id)
                @

            afterEach ()->
                gist.deleteComment(comment.id)
                @
            @

        describe "The 'getComment' method", ()->
            comment = null

            beforeEach ()->
                comment = gist.addComment("hoge")
                @

            it "should get added Comment", ()->
                expect(gist.getComment(comment.id).id).toBe(comment.id)
                @

            afterEach ()->
                gist.deleteComment(comment.id)
                @
            @
        describe "The 'addComment' method", ()->
            comment = null

            beforeEach ()->
                comment = gist.addComment("hoge")
                @

            it "should add new Comment", ()->
                expect(gist.getComment(comment.id).body).toBe("hoge")
                @

            afterEach ()->
                gist.deleteComment(comment.id)
                @
            @
        describe "The 'deleteComment" , ()->
            comment = null

            beforeEach ()->
                comment = gist.addComment("hoge")
                gist.deleteComment(comment.id)
                @
            it "should add new Comment", ()->
                expect(gist.getComments().map((c)->c.id)).not.toContain(comment.id)
                @
            @
        @
