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
	function mapFun(src, dst) {
		console.log(src);
		var mapSrcContent = "https://www.google.com/maps/embed/v1/directions?key=AIzaSyDKf_wK_7lVCODXoD6cS_tOdMrmTchxxZo&origin="
				+ src + "&destination=" + dst + "&avoid=tolls";
		document.getElementById('mapFrame').src = mapSrcContent;
		document.getElementById('mapFrame').style.display = "inline-block";
	}

	function imageFun(link) {
		var imageSrcContent = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&key=AIzaSyCjzdF82OByGEz2cxfQeL-hITA2D0w31Hc&photoreference="
				+ link;
		console.log(imageSrcContent);
		document.getElementById('imageFrame').src = imageSrcContent;
		document.getElementById('imageFrame').style.display = "inline-block";
	}

	$(document).ready(function() {
		$("#imageButton").click(function() {
			$("#imageFrame").toggle();
		});
	});

	$(document).ready(function() {
		$("#mapButton").click(function() {
			$("#mapFrame").toggle();
		});
	});

	function initialize(state, groupType, budgetType, address, dateSelected) {
		document.getElementById("state").value = state;
		document.getElementById("groupType").value = groupType;
		document.getElementById("budgetType").value = budgetType;
		document.getElementById("address").value = address;
		document.getElementById("selectedDate").value = dateSelected;
	}
</script>
</head>

<%
	String state1 = request.getParameter("state");
	String groupType = request.getParameter("groupType");
	String budgetType = request.getParameter("budgetType");
	String address = request.getParameter("address");
	if (address == null)
		address = "";
	String dateSelected = request.getParameter("selectedDate");
%>

