

let v = document.querySelector('video');
v.addEventListener('webkitpresentationmodechanged', (e)=>e.stopPropagation(), true);
console.log("video from id " + v.id + " is ready");
setTimeout(()=>v.webkitSetPresentationMode('picture-in-picture'), 3000);
completion()

var sideBar = document.querySelector("ytd-watch-next-secondary-results-renderer");
              sideBar.innerHTML = "";
              if (checkIfLive() == false) {
                  sideBar.appendChild(renderRabbit());
              }
          var comments = document.querySelector("ytd-comments");
          if (comments) {
              comments.innerHTML = "";
          }
          var chat = document.querySelector("ytd-live-chat-frame");
          if (chat && safe) {
              chat.innerHTML = "";
              if (checkIfLive() == true) {
                  chat.appendChild(renderRabbit());
              }
          }


