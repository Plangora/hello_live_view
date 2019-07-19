// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import LiveSocket from "phoenix_live_view";
const liveSocket = new LiveSocket("/live");
liveSocket.connect();

const EVENT_ATTR = 'phx-confirm-click';
document.addEventListener('phx:update', () => {
  document.querySelectorAll(`[${EVENT_ATTR}]`).forEach(el => {
    el.addEventListener('click', () => {
      if(confirm('Are you sure?')) {
        const target = document.querySelector('[data-phx-view]');
        liveSocket.owner(target, view => view.pushWithReply("event", {
          event: el.getAttribute(EVENT_ATTR),
          type: "click",
          value: el.getAttribute('phx-value')
        }));
      }
    });
  });
});