// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import socket from "./user_socket"
import Reactions from "./reactions"

import WordCloud from "../vendor/wordcloud"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

if (document.getElementById('emoji-trigger')) {
    Reactions.init(socket)
}


if (document.getElementById('file-form')) {
    let url = "https://sweetipfs.herokuapp.com/"
    document.getElementById('file-form').onsubmit = function(event) {
        event.preventDefault()
        let formData = new FormData()
        formData.append("upload", document.getElementById("upload").files[0])

        let xhr = new XMLHttpRequest()
        xhr.open("POST", url + "create", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                let ipfscid = xhr.responseText
                console.log("The file was upload to ipfscid " + ipfscid)
                if (document.getElementById('item_ipfscids')) {
                    document.getElementById('item_ipfscids').value = ipfscid
                }
                if (document.getElementById('user_profile_pic_cid')) {
                    document.getElementById('user_profile_pic_cid').value = ipfscid
                }
                if (document.getElementById('css_sheet_ipfscid')) {
                    document.getElementById('css_sheet_ipfscid').value = ipfscid
                }
                var image = document.createElement("img");
                image.setAttribute("src", url + "/read?ipfscid=" + ipfscid);
                document.getElementById('imageholder').appendChild(image)
            }
        }
        xhr.send(formData)
    }
}

let translate_button = document.getElementById("translate")
if (translate_button) {
    translate_button.addEventListener("click", function() {
        // this element's id from in translation.html.heex
        let targetLang = document.getElementById('target_lang').value
        let text = fetchItemText()
        let xhr = new XMLHttpRequest()
        xhr.open("POST", "https://translate.all4u.city/translate", true)
        xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                    let translation = JSON.parse(xhr.responseText)
                    console.log("The translation " + JSON.stringify(translation))
                    if (document.getElementById('translation')) {
                        let translated = document.getElementById('translation')
                        translated.innerHTML = '<pre>' + translation["translatedText"] + '</pre>'
                    }
                }
            }
            // xhr.onload = requestComplete;
        xhr.setRequestHeader("Content-Type", "application/json")
        let res = xhr.send(JSON.stringify({
            q: text,
            source: "auto",
            target: targetLang,
            format: "text",
            api_key: ""
        }))

    })
}

let wordcloudCanvas = document.getElementById('canvas')
if (wordcloudCanvas) {
    var domain = window.location.hostname;
    if(window.location.port)
        domain = domain + ':' + window.location.port;
        // for local testing
    fetch(`https://${domain}/tag/popular_tags`)
    .then(response => response.json())
    .then(data => {
        var list = data.list.map(tag => [tag.label, tag.count < 5 ? tag.count + 5 : tag.count, `http://${domain}/search/tag/${tag.slug}`]);
        console.log(list)
        WordCloud(wordcloudCanvas, { list: list, 
            backgroundColor: '#303030',
            click: (item) => { clickitem(item); }
        } );
    })
    .catch(error => console.error('Error:', error))
    
}

function clickitem(item){
    console.log(item)
    window.open(item[2], '_self');
}
