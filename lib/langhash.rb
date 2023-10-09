# A hash of all the standard ISO 3166-1 Market Codes.
# Includes their human-readable names, mapped to their ISO 3166-1 alpha-2 codes.
SearchEngines::ISO3166 =
  {
    "Argentina (Spanish)" => "es-AR",
    "Australia (English)" => "en-AU",
    "Austria (German)" => "de-AT",
    "Belgium (Dutch)" => "nl-BE",
    "Belgium (French)" => "fr-BE",
    "Brazil (Portuguese)" => "pt-BR",
    "Canada (English)" => "en-CA",
    "Canada (French)" => "fr-CA",
    "Chile (Spanish)" => "es-CL",
    "Denmark (Danish)" => "da-DK",
    "Finland (Finnish)" => "fi-FI",
    "France (French)" => "fr-FR",
    "Germany (German)" => "de-DE",
    "Hong Kong (Traditional Chinese)" => "zh-HK",
    "India (English)" => "en-IN",
    "Indonesia (English)" => "en-ID",
    "Italy (Italian)" => "it-IT",
    "Japan (Japanese)" => "ja-JP",
    "Korea (Korean)" => "ko-KR",
    "Malaysia (English)" => "en-MY",
    "Mexico (Spanish)" => "es-MX",
    "Netherlands (Dutch)" => "nl-NL",
    "New Zealand (English)" => "en-NZ",
    "Norway (Norwegian)" => "no-NO",
    "People's Republic of China (Chinese)" => "zh-CN",
    "Poland (Polish)" => "pl-PL",
    "Portugal (Portuguese)" => "pt-PT",
    "Philippines (English)" => "en-PH",
    "Russia (Russian)" => "ru-RU",
    "Saudi Arabia (Arabic)" => "ar-SA",
    "South Africa (English)" => "en-ZA",
    "Spain (Spanish)" => "es-ES",
    "Sweden (Swedish)" => "sv-SE",
    "Switzerland (French)" => "fr-CH",
    "Switzerland (German)" => "de-CH",
    "Taiwan (Traditional Chinese)" => "zh-TW",
    "Turkey (Turkish)" => "tr-TR",
    "United Kingdom (English)" => "en-GB",
    "United States (English)" => "en-US",
    "United States (Spanish)" => "es-US",
  }
    .freeze

# (see SearchEngines::ISO3166)
# @return [Hash<String, String>] (see SearchEngines::ISO3166)
# @see SearchEngines::ISO3166
def SearchEngines.Languages
  return SearchEngines::ISO3166
end
