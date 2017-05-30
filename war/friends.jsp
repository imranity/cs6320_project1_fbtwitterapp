<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.EntityNotFoundException" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>FBTweet, from @mmalik6</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="FB Tweet Project CS6320">
    <meta name="author" content="Imran Malik">

 <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

         <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    

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

     <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="home.jsp">Home</a></li>
              <li><a id="profile_link" target="_blank" href="#">Profile</a> </li>
              <li><a id="friends_tweet" href="./friends.jsp">Friends Tweet</a> </li>
              <li><a id="friends_top_tweets" href="./friends_top_tweets.jsp">Top Tweets of Friends</a> </li>
            </ul>
          </div>
          </div>
          </div>
          </div>
  <div class="jumbotron">
  <h1> Friends Tweet Page</h1><br>
  <h3> View Friends tweets here</h3>
  </div>

<% Cookie[] cookies = request.getCookies();
		String name="";
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie cookie = cookies[i];
				if (cookie.getName().equals("userid")) {
					name = cookie.getValue();
					break;
				}
				else{
				}
			}
		}
		
 %> 
		
		<% 
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    // Run an ancestor query to ensure we see the most up-to-date
	    // view of the Greetings belonging to the selected Guestbook.
	    Query query = new Query("Tweet");
	    query.addFilter("userid",
	            Query.FilterOperator.NOT_EQUAL,
	            name);
	    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
	    int num_tweets = tweets.size();
	    if (tweets.isEmpty()) {
		%>
<div class="alert alert-danger">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <h4>Warning!</h4>
  No tweets from friends... Best check if any of your friends is using this app...
</div>
<% 
} 
	     else {
	    	 for (Entity tweet : tweets) { 
	    			String tweet_text =  (String) tweet.getProperty("text");
	    			String tweet_date = (String) tweet.getProperty("date");
	    			String username = (String) tweet.getProperty("username");
	    			Long count = (Long) tweet.getProperty("count");
	    			String key = KeyFactory.keyToString(tweet.getKey()); 
					String href = "'view_tweet.jsp?tweet_key=" + key + "'";
					String picture = "'" + (String) tweet.getProperty("picture") + "'";
					%>
	     <div class="container">
        <ul class="list-group">

            <li class="list-group-item list-group-item-success">
              <p>
                <a class="active" target="_blank" href=<%=href%> ><%=tweet_text%></a>
              </p>
              <p>
                <strong>Created at: <%=tweet_date %></strong>
              </p>
              <p>
                <strong> Posted by: <%=username %></strong> 
              </p>
               <p>
                <strong> View Count : <%=count %></strong> 
              </p>
              <div id="profile_pic" class="span1"><a href=<%=href%> class="thumbnail"><img src=<%=picture%> alt=""></a></div>
            </li>


      </ul>
  </div>
	     <% }  
	    	} %>
 <script>
document.getElementById('profile_link').href = localStorage.profile_url;
</script>
</body>
</html>