component {

	// Module Properties
	this.title 				= "Github";
	this.author 			= "Jeremy R DeYoung";
	this.webURL 			= "http://www.nextstep.guru";
	this.description 		= "Coldbox Module to allow Social Login via Github";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "github";
	// Model Namespace
	this.modelNamespace		= "github";
	// CF Mapping
	this.cfmapping			= "github";
	// Module Dependencies
	this.dependencies 		= ["nsg-module-security","nsg-module-oauth"];

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			oauth = {
				oauthVersion 		= 2,
				authorizeRequestURL = "https://github.com/login/oauth/authorize",
				tokenRequestURL 	= "https://github.com/login/oauth/access_token"
			}
		};

		// Layout Settings
		layoutSettings = {
		};

		// datasources
		datasources = {

		};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="oauth",action="index"},
			{pattern="/oauth/:id?", handler="oauth",action="index"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = "githubLoginFailure,githubLoginSuccess"
		};

		// Custom Declared Interceptors
		interceptors = [
		];

		// Binder Mappings
		binder.mapDirectory( "#moduleMapping#.models" );

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var nsgSocialLogin = controller.getSetting('nsgSocialLogin',false,arrayNew());
			arrayAppend(nsgSocialLogin,{"name":"github","icon":"github","title":"Github"});
			controller.setSetting('nsgSocialLogin',nsgSocialLogin);

		var nsgMenu = controller.getSetting('nsgMenu',false,[]);
		// menu::login
		arrayAppend(nsgMenu,{ "menu"="topRight","subid":"login","icon"="fa fa-github","id":"logingithub","title":"Sign-in with Github","link":"/security/login/github","roles":"","type":"link","isUserLoggedIn":false });
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}