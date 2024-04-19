#!/usr/bin/env python

import json
import requests
from datetime import datetime

WWO_CODE = {
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

WEATHER_SYMBOL = {
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

MOON_PHASE = {
    "New Moon": "",
    "Waxing Crescent": "",
    "First Quarter": "",
    "Waxing Gibbous": "",
    "Full Moon": "",
    "Waning Gibbous": "",
    "Third Quater": "",
    "Waning Crescent": "",
}

MOON_PHASE_FULL = (
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
)

WIND_SPEED = ("", "", "", "", "", "", "", "", "", "", "", "", "󰢘")


def get_moon(weather) -> str:
    # moon_phases = []
    # for i in weather["weather"]:
    #     moon_phases.append(i["astronomy"][0]["moon_phase"])
    moon_phase = MOON_PHASE[weather["weather"][0]["astronomy"][0]["moon_phase"]]
    return f"{moon_phase} {weather['weather'][0]['astronomy'][0]['moon_phase']}"


def get_wind(weather) -> str:
    wind = int(weather["current_condition"][0]["windspeedKmph"])
    wind_speed = [1, 5, 11, 19, 28, 38, 49, 61, 74, 88, 102, 117]
    wind_res = ""
    for i, w in enumerate(wind_speed):
        if wind < w:
            wind_res = WIND_SPEED[i]
    if wind_res == "":
        wind_res = WIND_SPEED[-1]
    return f"{wind_res} {wind}Kph"


def get_precipitation(weather) -> str:
    precipitation = []
    for h in weather["weather"][0]["hourly"]:
        precipitation.append(int(h["chanceofrain"]))
    avg = sum(precipitation[:3]) // len(precipitation[:3])
    return f"{avg} %"


def get_weather(weather) -> str:
    code = weather["current_condition"][0]["weatherCode"]
    if code in WWO_CODE:
        if WWO_CODE[code] == "Sunny" and not (6 < datetime.now().hour < 18):
            return "󰽥"
        return WEATHER_SYMBOL[WWO_CODE[code]]
    return "󰼯 "


def format_tooltip(weather: dict) -> str:
    string = ""
    string += f"<b>{get_weather(weather)} {weather['current_condition'][0]['temp_C']}°C</b> {weather['nearest_area'][0]['areaName'][0]['value']}\n"
    string += f"Moon {get_moon(weather)}\n"
    string += f"Wind {get_wind(weather)}\n"
    string += f"Rain {get_precipitation(weather)}"
    return string


try:
    weather = requests.get("https://wttr.in/Aachen?format=j1").json()
    data = {}
    data["text"] = (
        f"{get_weather(weather)} {weather['current_condition'][0]['temp_C']}°C"
    )
    data["tooltip"] = format_tooltip(weather)

    print(json.dumps(data))
except Exception:
    print(json.dumps({"text": "󰼯 ", "tooltip": "<b>Something went wrong</b>"}))
