<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>FBTweet, from @mmalik6</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="FB Tweet Project CS6320">
    <meta name="author" content="Imran Malik">

    <link href="./css/bootstrap.min.css" media="all" type="text/css" rel="stylesheet">
    <link href="./css/bootstrap-responsive.min.css" media="all" type="text/css" rel="stylesheet">
    <link href="./css/font-awesome.css" rel="stylesheet" >
    <link href="./css/nav-fix.css" media="all" type="text/css" rel="stylesheet">
    
    <style>
      .artwork {
        margin-top:30px;
        margin-bottom: 30px;
      }

    </style>

  </head>
<body>
 <div id="fb-root"></div>
<script>
// This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response) {
console.log('statusChangeCallback');
console.log(response);
// The response object is returned with a status field that lets the
// app know the current login status of the person.
// Full docs on the response object can be found in the documentation
// for FB.getLoginStatus().
if (response.status === 'connected') {
// Logged into your app and Facebook.
var msg=document.getElementById('main_tweet_db');
msg.style.display='';
var login_div=document.getElementById('status');
login_div.style.display='none';
testAPI();
} 
else if (response.status === 'not_authorized') {
// The person is logged into Facebook, but not your app.
var msg=document.getElementById('main_tweet_db');
msg.style.display='none';
var profile=document.getElementById('profile_link');
profile.style.display='none';
document.cookie = "userid=" ;
document.cookie = "username=";


} else {
// The person is not logged into Facebook, so we're not sure if
// they are logged into this app or not.
var msg=document.getElementById('main_tweet_db');
msg.style.display='none';
var profile=document.getElementById('profile_link');
msg.style.display='none';
document.cookie = "userid=" ;
document.cookie = "username=";

}
}


var login_event = function(response) {
	var msg=document.getElementById('main_tweet_db');
	msg.style.display='';
	var login_div=document.getElementById('status');
	login_div.style.display='none';
}

var logout_event = function(response) {
	var msg=document.getElementById('main_tweet_db');
	msg.style.display='none';
	var profile=document.getElementById('profile_link');
	msg.style.display='none';
	var login_div=document.getElementById('status');
	login_div.style.display='';
	document.cookie = "userid=" ;
	document.cookie = "username=";

}
// This function is called when someone finishes with the Login
// Button.  See the onlogin handler attached to it in the sample
// code below.
  function checkLoginState() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }


window.fbAsyncInit = function() {
    FB.init({
// for localhost use: 404277549954087
//      appId      : '404277549954087',
      // for appengine use following 
      //for tweet project local 685563044963492
      // For appengine 404277549954087
   	appId      : '404277549954087',
      cookie     : true,  // enable cookies to allow the server to access 
      // the session
      xfbml      : true,
      version    : 'v2.1'
    });  
FB.getLoginStatus(function(response) {
	    statusChangeCallback(response);
	  });
FB.Event.subscribe('auth.statusChange', function(response) {
    if (response.status === 'connected') {
                  //the user is logged and has granted permissions
       login_event();
    } else if (response.status === 'not_authorized') {
          //ask for permissions
         logout_event();
    } else {
    	logout_event();
          //ask the user to login to facebook
    }
});

	  };	  