<body
	onLoad="initialize('<%=state1%>','<%=groupType%>','<%=budgetType%>','<%=address%>','<%=dateSelected%>')"
	border="5">
	<div class="container-fluid">
		<h1 align="center" style="margin-bottom: 20px;">Weekend Fun
			Activity</h1>
		<div class="row">
			<div class="col-sm-2 border-right">
				<h3>Inputs</h3>
				<form action="">
					<div class="form-group">
						<label for="state">Select State:</label> <select
							class="form-control" id="state" name="state" required="true">
							<%
								String[] states = {"Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado",
										"Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa",
										"Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland",
										"Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina",
										" North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York",
										"Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina",
										"South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington",
										"Wisconsin", "West Virginia", "Wyoming"};
								for (String state : states) {
									out.print("<option>");
									out.print(state);
									out.print("</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="groupType">Select group type:</label> <select
							class="form-control" id="groupType" name="groupType"
							required="true">
							<option value="kids">Kids</option>
							<option value="teens">Teenagers</option>
							<option value="youth">Youth</option>
							<option value="adults">Adults</option>
							<option value="seniors">Seniors</option>
						</select>
					</div>
					<div class="form-group">
						<label for="budgetType">Type of budget:</label> <select
							class="form-control" id="budgetType" name="budgetType"
							required="true">
							<option value="free">Almost Free</option>
							<option value="inexpensive cheap">Economical</option>
							<option value="affordable">Affordable</option>
							<option value="expensive">Luxurious</option>
						</select>
					</div>
					<div class="form-group">
						<label for="address">Starting Address:</label> <input
							type="search" class="form-control" id="address"
							placeholder="Enter address" name="address" required="true">
					</div>
					<div class="form-group">
						<label for="selectedDate">Fun day to choose:</label> <input
							type="date" class="form-control" id="selectedDate"
							placeholder="Enter the date within five days from today"
							name="selectedDate" max="2018-05-08" min="2018-05-04"
							required="true">
					</div>
					<button type="submit" class="btn btn-primary">Submit</button>
				</form>
			</div>
			<div class="col-sm-6 border-right" id="results">
				<h3>Results of Recommendation</h3>
				<div class="table-responsive"
					style="overflow-y: scroll; height: 78%;">
					<table class="table">
						<thead>
							<tr>
								<th>Name</th>
								<th>City</th>
								<th>Rating</th>
								<th>Weather</th>
								<th>Temperature</th>
							</tr>
						</thead>
						<tbody>
							<%
								Map<String, JSONObject> results = (Map<String, JSONObject>) request.getAttribute("results");
								String src = (String) request.getParameter("address");
								src = '\'' + src + '\'';
								String dst = null;
								String link = null;
								Double rating = null;
								String city = null;
								if (results != null) {
									for (String placeName : results.keySet()) {
										rating = null;
										JSONObject place = results.get(placeName);
										JSONArray weathers = (JSONArray) place.get("weatherMap");
										Map<String, String> weather = (Map<String, String>) weathers.get(0);
										if (place.has("formatted_address")) {
											dst = place.getString("formatted_address");
										} else {
											dst = "No Info";
										}
										String[] arrOfaddr = dst.split(",");
										int addLength = arrOfaddr.length; 
										if (addLength < 3) {
											if(addLength < 2) {
												city = arrOfaddr[0];
											}
											else {
												city = arrOfaddr[1];	
											}
										} else {
											city = arrOfaddr[addLength - 3];
										}

										String newDst = dst.replaceAll("[,]", "");
										if (place.has("rating")) {
											rating = place.getDouble("rating");
										}
										if (rating == null) {
											rating = -1.0;
										}
										newDst = '\'' + newDst + '\'';
										if (!place.keySet().contains("photos")) {
											link = " ";
										} else {
											JSONArray photos = place.getJSONArray("photos");
											link = photos.getJSONObject(0).getString("photo_reference");
										}
										link = '\'' + link + '\'';
										out.print("<tr>");
										out.print("<td onmouseover=\"\" style=\"cursor: pointer;\" onClick=\"imageFun(" + link + ")\"/>");
										if (place.has("name")) {
											out.print(place.getString("name"));
										} else {
											out.print("No info");;
										}

										out.print("</td>");
										//String funCall = "map(East Orange Street,\<\%\=dest\%\>)";
										//out.print("<button type=\"button\" onclick=\"map('east orange street', 'east university drive')\">");
										out.print("<td onmouseover=\"\" style=\"cursor: pointer;\" onClick=\"mapFun(" + src + ", " + newDst
												+ ")\"/>");
										out.print(city);
										//out.println("<button type='button' class='button' onClick='addProgressGoal(" + g.getGoalProgress() +", "+ g.getGoalID() +", "+ g.getTargetValue() + ")'>Add Progress</button>");
										out.print("</td>");
										out.print("<td>");
										out.print(rating);
										out.print("</td>");
										out.print("<td>");
										out.print(weather.get("weatherDesc"));
										out.print("</td>");
										out.print("<td>");
										out.print(weather.get("temperature") + " °F");
										out.print("</td>");
										out.print("</tr>");
									}
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
			<div class="col-sm-4">
				<h3>Graphics</h3>
				<div class="row">
					<iframe id="mapFrame" width="90%" height="35%" frameborder="1"
						style="border: 1; display: none;"
						src="https://www.google.com/maps/embed/v1/directions?key=AIzaSyDKf_wK_7lVCODXoD6cS_tOdMrmTchxxZo&origin=Oslo+Norway&destination=Telemark+Norway&avoid=tolls|highways"
						allowfullscreen> </iframe>
					<input type="button" id="mapButton" class="button"
						value="Show/Hide Map">
				</div>
				<div class="row">
					<img id="imageFrame" width="90%" height="35%" frameborder="1"
						style="border: 1; display: none;"
						src="https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyCjzdF82OByGEz2cxfQeL-hITA2D0w31Hc&photoreference=CmRaAAAAqHoeSokzUAexWeiJ7uoSJtOvUq0gJBYaIqnedfU3jCq6GDmLoK9bPfSoFhvMwJZ4gU3dTgXLktQzOcO34QPqYjR98TF8u2NK8Rlm5yllKegwjkBeP6l-RADjyx-Z6VVVEhDbUvsbdx2QB_peJFsCiRWwGhR6ZPesv8HPCMbDIV4JLI5pszRn5w"
						allowfullscreen> </img> <input type="button" id="imageButton"
						class="button" value="Show/Hide Image">
				</div>
			</div>
		</div>
	</div>
	<script>
		function initMap() {
			var input = document.getElementById('address');
			var autocomplete = new google.maps.places.Autocomplete(input);
		}
	</script>
	<script
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCjzdF82OByGEz2cxfQeL-hITA2D0w31Hc&libraries=places&callback=initMap"
		async defer></script>
</body>
</html>