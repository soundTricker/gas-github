describe "GAS Github Library Spec", ()-> 
    it 'should have create method, that generate Github.Github class', ()->
        expect(Github.create).toBeDefined()
        expect(Github.create('test')).toEqual(jasmine.any(Github.Github))

    it 'should have dummy method for code assist , if run it,it should be throw error', ()->
        msg = "it's a mock function for code assitant, please run this by created instance by create function."
        expect(Github.users).toBeDefined()
        expect(Github.users).toThrow(msg)

        expect(Github.gists).toBeDefined()
        expect(Github.gists).toThrow(msg)


