const battery = await Service.import("battery")

let percentage = Variable(false,{})

const Percentage = () => Widget.Revealer({
  transition:"slide_right",
  click_through:true,
  reveal_child: percentage.bind(),
  child: Widget.Label({
    label: battery.bind("percent").as(p=> `${p}`)
  })
})

const BatteryIcon = () => {
  const icons = ['󰁺','󰁻','󰁼','󰁽','󰁾','󰁿','󰂀','󰂁','󰂂','󰁹']
  if (battery.bind("charged")){
    return "󰂄"
  }
  return Widget.Lebel(battery.bind("percent").as(p=>`${icons[Math.floor(p/10)]}`))
}

const Regular = () => Widget.Box({
  class_name: "",
  children: [
    //BatteryIcon(),
    //Percentage(),
  ]
})



export default () => Widget.Button({
  class_name: "battery-bar",
  on_clicked: () => {percentage.value = !percentage.value},
  child: Widget.Box({
    //visible: batter.bind("available"),
    child: Regular()
  }),
}) 
