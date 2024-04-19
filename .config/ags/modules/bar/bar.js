import Battery from "./widgets/battery.js";
import Power from "./widgets/power.js";
import Clock from "./widgets/clock.js";
import SysTray from './widgets/systray.js';
//import Workspaces from './widgets/workspaces.js';


let start = ["power"]//["power"]
let center = ["clock"]
let end = ["battery","systray"]


const widget = {
  battery: Battery,
  power: Power,
  systray: SysTray,
  //sysinfo: SysInfo,
  //media: Media,
  //network: Network,
  clock: Clock,
  //workspaces: Workspaces,
  //weather: Weather,
}

export default (monitor=1) => Widget.Window({
  monitor,
  name:`bar-${monitor}`,
  className: "bar",
  layer: "top",
  anchor: ["top","left","right"],
  child: Widget.CenterBox({
    start_widget: Widget.Box({
      hexpand: true,
      children: start.map(w => widget[w]())
    }),
    center_widget: Widget.Box({
      hpack: "center",
      children: center.map(w => widget[w]())
    }),
    end_widget: Widget.Box({
      hexpand: true,
      hpack: "end",
      children: end.map(w => widget[w]())
    }),
  })
})
