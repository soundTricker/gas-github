// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function(global) {
  var ApiBase, AuthenticatedGithubUser, GithubUser, UsersApi, Util;
  ApiBase = global.ApiBase;
  Util = global.Util;
  UsersApi = (function(_super) {

    __extends(UsersApi, _super);

    function UsersApi(accessToken) {
      UsersApi.__super__.constructor.call(this, accessToken);
    }

    UsersApi.prototype.me = function(get) {
      var req;
      if (get == null) {
        get = true;
      }
      if (get) {
        req = this.request('get', '/user');
        return new AuthenticatedGithubUser(this.accessToken, JSON.parse(req.getContentText()));
      } else {
        return new AuthenticatedGithubUser(this.accessToken);
      }
    };

    UsersApi.prototype.list = function(optSince) {
      var req, u, users;
      req = this.request('get', '/users', optSince ? {
        since: optSince
      } : void 0);
      users = JSON.parse(req.getContentText());
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = users.length; _i < _len; _i++) {
          u = users[_i];
          _results.push(new GithubUser(this.accessToken, u));
        }
        return _results;
      }).call(this);
    };

    UsersApi.prototype.get = function(userId) {
      var req;
      req = this.request('get', "/user/" + userId);
      return new GithubUser(this.accessToken, JSON.parse(req.getContentText()));
    };

    UsersApi.prototype.isFollowing = function(fromUserId, targetUserId) {
      var req;
      req = this.request('get', "/users/" + formUserId + "/following/" + targetUserId, null, true);
      return req.getResponceCode === 204;
    };

    UsersApi.prototype.getKeys = function(userId) {
      var req;
      req = this.request('get', "/users/" + userId + "/keys");
      return JSON.parse(req.getContentText());
    };

    return UsersApi;

  })(ApiBase);
  GithubUser = (function(_super) {

    __extends(GithubUser, _super);

    function GithubUser(accessToken, object) {
      var k, v;
      if (object == null) {
        object = {};
      }
      GithubUser.__super__.constructor.call(this, accessToken);
      for (k in object) {
        v = object[k];
        this[k] = v;
      }
    }

    GithubUser.prototype.getFollowers = function() {
      var req, u, users;
      req = this.request('get', "/users/" + this.id + "/followers");
      users = JSON.parse(req.getContentText());
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = users.length; _i < _len; _i++) {
          u = users[_i];
          _results.push(new GithubUser(this.accessToken, u));
        }
        return _results;
      }).call(this);
    };

    GithubUser.prototype.getFollowing = function() {
      var req, u, users;
      req = this.request('get', "/users/" + this.id + "/following");
      users = JSON.parse(req.getContentText());
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = users.length; _i < _len; _i++) {
          u = users[_i];
          _results.push(new GithubUser(this.accessToken, u));
        }
        return _results;
      }).call(this);
    };

    GithubUser.prototype.isFollowing = function(userId) {
      return new UserApi(this.accessToken).isFollowing(this.id, userId);
    };

    GithubUser.prototype.getKeys = function() {
      return new UserApi(this.accessToken).getKeys(this.id);
    };

    return GithubUser;

  })(ApiBase);
  return AuthenticatedGithubUser = (function(_super) {

    __extends(AuthenticatedGithubUser, _super);

    function AuthenticatedGithubUser(accessToken, object) {
      AuthenticatedGithubUser.__super__.constructor.call(this, accessToken, object);
    }

    AuthenticatedGithubUser.prototype.addEmails = function(emails) {
      var req;
      req = this.request('post', '/user/emails', emails);
      return JSON.parse(req.getContentText());
    };

    AuthenticatedGithubUser.prototype.getEmails = function() {
      var req;
      req = this.request('get', '/user/emails');
      return JSON.parse(req.getContentText());
    };

    AuthenticatedGithubUser.prototype.deleteEmails = function(emails) {
      var req;
      return req = this.request('delete', '/user/emails', emails);
    };

    AuthenticatedGithubUser.prototype.getFollowers = function() {
      var req, u, users;
      req = this.request('get', "/user/followers");
      users = JSON.parse(req.getContentText());
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = users.length; _i < _len; _i++) {
          u = users[_i];
          _results.push(new GithubUser(this.accessToken, u));
        }
        return _results;
      }).call(this);
    };

    AuthenticatedGithubUser.prototype.getFollowing = function() {
      var req, u, users;
      req = this.request('get', "/user/following");
      users = JSON.parse(req.getContentText());
      return (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = users.length; _i < _len; _i++) {
          u = users[_i];
          _results.push(new GithubUser(this.accessToken, u));
        }
        return _results;
      }).call(this);
    };

    AuthenticatedGithubUser.prototype.update = function(object) {
      var json, k, req, v;
      req = this.request('patch', "/user", object);
      json = JSON.parse(req.getContentText());
      for (k in json) {
        v = json[k];
        this[k] = v;
      }
      return this;
    };

    AuthenticatedGithubUser.prototype.isFollowing = function(userId) {
      var req;
      req = this.request('get', "/user/following/" + userId, null, true);
      return req.getResponceCode === 204;
    };

    AuthenticatedGithubUser.prototype.addFollow = function(userId) {
      var req;
      return req = this.request('put', "/user/following/" + userId);
    };

    AuthenticatedGithubUser.prototype.unFollow = function(userId) {
      var req;
      return req = this.request('delete', "/user/following/" + userId);
    };

    AuthenticatedGithubUser.prototype.getKeys = function() {
      var req;
      req = this.request('get', "/user/keys");
      return JSON.parse(req.getContentText());
    };

    AuthenticatedGithubUser.prototype.getKey = function(keyId) {
      var req;
      req = this.request('get', "/user/keys/" + keyId);
      return JSON.parse(req.getContentText());
    };

    AuthenticatedGithubUser.prototype.addKey = function(title, key) {
      var req;
      req = this.request('post', "/user/keys/", {
        title: title,
        key: key
      });
      return JSON.parse(req.getContentText());
    };

    AuthenticatedGithubUser.prototype.updateKey = function(keyId, title, key) {
      var req;
      req = this.request('patch', "/user/keys/" + keyId, {
        title: title,
        key: key
      });
      return JSON.parse(req.getContentText());
    };

    AuthenticatedGithubUser.prototype.deleteKey = function(keyId) {
      var req;
      return req = this.request('delete', "/user/keys/" + keyId);
    };

    return AuthenticatedGithubUser;

  })(GithubUser);
})(this);
