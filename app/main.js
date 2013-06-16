
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

/**
 * Get Activity API Instance
 * @return {GithubActivityApi} Activity Api Instance
 */
function activity() {
  throw new Error("it's a mock function for code assitant, please run this by created instance by create function.");
}

/**
 * Get Notification API Instance
 * @return {GithubNotificationApi} Notification Api Instance
 */
function notifications() {
  throw new Error("it's a mock function for code assitant, please run this by created instance by create function.");
}