(function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
   
   


var post = function() {
	var text = document.getElementById('tweet_text').value;
	console.log("value of text is " + text);
	FB.api('/me/feed', 'post', { message: text }, function(response) {
		  if (!response || response.error) {
		    alert('Error occured due to: ' + response.error.message);
		    console.log(response.error.message);
		  } else {
		    alert('Post ID: ' + response.id);
		    location.reload();
		  }
		});

	
}


// Here we run a very simple test of the Graph API after login is
// successful. See statusChangeCallback() for when this call is made.
function share() {
	var tweet_text = document.getElementById('tweet_text').value;
	var userid = document.getElementById('userid').value;
	var username = document.getElementById('username').value;
	var picture = document.getElementById('picture').value;
	var msg_tweet = "true";

	var post_data = {
			  tweet_text: tweet_text,
			  userid: userid  , 
			  username: username,
			 picture: picture,
			 msg_tweet : "true"
			};
	$.post( "Tweet", post_data, function(data) {
		console.log(data);
		var key = data;
		var url = window.location.href ;
		if (url.search("localhost")!==-1) {
			url = "https://facebook.com/";
		}
		var share_url = url + "view_tweet.jsp?tweet_key=" + key ;
		var dict = {
				  method: 'send',
				  link: share_url  , 
				  caption: 'tweet',
				 description: 'Dialogs provide a simple, consistent interface for applications to interface with users.'
				   
				};

	FB.ui(
				   dict ,
				   function(response) {

				     if (response && response.success) {
				       alert('Post was shared via message.');
				       location.reload();
				     } else {
				       alert('Post was not published due to .' + response.error.message);
				     }
				   }
				 );	
		
		
		
		

	} );
	
	


}
var profile_url = "";
function testAPI() {

console.log('Welcome! Fetching your information.... ');
FB.api('/me', function(response) {

console.log('Successful login for: ' + response.name);
console.log('response is ' + JSON.stringify(response));
document.getElementById('profile_pic').innerHTML = '<a href="#" class="thumbnail"><img src="http://graph.facebook.com/' + response.id + '/picture?type=large" /></a>';
document.getElementById('fullname').innerText = response.name;
document.getElementById('fullname_head').innerText = response.name;
document.getElementById('whatsup').innerText = 'What\'s happening ' + response.name;
document.getElementById('profile_link').href = 'https://facebook.com/' + response.id;
profile_url = 'https://facebook.com/' + response.id;
localStorage.profile_url = profile_url;
document.getElementById('picture').value = 'http://graph.facebook.com/' + response.id + '/picture';
document.getElementById('userid').value =  response.id;
document.getElementById('username').value =  response.name.split(" ")[0];
document.cookie = "userid=" + response.id;
document.cookie = "username=" + response.name.split(" ")[0];
document.cookie = "profile=" + "https://facebook.com/" + response.id;
document.cookie = "picture=" + "http://graph.facebook.com/" + response.id + "/picture?type=large";

});
}
</script>



<div id ="status" class="well" style="width:800px; margin:0 auto;">
  <h1 class="lead"><strong>Welcome to Tweeter App by Imran Malik </strong> </h1>
  <p>This app lets you post your tweets to facebook or share with friends :) </p>
  <p>You need to login with your facebook account to continue...</p>
<fb:login-button size="xlarge" autologoutlink="true" scope="public_profile,email,publish_actions,user_friends" onlogin="checkLoginState();">
</fb:login-button>
</div>


<% Cookie[] cookies = request.getCookies();
		String userid="", username="",picture="";
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie cookie = cookies[i];
				if (cookie.getName().equals("userid")) {
					userid = cookie.getValue();
				}

				if (cookie.getName().equals("username")) {
					username = cookie.getValue();
				}

				if (cookie.getName().equals("picture")) {
					picture = cookie.getValue();
				}
			}
		}
		
		%>
		
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">Tweeter for FB</a>
          <div class="btn-group pull-right" id="welcome">
           Welcome, <strong><a id="fullname"> </a> </strong> 
                <fb:login-button size="large" autologoutlink="true" scope="public_profile,email,publish_actions,user_friends" onlogin="checkLoginState();">
				</fb:login-button>                      
           </div>
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a id="profile_link" target="_blank" href="#">Profile</a> </li>
              <li><a id="friends_tweet" href="./friends.jsp">Friends Tweet</a> </li>
              <li><a id="friends_top_tweets" href="./friends_top_tweets.jsp">Top Tweets of Friends</a> </li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
        <div class="container">
      <div class="row">
        <div class="span8 offset2">
     <div class="row artwork hidden-phone" style="font-size:80px; text-align: center;">
		<div class="span2"><i class="icon-group"></i></div>
		<div class="span2"><i class="icon-comments-alt"></i></div>
		<div class="span2"><i class="icon-globe"></i></div>
		<div class="span2"><i class="icon-thumbs-up"></i></div>
	</div>
	</div>
	</div>
	</div>
