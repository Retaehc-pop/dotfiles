export default () => Widget.Button({
  class_name:"power",
  child: Widget.Label(""),
  on_clicked: () => Utils.exec("wlogout")
})
