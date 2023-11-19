export const JS_FORWARD_Hook = {
    mounted() {
        this.handleEvent("js_push", (payload) => {
            console.log("JS_PUSH", payload);
            this.liveSocket.execJS(this.el, JSON.stringify(payload.js))
        })
    },
}
