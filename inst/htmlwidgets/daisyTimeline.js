HTMLWidgets.widget({

  name: 'daisyTimeline',

  type: 'output',

  factory: function(el, width, height) {

    return {
      renderValue: function(x) {
        el.innerHTML = "";
      
        // Insert the CSS needed for the timeline component
        if (!document.getElementById('daisyui-timeline-css')) {
        const style = document.createElement('style');
        style.id = 'daisyui-timeline-css';
        style.textContent = `
          .timeline {
      
          }
          .timeline::before {
      
          }
          .timeline li {
      
          }
          .timeline-start {
      
          }
          .timeline-middle {
            left: 0.75rem;
            width: 0.75rem;
            height: 0.75rem;
            background-color: #2563eb; /* tailwind blue-600 */
            border-radius: 9999px;
            border: 2px solid white;
            box-shadow: 0 0 0 2px #2563eb;
            top: 0.25rem;
          }
          .timeline-end {
      
          }
          .timeline-box {
      
          }
          .timeline-hr {
            border-top: 1px solid #000000;
          }
        `;
        document.head.appendChild(style);
      }
      
      
        // Build HTML
        const ul = document.createElement("ul");
        ul.className = "timeline timeline-vertical lg:timeline-horizontal";
        x.events.forEach((event, index) => {
          const li = document.createElement("li");
          const start = document.createElement("div");
          start.className = "timeline-start";
          start.textContent = event.date;
      
          const middle = document.createElement("div");
          middle.className = "timeline-middle";
      
          const end = document.createElement("div");
          end.className = "timeline-end";
          const box = document.createElement("div");
          box.className = "timeline-box";
          box.textContent = event.content;
          
          box.onclick = function() {
            if (HTMLWidgets.shinyMode && Shiny.setInputValue) {
              Shiny.setInputValue(el.id + "_selected", index);
            }
          };
          
          
          const hrStart = document.createElement("hr");
          hrStart.className = "timeline-hr";
          
          
          const hrEnd = document.createElement("hr");
      
          end.appendChild(box);
          if (index > 0) {
           li.appendChild(hrStart); 
          }
          li.appendChild(start);
          li.appendChild(middle);
          li.appendChild(end);
          if (index < x.events.length - 1) { // Check if it's the first AND not the last
          li.appendChild(hrEnd);
          }
          ul.appendChild(li);
        });
      
        el.appendChild(ul);
      }

    };
  }
});
