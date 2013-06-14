do(global=@)->
    ApiBase = global.ApiBase
    class EventActivityApi extends ApiBase
        constructor:(accessToken)->super(accessToken)

        list:(option)->
            
