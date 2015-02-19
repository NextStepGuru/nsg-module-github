component {

	function preHandler(event,rc,prc){
		prc.githubCredentials = getSetting('github')['oauth'];
		prc.githubSettings = getModuleSettings('nsg-module-github')['oauth'];
		if(!structKeyExists(session,'githubOAuth')){
			session['githubOAuth'] = structNew();
		}
	}

	function index(event,rc,prc){

		if( event.getValue('id','') == 'activateUser' ){
			var results = duplicate(session['githubOAuth']);
			// convert expires into a useful date/time
			var httpService = new http();
				httpService.setURL('https://api.github.com/user?access_token=#session['githubOAuth']['access_token']#');
			var data = deserializeJSON(httpService.send().getPrefix()['fileContent']);
			structAppend(results,data);

			announceInterception( state='githubLoginSuccess', interceptData=results );
			setNextEvent(view=prc.githubCredentials['loginSuccess'],ssl=( cgi.server_port == 443 ? true : false ));

		}else if( event.valueExists('code') ){
			session['githubOAuth']['code'] = event.getValue('code');

			var httpService = new http();
				httpService.setURL('#prc.githubSettings['tokenRequestURL']#?client_id=#prc.githubCredentials['clientID']#&redirect_uri=#urlEncodedFormat(prc.githubCredentials['redirectURL'])#&client_secret=#prc.githubCredentials['clientSecret']#&code=#session['githubOAuth']['code']#');
			var results = httpService.send().getPrefix();

			if( results['status_code'] == 200 ){
				var myFields = listToArray(results['fileContent'],'&');

				for(var i=1;i<=arrayLen(myFields);i++){
					if(listLen(myFields[i],'=') eq 2){
						session['githubOAuth'][listFirst(myFields[i],'=')] = listLast(myFields[i],'=');
					}
				}

				setNextEvent('github/oauth/activateUser')
			}else{
				announceInterception( state='githubLoginFailure', interceptData=results );
				throw('Unknown github OAuth.v2 Error','github.oauth');
			}

		}else{

			location(url="#prc.githubSettings['authorizeRequestURL']#?client_id=#prc.githubCredentials['clientID']#&redirect_uri=#urlEncodedFormat(prc.githubCredentials['redirectURL'])#&scope=#prc.githubCredentials['scope']#&state=#hash(randRange(1,99))#",addtoken=false);
		}
	}
}