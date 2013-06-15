
/**
 * Create Github api Instance.
 *
 * @param {String} apiKey api key. Please generate at "Personal API Access Tokens" on https://github.com/settings/application.
 * @return {Github} Github API Instance
 */
function create(apiKey) {
  return new Github(apiKey);
}

/**
 * Get Users API Instance.
 * @return {GithubUsersApi} Users Api Instance
 */
function users(){
  throw new Error("it's a mock function for code assitant, please run this by created instance by create function.");
}

/**
 * Get Gists API Instance.
 * @return {GithubGistsApi} Gists Api Instance
 */
function gists(){
  throw new Error("it's a mock function for code assitant, please run this by created instance by create function.");
}