<div id="main_tweet_db" class="container" style="display:none;">
<div class="row">
   <div class="span4 offset4">
    <p id="whatsup" class="lead"> </p>
    <div class="row">
      <div class="span4 well">
      <form method="post" action="Tweet" name="post_tweet" id="post_tweet" accept-charset="UTF-8">        
      <input type="hidden" name="userid" id="userid" value=""/>
      <input type="hidden" name="username" id="username" value=""/>
      <input type="hidden" name="picture" id="picture" value=""/>                  
      <textarea class="span4" id="tweet_text" name="tweet_text" rows="5" placeholder="Type in your new tweet"></textarea>
        <input type="submit" name="post_btn" value="Post New Tweet" class="btn btn-info" onclick="post()"/>
        <input type="button" name="share_btn" value="Share with friends" class="btn btn-primary" onclick="share()"/>
        </form>     
         </div>
    </div>
    
    <div class="row">
      <div class="span4 well">
        <div class="row">
          <div id="profile_pic" class="span1"><a href="#" class="thumbnail"><img src="./img/user.jpg" alt=""></a></div>
          <div class="span3">
            <h3><a id="fullname_head"> </a></h3>
            <span id="num_tweets" class=" badge badge-warning">0 tweets</span> <span class=" badge badge-info">0 followers</span>          
           </div>
        </div>
      </div>
    </div>

    <div class="container">
    <div class="row">
   <div class="span4 well" style="overflow-y: scroll; height:101%;">
        <p class="lead"> Previously Tweeted:</p>
            		  <hr />
   
<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Tweet").addSort("date", Query.SortDirection.DESCENDING);
    query.addFilter("userid",
            Query.FilterOperator.EQUAL,
            userid);
    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
    int num_tweets = tweets.size();
    if (tweets.isEmpty()) {
%>
<div class="alert alert-danger"> <p> No tweets to be shown yet</p>
</div>
<%
}
else { 
%>
	<script type="text/javascript"> console.log(<%=num_tweets%>);document.getElementById("num_tweets").innerText = "<%=num_tweets%> tweets";</script>
<% 
	for (Entity tweet : tweets) { 
		String tweet_text =  (String) tweet.getProperty("text");
		String tweet_date = (String) tweet.getProperty("date");
		String key = KeyFactory.keyToString(tweet.getKey());
		String href = "'view_tweet.jsp?tweet_key=" + key + "'";
%>
    		  <div>
            <a class="active" href=<%=href%> ><%=tweet_text%></a>
            <form method="post" action="Delete" name="delete_tweet" accept-charset="UTF-8">     
            <input type="hidden" name="tweet_key" id="tweet_key" value="<%=key%>"/>    
            <input type="submit" class="btn btn-danger" value="Delete"/>
            </form>
            <span class="badge pull-right">At <%=tweet_date%></span>
            <p>&nbsp;</p>
    		</div>      
    		   <hr />
<% 
  } 
%>

        <ul class="pager"><li class="previous disabled"><a href="#">&laquo; Previous</a></li><li class="next disabled"><a href="#">Next &raquo;</a></li></ul>      
    </div>
    </div>
    </div>
    
    <div class="container">
    <div class="row">
      <div class="span4 well" style="overflow-y: scroll; height:101%;">
        <p class="lead"> Most Famous Tweets:</p>
           <hr />
        <%   Query c_query = new Query("Tweet").addSort("count", Query.SortDirection.DESCENDING);
c_query.addFilter("userid",
        Query.FilterOperator.EQUAL,
        userid);
List<Entity> c_tweets = datastore.prepare(c_query).asList(FetchOptions.Builder.withChunkSize(2000)); 
for (Entity each_tweet : c_tweets ) { 
		String c_tweet_text =  (String) each_tweet.getProperty("text");
		String c_tweet_date = (String) each_tweet.getProperty("date");
		Long c_tweet_count = (Long) each_tweet.getProperty("count");
		String c_key = KeyFactory.keyToString(each_tweet.getKey());
		String c_href = "'view_tweet.jsp?tweet_key=" + c_key + "'";%>
    		<div>
            <a class="active" href=<%=c_href%> ><%=c_tweet_text%></a>
            <p>&nbsp;</p>
            <button type="submit" class="btn btn-primary">View Count <%=c_tweet_count %></button>
             <span class="badge pull-right"><%=c_tweet_date%></span>
            <p>&nbsp;</p>
    	   </div>  
    	    <hr />	
    	   <% } %>    
    	     
       </div>
    </div>   
    
    <% } %>
    </div>
  </div>
  </div>
  
</div>
    <div class="container">
      <hr />
      <div class="row">
        <div class="span12">
        <p>Tweeter from you.</p>
        </div>
      </div>
    </div>
  <script src="./js/jquery-1.7.2.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
    <script src="./js/charcounter.js"></script>
  <script src="./js/app.js"></script>
  </body>
</html>
