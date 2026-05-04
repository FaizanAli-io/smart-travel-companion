import '../models/place.dart';

const List<TravelPlace> samplePlaces = [
  TravelPlace(
    id: 1,
    name: 'Lake Tekapo',
    region: 'Canterbury',
    country: 'New Zealand',
    category: 'Nature',
    description:
        'Lake Tekapo is famous for turquoise water, alpine views, and the iconic Church of the Good Shepherd framed by dramatic Southern Alps scenery.',
    imageUrl:
        'https://images.unsplash.com/photo-1507692049790-de58290a4334?auto=format&fit=crop&w=1200&q=80',
    latitude: -44.0047,
    longitude: 170.4822,
    isFeatured: true,
  ),
  TravelPlace(
    id: 2,
    name: 'Lake Bled',
    region: 'Upper Carniola',
    country: 'Slovenia',
    category: 'Lakes',
    description:
        'A postcard-perfect alpine lake with a tiny island church, a cliffside castle, and calm water that reflects the surrounding mountains.',
    imageUrl:
        'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
    latitude: 46.3625,
    longitude: 14.0958,
  ),
  TravelPlace(
    id: 3,
    name: 'Banff National Park',
    region: 'Alberta',
    country: 'Canada',
    category: 'Mountains',
    description:
        'Glacial lakes, pine forests, and rugged peaks define this iconic national park in the Canadian Rockies.',
    imageUrl:
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
    latitude: 51.4968,
    longitude: -115.9281,
  ),
  TravelPlace(
    id: 4,
    name: 'Amalfi Coast',
    region: 'Campania',
    country: 'Italy',
    category: 'Coastal',
    description:
        'Colorful cliffside villages, citrus terraces, and shimmering Mediterranean water make the Amalfi Coast a timeless getaway.',
    imageUrl:
        'https://images.unsplash.com/photo-1533282960533-51328aa49826?auto=format&fit=crop&w=1200&q=80',
    latitude: 40.6340,
    longitude: 14.6027,
    isFeatured: true,
  ),
  TravelPlace(
    id: 5,
    name: 'Cappadocia',
    region: 'Central Anatolia',
    country: 'Turkey',
    category: 'Adventure',
    description:
        'Ancient cave dwellings and hot air balloons create one of the most distinctive landscapes in the world.',
    imageUrl:
        'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?auto=format&fit=crop&w=1200&q=80',
    latitude: 38.6431,
    longitude: 34.8300,
  ),
  TravelPlace(
    id: 6,
    name: 'Hallstatt',
    region: 'Salzkammergut',
    country: 'Austria',
    category: 'Village',
    description:
        'A serene lakeside village with historic timber houses, steep mountain slopes, and mirror-like reflections at sunrise.',
    imageUrl:
        'https://images.unsplash.com/photo-1527668752968-14dc70a27c95?q=80&w=1200&auto=format&fit=crop',
    latitude: 47.5622,
    longitude: 13.6492,
  ),
  TravelPlace(
    id: 7,
    name: 'Santorini',
    region: 'South Aegean',
    country: 'Greece',
    category: 'Island',
    description:
        'Whitewashed architecture, blue domes, and volcanic cliffs combine into a striking island view over the Aegean Sea.',
    imageUrl:
        'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?auto=format&fit=crop&w=1200&q=80',
    latitude: 36.3932,
    longitude: 25.4615,
    isFeatured: true,
  ),
  TravelPlace(
    id: 8,
    name: 'Kyoto Bamboo Grove',
    region: 'Kansai',
    country: 'Japan',
    category: 'Culture',
    description:
        'A quiet pathway through towering bamboo that softens sound and creates a calm, immersive atmosphere.',
    imageUrl:
        'https://images.unsplash.com/photo-1491884662610-dfcd28f30cfb?auto=format&fit=crop&w=1200&q=80',
    latitude: 35.0094,
    longitude: 135.6675,
  ),
  TravelPlace(
    id: 9,
    name: 'Petra',
    region: 'Ma\'an',
    country: 'Jordan',
    category: 'Heritage',
    description:
        'Carved sandstone facades, narrow siq canyons, and ancient Nabataean engineering define this desert city.',
    imageUrl:
        'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80',
    latitude: 30.3285,
    longitude: 35.4444,
  ),
  TravelPlace(
    id: 10,
    name: 'Plitvice Lakes',
    region: 'Lika-Senj',
    country: 'Croatia',
    category: 'Waterfalls',
    description:
        'A connected network of lakes and waterfalls that shift between bright turquoise and deep green throughout the seasons.',
    imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
    latitude: 44.8800,
    longitude: 15.6167,
    isFeatured: true,
  ),
  TravelPlace(
    id: 11,
    name: 'Machu Picchu',
    region: 'Cusco Region',
    country: 'Peru',
    category: 'Archaeology',
    description:
        'A mountaintop citadel with terraces, stonework, and dramatic cloud forest views over the Andes.',
    imageUrl:
        'https://images.unsplash.com/photo-1526392060635-9d6019884377?auto=format&fit=crop&w=1200&q=80',
    latitude: -13.1631,
    longitude: -72.5450,
  ),
  TravelPlace(
    id: 12,
    name: 'Reykjavik Harbor',
    region: 'Capital Region',
    country: 'Iceland',
    category: 'Cityscape',
    description:
        'Colorful waterfront architecture, clean air, and quick access to volcanic landscapes make this harbor city memorable.',
    imageUrl:
        'https://images.unsplash.com/photo-1504893524553-b855bce32c67?auto=format&fit=crop&w=1200&q=80',
    latitude: 64.1466,
    longitude: -21.9426,
  ),
  TravelPlace(
    id: 13,
    name: 'Serengeti Plains',
    region: 'Mara',
    country: 'Tanzania',
    category: 'Safari',
    description:
        'Wide grasslands, migrating herds, and expansive skies create one of Africa\'s most iconic wildlife regions.',
    imageUrl:
        'https://images.unsplash.com/photo-1505968409348-bd000797c92e?auto=format&fit=crop&w=1200&q=80',
    latitude: -2.3333,
    longitude: 34.8333,
  ),
  TravelPlace(
    id: 14,
    name: 'Cinque Terre',
    region: 'Liguria',
    country: 'Italy',
    category: 'Coastal',
    description:
        'Pastel villages cling to cliffs above the Ligurian Sea, linked by trails, trains, and sea views.',
    imageUrl:
        'https://images.unsplash.com/photo-1493558103817-58b2924bce98?auto=format&fit=crop&w=1200&q=80',
    latitude: 44.1270,
    longitude: 9.7090,
  ),
  TravelPlace(
    id: 15,
    name: 'Banff Townsite',
    region: 'Alberta',
    country: 'Canada',
    category: 'Mountain Town',
    description:
        'A mountain town base with alpine streets, trail access, and easy views of the Rockies.',
    imageUrl:
        'https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?auto=format&fit=crop&w=1200&q=80',
    latitude: 51.1784,
    longitude: -115.5708,
    isFeatured: true,
  ),
  TravelPlace(
    id: 16,
    name: 'Yosemite Valley',
    region: 'California',
    country: 'United States',
    category: 'National Park',
    description:
        'Granite cliffs, giant sequoias, and broad valley views make this one of the most recognizable parks in the world.',
    imageUrl:
        'https://images.unsplash.com/photo-1509316785289-025f5b846b35?auto=format&fit=crop&w=1200&q=80',
    latitude: 37.7459,
    longitude: -119.5332,
  ),
  TravelPlace(
    id: 17,
    name: 'Bali Rice Terraces',
    region: 'Ubud',
    country: 'Indonesia',
    category: 'Landscape',
    description:
        'Layered emerald terraces and temple-lined waterways create a calm agricultural landscape.',
    imageUrl:
        'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=80',
    latitude: -8.5069,
    longitude: 115.2625,
  ),
  TravelPlace(
    id: 18,
    name: 'Torres del Paine',
    region: 'Magallanes',
    country: 'Chile',
    category: 'Glacier',
    description:
        'Jagged peaks, glacial lakes, and strong Patagonian weather define this remote national park.',
    imageUrl:
        'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80',
    latitude: -51.2538,
    longitude: -72.9854,
  ),
  TravelPlace(
    id: 19,
    name: 'Bora Bora Lagoon',
    region: 'Leeward Islands',
    country: 'French Polynesia',
    category: 'Island',
    description:
        'Lagoon waters, overwater bungalows, and a volcanic skyline create a classic tropical escape.',
    imageUrl:
        'https://images.unsplash.com/photo-1532408840957-031d8034aeef?auto=format&fit=crop&w=1200&q=80',
    latitude: -16.5004,
    longitude: -151.7415,
    isFeatured: true,
  ),
  TravelPlace(
    id: 20,
    name: 'Scottish Highlands',
    region: 'Highland',
    country: 'United Kingdom',
    category: 'Countryside',
    description:
        'Moody hills, lochs, and wide-open moorland create a dramatic, weather-shaped landscape.',
    imageUrl:
        'https://images.unsplash.com/photo-1518895949257-7621c3c786d7?auto=format&fit=crop&w=1200&q=80',
    latitude: 57.1497,
    longitude: -4.6086,
  ),
  TravelPlace(
    id: 21,
    name: 'Rovaniemi',
    region: 'Lapland',
    country: 'Finland',
    category: 'Arctic',
    description:
        'A northern city known for winter light, reindeer country, and easy access to Arctic experiences.',
    imageUrl:
        'https://images.unsplash.com/photo-1517935706615-2717063c2225?auto=format&fit=crop&w=1200&q=80',
    latitude: 66.5039,
    longitude: 25.7294,
  ),
  TravelPlace(
    id: 22,
    name: 'Marrakech Medina',
    region: 'Marrakesh-Safi',
    country: 'Morocco',
    category: 'Market',
    description:
        'Narrow alleys, tiled courtyards, and busy souks form one of North Africa\'s most vibrant urban cores.',
    imageUrl:
        'https://images.unsplash.com/photo-1539020140153-e479b8c22e70?auto=format&fit=crop&w=1200&q=80',
    latitude: 31.6295,
    longitude: -7.9811,
  ),
  TravelPlace(
    id: 23,
    name: 'Zermatt',
    region: 'Valais',
    country: 'Switzerland',
    category: 'Mountain Village',
    description:
        'A car-free alpine village with wooden chalets, ski access, and constant Matterhorn views.',
    imageUrl:
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
    latitude: 46.0207,
    longitude: 7.7491,
  ),
  TravelPlace(
    id: 24,
    name: 'Geirangerfjord',
    region: 'More og Romsdal',
    country: 'Norway',
    category: 'Fjord',
    description:
        'Sheer cliffs, cascading waterfalls, and calm blue water make this fjord a classic scenic route.',
    imageUrl:
        'https://images.unsplash.com/photo-1500048993953-d23a436266cf?auto=format&fit=crop&w=1200&q=80',
    latitude: 62.1015,
    longitude: 7.2064,
  ),
  TravelPlace(
    id: 25,
    name: 'Salar de Uyuni',
    region: 'Potosi',
    country: 'Bolivia',
    category: 'Salt Flats',
    description:
        'A vast mirror-like salt flat that transforms into a surreal reflection scene after rainfall.',
    imageUrl:
        'https://images.unsplash.com/photo-1514890547357-a9ee288728e0?auto=format&fit=crop&w=1200&q=80',
    latitude: -20.1338,
    longitude: -67.4891,
  ),
  TravelPlace(
    id: 26,
    name: 'Great Barrier Reef',
    region: 'Queensland',
    country: 'Australia',
    category: 'Marine',
    description:
        'Coral gardens, clear water, and marine life make this the world\'s largest reef system.',
    imageUrl:
        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
    latitude: -18.2871,
    longitude: 147.6992,
    isFeatured: true,
  ),
  TravelPlace(
    id: 27,
    name: 'Kyoto Gion District',
    region: 'Kansai',
    country: 'Japan',
    category: 'Culture',
    description:
        'Historic lanes, tea houses, and preserved streets capture a quieter side of the city.',
    imageUrl:
        'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?auto=format&fit=crop&w=1200&q=80',
    latitude: 35.0037,
    longitude: 135.7788,
  ),
  TravelPlace(
    id: 29,
    name: 'Ha Long Bay',
    region: 'Quang Ninh',
    country: 'Vietnam',
    category: 'Bay',
    description:
        'Limestone islands rise from calm emerald water, making this bay a classic cruise destination.',
    imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
    latitude: 20.9101,
    longitude: 107.1839,
  ),
  TravelPlace(
    id: 30,
    name: 'Atacama Desert',
    region: 'Antofagasta',
    country: 'Chile',
    category: 'Desert',
    description:
        'Dry valleys, salt basins, and some of the clearest skies in the world define this high desert.',
    imageUrl:
        'https://images.unsplash.com/photo-1509316785289-025f5b846b35?auto=format&fit=crop&w=1200&q=80',
    latitude: -22.9075,
    longitude: -68.1988,
  ),
  TravelPlace(
    id: 32,
    name: 'Patagonia Coast',
    region: 'Santa Cruz',
    country: 'Argentina',
    category: 'Wilderness',
    description:
        'Wind-carved coastlines and open horizons bring a stark, cinematic feel to southern Argentina.',
    imageUrl:
        'https://images.unsplash.com/photo-1519608487953-e999c86e7455?auto=format&fit=crop&w=1200&q=80',
    latitude: -47.7500,
    longitude: -65.7500,
  ),
  TravelPlace(
    id: 34,
    name: 'Angkor Wat',
    region: 'Siem Reap',
    country: 'Cambodia',
    category: 'Temple',
    description:
        'Towering stone spires, carved bas-reliefs, and sunrise reflections make this temple complex iconic.',
    imageUrl:
        'https://images.unsplash.com/photo-1555400038-63f5ba517a47?auto=format&fit=crop&w=1200&q=80',
    latitude: 13.4125,
    longitude: 103.8667,
    isFeatured: true,
  ),
  TravelPlace(
    id: 35,
    name: 'Milos Beaches',
    region: 'South Aegean',
    country: 'Greece',
    category: 'Beach',
    description:
        'Volcanic rock, bright water, and unusual shore formations give the island a dramatic coastline.',
    imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
    latitude: 36.6940,
    longitude: 24.4240,
  ),
  TravelPlace(
    id: 36,
    name: 'Wadi Rum',
    region: 'Aqaba',
    country: 'Jordan',
    category: 'Desert',
    description:
        'Red sand, sandstone arches, and open desert vistas make this a favorite for overland adventures.',
    imageUrl:
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
    latitude: 29.5850,
    longitude: 35.4250,
  ),
  TravelPlace(
    id: 37,
    name: 'Valparaiso Hills',
    region: 'Valparaiso',
    country: 'Chile',
    category: 'Harbor City',
    description:
        'Steep streets, cable cars, and bright hillside homes overlook the Pacific in a layered urban landscape.',
    imageUrl:
        'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1200&q=80',
    latitude: -33.0472,
    longitude: -71.6127,
  ),
  TravelPlace(
    id: 39,
    name: 'Maldives Atoll',
    region: 'Kaafu',
    country: 'Maldives',
    category: 'Island',
    description:
        'Low coral islands, shallow turquoise water, and bright sandbars create a classic tropical scene.',
    imageUrl:
        'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?auto=format&fit=crop&w=1200&q=80',
    latitude: 4.1755,
    longitude: 73.5093,
  ),
  TravelPlace(
    id: 40,
    name: 'Kotor Bay',
    region: 'Kotor',
    country: 'Montenegro',
    category: 'Bay',
    description:
        'A sheltered bay surrounded by mountains, stone walls, and winding roads with strong Adriatic views.',
    imageUrl:
        'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
    latitude: 42.4247,
    longitude: 18.7712,
  ),
];
