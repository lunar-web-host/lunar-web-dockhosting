(function () {
  "use strict";
  var storageKey = "lunarweb.render-url";
  var form = document.getElementById("host-form");
  var input = document.getElementById("render-url");
  var status = document.getElementById("status");
  var launch = document.getElementById("launch");

  function serviceUrl(value) {
    var url;
    try { url = new URL(String(value).trim()); }
    catch (e) { throw new Error("Enter a complete HTTPS address for your Lunar Web service."); }
    if (url.protocol !== "https:" || url.username || url.password || url.search || url.hash || url.pathname !== "/") {
      throw new Error("Use an HTTPS service address without a path, password, query, or fragment.");
    }
    return url.href;
  }
  function error(message) {
    status.textContent = message;
    status.dataset.error = "true";
    form.hidden = false;
    launch.hidden = true;
  }
  function open(value, automatic) {
    var target;
    try { target = serviceUrl(value); }
    catch (e) { error(e.message); return; }
    status.textContent = "Opening " + new URL(target).hostname + "...";
    status.dataset.error = "false";
    launch.href = target;
    launch.hidden = false;
    form.hidden = true;
    if (!automatic) {
      try { window.localStorage.setItem(storageKey, target); } catch (e) {}
    }
    // Navigate the whole page so gameplay, the menu iframe, and authentication
    // share the Render origin. Never accept a backend address from URL params.
    window.location.replace(target);
  }
  form.addEventListener("submit", function (event) {
    event.preventDefault();
    open(input.value, false);
  });
  var configured = window.LunarPagesConfig && window.LunarPagesConfig.renderUrl;
  if (configured) {
    open(configured, true);
  } else {
    try { input.value = window.localStorage.getItem(storageKey) || ""; } catch (e) {}
    status.textContent = "Connect to your hosted Lunar Web client.";
    form.hidden = false;
  }
})();
