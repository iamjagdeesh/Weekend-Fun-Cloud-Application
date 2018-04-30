<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONException"%>
<%@ page import="org.json.JSONObject"%>

<%-- //[START imports]--%>
<%-- //[END imports]--%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<meta http-equiv="content-type"
	content="application/xhtml+xml; charset=UTF-8" />
<title>Weekend Fun</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
function map(src, dst) {
	console.log(src);
	var srcContent = "https://www.google.com/maps/embed/v1/directions?key=AIzaSyDKf_wK_7lVCODXoD6cS_tOdMrmTchxxZo&origin="+src+"&destination="+dest+"&avoid=tolls|highways";
    document.getElementById('mapFrame').src = srcContent;
  }
</script>
</head>

<body>
	<div class="container">
		<h1 align="center">Weekend Fun Activity Search</h1>
		<div class="row">
			<div class="col-sm-3">
				<form action="">
					<div class="form-group">
						<label for="state">Select State:</label> <select
							class="form-control" id="state" name="state">
							<% String[] states = { "Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado",
				"Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa",
				"Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine",
				"Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", " North Dakota",
				"Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma",
				"Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
				"Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia",
				"Wyoming" };
								for (String state : states)
								{
									out.print("<option>");
									out.print(state);
									out.print("</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="groupType">Select group type:</label> <select
							class="form-control" id="groupType" name="groupType">
							<option value="kids">Kids</option>
							<option value="teens">Teenagers</option>
							<option value="youth">Youth</option>
							<option value="adults">Adults</option>
							<option value="seniors">Seniors</option>
						</select>
					</div>
					<div class="form-group">
						<label for="budgetType">Type of budget:</label> <select
							class="form-control" id="budgetType" name="budgetType">
							<option value="free">Free</option>
							<option value="inexpensive cheap">Economical</option>
							<option value="affordable">Affordable</option>
							<option value="expensive">Luxurious</option>
						</select>
					</div>
					<div class="form-group">
						<label for="address">Starting Address:</label> <input
							type="search" class="form-control" id="address"
							placeholder="Enter address" name="address">
					</div>
					<div class="form-group">
						<label for="activityType">Type of activity:</label> <input
							type="search" class="form-control" id="activityType"
							placeholder="Enter activity type" name="activityType">
					</div>
					<div class="form-group">
						<label for="selectedDate">Fun day to choose:</label> <input
							type="date" class="form-control" id="selectedDate"
							placeholder="Enter the date within five days from today"
							name="selectedDate" max="2018-05-03" min="2018-04-29">
					</div>
					<button type="submit" class="btn btn-primary">Submit</button>
				</form>
			</div>
			<div class="col-sm-6" id="results">
				<h3>Results of Recommendation</h3>
				<div class="table-responsive"
					style="overflow-y: scroll; height: 70%;">
					<table class="table">
						<thead>
							<tr>
								<th>Place Name</th>
								<th>Link</th>
								<th>Weather</th>
								<th>Temperature in °F</th>
							</tr>
						</thead>
						<tbody>
							<% Map<String, JSONObject> results = (Map<String, JSONObject>) request.getAttribute("results");
								String src = (String) request.getParameter("address");
								String dest = null;
								if(results != null) {
									for (String placeName : results.keySet())
									{
										JSONObject place = results.get(placeName);
										JSONArray weathers = (JSONArray) place.get("weatherMap");
										Map<String, String> weather = (Map<String, String>) weathers.get(0);
										dest = place.getString("formatted_address");
										out.print("<tr>");
										out.print("<td>");
										out.print(place.getString("name"));
										out.print("</td>");
										out.print("<td>");
										String funCall = "map(East+Orange+Street,Oslo+Norway)";
										out.print("<button type=\"button\" onclick="+funCall+"/>");
										out.print("</td>");
										out.print("<td>");
										out.print(weather.get("weatherDesc"));
										out.print("</td>");
										out.print("<td>");
										out.print(weather.get("temperature"));
										out.print("</td>");
										out.print("</tr>");
									}
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
			<div class="col-sm-3">
				<iframe id="mapFrame" width="600" height="450" frameborder="0" style="border: 0"
					src="https://www.google.com/maps/embed/v1/directions?key=AIzaSyDKf_wK_7lVCODXoD6cS_tOdMrmTchxxZo&origin=Oslo+Norway&destination=Telemark+Norway&avoid=tolls|highways"
					allowfullscreen> </iframe>
			</div>
		</div>
	</div>
</body>
</html>