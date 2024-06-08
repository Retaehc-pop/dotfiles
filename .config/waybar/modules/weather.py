#!/usr/bin/env python

import json
import requests
import argparse
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
    "Sunny": "",
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


class Weather:
    def __init__(self, city: str = ""):
        self.city = city
        self.raw_data = self.request_value()

    def request_value(self):
        value = requests.get(f"https://wttr.in/{self.city}?format=j1").json()
        return value

    def get(self, mode):
        match mode:
            case "weather_time":
                return self.get_weather_time(self.raw_data)
            case "weather":
                return self.get_weather(self.raw_data)
            case "temp" | "temperature":
                return self.get_temperature(self.raw_data)
            case "rain" | "precipitation":
                return self.get_precipitation(self.raw_data)
            case "moon" | "moon_phase":
                return self.get_moon_phase(self.raw_data)
            case "wind":
                return self.get_wind(self.raw_data)
            case "location" | "city":
                return self.city
            case "sun" | "sunrise":
                return self.get_sun(self.raw_data)
            case _:
                return "󰼯  invalid mode"

    def get_moon_phase(self, raw_data):
        return MOON_PHASE[raw_data["weather"][0]["astronomy"][0]["moon_phase"]]

    def get_temperature(self, raw_data):
        return f"{raw_data['current_condition'][0]['temp_C']}°C"

    def get_weather_time(self, raw_data):
        weather = self.get_weather(raw_data)
        time = self.get_sun(raw_data)
        match time:
            case "day":
                return weather
            case "night":
                if weather == "":
                    weather = ""
                return weather

    def get_wind(self, raw_data) -> str:
        wind = int(raw_data["current_condition"][0]["windspeedKmph"])
        wind_speed = [1, 5, 11, 19, 28, 38, 49, 61, 74, 88, 102, 117]
        wind_res = ""
        for i, w in enumerate(wind_speed):
            if wind < w:
                wind_res = WIND_SPEED[i]
        if wind_res == "":
            wind_res = WIND_SPEED[-1]
        return f"{wind_res} {wind}Kph"

    def get_weather(self, raw_data):
        if raw_data["current_condition"][0]["weatherCode"] in WWO_CODE:
            return WEATHER_SYMBOL[
                WWO_CODE[raw_data["current_condition"][0]["weatherCode"]]
            ]
        else:
            return "󰼯 "

    def get_precipitation(self, raw_data) -> str:
        precipitation = []
        for h in raw_data["weather"][0]["hourly"]:
            precipitation.append(int(h["chanceofrain"]))
        avg = sum(precipitation[:3]) // len(precipitation[:3])
        return f"{avg}%"

    def get_sun(self, raw_data) -> str:
        sunrise = raw_data["weather"][0]["astronomy"][0]["sunrise"]
        sunrise = datetime.strptime(sunrise, "%I:%M %p")
        sunset = raw_data["weather"][0]["astronomy"][0]["sunset"]
        sunset = datetime.strptime(sunset, "%I:%M %p")

        if sunrise <= datetime.now() <= sunset:
            return "day"
        else:
            return "night"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="Weather")
    parser.add_argument("-c", "--city")
    parser.add_argument("-m", "--mode", nargs="+")
    args = parser.parse_args()
    try:
        weather = Weather(args.city)
        res = []
        for mode in args.mode:
            res.append(weather.get(mode))
        print(json.dumps({"text": " ".join(res)}))
    except Exception as e:
        print(json.dumps({"text": "󰼯 "}))
