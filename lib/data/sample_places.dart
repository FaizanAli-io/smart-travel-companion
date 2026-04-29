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
    weather: WeatherSnapshot(
      temperature: 16,
      conditions: 'Clear Sky',
      windSpeed: 12,
      humidity: 58,
      feelsLike: 15,
    ),
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
    weather: WeatherSnapshot(
      temperature: 18,
      conditions: 'Partly Cloudy',
      windSpeed: 9,
      humidity: 61,
      feelsLike: 18,
    ),
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
    weather: WeatherSnapshot(
      temperature: 11,
      conditions: 'Light Breeze',
      windSpeed: 14,
      humidity: 49,
      feelsLike: 9,
    ),
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
        'https://images.unsplash.com/photo-1531210156829-b8f0b8f0d96f?auto=format&fit=crop&w=1200&q=80',
    weather: WeatherSnapshot(
      temperature: 24,
      conditions: 'Sunny',
      windSpeed: 8,
      humidity: 44,
      feelsLike: 25,
    ),
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
    weather: WeatherSnapshot(
      temperature: 20,
      conditions: 'Warm Breeze',
      windSpeed: 16,
      humidity: 37,
      feelsLike: 19,
    ),
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
        'https://images.unsplash.com/photo-1501959915551-4e8f60d5f4f8?auto=format&fit=crop&w=1200&q=80',
    weather: WeatherSnapshot(
      temperature: 14,
      conditions: 'Cloudy',
      windSpeed: 7,
      humidity: 66,
      feelsLike: 13,
    ),
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
    weather: WeatherSnapshot(
      temperature: 26,
      conditions: 'Bright Sun',
      windSpeed: 11,
      humidity: 39,
      feelsLike: 27,
    ),
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
    weather: WeatherSnapshot(
      temperature: 21,
      conditions: 'Mild',
      windSpeed: 5,
      humidity: 54,
      feelsLike: 22,
    ),
  ),
];
