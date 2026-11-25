// Open links to other sites in a new tab.
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll('a.external[href^="http"]').forEach(function (link) {
    if (link.host !== window.location.host) {
      link.target = "_blank";
      link.rel = "noopener";
    }
  });
});
