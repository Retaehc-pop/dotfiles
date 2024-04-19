function Weather() {
  const WWO_CODE = {
    "113": "Sunny",
    "116": "PartlyCloudy",
    "119": "Cloudy",
    "122": "VeryCloudy",
    "143": "Fog",
    "176": "LightShowers",
    "179": "LightSleetShowers",
    "182": "LightSleet",
    "185": "LightSleet",
    "200": "ThunderyShowers",
    "227": "LightSnow",
    "230": "HeavySnow",
    "248": "Fog",
    "260": "Fog",
    "263": "LightShowers",
    "266": "LightRain",
    "281": "LightSleet",
    "284": "LightSleet",
    "293": "LightRain",
    "296": "LightRain",
    "299": "HeavyShowers",
    "302": "HeavyRain",
    "305": "HeavyShowers",
    "308": "HeavyRain",
    "311": "LightSleet",
    "314": "LightSleet",
    "317": "LightSleet",
    "320": "LightSnow",
    "323": "LightSnowShowers",
    "326": "LightSnowShowers",
    "329": "HeavySnow",
    "332": "HeavySnow",
    "335": "HeavySnowShowers",
    "338": "HeavySnow",
    "350": "LightSleet",
    "353": "LightShowers",
    "356": "HeavyShowers",
    "359": "HeavyRain",
    "362": "LightSleetShowers",
    "365": "LightSleetShowers",
    "368": "LightSnowShowers",
    "371": "HeavySnowShowers",
    "374": "LightSleetShowers",
    "377": "LightSleet",
    "386": "ThunderyShowers",
    "389": "ThunderyHeavyRain",
    "392": "ThunderySnowShowers",
    "395": "HeavySnowShowers",
  }

  const WEATHER_SYMBOL = {
    "Unknown": "󰼯",
    "Cloudy": "",
    "Fog": "󰖑",
    "HeavyRain": "",
    "HeavyShowers": "",
    "HeavySnow": "󰼶",
    "HeavySnowShowers": "󰼶",
    "LightRain": "",
    "LightShowers": "",
    "LightSleet": "",
    "LightSleetShowers": "",
    "LightSnow": "",
    "LightSnowShowers": "",
    "PartlyCloudy": "󰖕",
    "Sunny": "",
    "ThunderyHeavyRain": "",
    "ThunderyShowers": "⛈",
    "ThunderySnowShowers": "",
    "VeryCloudy": "",
  }

  const MOON_PHASE = {
    "New Moon": "",
    "Waxing Crescent": "",
    "First Quarter": "",
    "Waxing Gibbous": "",
    "Full Moon": "",
    "Waning Gibbous": "",
    "Third Quater": "",
    "Waning Crescent": "",
  }

  const WIND_SPEED = ["", "", "", "", "", "", "", "", "", "", "", "", "󰢘"]

  const get_weather = (weather) => {
    Promise.resolve(weather)
    code = weather['current_condition'][0]['weatherCode']
    if(WWO_CODE.contain(code)){
        if (WWO_CODE[code] == "Sunny" && !(new Date().hour < 18 && new Date().hour > 6)){
          return "MOON_Placeholder"
        }
      return WEATHER_SYMBOL[WWO_CODE[code]]
    }
    return "󰼯 "
  }
// Utils.fetch("https://wttr.in/Aachen?format=j1").then(
//           res => res.json()
//         ).then(
//           res => {
//             const symbol = WEATHER_SYMBOL[WWO_CODE[res['current_condition'][0]['weatherCode']]]
//             const temp = res['current_condition'][0]['temp_C']
//             return `${symbol} ${temp}°`
//           }
//         )
  const weather = Utils.fetch("https://wttr.in/Aachen?format=j1")
  .then(res => res.json())
  .catch(console.error)

  return Widget.Button({
    child: Widget.Label(
      {
        label:get_weather(weather) 
      }),
    on_clicked: () => (Utils.exec(""))
  })
}

