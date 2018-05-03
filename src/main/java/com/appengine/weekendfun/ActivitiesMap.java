package com.appengine.weekendfun;

import java.util.HashMap;
import java.util.Map;

import org.springframework.cache.annotation.Cacheable;

public class ActivitiesMap {

	private static Map<String, Map<String, String[]>> activitiesMap = new HashMap<String, Map<String, String[]>>();

	@Cacheable("cachedMap")
	public static Map<String, Map<String, String[]>> initializeMap() {

		String[] seniorsType1 = { "golf","swimming","badminton"};
		String[] seniorsType2 = { "karaoke","theatre and plays","movies" };
		String[] seniorsType3 = { "casino","trivia night", "parties for seniors" };
		String[] seniorsType4 = { "bingo game", "poker game", "arts and craft centers" };
		String[] seniorsType5 = { "animal interaction", "boating", "picnic"};
		String[] seniorsType6 = { "carnivals", "museums for seniors","wineries" };
		Map<String, String[]> seniorsMap = new HashMap<String, String[]>();
		seniorsMap.put("type1", seniorsType1);
		seniorsMap.put("type2", seniorsType2);
		seniorsMap.put("type3", seniorsType3);
		seniorsMap.put("type4", seniorsType4);
		seniorsMap.put("type5", seniorsType5);
		seniorsMap.put("type6", seniorsType6);
		activitiesMap.put("seniors", seniorsMap);

		String[] adultsType1 = { "beach volleyball", "bowling", "swimming" };
		String[] adultsType2 = { "karaoke", "theatre and plays", "fun activities for families" };
		String[] adultsType3 = { "sports grills", "movies", "casino" };
		String[] adultsType4 = { "nature photography","kayaking","horse racing" };
		String[] adultsType5 = { "arcades for adults","concerts", "theme parks" };
		Map<String, String[]> adultsMap = new HashMap<String, String[]>();
		adultsMap.put("type1", adultsType1);
		adultsMap.put("type2", adultsType2);
		adultsMap.put("type3", adultsType3);
		adultsMap.put("type4", adultsType4);
		adultsMap.put("type5", adultsType5);
		activitiesMap.put("adults", adultsMap);

		String[] youthType1 = { "fun activities for young people", "fun activities for youth" };
		String[] youthType2 = { "paint-ball", "ice skating", "bowling"};
		String[] youthType3 = { "escape room", "sports grills", "movies"};
		String[] youthType4 = { "scuba diving", "sky diving", "bungee jumping"};
		String[] youthType5 = { "hiking","biking", "rafting" };
		String[] youthType6 = { "arcades for youth", "concerts", "theme parks" };
		Map<String, String[]> youthMap = new HashMap<String, String[]>();
		youthMap.put("type1", youthType1);
		youthMap.put("type2", youthType2);
		youthMap.put("type3", youthType3);
		youthMap.put("type4", youthType4);
		youthMap.put("type5", youthType5);
		youthMap.put("type6", youthType6);
		activitiesMap.put("youth", youthMap);

		String[] teensType1 = { "fun activities for teenagers", "fun activities for college students" };
		String[] teensType2 = { "paint-ball", "ice skating", "bowling"};
		String[] teensType3 = { "salsa dancing", "swing dancing", "movies" };
		String[] teensType4 = { "escape room", "scuba diving", "sky diving" };
		String[] teensType5 = { "hiking","rafting","go karting" };
		String[] teensType6 = { "arcades for teenagers", "concerts", "theme parks" };
		Map<String, String[]> teensMap = new HashMap<String, String[]>();
		teensMap.put("type1", teensType1);
		teensMap.put("type2", teensType2);
		teensMap.put("type3", teensType3);
		teensMap.put("type4", teensType4);
		teensMap.put("type5", teensType5);
		teensMap.put("type6", teensType6);
		activitiesMap.put("teens", teensMap);

		String[] kidsType1 = { "fun activities for kids" };
		Map<String, String[]> kidsMap = new HashMap<String, String[]>();
		kidsMap.put("type1", kidsType1);
		activitiesMap.put("kids", kidsMap);

		return activitiesMap;
	}

	@Cacheable("cachedStates")
	public String[] getStates() {
		String[] states = { "Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado",
				"Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa",
				"Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine",
				"Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", " North Dakota",
				"Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma",
				"Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
				"Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia",
				"Wyoming" };
		
		return states;

	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
