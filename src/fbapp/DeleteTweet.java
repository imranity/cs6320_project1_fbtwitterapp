package fbapp;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.*;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Key;

@SuppressWarnings("serial")
public class DeleteTweet extends HttpServlet {
    public void doGet(HttpServletRequest req,
                      HttpServletResponse resp)
        throws IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        
        String tweet_key = req.getParameter("tweet_key");

        DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
        Key tw_key = KeyFactory.stringToKey(tweet_key);        
        try {
			Entity tweet = ds.get(tw_key);
			out.println("found entity" + tweet.getProperty("tweet_text"));
			ds.delete(tw_key);
	        out.println("<p>Deleted the tweet successfully: " +
	        		tweet.getProperty("tweet_text") + "</p>");
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        
        resp.sendRedirect("/");
    }
 
    public void doPost(HttpServletRequest req,
            HttpServletResponse resp) throws IOException {
    	doGet(req,resp);
    }
}