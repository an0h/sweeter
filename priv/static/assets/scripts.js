(() => {
  // js/scripts.js
  window.addEventListener("DOMContentLoaded", (event) => {
    feather.replace();
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function(popoverTriggerEl) {
      return new bootstrap.Popover(popoverTriggerEl);
    });
    const sidebarToggle = document.body.querySelector("#sidebarToggle");
    if (sidebarToggle) {
      sidebarToggle.addEventListener("click", (event2) => {
        event2.preventDefault();
        document.body.classList.toggle("sidenav-toggled");
        localStorage.setItem("sb|sidebar-toggle", document.body.classList.contains("sidenav-toggled"));
      });
    }
    const sidenavContent = document.body.querySelector("#layoutSidenav_content");
    if (sidenavContent) {
      sidenavContent.addEventListener("click", (event2) => {
        const BOOTSTRAP_LG_WIDTH = 992;
        if (window.innerWidth >= 992) {
          return;
        }
        if (document.body.classList.contains("sidenav-toggled")) {
          document.body.classList.toggle("sidenav-toggled");
        }
      });
    }
    let activatedPath = window.location.pathname.match(/([\w-]+\.html)/, "$1");
    if (activatedPath) {
      activatedPath = activatedPath[0];
    } else {
      activatedPath = "/";
    }
    const targetAnchors = document.body.querySelectorAll('[href="' + activatedPath + '"].nav-link');
    targetAnchors.forEach((targetAnchor) => {
      let parentNode = targetAnchor.parentNode;
      while (parentNode !== null && parentNode !== document.documentElement) {
        if (parentNode.classList.contains("collapse")) {
          parentNode.classList.add("show");
          const parentNavLink = document.body.querySelector(
            '[data-bs-target="#' + parentNode.id + '"]'
          );
          parentNavLink.classList.remove("collapsed");
          parentNavLink.classList.add("active");
        }
        parentNode = parentNode.parentNode;
      }
      targetAnchor.classList.add("active");
    });
  });
})();
/*!
    * Start Bootstrap - SB Admin Pro v2.0.5 (https://shop.startbootstrap.com/product/sb-admin-pro)
    * Copyright 2013-2023 Start Bootstrap
    * Licensed under SEE_LICENSE (https://github.com/StartBootstrap/sb-admin-pro/blob/master/LICENSE)
    */
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsiLi4vLi4vLi4vYXNzZXRzL2pzL3NjcmlwdHMuanMiXSwKICAic291cmNlc0NvbnRlbnQiOiBbIi8qIVxuICAgICogU3RhcnQgQm9vdHN0cmFwIC0gU0IgQWRtaW4gUHJvIHYyLjAuNSAoaHR0cHM6Ly9zaG9wLnN0YXJ0Ym9vdHN0cmFwLmNvbS9wcm9kdWN0L3NiLWFkbWluLXBybylcbiAgICAqIENvcHlyaWdodCAyMDEzLTIwMjMgU3RhcnQgQm9vdHN0cmFwXG4gICAgKiBMaWNlbnNlZCB1bmRlciBTRUVfTElDRU5TRSAoaHR0cHM6Ly9naXRodWIuY29tL1N0YXJ0Qm9vdHN0cmFwL3NiLWFkbWluLXByby9ibG9iL21hc3Rlci9MSUNFTlNFKVxuICAgICovXG4gICAgd2luZG93LmFkZEV2ZW50TGlzdGVuZXIoJ0RPTUNvbnRlbnRMb2FkZWQnLCBldmVudCA9PiB7XG4gICAgLy8gQWN0aXZhdGUgZmVhdGhlclxuICAgIGZlYXRoZXIucmVwbGFjZSgpO1xuXG4gICAgLy8gRW5hYmxlIHRvb2x0aXBzIGdsb2JhbGx5XG4gICAgdmFyIHRvb2x0aXBUcmlnZ2VyTGlzdCA9IFtdLnNsaWNlLmNhbGwoZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbCgnW2RhdGEtYnMtdG9nZ2xlPVwidG9vbHRpcFwiXScpKTtcbiAgICB2YXIgdG9vbHRpcExpc3QgPSB0b29sdGlwVHJpZ2dlckxpc3QubWFwKGZ1bmN0aW9uICh0b29sdGlwVHJpZ2dlckVsKSB7XG4gICAgICAgIHJldHVybiBuZXcgYm9vdHN0cmFwLlRvb2x0aXAodG9vbHRpcFRyaWdnZXJFbCk7XG4gICAgfSk7XG5cbiAgICAvLyBFbmFibGUgcG9wb3ZlcnMgZ2xvYmFsbHlcbiAgICB2YXIgcG9wb3ZlclRyaWdnZXJMaXN0ID0gW10uc2xpY2UuY2FsbChkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKCdbZGF0YS1icy10b2dnbGU9XCJwb3BvdmVyXCJdJykpO1xuICAgIHZhciBwb3BvdmVyTGlzdCA9IHBvcG92ZXJUcmlnZ2VyTGlzdC5tYXAoZnVuY3Rpb24gKHBvcG92ZXJUcmlnZ2VyRWwpIHtcbiAgICAgICAgcmV0dXJuIG5ldyBib290c3RyYXAuUG9wb3Zlcihwb3BvdmVyVHJpZ2dlckVsKTtcbiAgICB9KTtcblxuICAgIC8vIFRvZ2dsZSB0aGUgc2lkZSBuYXZpZ2F0aW9uXG4gICAgY29uc3Qgc2lkZWJhclRvZ2dsZSA9IGRvY3VtZW50LmJvZHkucXVlcnlTZWxlY3RvcignI3NpZGViYXJUb2dnbGUnKTtcbiAgICBpZiAoc2lkZWJhclRvZ2dsZSkge1xuICAgICAgICAvLyBVbmNvbW1lbnQgQmVsb3cgdG8gcGVyc2lzdCBzaWRlYmFyIHRvZ2dsZSBiZXR3ZWVuIHJlZnJlc2hlc1xuICAgICAgICAvLyBpZiAobG9jYWxTdG9yYWdlLmdldEl0ZW0oJ3NifHNpZGViYXItdG9nZ2xlJykgPT09ICd0cnVlJykge1xuICAgICAgICAvLyAgICAgZG9jdW1lbnQuYm9keS5jbGFzc0xpc3QudG9nZ2xlKCdzaWRlbmF2LXRvZ2dsZWQnKTtcbiAgICAgICAgLy8gfVxuICAgICAgICBzaWRlYmFyVG9nZ2xlLmFkZEV2ZW50TGlzdGVuZXIoJ2NsaWNrJywgZXZlbnQgPT4ge1xuICAgICAgICAgICAgZXZlbnQucHJldmVudERlZmF1bHQoKTtcbiAgICAgICAgICAgIGRvY3VtZW50LmJvZHkuY2xhc3NMaXN0LnRvZ2dsZSgnc2lkZW5hdi10b2dnbGVkJyk7XG4gICAgICAgICAgICBsb2NhbFN0b3JhZ2Uuc2V0SXRlbSgnc2J8c2lkZWJhci10b2dnbGUnLCBkb2N1bWVudC5ib2R5LmNsYXNzTGlzdC5jb250YWlucygnc2lkZW5hdi10b2dnbGVkJykpO1xuICAgICAgICB9KTtcbiAgICB9XG5cbiAgICAvLyBDbG9zZSBzaWRlIG5hdmlnYXRpb24gd2hlbiB3aWR0aCA8IExHXG4gICAgY29uc3Qgc2lkZW5hdkNvbnRlbnQgPSBkb2N1bWVudC5ib2R5LnF1ZXJ5U2VsZWN0b3IoJyNsYXlvdXRTaWRlbmF2X2NvbnRlbnQnKTtcbiAgICBpZiAoc2lkZW5hdkNvbnRlbnQpIHtcbiAgICAgICAgc2lkZW5hdkNvbnRlbnQuYWRkRXZlbnRMaXN0ZW5lcignY2xpY2snLCBldmVudCA9PiB7XG4gICAgICAgICAgICBjb25zdCBCT09UU1RSQVBfTEdfV0lEVEggPSA5OTI7XG4gICAgICAgICAgICBpZiAod2luZG93LmlubmVyV2lkdGggPj0gOTkyKSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgaWYgKGRvY3VtZW50LmJvZHkuY2xhc3NMaXN0LmNvbnRhaW5zKFwic2lkZW5hdi10b2dnbGVkXCIpKSB7XG4gICAgICAgICAgICAgICAgZG9jdW1lbnQuYm9keS5jbGFzc0xpc3QudG9nZ2xlKFwic2lkZW5hdi10b2dnbGVkXCIpO1xuICAgICAgICAgICAgfVxuICAgICAgICB9KTtcbiAgICB9XG5cbiAgICAvLyBBZGQgYWN0aXZlIHN0YXRlIHRvIHNpZGJhciBuYXYgbGlua3NcbiAgICBsZXQgYWN0aXZhdGVkUGF0aCA9IHdpbmRvdy5sb2NhdGlvbi5wYXRobmFtZS5tYXRjaCgvKFtcXHctXStcXC5odG1sKS8sICckMScpO1xuXG4gICAgaWYgKGFjdGl2YXRlZFBhdGgpIHtcbiAgICAgICAgYWN0aXZhdGVkUGF0aCA9IGFjdGl2YXRlZFBhdGhbMF07XG4gICAgfSBlbHNlIHtcbiAgICAgICAgYWN0aXZhdGVkUGF0aCA9ICcvJztcbiAgICB9XG5cbiAgICBjb25zdCB0YXJnZXRBbmNob3JzID0gZG9jdW1lbnQuYm9keS5xdWVyeVNlbGVjdG9yQWxsKCdbaHJlZj1cIicgKyBhY3RpdmF0ZWRQYXRoICsgJ1wiXS5uYXYtbGluaycpO1xuXG4gICAgdGFyZ2V0QW5jaG9ycy5mb3JFYWNoKHRhcmdldEFuY2hvciA9PiB7XG4gICAgICAgIGxldCBwYXJlbnROb2RlID0gdGFyZ2V0QW5jaG9yLnBhcmVudE5vZGU7XG4gICAgICAgIHdoaWxlIChwYXJlbnROb2RlICE9PSBudWxsICYmIHBhcmVudE5vZGUgIT09IGRvY3VtZW50LmRvY3VtZW50RWxlbWVudCkge1xuICAgICAgICAgICAgaWYgKHBhcmVudE5vZGUuY2xhc3NMaXN0LmNvbnRhaW5zKCdjb2xsYXBzZScpKSB7XG4gICAgICAgICAgICAgICAgcGFyZW50Tm9kZS5jbGFzc0xpc3QuYWRkKCdzaG93Jyk7XG4gICAgICAgICAgICAgICAgY29uc3QgcGFyZW50TmF2TGluayA9IGRvY3VtZW50LmJvZHkucXVlcnlTZWxlY3RvcihcbiAgICAgICAgICAgICAgICAgICAgJ1tkYXRhLWJzLXRhcmdldD1cIiMnICsgcGFyZW50Tm9kZS5pZCArICdcIl0nXG4gICAgICAgICAgICAgICAgKTtcbiAgICAgICAgICAgICAgICBwYXJlbnROYXZMaW5rLmNsYXNzTGlzdC5yZW1vdmUoJ2NvbGxhcHNlZCcpO1xuICAgICAgICAgICAgICAgIHBhcmVudE5hdkxpbmsuY2xhc3NMaXN0LmFkZCgnYWN0aXZlJyk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBwYXJlbnROb2RlID0gcGFyZW50Tm9kZS5wYXJlbnROb2RlO1xuICAgICAgICB9XG4gICAgICAgIHRhcmdldEFuY2hvci5jbGFzc0xpc3QuYWRkKCdhY3RpdmUnKTtcbiAgICB9KTtcbn0pO1xuIl0sCiAgIm1hcHBpbmdzIjogIjs7QUFLSSxTQUFPLGlCQUFpQixvQkFBb0IsV0FBUztBQUVyRCxZQUFRLFFBQVE7QUFHaEIsUUFBSSxxQkFBcUIsQ0FBQyxFQUFFLE1BQU0sS0FBSyxTQUFTLGlCQUFpQiw0QkFBNEIsQ0FBQztBQUM5RixRQUFJLGNBQWMsbUJBQW1CLElBQUksU0FBVSxrQkFBa0I7QUFDakUsYUFBTyxJQUFJLFVBQVUsUUFBUSxnQkFBZ0I7QUFBQSxJQUNqRCxDQUFDO0FBR0QsUUFBSSxxQkFBcUIsQ0FBQyxFQUFFLE1BQU0sS0FBSyxTQUFTLGlCQUFpQiw0QkFBNEIsQ0FBQztBQUM5RixRQUFJLGNBQWMsbUJBQW1CLElBQUksU0FBVSxrQkFBa0I7QUFDakUsYUFBTyxJQUFJLFVBQVUsUUFBUSxnQkFBZ0I7QUFBQSxJQUNqRCxDQUFDO0FBR0QsVUFBTSxnQkFBZ0IsU0FBUyxLQUFLLGNBQWMsZ0JBQWdCO0FBQ2xFLFFBQUksZUFBZTtBQUtmLG9CQUFjLGlCQUFpQixTQUFTLENBQUFBLFdBQVM7QUFDN0MsUUFBQUEsT0FBTSxlQUFlO0FBQ3JCLGlCQUFTLEtBQUssVUFBVSxPQUFPLGlCQUFpQjtBQUNoRCxxQkFBYSxRQUFRLHFCQUFxQixTQUFTLEtBQUssVUFBVSxTQUFTLGlCQUFpQixDQUFDO0FBQUEsTUFDakcsQ0FBQztBQUFBLElBQ0w7QUFHQSxVQUFNLGlCQUFpQixTQUFTLEtBQUssY0FBYyx3QkFBd0I7QUFDM0UsUUFBSSxnQkFBZ0I7QUFDaEIscUJBQWUsaUJBQWlCLFNBQVMsQ0FBQUEsV0FBUztBQUM5QyxjQUFNLHFCQUFxQjtBQUMzQixZQUFJLE9BQU8sY0FBYyxLQUFLO0FBQzFCO0FBQUEsUUFDSjtBQUNBLFlBQUksU0FBUyxLQUFLLFVBQVUsU0FBUyxpQkFBaUIsR0FBRztBQUNyRCxtQkFBUyxLQUFLLFVBQVUsT0FBTyxpQkFBaUI7QUFBQSxRQUNwRDtBQUFBLE1BQ0osQ0FBQztBQUFBLElBQ0w7QUFHQSxRQUFJLGdCQUFnQixPQUFPLFNBQVMsU0FBUyxNQUFNLGtCQUFrQixJQUFJO0FBRXpFLFFBQUksZUFBZTtBQUNmLHNCQUFnQixjQUFjLENBQUM7QUFBQSxJQUNuQyxPQUFPO0FBQ0gsc0JBQWdCO0FBQUEsSUFDcEI7QUFFQSxVQUFNLGdCQUFnQixTQUFTLEtBQUssaUJBQWlCLFlBQVksZ0JBQWdCLGFBQWE7QUFFOUYsa0JBQWMsUUFBUSxrQkFBZ0I7QUFDbEMsVUFBSSxhQUFhLGFBQWE7QUFDOUIsYUFBTyxlQUFlLFFBQVEsZUFBZSxTQUFTLGlCQUFpQjtBQUNuRSxZQUFJLFdBQVcsVUFBVSxTQUFTLFVBQVUsR0FBRztBQUMzQyxxQkFBVyxVQUFVLElBQUksTUFBTTtBQUMvQixnQkFBTSxnQkFBZ0IsU0FBUyxLQUFLO0FBQUEsWUFDaEMsdUJBQXVCLFdBQVcsS0FBSztBQUFBLFVBQzNDO0FBQ0Esd0JBQWMsVUFBVSxPQUFPLFdBQVc7QUFDMUMsd0JBQWMsVUFBVSxJQUFJLFFBQVE7QUFBQSxRQUN4QztBQUNBLHFCQUFhLFdBQVc7QUFBQSxNQUM1QjtBQUNBLG1CQUFhLFVBQVUsSUFBSSxRQUFRO0FBQUEsSUFDdkMsQ0FBQztBQUFBLEVBQ0wsQ0FBQzsiLAogICJuYW1lcyI6IFsiZXZlbnQiXQp9Cg==
