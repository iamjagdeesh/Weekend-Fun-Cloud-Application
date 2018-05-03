package com.appengine.weekendfun;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.client.utils.URIBuilder;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.appengine.api.urlfetch.URLFetchService;
import com.google.appengine.api.urlfetch.URLFetchServiceFactory;
import com.google.gson.JsonArray;

import org.springframework.cache.annotation.EnableCaching;

@SuppressWarnings("serial")
@WebServlet("/")
@EnableCaching
public class MapsApiServlet extends HttpServlet {

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		Map<String, JSONObject> results = getResultsForCategory(req);
		String link = null;
		/*if (results != null) {
			for (String placeName : results.keySet()) {
				JSONObject place = results.get(placeName);
				JSONArray weathers = (JSONArray) place.get("weatherMap");
				Map<String, String> weather = (Map<String, String>) weathers.get(0);
				String w1 = weather.get("weatherDesc");
				String w2 = weather.get("temperature");
				if(!place.keySet().contains("photos")) {
					System.out.println(place.getString("name"));
				} else {
					JSONArray photos = place.getJSONArray("photos");
					link = photos.getJSONObject(0).getString("photo_reference");
				}
				// out.print("<tr>");
				// out.print("<td>");
				// out.print(place.getString("name"));
				// out.print("</td>");
				// out.print("<td>");
				// out.print(link);
				// out.print("</td>");
				// out.print("<td>");
				// out.print(place.getString("name"));
				// out.print("</td>");
				// out.print("</tr>");
			}
		}*/
		req.setAttribute("results", results);
		RequestDispatcher dispatcher = req.getRequestDispatcher("index.jsp");
		dispatcher.forward(req, resp);
	}

	public static JSONObject readJsonFromUrl(URL url) throws IOException, JSONException {
		InputStream is = url.openStream();
		try {
			BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
			String jsonText = readAll(rd);
			JSONObject json = new JSONObject(jsonText);
			return json;
		} finally {
			is.close();
		}
	}

	private static String readAll(Reader rd) throws IOException {
		StringBuilder sb = new StringBuilder();
		int cp;
		while ((cp = rd.read()) != -1) {
			sb.append((char) cp);
		}
		return sb.toString();
	}

	public static Map<String, JSONObject> getResultsForCategory(HttpServletRequest req)
			throws ServletException, JSONException, IOException {
		String state = req.getParameter("state");
		if (state == null)
			return null;
		String groupType = req.getParameter("groupType");
		String budgetType = req.getParameter("budgetType");
		String address = req.getParameter("address");
		String dateSelected = req.getParameter("selectedDate");
		String queryString = null;
		String key = "AIzaSyCjzdF82OByGEz2cxfQeL-hITA2D0w31Hc";
		URIBuilder builder = null;
		URI uri = null;
		URL url = null;
		Map<String, Map<String, String[]>> activitiesMap = ActivitiesMap.initializeMap();
		Map<String, String[]> typeMap = activitiesMap.get(groupType);
		Map<String, JSONObject> resultsMap = new HashMap<String, JSONObject>();
		for (String type : typeMap.keySet()) {
			String[] keywords = typeMap.get(type);
			for (String activityType : keywords) {
				queryString = budgetType + " " + activityType + " in " + state;
				builder = new URIBuilder();
				builder.setScheme("https").setHost("maps.googleapis.com").setPath("/maps/api/place/textsearch/json")
						.addParameter("query", queryString) // Tracking ID / Property ID.
						// Anonymous Client Identifier. Ideally, this should be a UUID that
						// is associated with particular user, device, or browser instance.
						.addParameter("key", key);
				try {
					uri = builder.build();
				} catch (URISyntaxException e) {
					throw new ServletException("Problem building URI", e);
				}
				/* URLFetchService fetcher = URLFetchServiceFactory.getURLFetchService(); */
				url = uri.toURL();
				JSONObject jo = readJsonFromUrl(url);
				JSONArray results = (JSONArray) jo.get("results");
				if (results.length() == 0)
					continue;
				if (groupType.equals("kids")) {
					for (int i = 0; i < results.length() && i < 15; i++) {
						JSONObject place = results.getJSONObject(i);
						String placeName = place.getString("name");
						JSONObject geometry = place.getJSONObject("geometry");
						JSONObject location = geometry.getJSONObject("location");
						Double lat = location.getDouble("lat");
						Double lng = location.getDouble("lng");
						Map<String, String> weatherMap = new HashMap<String, String>();
						weatherMap = getWeatherDetails(lat, lng, dateSelected);
						place.append("weatherMap", weatherMap);
						resultsMap.put(placeName, place);
					}
				} else {
					for (int i = 0; i < results.length() && i < 3; i++) {
						JSONObject place = results.getJSONObject(i);
						String placeName = place.getString("name");
						JSONObject geometry = place.getJSONObject("geometry");
						JSONObject location = geometry.getJSONObject("location");
						Double lat = location.getDouble("lat");
						Double lng = location.getDouble("lng");
						Map<String, String> weatherMap = new HashMap<String, String>();
						weatherMap = getWeatherDetails(lat, lng, dateSelected);
						place.append("weatherMap", weatherMap);
						resultsMap.put(placeName, place);
					}
				}
			}
		}

		return resultsMap;
	}

	public static Map<String, String> getWeatherDetails(Double lat, Double lng, String dateSelected)
			throws ServletException, JSONException, IOException {
		Map<String, String> weatherMap = new HashMap<String, String>();
		String queryString = null;
		String appid = "352612c43a47f53389e2c0dcd28e2d2e";
		URIBuilder builder = new URIBuilder();
		builder.setScheme("http").setHost("api.openweathermap.org").setPath("/data/2.5/forecast")
				.addParameter("appid", appid) // Tracking ID / Property ID.
				// Anonymous Client Identifier. Ideally, this should be a UUID that
				// is associated with particular user, device, or browser instance.
				.addParameter("mode", "json").addParameter("lon", lng.toString()).addParameter("lat", lat.toString())
				.addParameter("units", "imperial");
		URI uri = null;
		try {
			uri = builder.build();
		} catch (URISyntaxException e) {
			throw new ServletException("Problem building URI", e);
		}
		URL url = uri.toURL();
		JSONObject jo = readJsonFromUrl(url);
		JSONArray dates = jo.getJSONArray("list");
		for (int i = 0; i < dates.length(); i++) {
			JSONObject date = dates.getJSONObject(i);
			String dateText = date.getString("dt_txt");
			String[] dateTime = dateText.split(" ");
			if (dateTime[0].equals(dateSelected)) {
				JSONArray weather = date.getJSONArray("weather");
				JSONObject weatherObj = weather.getJSONObject(0);
				String weatherDesc = weatherObj.getString("description");
				weatherMap.put("weatherDesc", weatherDesc);
				JSONObject temperatureObj = date.getJSONObject("main");
				Double temperature = temperatureObj.getDouble("temp");
				weatherMap.put("temperature", temperature.toString());
				break;
			}
		}
		return weatherMap;
	}

}
