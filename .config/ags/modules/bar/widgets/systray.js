
const systemtray = await Service.import("systemtray")
const ignore = []
const SysTrayItem = (item) => Widget.Button({
  class_name: "tray-item",
  child: Widget.Icon({ icon: item.bind("icon") }),
  tooltip_markup: item.bind("tooltip_markup"),
  on_primary_click: (_,event) => item.activate(event),
  on_secondary_click: (_,event) => item.openMenu(event),
})

export default () =>Widget.Box()
  .bind("children", systemtray, "items", i => i
    .filter(({ id }) => !ignore.includes(id))
    .map(SysTrayItem))
