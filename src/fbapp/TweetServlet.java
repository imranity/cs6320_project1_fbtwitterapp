package fbapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.SimpleTimeZone;
import javax.servlet.http.*;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.KeyFactory;


@SuppressWarnings("serial")
public class TweetServlet extends HttpServlet {
    public void doGet(HttpServletRequest req,
                      HttpServletResponse resp)
        throws IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSSSSS");
        fmt.setTimeZone(new SimpleTimeZone(0, ""));
        String date = fmt.format(new Date());
        String tweet_text = req.getParameter("tweet_text");
        String userid =req.getParameter("userid");
        String username =req.getParameter("username");
        String picture =req.getParameter("picture");
        String msg_tweet = req.getParameter("msg_tweet");
        int count = 0;


        DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

        Entity tweet = new Entity("Tweet");

        tweet.setProperty("text", tweet_text);
        tweet.setProperty("userid", userid);
        tweet.setProperty("date", date);
        tweet.setProperty("username", username);
        tweet.setProperty("picture", picture);
        tweet.setProperty("count", count);
        ds.put(tweet);
        String key = KeyFactory.keyToString(tweet.getKey());
        if (msg_tweet != null || msg_tweet == "true") {
        	out.print(key);
        }
        else {
        resp.sendRedirect("/");
        }
    }
 
    public void doPost(HttpServletRequest req,
            HttpServletResponse resp) throws IOException {
    	doGet(req,resp);
    }
}