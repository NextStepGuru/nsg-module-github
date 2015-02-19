Coldbox Module to allow Social Login via Github
================

Setup & Installation
---------------------

####Add the following structure to Coldbox.cfc

    github = {
        oauth = {
            loginSuccess        = "login.success",
            loginFailure        = "login.failure",
            clientID            = "{{github_provided_clientID}}",
            clientSecret        = "{{github_provided_clientSecret}}",
            redirectURL         = "{{where_the_user_will_land_after_redirect}}",
            scope               = "user,user:email"
        }
    }

Interception Point
---------------------
If you want to capture any data from a successful login, use the interception point twitterLoginSuccess. Inside the interceptData structure will contain all the provided data from twitter for the specific user.

####An example interception could look like this

    component {
        function githubLoginSuccess(event,interceptData){
            var queryService = new query(sql="SELECT roles,email,password FROM user WHERE githubUserID = :id;");
                queryService.addParam(name="id",value=interceptData['id']);
            var lookup = queryService.execute().getResult();
            if( lookup.recordCount ){
                login {
                    loginuser name=lookup.email password=lookup.password roles=lookup.roles;
                };
            }else{
                // create new user
            }
        }
    }

