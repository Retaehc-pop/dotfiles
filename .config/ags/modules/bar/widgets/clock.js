const date = Variable("",{poll:[1000,`date "+%b %e %H:%M:%S"`]})

export default () => Widget.Label({
    class_name:"clock",
    label:date.bind()
})
