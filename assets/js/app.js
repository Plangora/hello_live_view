// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
const Hooks = {};
Hooks.ConfirmClick = {
  mounted() {
    this.el.addEventListener('click', () => {
      if(confirm('Are you sure?')) {
        this.pushEvent(this.el.getAttribute('phx-confirm-click'), this.el.getAttribute('phx-value'));
      }
    });
  }
};
import "phoenix_html"
import {Socket} from "phoenix";
import {LiveSocket} from "phoenix_live_view";
import NProgress from "nprogress";
const csrfToken = document.querySelector("meta[name='csrf-token'").getAttribute('content');
const liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}});
window.addEventListener('phx:page-loading-start', info => NProgress.start());
window.addEventListener('phx:page-loading-stop', info => NProgress.done());
liveSocket.connect();
window.liveSocket = liveSocket;
import 'jquery';
import 'bootstrap';